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
    extent numeric,
    extentConfidence Varchar(255),
    takeOnDate timestamp,
    manufactureDate timestamp,
    derecognitionDate timestamp,
    derecognitionValue numeric,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);
/* =============================================================================================
================================================================================================
================================================================================================
======================================FUNCTIONS=================================================
================================================================================================
================================================================================================
==============================================================================================*/

CREATE OR REPLACE FUNCTION public.postasset(
    var_id integer,
    var_name character varying,
    var_description character varying,
    var_serialNo character varying,
    var_size numeric,
    var_sizeUnit character varying,
    var_type integer,
    var_class integer,
    var_dimension1Val numeric,
    var_dimension2Val numeric,
    var_dimension3Val numeric,
    var_dimension4Val numeric,
    var_dimension5Val numeric,
    var_dimension6Val numeric,
    var_extent numeric,
    var_extentConfidence character varying, 
    var_takeOnDate timestamp,
    var_manufactureDate timestamp,
    var_derecognitionDate timestamp,
    var_derecognitionValue numeric,
    OUT res_success boolean,
    OUT ret_error character varying
)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
    var_generated_id double precision = array_to_string(ARRAY(SELECT chr((48 + round(random() * 9)) :: integer)
    FROM generate_series(1,6)), '');
BEGIN
    INSERT INTO public.Asset(ID, name, description, serialNo, size, sizeUnit, type, class, dimension1Val, dimension2Val, dimension3Val, dimension4Val, dimension5Val, dimension6Val, 
                             extent, extentConfidence, takeOnDate, manufactureDate, derecognitionDate, derecognitionValue, CreatedDateTime, IsDeleted, ModifiedDateTime)
    VALUES(var_id, var_name, var_description, var_serialNo, var_size, var_sizeUnit, var_type, var_class, var_dimension1Val, var_dimension2Val, var_dimension3Val, 
           var_dimension4Val, var_dimension5Val, var_dimension6Val, var_extent, var_extentConfidence, var_takeOnDate, var_manufactureDate, var_derecognitionDate,
           var_derecognitionValue, CURRENT_TIMESTAMP , 'false', CURRENT_TIMESTAMP);

           res_success := true;
           ret_error := 'Asset Successfully created!';
END;
$BODY$;
