# CLDN2

* **Developed by:** Thomas
* **Developed for:** Salimata
* **Team:** Prochiantz
* **Date:** September 2024
* **Software:** Fiji


### Images description

3D images of choroid plexus taken on an spinning-disk microscope.

1 channel: *488:* CLDN2.
     
### Plugin description

* Segment choroid plexus using stack sum projection + background subtraction + median filtering + Triangle thresholding
* Estimate background noise as median intensity of stack minimum projection
* For each obtained ROI, compute area + mean intensity measured on the background-corrected stack average projection

### Dependencies

None

### Version history

Version 1 released on September 30, 2024.
