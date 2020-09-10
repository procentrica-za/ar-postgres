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
    dimension4Unit integer,
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
    extent numeric,
    extentConfidence numeric,
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
	SELECT a.code, a.name, a.description, a.isutc, a.sizeunit, a.typelookup, a.sizelookup, a.dimension1name, a.dimension1description, a.dimension1unit, a.dimension2name, a.dimension2description, a.extentformula, a.depreciationmodel, a.depreciationmethod, a.isactive
	INTO ret_code, ret_name, ret_description, ret_isutc, ret_sizeunit, ret_typelookup, ret_sizelookup, ret_dimension1name, ret_dimension1description, ret_dimension1unit, ret_dimension2name, ret_dimension2description, ret_extentformula, ret_depreciationmodel, ret_depreciationmethod, ret_isactive
    FROM public.AssetType a
    WHERE a.id = var_assettypeid AND a.isdeleted = false;
	ELSE
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
	OUT ret_size integer,
	OUT ret_type integer,
	OUT ret_class integer,
	OUT ret_dimension1val integer,
	OUT ret_dimension2val integer,
	OUT ret_dimension3val integer,
	OUT ret_dimension4val integer,
	OUT ret_dimension5val integer,
	OUT ret_dimension6val integer,
	OUT ret_derecognitionvalue integer)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.Asset a WHERE a.id = var_assetid AND a.isdeleted = false) THEN
	SELECT a.name, a.description, a.serialno, a.size, a.type, a.class, a.dimension1val, a.dimension2val, a.dimension3val, a.dimension4val, a.dimension5val, a.dimension6val, a.derecognitionvalue
	INTO ret_name, ret_description, ret_serialno, ret_size, ret_type, ret_class, ret_dimension1val, ret_dimension2val, ret_dimension3val, ret_dimension4val, ret_dimension5val, ret_dimension6val, ret_derecognitionvalue
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
        ret_derecognitionvalue = 00000;
    END IF;
END;
$BODY$;


/* ---- Retrieve Assets Function ---- */
CREATE OR REPLACE FUNCTION public.retrieveassets(
    var_assettypeid integer
)
    RETURNS TABLE( name character varying, description character varying, serialno character varying, size integer, type integer, class integer, dimension1val integer, dimension2val integer, dimension3val integer, dimension4val integer, dimension5val integer, dimension6val integer, derecognitionvalue integer)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.name, a.description, a.serialno, a.size, a.type, a.class, a.dimension1val, a.dimension2val, a.dimension3val, a.dimension4val, a.dimension5val, a.dimension6val, a.derecognitionvalue
    FROM public.Asset a
    WHERE a.type = var_assettypeid AND a.isdeleted = false;
END;
$BODY$;


