from firebase_functions import https_fn, options
from firebase_admin import initialize_app, firestore
from PIL import Image, ImageChops
from flask import send_file
import qrcode
from io import BytesIO

app = initialize_app()


@https_fn.on_request(
    cors=options.CorsOptions(cors_origins="*", cors_methods=["get", "post"])
)
def generate_diff(req: https_fn.Request) -> https_fn.Response:
    """Take the text parameter passed to this HTTP endpoint and insert it into
    a new document in the messages collection."""
    if 'source' not in req.form or 'target' not in req.form:
        return https_fn.Response(status=400)

    img_io = BytesIO()
    source = _make_qrcode_from_string(req.form['source'])
    target = _make_qrcode_from_string(req.form['target'])

    if 'highlight' == req.args.get('output'):
        diff = _make_image_from_difference_highlighted(source, target)
    else:
        diff = _make_image_from_difference(source, target)

    diff.save(img_io, 'JPEG')
    img_io.seek(0)

    if diff.getbbox() is None:
        return https_fn.Response(status=204)

    return send_file(
        img_io,
        as_attachment=False,
        download_name='qrcode_diff.jpg'
    )


def _make_qrcode_from_string(data: str) -> Image:
    """
    Generate a QR code for the given data.
    """
    qr = qrcode.QRCode(
        version=1,
        error_correction=qrcode.constants.ERROR_CORRECT_L,
        box_size=10,
        border=4,
    )

    qr.add_data(data)
    qr.make(fit=True)

    return qr.make_image(fill="black", back_color="white")


def _make_image_from_difference(a: Image, b: Image) -> Image:
    """
    Generate image from two image difference.
    """
    if a.size != b.size:
        raise ValueError(
            "Images are of different sizes, they need to be the same size.")

    a = a.convert('L')
    b = b.convert('L')

    return ImageChops.difference(a, b)


def _make_image_from_difference_highlighted(a: Image, b: Image):
    """
    Generate image from two image difference.
    """
    if a.size != b.size:
        raise ValueError(
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
