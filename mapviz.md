Mapnik + TileStache + other map stuff


## TODO

Run server that dynamically creates tiles.
http://wiki.openstreetmap.org/wiki/Creating_your_own_tiles

Goal: given a grid of small images, render tiles of images on the fly.

Use TileStache??? Use mod_tile???

## Visualizations

* http://visual.ly/
* http://www.betterworldflux.com/
* http://kartograph.org/
* http://climateviewer.com/3D/

## Mapnik

```bash
sudo apt-get update
sudo apt-get upgrade

# install postgresql 9.3
# http://www.postgresql.org/download/linux/ubuntu/
sudo echo 'deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main' > /etc/apt/sources.list.d/pgdg.list
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt-get update
sudo apt-get update
sudo apt-get install postgresql-9.3
sudo apt-get install postgresql-9.3-postgis postgresql-contrib

# [optional] install pgadmin3
sudo apt-get install pgadmin3
sudo -u postgres psql
CREATE EXTENSION adminpack;
\q


# install mapnik
# https://github.com/mapnik/mapnik/wiki/UbuntuInstallation
sudo add-apt-repository ppa:mapnik/nightly-2.3
sudo apt-get update
sudo apt-get install libmapnik libmapnik-dev mapnik-utils python-mapnik

# [optional]
sudo apt-get install mapnik-input-plugin-gdal mapnik-input-plugin-ogr\
  mapnik-input-plugin-postgis \
  mapnik-input-plugin-sqlite \
  mapnik-input-plugin-osm

# install image tools
sudo apt-get install imagemagick

# download scripts
mkdir mapnik && cd mapnik
wget http://svn.openstreetmap.org/applications/rendering/mapnik/generate_tiles.py

# download shape data for testing
wget https://github.com/mapnik/mapnik/wiki/data/110m-admin-0-countries.zip
apt-get install unzip
unzip 110m-admin-0-countries.zip

# generate tiles
mkdir tiles
MAPNIK_MAP_FILE=world_style.xml MAPNIK_TILE_DIR=./tiles/ ./generate_tiles.py
```


## TileStache

https://github.com/migurski/TileStache

```bash
# install pip
sudo apt-get install python-pip python-dev build-essential
sudo pip install --upgrade pip

# install requirements
apt-get install libjpeg8 libjpeg62-dev libfreetype6 libfreetype6-dev
sudo pip install -U PIL modestmaps simplejson werkzeug

# install tilestache
git clone https://github.com/migurski/TileStache.git
cd TileStache
python setup.py install

# run server
./scripts/tilestache-server.py -i [IP ADDRESS]

# preview in browser
http://[IP ADDRESS]:8080/osm/preview.html

```
