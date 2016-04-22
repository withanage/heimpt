Figures for testing

File naming convention

{color space}-{color profile}-{compression algorithm}-{dpi}-{specials}.{format extension}

Color space: RGB, CMYK, LAB, Greyscale, Bitmap
Color profile: either short name of the color profile embedded or none
Compression algorithm: jpg, lzw, zip, no_compression
dpi: resolution in dots per inch
specials: other criteria to test, e.g. layers in photoshop psd or tiff files 

Example
-----------
RGB-sRGB-LZW-300.tif

Means, that there is a full color image in RGB and 300 dpi with an embedded sRGB ICC color profile, compression is LZW.
