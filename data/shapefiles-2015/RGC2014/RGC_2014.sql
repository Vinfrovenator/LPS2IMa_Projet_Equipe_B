-- psql -h ubsbase3 -p 5434 -U Etudiant01 DB_Etudiant01
CREATE TABLE RGC_2014
(
DEP character varying(2),
COM integer,    
ARRD integer,    
CANT integer,    
ADMI integer,    
POPU integer,    
SURFACE integer,    
NOM character varying(50),
XLAMB2 integer,
YLAMB2 integer,    
XLAMBZ integer,    
YLAMBZ integer,    
XLAMB93 integer,    
YLAMB93 integer,    
LONGI_GRD character varying(6),    
LATI_GRD character varying(6),    
LONGI_DMS integer,    
LATI_DMS integer,    
ZMIN integer,    
ZMAX integer
)
WITH (
  OIDS=FALSE
);

\COPY RGC_2014 FROM 'O:/RGC2014/RGC_2014.txt' WITH DELIMITER E'\t' CSV HEADER;

ALTER TABLE RGC_2014 ADD geom GEOMETRY;
UPDATE RGC_2014 SET geom=St_GeometryFromText('POINT('||XLAMB93*100||' '||YLAMB93*100||')',2154);
ALTER TABLE RGC_2014 ADD CONSTRAINT RGC_2014_pkey PRIMARY KEY(DEP,COM);
ALTER TABLE RGC_2014 ADD CONSTRAINT RGC_2014_enforce_dims_geom CHECK (st_ndims(geom) = 2);
ALTER TABLE RGC_2014 ADD CONSTRAINT RGC_2014_enforce_geotype_geom CHECK (geometrytype(geom) = 'POINT'::text OR geom IS NULL);
ALTER TABLE RGC_2014 ADD CONSTRAINT RGC_2014_enforce_srid_geom CHECK (st_srid(geom) = 2154);
CREATE INDEX "RGC_2014_geom_idx" ON public.rgc_2014 USING gist (geom);

-- \q
-- pgsql2shp -f O:\RGC2014\RGC_2014_geom.shp -g geom -k -h ubsbase3 -p 5434 -u Etudiant01 -P P@ssw0rd DB_Etudiant01 public.rgc_2014
