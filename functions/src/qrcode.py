from firebase_functions import https_fn, options
from firebase_admin import initialize_app, firestore
from PIL import Image, ImageChops
from flask import send_file
import qrcode
from io import BytesIO
import base64

app = initialize_app()


class NoDifferenceException(Exception):
    """There is no difference between two images."""


class DifferentSizeException(Exception):
    """Sources images are not based on the same size."""


@https_fn.on_request()
def http_generate_diff(req: https_fn.Request) -> https_fn.Response:
    if 'source' not in req.form or 'target' not in req.form:
        return https_fn.Response('`source` and `target` data must be passed.', status=400)

    try:
        img_io = _generate_diff(
            req.form['source'],
            req.form['target'],
            req.args.get('output')
        )
    except NoDifferenceException as e:
        return https_fn.Response('No difference found between source and target.', status=204)
    except DifferentSizeException as e:
        return https_fn.Response('Source and target must be based on same size.', status=400)

    return send_file(img_io, mimetype='image/jpeg')


@https_fn.on_call()
def generate_diff(req: https_fn.CallableRequest) -> https_fn.Response:
    """Take the text parameter passed to this HTTP endpoint and insert it into
    a new document in the messages collection."""
    if 'source' not in req.data or 'target' not in req.data:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            message='`source` and `target` data must be passed.'
        )

    try:
        img_io = _generate_diff(
            req.data['source'],
            req.data['target'],
            req.data.get('output')
        )
    except NoDifferenceException as e:
        return {'error': 'No difference found between source and target.'}
    except DifferentSizeException as e:
        raise https_fn.HttpsError(
            code=https_fn.FunctionsErrorCode.INVALID_ARGUMENT,
            message='Source and target must be based on same size.'
        )

    return {
        'imageBase64': base64
        .b64encode(s=img_io.getvalue(), altchars=b'-_')
        .decode()
    }


def _generate_diff(
    source: str,
    target: str,
    output='highlight'
) -> BytesIO:
    if (source == target):
        raise NoDifferenceException('No difference between images.')

    img_io = BytesIO()
    source = _make_qrcode_from_string(source)
    target = _make_qrcode_from_string(target)

    if 'highlight' == output:
        diff = _make_image_from_difference_highlighted(source, target)
    else:
        diff = _make_image_from_difference(source, target)

    if diff.getbbox() is None:
        raise NoDifferenceException('No difference between images.')

    diff.save(img_io, 'JPEG')
    img_io.seek(0)

    return img_io


def _make_qrcode_from_string(data: str, version: int = 1) -> Image:
    """
    Generate a QR code for the given data.
    """
    qr = qrcode.QRCode(
        version=None,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=2
    )

    qr.add_data(data)
    qr.make(fit=True)

    return qr.make_image(fill="black", back_color="white")


def _make_image_from_difference(a: Image, b: Image) -> Image:
    """
    Generate image from two image difference.
    """
    if a.size != b.size:
        raise DifferentSizeException(
            "Images are of different sizes, they need to be the same size.")

    a = a.convert('L')
    b = b.convert('L')

    return ImageChops.difference(a, b)


def _make_image_from_difference_highlighted(a: Image, b: Image):
    """
    Generate image from two image difference.
    """
    if a.size != b.size:
        raise DifferentSizeException(
            "Images are of different sizes, they need to be the same size.")

    a = a.convert("RGB")
    b = b.convert("RGB")

    width, height = a.size

    diff = Image.new("RGB", (width, height))

    pixels_a = a.load()
    pixels_b = b.load()
    pixels_diff = diff.load()

    for y in range(height):
        for x in range(width):
            if pixels_a[x, y] != pixels_b[x, y]:
                # Addition
                if pixels_b[x, y] != (0, 0, 0):
                    pixels_diff[x, y] = (0, 255, 0)
                # Deletion
                if pixels_a[x, y] != (0, 0, 0):
                    pixels_diff[x, y] = (255, 0, 0)
            else:
                # No difference
                pixels_diff[x, y] = pixels_a[x, y]

    return diff
