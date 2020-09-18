/* ---- Creating Extension needed for uuid datatypes and uuid operations ---- */
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
/* ---- Initializing all tables ---- */

CREATE TABLE public.AssetTypeLevel (
    ID uuid PRIMARY KEY NOT NULL,
    level integer,
    name Varchar(255) NOT NULL,
    description Varchar(255) NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);
CREATE TABLE public.AssetType (
    ID uuid PRIMARY KEY NOT NULL,
    AssetTypeLevelID uuid  NOT NULL,
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
    ID uuid PRIMARY KEY NOT NULL,
    AssetTypeID uuid  NOT NULL,
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
    ID uuid PRIMARY KEY NOT NULL,
    AssetTypeID uuid  NOT NULL,
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
    ID uuid PRIMARY KEY NOT NULL,
    FY Varchar(255) NOT NULL,
    unitRate numeric,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);


CREATE TABLE public.CompatibleUnit (
    ID uuid PRIMARY KEY NOT NULL,
    Code uuid  NOT NULL,
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
    ID uuid PRIMARY KEY NOT NULL,
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

CREATE TABLE public.Funcloc (
    ID uuid PRIMARY KEY NOT NULL,
    name Varchar(255) NOT NULL,
    description Varchar(255),
    CreatedDateTime timestamp NOT NULL,
    IsDeleted Boolean DEFAULT(false),
    ModifiedDateTime timestamp
);

CREATE TABLE public.Asset (
    ID uuid PRIMARY KEY NOT NULL,
    funclocID uuid NOT NULL,
    CONSTRAINT funclocfkey FOREIGN KEY (funclocID)
        REFERENCES public.Funcloc (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    name Varchar(255) NOT NULL,
    description Varchar(255) NOT NULL,
    serialNo varchar(255),
    size numeric,
    sizeUnit Varchar(255),
    type uuid NOT NULL,
    class uuid NOT NULL,
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



/*create function foo_j(data JSON) returns void language plpgsql as $$
begin
  insert into t(x, y)
  select (d->>'x')::int, (d->>'y')::text
  from json_array_elements(data) as d;
  return;
end $$;*/


/* =============================================================================================
================================================================================================
================================================================================================
======================================FUNCTIONS=================================================
================================================================================================
================================================================================================
==============================================================================================*/

CREATE OR REPLACE FUNCTION public.postfuncloc(
	var_id uuid,
	var_name character varying,
	var_description character varying,
	OUT res_success boolean,
	OUT ret_error character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
var_exists boolean := false;
BEGIN
	IF EXISTS (SELECT 1 FROM public.Funcloc f WHERE f.isdeleted = false AND f.id = var_id) THEN
		var_exists := true;
        res_success := true;
        ret_error := 'Funcloc already exists! continuing with posting assets... ';
	ELSE
		INSERT INTO public.Funcloc(ID, name, description, CreatedDateTime, IsDeleted, ModifiedDateTime)
		VALUES(var_id, var_name, var_description, CURRENT_TIMESTAMP , 'false', CURRENT_TIMESTAMP );
        res_success := true;
        ret_error := 'Funcloc created! continuing with posting assets... ';
	END IF;
END;
$BODY$;

/*CREATE OR REPLACE FUNCTION foo_j(
    data JSON,
    OUT res_success boolean
) 
RETURNS boolean
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
    insert into t1(x1,y1)
	select (d->>'x1')::int, (d->>'y1')::text
    from json_array_elements(data) as d;
	insert into t(x, y)
    select (d->>'x')::int, (d->>'y')::text
    from json_array_elements(data) as d;
	
	res_success := true;
END;
$BODY$;*/

CREATE OR REPLACE FUNCTION public.postassets(
	data json,
	OUT res_success boolean,
	OUT ret_error character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE

BEGIN
    INSERT INTO public.Asset(ID, funclocID, name, description, serialno, size, sizeunit, type, class, dimension1Val, dimension2Val,
							dimension3Val, dimension4Val, dimension5Val, dimension6Val, extent, extentConfidence, takeOnDate,
							manufactureDate, derecognitionDate, derecognitionValue, CreatedDateTime, IsDeleted, ModifiedDateTime)
    SELECT (d->>'id')::uuid, (d->>'funclocid')::uuid, (d->>'name')::character varying, (d->>'description')::character varying,
		   (d->>'serialno')::character varying, (d->>'size')::numeric, (d->>'sizeunit')::character varying,
		   (d->>'type')::uuid, (d->>'class')::uuid, (d->>'dimension1val')::numeric, (d->>'dimension2val')::numeric,
		   (d->>'dimension3val')::numeric, (d->>'dimension4val')::numeric, (d->>'dimension5val')::numeric,
		   (d->>'dimension6val')::numeric, (d->>'extent')::character varying, (d->>'extentconfidence')::character varying,
		   (d->>'takeondate')::timestamp, (d->>'manufacturedate')::timestamp, (d->>'derecognitiondate')::timestamp,
		   (d->>'derecognitionvalue')::numeric, CURRENT_TIMESTAMP, 'false', CURRENT_TIMESTAMP
		   
    FROM json_array_elements(data) as d;
    res_success := true;
    ret_error := 'Asset Successfully created!';
END;
$BODY$;


/* ---- Creating all functions needed for CRUD functions to be used by the CRUD service ---- */


 

/* ---- Export Asset Function ---- */

CREATE OR REPLACE FUNCTION public.exportasset(
	var_assetid uuid,
	OUT ret_name character varying,
	OUT ret_description character varying,
	OUT ret_serialno character varying,
	OUT ret_size character varying,
	OUT ret_type character varying,
	OUT ret_class character varying,
	OUT ret_dimension1val character varying,
	OUT ret_dimension2val character varying,
	OUT ret_dimension3val character varying,
	OUT ret_dimension4val character varying,
	OUT ret_dimension5val character varying,
	OUT ret_dimension6val character varying,
	OUT ret_extent character varying,
	OUT ret_extentconfidence character varying,
	OUT ret_takeondate character varying,
	OUT ret_derecognitionvalue character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.Asset a WHERE a.id = var_assetid AND a.isdeleted = false) THEN
	SELECT CASE WHEN a.name IS NULL THEN 'n/a' ELSE a.name::text END, CASE WHEN a.description IS NULL THEN 'n/a' ELSE a.description::text END, CASE WHEN a.serialno IS NULL THEN 'n/a' ELSE a.serialno::text END, CASE WHEN a.size IS NULL THEN 'n/a' ELSE a.size::text END, CASE WHEN a.type IS NULL THEN 'n/a' ELSE a.type::text END, CASE WHEN a.class IS NULL THEN 'n/a' ELSE a.class::text END, CASE WHEN a.dimension1val IS NULL THEN 'n/a' ELSE a.dimension1val::text END, CASE WHEN a.dimension2val IS NULL THEN 'n/a' ELSE a.dimension2val::text END, CASE WHEN a.dimension3val IS NULL THEN 'n/a' ELSE a.dimension3val::text END,CASE WHEN a.dimension4val IS NULL THEN 'n/a' ELSE a.dimension4val::text END,  CASE WHEN a.dimension5val IS NULL THEN 'n/a' ELSE a.dimension5val::text END,  CASE WHEN a.dimension6val IS NULL THEN 'n/a' ELSE a.dimension6val::text END, a.extent, a.extentconfidence, CASE WHEN a.takeondate IS NULL THEN 'n/a' ELSE a.takeondate::text END, CASE WHEN a.derecognitionvalue IS NULL THEN 'n/a' ELSE a.derecognitionvalue::text END	
    INTO ret_name, ret_description, ret_serialno, ret_size, ret_type, ret_class, ret_dimension1val, ret_dimension2val, ret_dimension3val, ret_dimension4val, ret_dimension5val, ret_dimension6val, ret_extent, ret_extentconfidence, ret_takeondate, ret_derecognitionvalue
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


/* ---- Retrieve Asset Function ---- */

CREATE OR REPLACE FUNCTION public.retrieveasset(
	var_assetid uuid,
	OUT ret_name character varying,
	OUT ret_description character varying,
	OUT ret_serialno character varying,
	OUT ret_size character varying,
	OUT ret_type character varying,
	OUT ret_class character varying,
	OUT ret_dimension1val character varying,
	OUT ret_dimension2val character varying,
	OUT ret_dimension3val character varying,
	OUT ret_dimension4val character varying,
	OUT ret_dimension5val character varying,
	OUT ret_dimension6val character varying,
	OUT ret_extent character varying,
	OUT ret_extentconfidence character varying,
	OUT ret_takeondate character varying,
	OUT ret_derecognitionvalue character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.Asset a WHERE a.id = var_assetid AND a.isdeleted = false) THEN
	SELECT CASE WHEN a.name IS NULL THEN 'n/a' ELSE a.name::text END, CASE WHEN a.description IS NULL THEN 'n/a' ELSE a.description::text END, CASE WHEN a.serialno IS NULL THEN 'n/a' ELSE a.serialno::text END, CASE WHEN a.size IS NULL THEN 'n/a' ELSE a.size::text END, CASE WHEN a.type IS NULL THEN 'n/a' ELSE a.type::text END, CASE WHEN a.class IS NULL THEN 'n/a' ELSE a.class::text END, CASE WHEN a.dimension1val IS NULL THEN 'n/a' ELSE a.dimension1val::text END, CASE WHEN a.dimension2val IS NULL THEN 'n/a' ELSE a.dimension2val::text END, CASE WHEN a.dimension3val IS NULL THEN 'n/a' ELSE a.dimension3val::text END,CASE WHEN a.dimension4val IS NULL THEN 'n/a' ELSE a.dimension4val::text END,  CASE WHEN a.dimension5val IS NULL THEN 'n/a' ELSE a.dimension5val::text END,  CASE WHEN a.dimension6val IS NULL THEN 'n/a' ELSE a.dimension6val::text END, a.extent, a.extentconfidence, CASE WHEN a.takeondate IS NULL THEN 'n/a' ELSE a.takeondate::text END, CASE WHEN a.derecognitionvalue IS NULL THEN 'n/a' ELSE a.derecognitionvalue::text END	
    INTO ret_name, ret_description, ret_serialno, ret_size, ret_type, ret_class, ret_dimension1val, ret_dimension2val, ret_dimension3val, ret_dimension4val, ret_dimension5val, ret_dimension6val, ret_extent, ret_extentconfidence, ret_takeondate, ret_derecognitionvalue
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
    var_assettypeid uuid
)
    RETURNS TABLE( name character varying, description character varying, serialno character varying, size numeric, type uuid, class uuid, dimension1val numeric, dimension2val numeric, dimension3val numeric, dimension4val numeric, dimension5val numeric, dimension6val numeric, extent character varying, extentconfidence character varying, takeondate timestamp without time zone, derecognitionvalue numeric)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.name, a.description, a.serialno, a.size, a.type, a.class, a.dimension1val, a.dimension2val, a.dimension3val, a.dimension4val, a.dimension5val, a.dimension6val, a.extent, a.extentconfidence, a.takeondate, a.derecognitionvalue
    FROM public.Asset a
    WHERE a.type = var_assettypeid AND a.isdeleted = false;
END;
$BODY$;

/* ---- Extract Assets Function ---- */
CREATE OR REPLACE FUNCTION public.extractassets(
    var_assettypeid uuid
)
    RETURNS TABLE( name character varying, description character varying, serialno character varying, size numeric, type uuid, class uuid, dimension1val numeric, dimension2val numeric, dimension3val numeric, dimension4val numeric, dimension5val numeric, dimension6val numeric, extent character varying, extentconfidence character varying, takeondate timestamp without time zone, derecognitionvalue numeric)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.name, a.description, a.serialno, a.size, a.type, a.class, a.dimension1val, a.dimension2val, a.dimension3val, a.dimension4val, a.dimension5val, a.dimension6val, a.extent, a.extentconfidence, a.takeondate, a.derecognitionvalue
    FROM public.Asset a
    WHERE a.type = var_assettypeid AND a.isdeleted = false;
END;
$BODY$;

/* ---- Analyse Assets Function ---- */
CREATE OR REPLACE FUNCTION public.analyseassets(
     var_assettypeid uuid
)
    RETURNS TABLE( name character varying, description character varying, serialno character varying, size numeric, type uuid, class uuid, dimension1val numeric, dimension2val numeric, dimension3val numeric, dimension4val numeric, dimension5val numeric, dimension6val numeric, extent character varying, extentconfidence character varying, takeondate timestamp without time zone, derecognitionvalue numeric)
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.name, a.description, a.serialno, a.size, a.type, a.class, a.dimension1val, a.dimension2val, a.dimension3val, a.dimension4val, a.dimension5val, a.dimension6val, a.extent, a.extentconfidence, a.takeondate, a.derecognitionvalue
    FROM public.Asset a
    WHERE a.type = var_assettypeid AND a.isdeleted = false;
END;
$BODY$;


/* ---- Insert data for asset level ---- */
INSERT INTO public.AssetTypeLevel(ID, level, name, description, CreatedDateTime, ModifiedDateTime)
VALUES ('da832bde-d290-48e6-85a0-40e8347487ee' ,'1', 'one', 'Level One',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.AssetTypeLevel(ID, level, name, description, CreatedDateTime, ModifiedDateTime)
VALUES ('76f2f937-7fbb-4207-8bcd-6e40c0c7d350' ,'2', 'two', 'Level Two',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.AssetTypeLevel(ID, level, name, description, CreatedDateTime, ModifiedDateTime)
VALUES ('fc6daaa2-b87d-4033-931c-1a9c13f11837' ,'3', 'three', 'Level Three',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.AssetTypeLevel(ID, level, name, description, CreatedDateTime, ModifiedDateTime)
VALUES ('91b42869-92ee-441d-aef6-b2606edb4648' ,'4', 'four', 'Level Four',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.AssetTypeLevel(ID, level, name, description, CreatedDateTime, ModifiedDateTime)
VALUES ('1e588dc2-15e6-4957-a134-db660dd43e44' ,'5', 'five', 'Level Five',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.AssetTypeLevel(ID, level, name, description, CreatedDateTime, ModifiedDateTime)
VALUES ('f1285731-abb9-46dd-9269-dc1d835d9e4b' ,'6', 'six', 'Level Six',CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


/* ---- Insert data for asset Type ---- */
INSERT INTO public.AssetType(ID, AssetTypeLevelID, code, name, description, isUTC, sizeunit, typeLookup, sizeLookup, dimension1Name, dimension1Description, dimension1Unit, dimension2Name, dimension2Description, dimension2Unit, dimension3Name, dimension3Description, dimension3Unit, dimension5Name, dimension5Description, dimension5Unit, extentFormula, depreciationModel, depreciationMethod, isActive, CreatedDateTime, ModifiedDateTime)
VALUES ('7a20c16f-47f7-4e86-900f-d3504c46505c' ,'da832bde-d290-48e6-85a0-40e8347487ee', '120', 'Cast iron', 'Cast iron', true, 'meters', '0001' ,'0004', 'Length', 'Length', 'Length of the asset' ,'m', 'Width', 'Width of the asset', 'm', 'Height', 'Height of the Asset', 'Straight Line', 'Yes', 'none', 'A = l', 'none', 'none', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

/* ---- Insert data for functional location ---- */
INSERT INTO public.Funcloc(ID, name, description, CreatedDateTime, ModifiedDateTime)
VALUES ('29add2e4-3593-4f6a-8260-3eb3297b216c', 'Store1', 'Example store 1', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);


/* ---- Insert data for Asset ---- */
INSERT INTO public.Asset(ID, name, description, serialNo, size, sizeUnit, type, class, dimension1val, dimension2val, dimension3val, dimension4val, dimension5val, dimension6val, extent, extentConfidence, derecognitionValue, takeondate,  CreatedDateTime, ModifiedDateTime)
VALUES ('d417af58-150b-4c13-945c-61129927e66b' ,'Synthetic surface', 'Synthetic surface', '1234' ,'1234', 'meters', '7cafb7b2-5a5f-4ce6-9185-3b4ba2441658', '4615f9f9-e0ea-4a88-8c2e-0f35a9cce024', '5', '1' , '2', '2.2', '6', '2', 'Fair', 'Very Good', '2000', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO public.Asset(ID, name, description, serialNo, size, sizeUnit, type, class, dimension1val, dimension2val, dimension3val, dimension4val, dimension5val, dimension6val, extent, extentConfidence, derecognitionValue, takeondate, CreatedDateTime, ModifiedDateTime)
VALUES ('b5400743-ef94-46ae-ad66-50b0eb043f65' ,'Real surface', 'Synthetic surface', '1263' ,'1263', 'kilometers', '7cafb7b2-5a5f-4ce6-9185-3b4ba2441658', '4615f9f9-e0ea-4a88-8c2e-0f35a9cce024', '5', '1' , '2', '2.2', '6', '2', 'Poor', 'Very Good', '2000', CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);