# coding: utf-8
# !/usr/bin/env python3
# Created by wit at 19.06.18
from reportlab.pdfgen import canvas

c = canvas.Canvas("hello.pdf")
c.drawString(100, 750, "Welcome to Reportlab!")
c.save()
