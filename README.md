# CLDN2

* **Developed for:** Salimata
* **Developed by:** Thomas
* **Team:** Prochiantz
* **Date:** September 2024
* **Software:** Macro ImageJ


### Images description

3D images taken on an spinning-disk microscope.

1 channel:
  1. *488:* CLDN2
     
### Plugin description

* Detect astrocytes with Cellpose
* Compute distance between each cell and its nearest neighbors
* Compute G-function related spatial distribution index of the population of cells
* If vessels channel provided:
  * Detect vessels with median filtering + DoG filtering + thresholding + closing filtering + median filtering
  * Compute vessels skeleton and provide vessels diameter, length, branches number, and junctions number
  * Compute distance between each cell and its nearest vessel


### Dependencies

None

### Version history

Version 1 released on September 19, 2024.
