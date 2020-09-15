/* ---- Creating Extension needed for uuid datatypes and uuid operations ---- */
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
/* ---- Initializing all tables ---- */

CREATE TABLE public.AssetTypeLevel (
    ID INTEGER PRIMARY KEY NOT NULL,
    level integer,
    name Varchar(255) NOT NULL,
    description Varchar(255) NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);
CREATE TABLE public.AssetType (
    ID INTEGER PRIMARY KEY NOT NULL,
    AssetTypeLevelID INTEGER NOT NULL,
    code integer NOT NULL, 
    name Varchar(255) NOT NULL,
    description Varchar(255) NOT NULL,
    isUTC boolean NOT NULL,
    sizeUnit Varchar(255) ,
    typeLookup integer,
    sizeLookup integer,
    dimension1Name Varchar(255) NOT NULL,
    dimension1Description Varchar(255) NOT NULL,
    dimension1Unit Varchar(255) NOT NULL,
    dimension2Name Varchar(255),
    dimension2Description Varchar(255),
    dimension2Unit Varchar(255),
    dimension3Name Varchar(255),
    dimension3Description Varchar(255),
    dimension3Unit Varchar(255),
    dimension4Name Varchar(255),
    dimension4Description Varchar(255),
    dimension4Unit Varchar(255),
    dimension5Name Varchar(255),
    dimension5Description Varchar(255),
    dimension5Unit Varchar(255),
    extentFormula Varchar(255),
    depreciationModel Varchar(255),
    depreciationMethod Varchar(255),
    isActive boolean NOT NULL,
    CONSTRAINT assettypeassettypelevelfkey FOREIGN KEY (AssetTypeLevelID)
        REFERENCES public.AssetTypeLevel (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

CREATE TABLE public.ClassLookup (
    ID INTEGER PRIMARY KEY NOT NULL,
    AssetTypeID INTEGER NOT NULL,
    name Varchar(255) NOT NULL,
    description Varchar(255),
    CONSTRAINT classlookupassettypefkey FOREIGN KEY (AssetTypeID)
        REFERENCES public.AssetType (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

CREATE TABLE public.TypeLookup (
    ID INTEGER PRIMARY KEY NOT NULL,
    AssetTypeID INTEGER NOT NULL,
    CONSTRAINT typelookupassettypefkey FOREIGN KEY (AssetTypeID)
        REFERENCES public.AssetType (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    name Varchar(255) NOT NULL,
    description Varchar(255),
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

CREATE TABLE public.CompatibleUnitValue (
    ID INTEGER PRIMARY KEY NOT NULL,
    FY Varchar(255) NOT NULL,
    unitRate numeric,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);


CREATE TABLE public.CompatibleUnit (
    ID INTEGER PRIMARY KEY NOT NULL,
    Code INTEGER NOT NULL,
    CONSTRAINT compatilbeunitcompatibleunitvaluefkey FOREIGN KEY (Code)
        REFERENCES public.CompatibleUnitValue (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
        name Varchar(255) NOT NULL,
        description Varchar(255) NOT NULL,
        EULyears integer NOT NULL,
        residualValue numeric NOT NULL,
        size numeric,
        sizeUnit Varchar(255),
        type integer NOT NULL,
        class integer,
        isActive boolean NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

CREATE TABLE public.AssetTypeInheritence (
    ID INTEGER PRIMARY KEY NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

CREATE TABLE public.Asset (
    ID INTEGER PRIMARY KEY NOT NULL,
    name Varchar(255) NOT NULL,
    description Varchar(255) NOT NULL,
    serialNo varchar(255),
    size numeric,
    sizeUnit Varchar(255),
    type INTEGER NOT NULL,
    class INTEGER NOT NULL,
    dimension1Val numeric,
    dimension2Val numeric,
    dimension3Val numeric,
    dimension4Val numeric,
    dimension5Val numeric,
    dimension6Val numeric,
    extent Varchar(255),
    extentConfidence Varchar(255),
    takeOnDate timestamp,
    manufactureDate timestamp,
    derecognitionDate timestamp,
    derecognitionValue numeric,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

/*
----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------FUNCTIONS---------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------------------------
*/

/* ---- Creating all functions needed for CRUD functions to be used by the CRUD service ---- */


 

/* ---- Export Asset Function ---- */

CREATE OR REPLACE FUNCTION public.exportasset(
	var_assettypeid integer,
    OUT ret_assettypelevelid integer,
	OUT ret_code integer,
	OUT ret_name character varying,
	OUT ret_description character varying,
	OUT ret_isutc boolean,
	OUT ret_sizeunit character varying,
    OUT ret_typelookup integer,
	OUT ret_sizelookup integer,
    OUT ret_dimension1name character varying,
    OUT ret_dimension1description character varying,
    OUT ret_dimension1unit character varying,
    OUT ret_dimension2name character varying,
    OUT ret_dimension2description character varying,
    OUT ret_extentformula character varying,
    OUT ret_depreciationmodel character varying,
    OUT ret_depreciationmethod character varying,
    OUT ret_isactive boolean)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.AssetType a WHERE a.id = var_assettypeid AND a.isdeleted = false) THEN
	SELECT a.assettypelevelid, a.code, a.name, a.description, a.isutc, a.sizeunit, a.typelookup, a.sizelookup, a.dimension1name, a.dimension1description, a.dimension1unit, a.dimension2name, a.dimension2description, a.extentformula, a.depreciationmodel, a.depreciationmethod, a.isactive
	INTO ret_assettypelevelid, ret_code, ret_name, ret_description, ret_isutc, ret_sizeunit, ret_typelookup, ret_sizelookup, ret_dimension1name, ret_dimension1description, ret_dimension1unit, ret_dimension2name, ret_dimension2description, ret_extentformula, ret_depreciationmodel, ret_depreciationmethod, ret_isactive
    FROM public.AssetType a
    WHERE a.id = var_assettypeid AND a.isdeleted = false;
	ELSE
        ret_assettypelevelid = 0;
        ret_code = 00000;
		ret_name = 'none';
		ret_description = 'none';
		ret_isutc = false;
        ret_sizeunit = 'none';
        ret_typelookup = 00000;
        ret_sizelookup = 00000;
		ret_dimension1name = 'none';
		ret_dimension1description = 'none';
		ret_dimension1unit = 'none';
        ret_dimension2name = 'none';
        ret_dimension2description = 'none';
        ret_extentformula = 'none';
        ret_depreciationmodel = 'none';
        ret_depreciationmethod = 'none';
        ret_isactive = false;
    END IF;
END;
$BODY$;


/* ---- Retrieve Asset Function ---- */

CREATE OR REPLACE FUNCTION public.retrieveasset(
	var_assetid integer,
	OUT ret_name character varying,
	OUT ret_description character varying,
	OUT ret_serialno character varying,
	OUT ret_size numeric,
	OUT ret_type integer,
	OUT ret_class integer,
	OUT ret_dimension1val numeric,
	OUT ret_dimension2val numeric,
	OUT ret_dimension3val numeric,
	OUT ret_dimension4val numeric,
	OUT ret_dimension5val numeric,
	OUT ret_dimension6val numeric,
    OUT ret_extent character varying,
    OUT ret_extentconfidence character varying,
	OUT ret_derecognitionvalue numeric)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.Asset a WHERE a.id = var_assetid AND a.isdeleted = false) THEN
	SELECT a.name, a.description, a.serialno, a.size, a.type, a.class, a.dimension1val, a.dimension2val, a.dimension3val, a.dimension4val, a.dimension5val, a.dimension6val, a.extent, a.extentconfidence, a.derecognitionvalue
	INTO ret_name, ret_description, ret_serialno, ret_size, ret_type, ret_class, ret_dimension1val, ret_dimension2val, ret_dimension3val, ret_dimension4val, ret_dimension5val, ret_dimension6val, ret_extent, ret_extentconfidence, ret_derecognitionvalue
    FROM public.Asset a
    WHERE a.id = var_assetid AND a.isdeleted = false;
	ELSE
        ret_name = 'none';
		ret_description = 'none';
		ret_serialno = 'none';
		ret_size = 00000;
        ret_type = 00000;
        ret_class = 00000;
        ret_dimension1val = 00000;
		ret_dimension2val = 00000;
		ret_dimension3val = 00000;
		ret_dimension4val = 00000;
        ret_dimension5val = 00000;
        ret_dimension6val = 00000;
        ret_extent = 'none';
        ret_extentconfidence = 'none';
        ret_derecognitionvalue = 00000;
    END IF;
END;
$BODY$;


/* ---- Retrieve Assets Function ---- */
CREATE OR REPLACE FUNCTION public.retrieveassets(
    var_assettypeid integer
)
    RETURNS TABLE( name character varying, description character varying, serialno character varying, size numeric, type integer, class integer, dimension1val numeric, dimension2val numeric, dimension3val numeric, dimension4val numeric, dimension5val numeric, dimension6val numeric, extent character varying, extentconfidence character varying, derecognitionvalue numeric)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.name, a.description, a.serialno, a.size, a.type, a.class, a.dimension1val, a.dimension2val, a.dimension3val, a.dimension4val, a.dimension5val, a.dimension6val, a.extent, a.extentconfidence, a.derecognitionvalue
    FROM public.Asset a
    WHERE a.type = var_assettypeid AND a.isdeleted = false;
END;
$BODY$;

/* ---- Extract Assets Function ---- */
CREATE OR REPLACE FUNCTION public.extractassets(
    var_assettypeid integer
)
      RETURNS TABLE( name character varying, description character varying, serialno character varying, size numeric, type integer, class integer, dimension1val numeric, dimension2val numeric, dimension3val numeric, dimension4val numeric, dimension5val numeric, dimension6val numeric, extent character varying, extentconfidence character varying, derecognitionvalue numeric)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.name, a.description, a.serialno, a.size, a.type, a.class, a.dimension1val, a.dimension2val, a.dimension3val, a.dimension4val, a.dimension5val, a.dimension6val, a.extent, a.extentconfidence, a.derecognitionvalue
    FROM public.Asset a
    WHERE a.type = var_assettypeid AND a.isdeleted = false;
END;
$BODY$;

/* ---- Insert data for asset level ---- */
INSERT INTO public.AssetTypeLevel(ID, level, name, description, CreatedDateTime, ModifiedDateTime)
VALUES ('1' ,'1', 'one', 'Level One',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.AssetTypeLevel(ID, level, name, description, CreatedDateTime, ModifiedDateTime)
VALUES ('2' ,'2', 'two', 'Level Two',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.AssetTypeLevel(ID, level, name, description, CreatedDateTime, ModifiedDateTime)
VALUES ('3' ,'3', 'three', 'Level Three',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.AssetTypeLevel(ID, level, name, description, CreatedDateTime, ModifiedDateTime)
VALUES ('4' ,'4', 'four', 'Level Four',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.AssetTypeLevel(ID, level, name, description, CreatedDateTime, ModifiedDateTime)
VALUES ('5' ,'5', 'five', 'Level Five',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.AssetTypeLevel(ID, level, name, description, CreatedDateTime, ModifiedDateTime)
VALUES ('6' ,'6', 'six', 'Level Six',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


/* ---- Insert data for asset Type ---- */
INSERT INTO public.AssetType(ID, AssetTypeLevelID, code, name, description, isUTC, sizeunit, typeLookup, sizeLookup, dimension1Name, dimension1Description, dimension1Unit, dimension2Name, dimension2Description, dimension2Unit, dimension3Name, dimension3Description, dimension3Unit, dimension5Name, dimension5Description, dimension5Unit, extentFormula, depreciationModel, depreciationMethod, isActive, CreatedDateTime, ModifiedDateTime)
VALUES ('279' ,'1', '120', 'Cast iron', 'Cast iron', true, 'meters', '0001' ,'0004', 'Length', 'Length', 'Length of the asset' ,'m', 'Width', 'Width of the asset', 'm', 'Height', 'Height of the Asset', 'Straight Line', 'Yes', 'none', 'A = l', 'none', 'none', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


/* ---- Insert data for Asset ---- */
INSERT INTO public.Asset(ID, name, description, serialNo, size, sizeUnit, type, class, dimension1val, dimension2val, dimension3val, dimension4val, dimension5val, dimension6val, extent, extentConfidence, derecognitionValue,  CreatedDateTime, ModifiedDateTime)
VALUES ('249' ,'Synthetic surface', 'Synthetic surface', '1234' ,'1234', 'meters', '0078', '0054', '5', '1' , '2', '2.2', '6', '2', 'Fair', 'Very Good', '2000', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Asset(ID, name, description, serialNo, size, sizeUnit, type, class, dimension1val, dimension2val, dimension3val, dimension4val, dimension5val, dimension6val, extent, extentConfidence, derecognitionValue,  CreatedDateTime, ModifiedDateTime)
VALUES ('258' ,'Real surface', 'Synthetic surface', '1263' ,'1263', 'kilometers', '0078', '0054', '5', '1' , '2', '2.2', '6', '2', 'Poor', 'Very Good', '2000', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
