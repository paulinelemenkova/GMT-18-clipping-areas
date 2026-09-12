# GMT Clipping Areas — Coastline-Based Raster Clipping Scripts

GMT (Generic Mapping Tools) shell scripts demonstrating coastline-based raster clipping, where a coastline clip path is used to display one dataset over the ocean and a separately styled version over the masked land. This land/sea differential rendering (for example a colour geoid over the sea with gray-shaded topography over land) is a useful cartographic technique for emphasising marine data. The scripts have been used to generate figures in the author's geophysical and cartographic publications.

## What the scripts do

Each script builds a complete clipped map, typically chaining:

- colour palette generation from the grid (grd2cpt / makecpt)
- rendering of the primary dataset over the full extent (grdimage)
- initiation of a coastline clip path for land (pscoast -Gc)
- rendering of a second, differently coloured/shaded dataset inside the land clip (grdimage)
- undoing of the clip path and overlay of the basemap frame (pscoast -Q)
- contours (grdcontour), grid, colour scale bar (psscale), scale bar and rose (psbasemap)
- GMT logo (logo) and cleanup of temporary CPTs (rm)
- export to raster (psconvert) at high resolution

## Data sources

Geoid from EGM96, relief/bathymetry from ETOPO1. Coastlines from GSHHG via GMT.

## Files

Three worked examples over ocean-trench regions:

- GMT-21-script-JM-clip-KKT.sh: Kuril-Kamchatka Trench
- GMT-21-script-JM-clip-MT.sh and _11122020.sh: Mariana Trench

## Requirements

- GMT 6.x (Generic Mapping Tools): https://www.generic-mapping-tools.org
- A POSIX shell (bash)
- The relevant geoid / relief grid(s) available locally

## Usage

Place the required grid in the working directory, adjust the -R region and -J projection at the top of the chosen script, then run:

    bash GMT-21-script-JM-clip-KKT.sh

The script writes a PostScript file and converts it to a raster image (JPG/PNG) via psconvert.

## Author and citation

Polina Lemenkova
ORCID: https://orcid.org/0000-0002-5759-1089

These scripts accompany figures in the author's geophysical and cartographic papers; please cite the specific article a given figure appears in. The full publication list is available via the ORCID record above.

## License

See the LICENSE file in this repository.
