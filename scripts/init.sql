/* ---- Creating Extension needed for uuid datatypes and uuid operations ---- */
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


/* ---- Initializing all tables ---- */

CREATE TABLE public.CriticalityTypeLookup (
    ID uuid PRIMARY KEY NOT NULL ,
    Code integer,
    name Varchar(255),
    description Varchar(255),
    consequenceOfFailiure Varchar(255)
);

CREATE TABLE public.CompatibleUnit (
    ID uuid PRIMARY KEY NOT NULL ,
    Code integer,
    Name Varchar(255),
    Description Varchar(255),
    EULyears Varchar(255),
    ResidualValFactor Varchar(255),
    Size Varchar(255),
    SizeUnit Varchar(255),
    Type Varchar(255),
    Class Varchar(255),
    IsActive Varchar(255),
    CriticalityTypeLookupID uuid NOT NULL ,
    CONSTRAINT compatibleunitcriticalityidfkey FOREIGN KEY (CriticalityTypeLookupID)
        REFERENCES public.CriticalityTypeLookup (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);


CREATE TABLE public.Asset (
    ID uuid PRIMARY KEY NOT NULL ,
    name Varchar(255),
    AssetType Varchar(255),
    CompatibleUnitID uuid NOT NULL ,
    CONSTRAINT compatibleunitidfkey FOREIGN KEY (CompatibleUnitID)
        REFERENCES public.CompatibleUnit (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    derecognitionDate Varchar(255),
    derecognitionValue Varchar(255),
    description Varchar(255),
    dimension1Value Varchar(255),
    dimension2Value Varchar(255),
    dimension3Value Varchar(255),
    dimension4Value Varchar(255),
    dimension5Value Varchar(255),
    extent Varchar(255),
    extentConfidence Varchar(255),
    manufactureDate DATE,
    manufactureDateConfidence Varchar(255),
    takeOnDate DATE,
    serialNo Varchar(255),
    lat Varchar(255),
    lon Varchar(255),
    geom geometry
);

CREATE TABLE public.ObservationFlexVal (
    ID uuid PRIMARY KEY NOT NULL ,
    AssetID uuid NOT NULL ,
    CONSTRAINT observationflexvalassetfkey FOREIGN KEY (AssetID)
        REFERENCES public.Asset (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    name Varchar(255),
    value Varchar(255)
);


CREATE TABLE public.AssetValue(
    ID uuid PRIMARY KEY NOT NULL ,
    AssetID uuid NOT NULL ,
    CONSTRAINT assetidfkey FOREIGN KEY (AssetID)
        REFERENCES public.Asset (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    AGE varchar(255),
    carryingValueClosingBalance NUMERIC,
    carryingValueOpeningBalance NUMERIC,
    costClosingBalance NUMERIC,
    costOpeningBalance NUMERIC,
    CRC NUMERIC,
    depreciationClosingBalance NUMERIC,
    depreciationOpeningBalance NUMERIC,
    impairmentClosingBalance NUMERIC,
    impairmentOpeningBalance NUMERIC,
    residualValue NUMERIC,
    RULyears NUMERIC,
    DRC NUMERIC,
    FY NUMERIC
);

CREATE TABLE public.AssetFlexVal (
    ID uuid PRIMARY KEY NOT NULL ,
    AssetID uuid NOT NULL ,
    CONSTRAINT assetidfkey FOREIGN KEY (AssetID)
        REFERENCES public.Asset (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    name Varchar(255),
    value Varchar(255)
);

CREATE TABLE public.FuncLoc (
    ID uuid PRIMARY KEY NOT NULL ,
    description Varchar(255),
    name Varchar(255),
    LAT Varchar(255),
    LONG Varchar(255),
    geom geometry
);

CREATE TABLE public.NodeType (
    ID uuid PRIMARY KEY NOT NULL ,
    name Varchar(255),
    description Varchar(255)
);

CREATE TABLE public.FuncLocNode (
    ID uuid PRIMARY KEY NOT NULL ,
    name Varchar(255),
    aliasName Varchar(255),
    lat Varchar(255),
    long Varchar(255),
    geom geometry,
    nodeType uuid NOT NULL ,
    CONSTRAINT funclocnodenodetypefkey FOREIGN KEY (nodeType)
        REFERENCES public.NodeType (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ParentID uuid NOT NULL ,
    CONSTRAINT funclocnodenodefunclocnodefkey FOREIGN KEY (ParentID)
        REFERENCES public.FuncLocNode (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);


CREATE TABLE public.FuncLocLink (
    FuncLocID uuid NOT NULL ,
    CONSTRAINT funcloclinkfunclocfkey FOREIGN KEY (FuncLocID)
        REFERENCES public.FuncLoc (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    FuncLocNodeID uuid NOT NULL ,
    CONSTRAINT cudeploymentcompatibleunitfkey FOREIGN KEY (FuncLocNodeID)
        REFERENCES public.FuncLocNode (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);


CREATE TABLE public.AssetDeployment(
    AssetID uuid NOT NULL ,
    CONSTRAINT assetidfkey FOREIGN KEY (AssetID)
        REFERENCES public.Asset (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    FuncLockID uuid NOT NULL ,
    CONSTRAINT funclockidfkey FOREIGN KEY (FuncLockID)
        REFERENCES public.FuncLoc (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    installDate DATE,
    removeDate DATE,
    status Varchar(255)
);

CREATE TABLE public.AssetTypeLevel(
    ID uuid PRIMARY KEY NOT NULL ,
    level Varchar(255),
    name Varchar(255),
    description Varchar(255)
);

CREATE TABLE public.AssetType(
    ID uuid PRIMARY KEY NOT NULL ,
    AssetTypeLevelID uuid NOT NULL ,
    CONSTRAINT assettypeassettypelevelfkey FOREIGN KEY (AssetTypeLevelID)
        REFERENCES public.AssetTypeLevel (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    C integer, 
    name Varchar(255),
    description Varchar(255),
    isUTC Varchar(255),
    sizeUnit Varchar(255),
    typeLookup Varchar(255),
    sizeLookup Varchar(255),
    dimension1Name Varchar(255),
    dimension1Description Varchar(255),
    dimension1Unit Varchar(255),
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
    extentUOMName Varchar(255),
    extentUOMUnit Varchar(255),
    reportUOMName Varchar(255),
    reportUOMUnit Varchar(255),
    depreciationModel Varchar(255),
    depreciationMethod Varchar(255),
    isActive Varchar(255)
);

CREATE TABLE public.CUDeployment(
    AssetTypeID uuid NOT NULL ,
    CONSTRAINT cudeploymentassettypefkey FOREIGN KEY (AssetTypeID)
        REFERENCES public.AssetType (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CompatibleUnitID uuid NOT NULL ,
    CONSTRAINT cudeploymentcompatibleunitfkey FOREIGN KEY (CompatibleUnitID)
        REFERENCES public.CompatibleUnit (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE public.AssetTypeInheritance(
    ID uuid PRIMARY KEY NOT NULL ,
    ParentID uuid NOT NULL ,
    CONSTRAINT assettypeinheritenceassettypefkey FOREIGN KEY (ParentID)
        REFERENCES public.AssetType (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ChildID uuid NOT NULL ,
    CONSTRAINT assettypeinheriteassettypesfkey FOREIGN KEY (ChildID)
        REFERENCES public.AssetType (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION
);

CREATE TABLE public.TypeLookup (
    ID uuid PRIMARY KEY NOT NULL ,
    AssetTypeID uuid NOT NULL ,
    CONSTRAINT typelookupassettypefkey FOREIGN KEY (AssetTypeID)
        REFERENCES public.AssetType (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    Name Varchar(255),
    Description Varchar(255)
);

CREATE TABLE public.ClassLookup (
    ID uuid PRIMARY KEY NOT NULL ,
    AssetTypeID uuid NOT NULL ,
    CONSTRAINT classlookupassettypefkey FOREIGN KEY (AssetTypeID)
        REFERENCES public.AssetType (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    Name Varchar(255),
    Description Varchar(255)
);




/* ---- Shadow tables ---- */

/* ---- Initializing shadow tables ---- */

CREATE TABLE public.sdwCriticalityTypeLookup (
    ID uuid PRIMARY KEY NOT NULL ,
    Code integer,
    name Varchar(255),
    description Varchar(255),
    consequenceOfFailure Varchar(255),
    IsHandled Boolean DEFAULT(false)
);

CREATE TABLE public.sdwCompatibleUnit (
    ID uuid PRIMARY KEY NOT NULL ,
    Code integer,
    Name Varchar(255),
    Description Varchar(255),
    EULyears Varchar(255),
    ResidualValFactor Varchar(255),
    Size Varchar(255),
    SizeUnit Varchar(255),
    Type Varchar(255),
    Class Varchar(255),
    IsActive Varchar(255),
    CriticalityTypeLookupID uuid NOT NULL ,
    CONSTRAINT sdwcompatibleunitsdwcriticalityidfkey FOREIGN KEY (CriticalityTypeLookupID)
        REFERENCES public.sdwCriticalityTypeLookup (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    IsHandled Boolean DEFAULT(false)
);


CREATE TABLE public.sdwAsset (
    ID uuid PRIMARY KEY NOT NULL ,
    name Varchar(255),
    AssetType Varchar(255),
    CompatibleUnitID uuid NOT NULL ,
    CONSTRAINT sdwcompatibleunitidfkey FOREIGN KEY (CompatibleUnitID)
        REFERENCES public.sdwCompatibleUnit (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    derecognitionDate Varchar(255),
    derecognitionValue Varchar(255),
    description Varchar(255),
    dimension1Value Varchar(255),
    dimension2Value Varchar(255),
    dimension3Value Varchar(255),
    dimension4Value Varchar(255),
    dimension5Value Varchar(255),
    extent Varchar(255),
    extentConfidence Varchar(255),
    manufactureDate DATE,
    manufactureDateConfidence Varchar(255),
    takeOnDate DATE,
    serialNo Varchar(255),
    lat Varchar(255),
    lon Varchar(255),
    geom geometry,
    IsHandled Boolean DEFAULT(false)
);

CREATE TABLE public.sdwObservationFlexVal (
    ID uuid PRIMARY KEY NOT NULL ,
    AssetID uuid NOT NULL ,
    CONSTRAINT sdwobservationflexvalsdwassetfkey FOREIGN KEY (AssetID)
        REFERENCES public.sdwAsset (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    name Varchar(255),
    value Varchar(255),
    IsHandled Boolean DEFAULT(false)
);


CREATE TABLE public.sdwAssetValue(
    ID uuid PRIMARY KEY NOT NULL ,
    AssetID uuid NOT NULL ,
    CONSTRAINT sdwassetidfkey FOREIGN KEY (AssetID)
        REFERENCES public.sdwAsset (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    AGE varchar(255),
    carryingValueClosingBalance NUMERIC,
    carryingValueOpeningBalance NUMERIC,
    costClosingBalance NUMERIC,
    costOpeningBalance NUMERIC,
    CRC NUMERIC,
    depreciationClosingBalance NUMERIC,
    depreciationOpeningBalance NUMERIC,
    impairmentClosingBalance NUMERIC,
    impairmentOpeningBalance NUMERIC,
    residualValue NUMERIC,
    RULyears NUMERIC,
    DRC NUMERIC,
    FY NUMERIC,
    IsHandled Boolean DEFAULT(false)
);

CREATE TABLE public.sdwAssetFlexVal (
    ID uuid PRIMARY KEY NOT NULL ,
    AssetID uuid NOT NULL ,
    CONSTRAINT sdwassetidfkey FOREIGN KEY (AssetID)
        REFERENCES public.sdwAsset (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    name Varchar(255),
    value Varchar(255),
    IsHandled Boolean DEFAULT(false)
);

CREATE TABLE public.sdwFuncLoc (
    ID uuid PRIMARY KEY NOT NULL ,
    description Varchar(255),
    name Varchar(255),
    LAT Varchar(255),
    LONG Varchar(255),
    geom geometry,
    IsHandled Boolean DEFAULT(false)
);

CREATE TABLE public.sdwNodeType (
    ID uuid PRIMARY KEY NOT NULL ,
    name Varchar(255),
    description Varchar(255),
    IsHandled Boolean DEFAULT(false)
);

CREATE TABLE public.sdwFuncLocNode (
    ID uuid PRIMARY KEY NOT NULL ,
    name Varchar(255),
    aliasName Varchar(255),
    lat Varchar(255),
    long Varchar(255),
    geom geometry,
    nodeType uuid NOT NULL ,
    CONSTRAINT swdfunclocnodesdwnodetypefkey FOREIGN KEY (nodeType)
        REFERENCES public.sdwNodeType (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ParentID uuid NOT NULL ,
    CONSTRAINT funclocnodenodefunclocnodefkey FOREIGN KEY (ParentID)
        REFERENCES public.sdwFuncLocNode (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    IsHandled Boolean DEFAULT(false)
);


CREATE TABLE public.sdwFuncLocLink (
    FuncLocID uuid NOT NULL ,
    CONSTRAINT funcloclinkfunclocfkey FOREIGN KEY (FuncLocID)
        REFERENCES public.sdwFuncLoc (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    FuncLocNodeID uuid NOT NULL ,
    CONSTRAINT cudeploymentcompatibleunitfkey FOREIGN KEY (FuncLocNodeID)
        REFERENCES public.sdwFuncLocNode (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    IsHandled Boolean DEFAULT(false)
);



CREATE TABLE public.sdwAssetDeployment(
    AssetID uuid NOT NULL ,
    CONSTRAINT sdwassetidfkey FOREIGN KEY (AssetID)
        REFERENCES public.sdwAsset (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    FuncLockID uuid NOT NULL ,
    CONSTRAINT sdwfunclockidfkey FOREIGN KEY (FuncLockID)
        REFERENCES public.sdwFuncLoc (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    installDate DATE,
    removeDate Varchar(255),
    status Varchar(255),
    IsHandled Boolean DEFAULT(false)
);

CREATE TABLE public.sdwAssetTypeLevel(
    ID uuid PRIMARY KEY NOT NULL ,
    level Varchar(255),
    name Varchar(255),
    description Varchar(255),
    IsHandled Boolean DEFAULT(false)
);

CREATE TABLE public.sdwAssetType(
    ID uuid PRIMARY KEY NOT NULL ,
    AssetTypeLevelID uuid NOT NULL ,
    CONSTRAINT sdwassettypeasdwssettypelevelfkey FOREIGN KEY (AssetTypeLevelID)
        REFERENCES public.sdwAssetTypeLevel (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    code integer, 
    name Varchar(255),
    description Varchar(255),
    isUTC Varchar(255),
    sizeUnit Varchar(255),
    typeLookup Varchar(255),
    sizeLookup Varchar(255),
    dimension1Name Varchar(255),
    dimension1Description Varchar(255),
    dimension1Unit Varchar(255),
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
    extentUOMName Varchar(255),
    extentUOMUnit Varchar(255),
    reportUOMName Varchar(255),
    reportUOMUnit Varchar(255),
    depreciationModel Varchar(255),
    depreciationMethod Varchar(255),
    isActive Varchar(255),
    IsHandled Boolean DEFAULT(false)
);

CREATE TABLE public.sdwCUDeployment(
    AssetTypeID uuid NOT NULL ,
    CONSTRAINT sdwcudeploymentsdwassettypefkey FOREIGN KEY (AssetTypeID)
        REFERENCES public.sdwAssetType (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CompatibleUnitID uuid NOT NULL ,
    CONSTRAINT sdwcudeploymentsdwcompatibleunitfkey FOREIGN KEY (CompatibleUnitID)
        REFERENCES public.sdwCompatibleUnit (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    IsHandled Boolean DEFAULT(false)
);

CREATE TABLE public.sdwAssetTypeInheritance(
    ID uuid PRIMARY KEY NOT NULL ,
    ParentID uuid NOT NULL ,
    CONSTRAINT sdwassettypeinheritenceassettypefkey FOREIGN KEY (ParentID)
        REFERENCES public.sdwAssetType (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    ChildID uuid NOT NULL ,
    CONSTRAINT sdwassettypeinheriteassettypesfkey FOREIGN KEY (ChildID)
        REFERENCES public.sdwAssetType (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    IsHandled Boolean DEFAULT(false)
);

CREATE TABLE public.sdwTypeLookup (
    ID uuid PRIMARY KEY NOT NULL ,
    AssetTypeID uuid NOT NULL ,
    CONSTRAINT sdwtypelookupassettypefkey FOREIGN KEY (AssetTypeID)
        REFERENCES public.sdwAssetType (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    Name Varchar(255),
    Description Varchar(255),
    IsHandled Boolean DEFAULT(false)
);

CREATE TABLE public.sdwClassLookup (
    ID uuid PRIMARY KEY NOT NULL ,
    AssetTypeID uuid NOT NULL ,
    CONSTRAINT sdwclasslookupassettypefkey FOREIGN KEY (AssetTypeID)
        REFERENCES public.sdwAssetType (ID) MATCH SIMPLE
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    Name Varchar(255),
    Description Varchar(255),
    IsHandled Boolean DEFAULT(false)
);





/* =============================================================================================
================================================================================================
================================================================================================
======================================FUNCTIONS=================================================
================================================================================================
================================================================================================
==============================================================================================*/

/* ======== Create Functional Location in AR Tables ======== */


CREATE OR REPLACE FUNCTION public.postfuncloc(
	var_name character varying,
	var_description character varying,
	var_lat character varying,
	var_long character varying,
	var_geom character varying,
	OUT res_success boolean,
	OUT ret_error character varying,
	OUT ret_id uuid)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
var_exists boolean := false;
random_funclocid uuid := uuid_generate_v4();
BEGIN
	IF EXISTS (SELECT 1 FROM public.Funcloc f WHERE f.name = var_name AND f.LAT = var_lat AND f.LONG = var_long) THEN
		var_exists := true;
        res_success := true;
        ret_error := 'Funcloc already exists! continuing with posting funclocnode... ';
		SELECT id FROM public.Funcloc f WHERE f.name = var_name AND f.LAT = var_lat AND f.LONG = var_long
		INTO ret_id;
	ELSE
		INSERT INTO public.Funcloc(ID, name, description, LAT, LONG, Geom)
		VALUES(random_funclocid, var_name, var_description, var_lat, var_long, var_geom);
        res_success := true;
        ret_error := 'Funcloc created! continuing with posting funclocnode... ';
		ret_id := random_funclocid;
	END IF;
END;
$BODY$;




/* ======== Create Functional Location Node in AR Tables ======== */


CREATE OR REPLACE FUNCTION public.postfunclocnode(
	var_name character varying,
	var_aliasname character varying,
	var_lat character varying,
	var_long character varying,
	var_geom character varying,
	var_nodetype uuid,
	var_parentid uuid,
	OUT res_success boolean,
	OUT ret_error character varying,
	OUT ret_id uuid )
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
var_exists boolean := false;
random_id uuid := uuid_generate_v4();
BEGIN
	IF EXISTS (SELECT 1 FROM public.FuncLocNode f WHERE f.name = var_name) THEN
		var_exists := true;
        res_success := true;
        ret_error := 'Funclocnode already exists! continuing with posting funcloclink... ';
		SELECT id FROM public.FunclocNode f WHERE f.name = var_name
		INTO ret_id;
	ELSE
		INSERT INTO public.FuncLocNode(ID, name, aliasname, lat, long, geom, nodetype, parentid)
		VALUES(random_id, var_name, var_aliasname, var_lat, var_long, var_geom, var_nodetype, var_parentid);
        res_success := true;
        ret_error := 'Funclocnode created! continuing with posting funcloclink... ';
		ret_id := random_id;
	END IF;
END;
$BODY$;


/* ======== Create Functional Location Link in AR Tables ======== */


CREATE OR REPLACE FUNCTION public.postfuncloclink(
	var_funclocid uuid,
    var_funclocnodeid uuid,
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
	IF EXISTS (SELECT 1 FROM public.FuncLocLink f WHERE f.funclocid = var_funclocid AND f.funclocnodeid = var_funclocnodeid ) THEN
		var_exists := true;
        res_success := true;
        ret_error := 'FuncLocLink already exists! continuing with posting assets... ';
	ELSE
		INSERT INTO public.FuncLocLink(funclocid, funclocnodeid)
		VALUES(var_funclocid, var_funclocnodeid);
        res_success := true;
        ret_error := 'FuncLocLink created! continuing with posting assets... ';
	END IF;
END;
$BODY$;



/* ======== Create Functional Location in Shadow Tables ======== */

CREATE OR REPLACE FUNCTION public.sdwpostfuncloc(
	var_id uuid,
	var_name character varying,
	var_description character varying,
	var_lat character varying,
	var_long character varying,
	var_geom character varying,
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
	INSERT INTO public.sdwFuncLoc(ID, description, name, LAT, LONG, geom)
	VALUES(var_id, var_description, var_name, var_lat, var_long, var_geom);
	res_success := true;
	ret_error := 'Shadow Funcloc created! continuing with posting assets to shadow tables... ';
END;
$BODY$;

/* ======== Update Funclocs in AR Tables ======== */

CREATE OR REPLACE FUNCTION public.updatefuncloc(
	var_id uuid,
	var_name character varying,
	var_description character varying,
	var_lat character varying,
	var_long character varying,
	var_geom character varying,
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
IF EXISTS (SELECT 1 FROM public.Funcloc f WHERE f.id = var_id) THEN
    UPDATE public.Funcloc f 
    SET name = var_name, description = var_description, lat = var_lat, long = var_long, geom = var_geom
    WHERE f.id = var_id;
    res_success = true;
    ret_error = 'Funcloc successfully updated!';
ELSE
    res_success = false;
    ret_error = 'Funcloc ID does not exist...';
END IF;
	
END;
$BODY$;

/* ======== Create Assets in AR Tables ========  */

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
    INSERT INTO public.Asset(ID, name, AssetType, CompatibleUnitID, derecognitionDate, derecognitionValue, description, dimension1Value, dimension2Value,
							dimension3Value, dimension4Value, dimension5Value, extent, extentConfidence, manufactureDate, 
                            manufactureDateConfidence, takeOnDate, serialNo, lat, lon, geom
    )
    SELECT  (d->>'id')::uuid, (d->>'name')::character varying, (d->>'assettype')::character varying,
            (d->>'compatibleunitid')::uuid, (d->>'derecognitiondate')::character varying, (d->>'derecognitionvalue')::character varying,
            (d->>'description')::character varying, (d->>'dimension1value')::character varying, (d->>'dimension2value')::character varying,
            (d->>'dimension3value')::character varying, (d->>'dimension4value')::character varying, (d->>'dimension5value')::character varying,
            (d->>'extent')::character varying, (d->>'extentconfidence')::character varying, (d->>'manufacturedate')::date,
            (d->>'manufacturedateconfidence')::character varying, (d->>'takeondate')::date, (d->>'serialno')::character varying,
            (d->>'lat')::character varying, (d->>'lon')::character varying, (d->>'geom')::character varying
            
    FROM json_array_elements(data) as d;
    
    INSERT INTO public.AssetDeployment(AssetID, FuncLockID, installDate, status)
    SELECT (ad->>'id')::uuid, (ad->>'funclocid')::uuid, (ad->>'installdate')::date, (ad->>'active')::character varying

    FROM json_array_elements(data) as ad; 
    
    INSERT INTO public.AssetValue(ID, AssetID, AGE, carryingValueClosingBalance, carryingValueOpeningBalance, costClosingBalance, costOpeningBalance, CRC,
                depreciationClosingBalance, depreciationOpeningBalance, impairmentClosingBalance, impairmentOpeningBalance, residualValue, RULyears, DRC, FY
    )
    SELECT  (av->>'assetvalid')::uuid, (av->>'id')::uuid, (av->>'age')::character varying, (av->>'carryingvalueclosingbalance')::numeric, (av->>'carryingvalueopeningbalance')::numeric,
            (av->>'costclosingbalance')::numeric, (av->>'costopeningbalance')::numeric, (av->>'crc')::numeric, (av->>'depreciationclosingbalance')::numeric, 
            (av->>'depreciationopeningbalance')::numeric, (av->>'impairmentclosingbalance')::numeric, (av->>'impairmentopeningbalance')::numeric,
            (av->>'residualvalue')::numeric, (av->>'rulyears')::numeric, (av->>'drc')::numeric, (av->>'fy')::numeric
    FROM json_array_elements(data) as av;

    res_success := true;
    ret_error := 'Asset Successfully created!';
END;
$BODY$;

/* ======== Create Assets in Shadow Tables ======== */

CREATE OR REPLACE FUNCTION public.sdwpostassets(
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
    INSERT INTO public.sdwAsset(ID, name, AssetType, CompatibleUnitID, derecognitionDate, derecognitionValue, description, dimension1Value, dimension2Value,
							dimension3Value, dimension4Value, dimension5Value, extent, extentConfidence, manufactureDate, 
                            manufactureDateConfidence, takeOnDate, serialNo, lat, lon, geom
    )
    SELECT  (d->>'id')::uuid, (d->>'name')::character varying, (d->>'assettype')::character varying,
            (d->>'compatibleunitid')::uuid, (d->>'derecognitiondate')::character varying, (d->>'derecognitionvalue')::character varying,
            (d->>'description')::character varying, (d->>'dimension1value')::character varying, (d->>'dimension2value')::character varying,
            (d->>'dimension3value')::character varying, (d->>'dimension4value')::character varying, (d->>'dimension5value')::character varying,
            (d->>'extent')::character varying, (d->>'extentconfidence')::character varying, (d->>'manufacturedate')::date,
            (d->>'manufacturedateconfidence')::character varying, (d->>'takeondate')::date, (d->>'serialno')::character varying,
            (d->>'lat')::character varying, (d->>'lon')::character varying, (d->>'geom')::character varying
            
    FROM json_array_elements(data) as d;
    
    INSERT INTO public.sdwAssetDeployment(AssetID, FuncLockID, installDate, status)
    SELECT (ad->>'id')::uuid, (ad->>'funclocid')::uuid, (ad->>'installdate')::date, (ad->>'active')::character varying

    FROM json_array_elements(data) as ad; 
    
    INSERT INTO public.sdwAssetValue(ID, AssetID, AGE, carryingValueClosingBalance, carryingValueOpeningBalance, costClosingBalance, costOpeningBalance, CRC,
                depreciationClosingBalance, depreciationOpeningBalance, impairmentClosingBalance, impairmentOpeningBalance, residualValue, RULyears, DRC, FY
    )
    SELECT  (av->>'assetvalid')::uuid, (av->>'id')::uuid, (av->>'age')::character varying, (av->>'carryingvalueclosingbalance')::numeric, (av->>'carryingvalueopeningbalance')::numeric,
            (av->>'costclosingbalance')::numeric, (av->>'costopeningbalance')::numeric, (av->>'crc')::numeric, (av->>'depreciationclosingbalance')::numeric, 
            (av->>'depreciationopeningbalance')::numeric, (av->>'impairmentclosingbalance')::numeric, (av->>'impairmentopeningbalance')::numeric,
            (av->>'residualvalue')::numeric, (av->>'rulyears')::numeric, (av->>'drc')::numeric, (av->>'fy')::numeric
    FROM json_array_elements(data) as av;

    res_success := true;
    ret_error := 'Shadow Asset Successfully created!';
END;
$BODY$;


CREATE OR REPLACE FUNCTION public.updateassets(
	data json,
	OUT res_success boolean,
	OUT ret_error character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE
var_assetID integer = 0;
BEGIN

    SELECT (t->>'id')::uuid
    INTO var_assetID
    FROM json_array_elements(data) as t;
    
    UPDATE public.Asset a

    SET name = (d->>'name')::character varying, AssetType = (d->>'assettype')::character varying,
    CompatibleUnitID = (d->>'compatibleunitid')::uuid, derecognitionDate = (d->>'derecognitiondate')::character varying,
    derecognitionValue = (d->>'derecognitionvalue')::character varying, description = (d->>'description')::character varying,
    dimension1Value = (d->>'dimension1value')::character varying, dimension2Value = (d->>'dimension2value')::character varying,
    dimension3Value = (d->>'dimension3value')::character varying, dimension4Value = (d->>'dimension4value')::character varying,
    dimension5Value = (d->>'dimension5value')::character varying, extent = (d->>'extent')::character varying,
    extentConfidence = (d->>'extentconfidence')::character varying, manufactureDate = (d->>'manufacturedate')::date,
    manufactureDateConfidence = (d->>'manufacturedateconfidence')::character varying, takeOnDate = (d->>'takeondate')::date,
    serialNo = (d->>'serialno')::character varying, lat = (d->>'lat')::character varying,
    lon = (d->>'lon')::character varying, geom = (d->>'geom')::character varying

	FROM json_array_elements(data) as d
    WHERE a.id = var_assetID;

    UPDATE public.AssetDeployment adp

    SET installDate = (ad->>'installdate')::date , status = (ad->>'active')::character varying

    FROM json_array_elements(data) as ad
    WHERE adp.AssetID = var_assetID;

    UPDATE public.AssetValue avl

    SET AGE = (av->>'age')::character varying, carryingValueClosingBalance = (av->>'carryingvalueclosingbalance')::numeric,
    carryingValueOpeningBalance = (av->>'carryingvalueopeningbalance')::numeric, costClosingBalance = (av->>'costclosingbalance')::numeric,
    costOpeningBalance = (av->>'costopeningbalance')::numeric, CRC = (av->>'crc')::numeric,
    depreciationClosingBalance = (av->>'depreciationclosingbalance')::numeric, depreciationOpeningBalance = (av->>'depreciationopeningbalance')::numeric,
    impairmentClosingBalance = (av->>'impairmentclosingbalance')::numeric, impairmentOpeningBalance = (av->>'impairmentopeningbalance')::numeric,
    residualValue = (av->>'residualvalue')::numeric, RULyears = (av->>'rulyears')::numeric,
    DRC = (av->>'drc')::numeric, FY = (av->>'fy')::numeric 

    FROM json_array_elements(data) as av
    WHERE avl.AssetID = var_assetID;

    res_success := true;
    ret_error := 'Asset Successfully Updated!';

END;
$BODY$;


CREATE OR REPLACE FUNCTION public.handleshadowtablefuncloc(
	var_id uuid,
    OUT res_error character varying
	)
	RETURNS character varying
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE

BEGIN
	IF EXISTS (SELECT 1 FROM public.sdwFuncloc fl where fl.id = var_id ) THEN
        UPDATE public.sdwFuncloc fl
        SET isHandled = true
        WHERE fl.id = var_id;
        res_error := 'Funcloc handled and moved to Asset Register';
    ELSE
        res_error := 'Funcloc ID does not exist!';
    END IF;
	

END;
$BODY$;

CREATE OR REPLACE FUNCTION public.handleshadowtableasset(
	var_id uuid,
    OUT res_error character varying
	)
	RETURNS character varying
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE

BEGIN
	IF EXISTS (SELECT 1 FROM public.sdwAsset a where a.id = var_id ) THEN
        UPDATE public.sdwAsset a
        SET isHandled = true
        WHERE a.id = var_id;
        res_error := 'Asset handled and moved to Asset Register';
    ELSE
        res_error := 'Asset ID does not exist!';
    END IF;
	

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
	OUT ret_derecognitionvalue character varying,
    OUT ret_latitude character varying,
    OUT ret_longitude character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.Asset a WHERE a.id = var_assetid ) THEN
	SELECT CASE WHEN a.name IS NULL THEN 'n/a' ELSE a.name::text END, CASE WHEN a.description IS NULL THEN 'n/a' ELSE a.description::text END, CASE WHEN a.serialno IS NULL THEN 'n/a' ELSE a.serialno::text END, CASE WHEN a.size IS NULL THEN 'n/a' ELSE a.size::text END, CASE WHEN a.type IS NULL THEN 'n/a' ELSE a.type::text END, CASE WHEN a.class IS NULL THEN 'n/a' ELSE a.class::text END, CASE WHEN a.dimension1val IS NULL THEN 'n/a' ELSE a.dimension1val::text END, CASE WHEN a.dimension2val IS NULL THEN 'n/a' ELSE a.dimension2val::text END, CASE WHEN a.dimension3val IS NULL THEN 'n/a' ELSE a.dimension3val::text END,CASE WHEN a.dimension4val IS NULL THEN 'n/a' ELSE a.dimension4val::text END,  CASE WHEN a.dimension5val IS NULL THEN 'n/a' ELSE a.dimension5val::text END,  CASE WHEN a.dimension6val IS NULL THEN 'n/a' ELSE a.dimension6val::text END, a.extent, a.extentconfidence, CASE WHEN a.takeondate IS NULL THEN 'n/a' ELSE a.takeondate::text END, CASE WHEN a.derecognitionvalue IS NULL THEN 'n/a' ELSE a.derecognitionvalue::text END, CASE WHEN f.latitude IS NULL THEN 'n/a' ELSE f.latitude::text END, CASE WHEN f.longitude IS NULL THEN 'n/a' ELSE f.longitude::text END	
    INTO ret_name, ret_description, ret_serialno, ret_size, ret_type, ret_class, ret_dimension1val, ret_dimension2val, ret_dimension3val, ret_dimension4val, ret_dimension5val, ret_dimension6val, ret_extent, ret_extentconfidence, ret_takeondate, ret_derecognitionvalue, ret_latitude, ret_longitude
    FROM public.Asset a
    LEFT JOIN public.funcloc f ON f.id = a.funclocid
    WHERE a.id = var_assetid;
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
        ret_latitude = 'none';
        ret_longitude = 'none';
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
	OUT ret_derecognitionvalue character varying, 
    OUT ret_latitude character varying,
    OUT ret_longitude character varying
    )
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.Asset a WHERE a.id = var_assetid) THEN
	SELECT CASE WHEN a.name IS NULL THEN 'n/a' ELSE a.name::text END, CASE WHEN a.description IS NULL THEN 'n/a' ELSE a.description::text END, CASE WHEN a.serialno IS NULL THEN 'n/a' ELSE a.serialno::text END, CASE WHEN a.size IS NULL THEN 'n/a' ELSE a.size::text END, CASE WHEN a.type IS NULL THEN 'n/a' ELSE a.type::text END, CASE WHEN a.class IS NULL THEN 'n/a' ELSE a.class::text END, CASE WHEN a.dimension1val IS NULL THEN 'n/a' ELSE a.dimension1val::text END, CASE WHEN a.dimension2val IS NULL THEN 'n/a' ELSE a.dimension2val::text END, CASE WHEN a.dimension3val IS NULL THEN 'n/a' ELSE a.dimension3val::text END,CASE WHEN a.dimension4val IS NULL THEN 'n/a' ELSE a.dimension4val::text END,  CASE WHEN a.dimension5val IS NULL THEN 'n/a' ELSE a.dimension5val::text END,  CASE WHEN a.dimension6val IS NULL THEN 'n/a' ELSE a.dimension6val::text END, a.extent, a.extentconfidence, CASE WHEN a.takeondate IS NULL THEN 'n/a' ELSE a.takeondate::text END, CASE WHEN a.derecognitionvalue IS NULL THEN 'n/a' ELSE a.derecognitionvalue::text END, CASE WHEN f.latitude IS NULL THEN 'n/a' ELSE f.latitude::text END, CASE WHEN f.longitude IS NULL THEN 'n/a' ELSE f.longitude::text END			
    INTO ret_name, ret_description, ret_serialno, ret_size, ret_type, ret_class, ret_dimension1val, ret_dimension2val, ret_dimension3val, ret_dimension4val, ret_dimension5val, ret_dimension6val, ret_extent, ret_extentconfidence, ret_takeondate, ret_derecognitionvalue, ret_latitude, ret_longitude
    FROM public.Asset a
    LEFT JOIN public.funcloc f ON f.id = a.funclocid
    WHERE a.id = var_assetid;
	ELSE
        ret_name = 'none';
		ret_description = 'none';
		ret_serialno = 'none';
		ret_size = 00000;
        ret_type = 00000;
        ret_class = 00000;
        ret_dimension1val = 000000;
		ret_dimension2val = 00000;
		ret_dimension3val = 00000;
		ret_dimension4val = 00000;
        ret_dimension5val = 00000;
        ret_dimension6val = 00000;
        ret_extent = 'none';
        ret_extentconfidence = 'none';
        ret_derecognitionvalue = 00000;
        ret_latitude = 'none';
        ret_longitude = 'none';
    END IF;
END;
$BODY$;


/* ---- Retrieve Assets Function ---- */
CREATE OR REPLACE FUNCTION public.retrieveassets(
    var_assettypeid uuid)
    RETURNS TABLE(name character varying, description character varying, serialno character varying, size numeric, type uuid, class uuid, dimension1val numeric, dimension2val numeric, dimension3val numeric, dimension4val numeric, dimension5val numeric, dimension6val numeric, extent character varying, extentconfidence character varying, takeondate timestamp without time zone, derecognitionvalue numeric, latitude character varying, longitude character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.name, a.description, a.serialno, a.size, a.type, a.class, a.dimension1val, a.dimension2val, a.dimension3val, a.dimension4val, a.dimension5val, a.dimension6val, a.extent, a.extentconfidence, a.takeondate, a.derecognitionvalue, f.latitude, f.longitude
    FROM public.Asset a
	LEFT JOIN public.funcloc f ON f.id = a.funclocid
    WHERE a.type = var_assettypeid;
END;
$BODY$;

/* ---- Extract Assets Function ---- */
CREATE OR REPLACE FUNCTION public.extractassets(
    var_assettypeid uuid)
    RETURNS TABLE(name character varying, description character varying, serialno character varying, size numeric, type uuid, class uuid, dimension1val numeric, dimension2val numeric, dimension3val numeric, dimension4val numeric, dimension5val numeric, dimension6val numeric, extent character varying, extentconfidence character varying, takeondate timestamp without time zone, derecognitionvalue numeric, latitude character varying, longitude character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.name, a.description, a.serialno, a.size, a.type, a.class, a.dimension1val, a.dimension2val, a.dimension3val, a.dimension4val, a.dimension5val, a.dimension6val, a.extent, a.extentconfidence, a.takeondate, a.derecognitionvalue, f.latitude, f.longitude
    FROM public.Asset a
	LEFT JOIN public.funcloc f ON f.id = a.funclocid
    WHERE a.type = var_assettypeid;
END;
$BODY$;

/* ---- Analyse Assets Function ---- */


CREATE OR REPLACE FUNCTION public.analyseassets(
	var_assettypeid uuid)
    RETURNS TABLE(name character varying, description character varying, serialno character varying, size numeric, type uuid, class uuid, dimension1val numeric, dimension2val numeric, dimension3val numeric, dimension4val numeric, dimension5val numeric, dimension6val numeric, extent character varying, extentconfidence character varying, takeondate timestamp without time zone, derecognitionvalue numeric, latitude character varying, longitude character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.name, a.description, a.serialno, a.size, a.type, a.class, a.dimension1val, a.dimension2val, a.dimension3val, a.dimension4val, a.dimension5val, a.dimension6val, a.extent, a.extentconfidence, a.takeondate, a.derecognitionvalue, f.latitude, f.longitude
    FROM public.Asset a
	LEFT JOIN public.funcloc f ON f.id = a.funclocid
    WHERE a.type = var_assettypeid;
END;
$BODY$;




/* ---- Func Loc details Function ---- */


CREATE OR REPLACE FUNCTION public.funclocdetails(
	var_funclocid uuid,
    OUT ret_id character varying,
	OUT ret_description character varying,
	OUT ret_name character varying,
	OUT ret_lat character varying,
	OUT ret_long character varying,
	OUT ret_geom character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.Funcloc a WHERE a.id = var_funclocid) THEN
	SELECT a.id, a.description ,a.name, a.lat, a.long,a.geom		
    INTO ret_id, ret_description, ret_name, ret_lat, ret_long, ret_geom
    FROM public.Funcloc a
    WHERE a.id = var_funclocid;
 ELSE
        ret_id = 'none';
		ret_description = 'none';
        ret_name = 'none';
		ret_lat = 'none';
		ret_long = 'none';
		ret_geom = 'none';
    END IF;
END;
$BODY$;


/* ---- Location Assets Function ---- */


CREATE OR REPLACE FUNCTION public.funclocassets(
	var_funclocid uuid)
    RETURNS TABLE(assetid uuid, name character varying, derecognitiondate character varying, derecognitionvalue character varying, description character varying, dimension1value character varying, dimension2value character varying, dimension3value character varying, dimension4value character varying, dimension5value character varying, extent character varying, extentconfidence character varying, manufacturedate character varying, manufacturedateconfidence character varying, takeondate character varying, serialno character varying, lat character varying, lon character varying, cuname character varying, cudescription character varying, eulyears character varying, residualvalfactor character varying, size character varying, sizeunit character varying, type character varying, class character varying, isactive character varying, assetage character varying, carryingvalueclosingbalance character varying, carryingvalueopeningbalance character varying, costclosingbalance character varying, costopeningbalance character varying, crc character varying, depreciationclosingbalance character varying, depreciationopeningbalance character varying, impairmentclosingbalance character varying, impairmentopeningbalance character varying, residualvalue character varying, rulyears character varying, drc character varying, fy character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.id, CASE WHEN a.name IS NULL OR a.name = ''  THEN 'n/a' ELSE a.name::character varying END, CASE WHEN a.derecognitiondate IS NULL OR a.derecognitiondate = '' THEN 'n/a' ELSE a.derecognitiondate::character varying END, CASE WHEN a.derecognitionvalue IS NULL OR a.derecognitionvalue = '' THEN 'n/a' ELSE a.derecognitionvalue::character varying END, CASE WHEN a.description IS NULL OR a.description = '' THEN 'n/a' ELSE a.description::character varying END, CASE WHEN a.dimension1value IS NULL OR a.dimension1value = '' THEN 'n/a' ELSE a.dimension1value::character varying END, CASE WHEN a.dimension2value IS NULL OR a.dimension2value = '' THEN 'n/a' ELSE a.dimension2value::character varying END, CASE WHEN a.dimension3value IS NULL OR a.dimension3value = '' THEN 'n/a' ELSE a.dimension3value::character varying END, CASE WHEN a.dimension4value IS NULL OR a.dimension4value = '' THEN 'n/a' ELSE a.dimension4value::character varying END, CASE WHEN a.dimension5value IS NULL OR a.dimension5value = '' THEN 'n/a' ELSE a.dimension5value::character varying END, CASE WHEN a.extent IS NULL OR a.extent = '' THEN 'n/a' ELSE a.extent::character varying END, CASE WHEN a.extentconfidence IS NULL OR a.extentconfidence = '' THEN 'n/a' ELSE a.extentconfidence::character varying END, CASE WHEN a.manufacturedate IS NULL THEN 'n/a' ELSE a.manufacturedate::character varying END,CASE WHEN a.manufacturedateconfidence IS NULL OR a.manufacturedateconfidence = '' THEN 'n/a' ELSE a.manufacturedateconfidence::character varying END, CASE WHEN a.takeondate IS NULL THEN 'n/a' ELSE a.takeondate::character varying END, CASE WHEN a.serialno IS NULL OR a.serialno = '' THEN 'n/a' ELSE a.serialno::character varying END, CASE WHEN a.lat IS NULL OR a.lat = '' THEN 'n/a' ELSE a.lat::character varying END, CASE WHEN a.lon IS NULL OR a.lon = '' THEN 'n/a' ELSE a.lon::character varying END, CASE WHEN cu.name IS NULL OR cu.name = '' THEN 'n/a' ELSE cu.name::character varying END, CASE WHEN cu.description IS NULL OR cu.description = '' THEN 'n/a' ELSE cu.description::character varying END, CASE WHEN cu.eulyears IS NULL OR cu.eulyears = '' THEN 'n/a' ELSE cu.eulyears::character varying END, CASE WHEN cu.residualvalfactor IS NULL OR cu.residualvalfactor = '' THEN 'n/a' ELSE cu.residualvalfactor::character varying END, CASE WHEN cu.size IS NULL OR cu.size = '' THEN 'n/a' ELSE cu.size::character varying END, CASE WHEN cu.sizeunit IS NULL OR cu.sizeunit = '' THEN 'n/a' ELSE cu.sizeunit::character varying END, CASE WHEN cu.type IS NULL OR cu.type = '' THEN 'n/a' ELSE cu.type::character varying END, CASE WHEN cu.class IS NULL OR cu.class = '' THEN 'n/a' ELSE cu.class::character varying END, CASE WHEN cu.isactive IS NULL OR cu.isactive = '' THEN 'n/a' ELSE cu.isactive::character varying END, CASE WHEN av.age IS NULL OR av.age = '' THEN 'n/a' ELSE av.age::character varying END, CASE WHEN av.carryingvalueclosingbalance IS NULL  THEN 'n/a' ELSE av.carryingvalueclosingbalance::character varying END, CASE WHEN av.carryingvalueopeningbalance IS NULL  THEN 'n/a' ELSE av.carryingvalueopeningbalance::character varying END, CASE WHEN av.costclosingbalance IS NULL  THEN 'n/a' ELSE av.costclosingbalance::character varying END, CASE WHEN av.costopeningbalance IS NULL  THEN 'n/a' ELSE av.costopeningbalance::character varying END,CASE WHEN av.crc IS NULL  THEN 'n/a' ELSE av.crc::character varying END, CASE WHEN av.depreciationclosingbalance IS NULL  THEN 'n/a' ELSE av.depreciationclosingbalance::character varying END, CASE WHEN av.depreciationopeningbalance IS NULL  THEN 'n/a' ELSE av.depreciationopeningbalance::character varying END, CASE WHEN av.impairmentclosingbalance IS NULL  THEN 'n/a' ELSE av.impairmentclosingbalance::character varying END, CASE WHEN av.impairmentopeningbalance IS NULL  THEN 'n/a' ELSE av.impairmentopeningbalance::character varying END,  CASE WHEN av.residualvalue IS NULL  THEN 'n/a' ELSE av.residualvalue::character varying END, CASE WHEN av.rulyears IS NULL  THEN 'n/a' ELSE av.rulyears::character varying END, CASE WHEN av.drc IS NULL  THEN 'n/a' ELSE av.drc::character varying END, CASE WHEN av.fy IS NULL  THEN 'n/a' ELSE av.fy::character varying END
    FROM public.Asset a
	INNER JOIN public.AssetDeployment ad ON ad.assetid = a.id
	INNER JOIN public.Funcloc f ON f.id = ad.funclockid
    INNER JOIN public.CompatibleUnit cu ON cu.id = a.compatibleunitid
    INNER JOIN public.AssetValue av ON av.assetid = a.id
    WHERE f.id = var_funclocid;
END;
$BODY$;

/* ---- Func Loc shadow details Function ---- */


CREATE OR REPLACE FUNCTION public.funclocshadowdetails(
	var_funclocid uuid,
    OUT ret_id character varying,
	OUT ret_description character varying,
	OUT ret_name character varying,
	OUT ret_lat character varying,
	OUT ret_long character varying,
	OUT ret_geom character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.sdwFuncloc a WHERE a.id = var_funclocid) THEN
	SELECT a.id, a.description ,a.name, a.lat, a.long,a.geom		
    INTO ret_id, ret_description, ret_name, ret_lat, ret_long, ret_geom
    FROM public.sdwFuncloc a
    WHERE a.id = var_funclocid AND a.ishandled = false;
 ELSE
        ret_id = 'none';
		ret_description = 'none';
        ret_name = 'none';
		ret_lat = 'none';
		ret_long = 'none';
		ret_geom = 'none';
    END IF;
END;
$BODY$;

/* ---- Location shadow Assets Function ---- */


CREATE OR REPLACE FUNCTION public.funclocshadowassets(
	var_funclocid uuid)
    RETURNS TABLE(assetid uuid, name character varying, derecognitiondate character varying, derecognitionvalue character varying, description character varying, dimension1value character varying, dimension2value character varying, dimension3value character varying, dimension4value character varying, dimension5value character varying, extent character varying, extentconfidence character varying, manufacturedate character varying, manufacturedateconfidence character varying, takeondate character varying, serialno character varying, lat character varying, lon character varying, cuname character varying, cudescription character varying, eulyears character varying, residualvalfactor character varying, size character varying, sizeunit character varying, type character varying, class character varying, isactive character varying, assetage character varying, carryingvalueclosingbalance character varying, carryingvalueopeningbalance character varying, costclosingbalance character varying, costopeningbalance character varying, crc character varying, depreciationclosingbalance character varying, depreciationopeningbalance character varying, impairmentclosingbalance character varying, impairmentopeningbalance character varying, residualvalue character varying, rulyears character varying, drc character varying, fy character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.id, CASE WHEN a.name IS NULL OR a.name = ''  THEN 'n/a' ELSE a.name::character varying END, CASE WHEN a.derecognitiondate IS NULL OR a.derecognitiondate = '' THEN 'n/a' ELSE a.derecognitiondate::character varying END, CASE WHEN a.derecognitionvalue IS NULL OR a.derecognitionvalue = '' THEN 'n/a' ELSE a.derecognitionvalue::character varying END, CASE WHEN a.description IS NULL OR a.description = '' THEN 'n/a' ELSE a.description::character varying END, CASE WHEN a.dimension1value IS NULL OR a.dimension1value = '' THEN 'n/a' ELSE a.dimension1value::character varying END, CASE WHEN a.dimension2value IS NULL OR a.dimension2value = '' THEN 'n/a' ELSE a.dimension2value::character varying END, CASE WHEN a.dimension3value IS NULL OR a.dimension3value = '' THEN 'n/a' ELSE a.dimension3value::character varying END, CASE WHEN a.dimension4value IS NULL OR a.dimension4value = '' THEN 'n/a' ELSE a.dimension4value::character varying END, CASE WHEN a.dimension5value IS NULL OR a.dimension5value = '' THEN 'n/a' ELSE a.dimension5value::character varying END, CASE WHEN a.extent IS NULL OR a.extent = '' THEN 'n/a' ELSE a.extent::character varying END, CASE WHEN a.extentconfidence IS NULL OR a.extentconfidence = '' THEN 'n/a' ELSE a.extentconfidence::character varying END, CASE WHEN a.manufacturedate IS NULL THEN 'n/a' ELSE a.manufacturedate::character varying END,CASE WHEN a.manufacturedateconfidence IS NULL OR a.manufacturedateconfidence = '' THEN 'n/a' ELSE a.manufacturedateconfidence::character varying END, CASE WHEN a.takeondate IS NULL THEN 'n/a' ELSE a.takeondate::character varying END, CASE WHEN a.serialno IS NULL OR a.serialno = '' THEN 'n/a' ELSE a.serialno::character varying END, CASE WHEN a.lat IS NULL OR a.lat = '' THEN 'n/a' ELSE a.lat::character varying END, CASE WHEN a.lon IS NULL OR a.lon = '' THEN 'n/a' ELSE a.lon::character varying END, CASE WHEN cu.name IS NULL OR cu.name = '' THEN 'n/a' ELSE cu.name::character varying END, CASE WHEN cu.description IS NULL OR cu.description = '' THEN 'n/a' ELSE cu.description::character varying END, CASE WHEN cu.eulyears IS NULL OR cu.eulyears = '' THEN 'n/a' ELSE cu.eulyears::character varying END, CASE WHEN cu.residualvalfactor IS NULL OR cu.residualvalfactor = '' THEN 'n/a' ELSE cu.residualvalfactor::character varying END, CASE WHEN cu.size IS NULL OR cu.size = '' THEN 'n/a' ELSE cu.size::character varying END, CASE WHEN cu.sizeunit IS NULL OR cu.sizeunit = '' THEN 'n/a' ELSE cu.sizeunit::character varying END, CASE WHEN cu.type IS NULL OR cu.type = '' THEN 'n/a' ELSE cu.type::character varying END, CASE WHEN cu.class IS NULL OR cu.class = '' THEN 'n/a' ELSE cu.class::character varying END, CASE WHEN cu.isactive IS NULL OR cu.isactive = '' THEN 'n/a' ELSE cu.isactive::character varying END, CASE WHEN av.age IS NULL OR av.age = '' THEN 'n/a' ELSE av.age::character varying END, CASE WHEN av.carryingvalueclosingbalance IS NULL  THEN 'n/a' ELSE av.carryingvalueclosingbalance::character varying END, CASE WHEN av.carryingvalueopeningbalance IS NULL  THEN 'n/a' ELSE av.carryingvalueopeningbalance::character varying END, CASE WHEN av.costclosingbalance IS NULL  THEN 'n/a' ELSE av.costclosingbalance::character varying END, CASE WHEN av.costopeningbalance IS NULL  THEN 'n/a' ELSE av.costopeningbalance::character varying END,CASE WHEN av.crc IS NULL  THEN 'n/a' ELSE av.crc::character varying END, CASE WHEN av.depreciationclosingbalance IS NULL  THEN 'n/a' ELSE av.depreciationclosingbalance::character varying END, CASE WHEN av.depreciationopeningbalance IS NULL  THEN 'n/a' ELSE av.depreciationopeningbalance::character varying END, CASE WHEN av.impairmentclosingbalance IS NULL  THEN 'n/a' ELSE av.impairmentclosingbalance::character varying END, CASE WHEN av.impairmentopeningbalance IS NULL  THEN 'n/a' ELSE av.impairmentopeningbalance::character varying END,  CASE WHEN av.residualvalue IS NULL  THEN 'n/a' ELSE av.residualvalue::character varying END, CASE WHEN av.rulyears IS NULL  THEN 'n/a' ELSE av.rulyears::character varying END, CASE WHEN av.drc IS NULL  THEN 'n/a' ELSE av.drc::character varying END, CASE WHEN av.fy IS NULL  THEN 'n/a' ELSE av.fy::character varying END
    FROM public.sdwAsset a
	INNER JOIN public.sdwAssetDeployment ad ON ad.assetid = a.id
	INNER JOIN public.sdwFuncloc f ON f.id = ad.funclockid
    INNER JOIN public.sdwCompatibleUnit cu ON cu.id = a.compatibleunitid
    INNER JOIN public.sdwAssetValue av ON av.assetid = a.id
     WHERE f.id = var_funclocid AND a.ishandled = false;
END;
$BODY$;


/* ---- Location shadow Assets Function ---- */


CREATE OR REPLACE FUNCTION public.funclocshadowlist()
    RETURNS TABLE(locationid uuid, description character varying, name character varying, lat character varying, long character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT f.id, CASE WHEN f.description IS NULL OR f.description = ''  THEN 'n/a' ELSE f.description::character varying END, CASE WHEN f.name IS NULL OR f.name = '' THEN 'n/a' ELSE f.name::character varying END, CASE WHEN f.lat IS NULL OR f.lat = '' THEN 'n/a' ELSE f.lat::character varying END, CASE WHEN f.long IS NULL OR f.long = '' THEN 'n/a' ELSE f.long::character varying END
    FROM public.sdwFuncLoc f
    WHERE f.ishandled = false;
END;
$BODY$;



/* --------------- Nate Scripts ------------- */

CREATE OR REPLACE FUNCTION public.GetNodeAssetsRecurse (
  NodeId uuid
)
RETURNS TABLE (
  Id uuid,
  FuncLocId uuid,
  FuncLocNodeId uuid,
  Name varchar,
  Description varchar,
  Type varchar,
  Lat varchar,
  Lon varchar
) AS
$body$
BEGIN
return query
WITH RECURSIVE hierarchy AS(
SELECT fln_a.id,
		fln_a.parentid
FROM public.funclocnode fln_a
WHERE fln_a."id" =$1
UNION
SELECT  fln.id,
		fln.parentid
FROM public.funclocnode fln
INNER JOIN hierarchy h ON h.id = fln.parentid)

    select

    a.id as "Id",
    ad.funclockid as "FuncLocId",
    fll.funclocnodeid as "FuncLocNodeId",
	CASE WHEN a.name IS NULL OR a.name = ''  THEN '' ELSE a.name::varchar END,
	CASE WHEN a.description IS NULL OR a.description = ''  THEN '' ELSE a.description::varchar END,
	CASE WHEN a.assettype IS NULL OR a.assettype = ''  THEN '' ELSE a.assettype::varchar END,
	CASE WHEN a.lat IS NULL OR a.lat = ''  THEN '' ELSE a.lat::varchar END,
	CASE WHEN a.lon IS NULL OR a.lon = ''  THEN '' ELSE a.lon::varchar END
    FROM hierarchy h
    INNER JOIN public.funcloclink fll on fll.funclocnodeid = h.id

    INNER JOIN public.funcloc fl on fll.funclocid = fl.id
    INNER JOIN public.assetdeployment ad on ad.funclockid = fl.id
    INNER JOIN public.asset a on a.id = ad.assetid;

            END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100 ROWS 1000;

 







CREATE OR REPLACE FUNCTION public.GetNodeFuncLocRecurse (
  NodeId uuid
)
RETURNS TABLE (
  Id uuid,
  FuncLocNodeId uuid,
  Name varchar,
  Description varchar,
  Lat varchar,
  Lon varchar,
  InstallDate varchar,
  Status varchar,
  FuncLocNodeName varchar 
) AS
$body$
BEGIN
return query
WITH RECURSIVE hierarchy AS(
SELECT fln_a.id,
		fln_a.parentid
FROM public.funclocnode fln_a
WHERE fln_a.id =$1
UNION
SELECT  fln.id,
		fln.parentid
FROM public.funclocnode fln
INNER JOIN hierarchy h ON h.id = fln.parentid)

    select
    fl.id as "Id",
    fll.funclocnodeid as "FuncLocNodeId",
    CASE WHEN fl.name IS NULL OR fl.name = ''  THEN '' ELSE fl.name::varchar END,
    CASE WHEN fl.description IS NULL OR fl.description = ''  THEN '' ELSE fl.description::varchar END,
    CASE WHEN fl.lat IS NULL OR fl.lat = ''  THEN '' ELSE fl.lat::varchar END,
    CASE WHEN fl.long IS NULL OR fl.long = ''  THEN '' ELSE fl.long::varchar END,
    CASE WHEN ad.installdate IS NULL THEN '' ELSE ad.installdate::varchar END,
    CASE WHEN ad.status IS NULL OR ad.status = ''  THEN '' ELSE ad.status::varchar END,
    CASE WHEN fln.name IS NULL OR fln.name = ''  THEN '' ELSE fln.name::varchar END
    FROM hierarchy h
    INNER JOIN public.funclocnode fln on fln.id = h.id
    INNER JOIN public.funcloclink fll on fll.funclocnodeid = h.id

    INNER JOIN public.funcloc fl on fll.funclocid = fl.id
    LEFT JOIN public.assetdeployment ad on ad.funclockid = fl.id;

            END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER
PARALLEL UNSAFE
COST 100 ROWS 1000;




 

/* ---- Get asset detail Function ---- */

CREATE OR REPLACE FUNCTION public.getassetdetail(
	var_assetid uuid,
	OUT ret_id uuid,
	OUT ret_type character varying,
	OUT ret_description character varying,
	OUT ret_manufacturedate character varying,
	OUT ret_takeondate character varying,
	OUT ret_serialno character varying
    )
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.Asset a WHERE a.id = var_assetid) THEN
	SELECT a.id, 
    CASE WHEN a.assettype IS NULL OR a.assettype = '' THEN '' ELSE a.assettype::character varying END,
    CASE WHEN a.description IS NULL OR a.description = '' THEN '' ELSE a.description::character varying END,
    CASE WHEN a.manufacturedate IS NULL THEN '' ELSE a.manufacturedate::character varying END,
    CASE WHEN a.takeondate IS NULL THEN '' ELSE a.takeondate::character varying END,
    CASE WHEN a.serialno IS NULL OR a.serialno = '' THEN '' ELSE a.serialno::character varying END

    INTO ret_id, ret_type, ret_description, ret_manufacturedate, ret_takeondate, ret_serialno
    FROM public.Asset a

    WHERE a.id = var_assetid;
	ELSE
    ret_id = 0000000;
	ret_type = 'none';
	ret_description = 'none';
	ret_manufacturedate = 'none';
	ret_takeondate = 'none';
	ret_serialno = 'none';
    END IF;
END;
$BODY$;



CREATE OR REPLACE FUNCTION public.getassetdetailflexval(
    var_assetid uuid)
    RETURNS TABLE(name character varying, value character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT CASE WHEN afv.name IS NULL OR afv.name = ''  THEN '' ELSE afv.name::character varying END,
    CASE WHEN afv.value IS NULL OR afv.value = ''  THEN '' ELSE afv.value::character varying END
    FROM public.AssetFlexVal afv
    WHERE afv.assetid = var_assetid;
END;
$BODY$;







/* ------------- Get Func Loc Assets ----------- */


CREATE OR REPLACE FUNCTION public.getfunclocassets(
	var_funclocid uuid)
    RETURNS TABLE(assetid uuid, funclocid uuid, name character varying, description character varying, lat character varying, lon character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT a.id, f.id, 
    CASE WHEN a.name IS NULL OR a.name = '' THEN '' ELSE a.name::character varying END, 
    CASE WHEN a.description IS NULL OR a.description = '' THEN '' ELSE a.description::character varying END, 
    CASE WHEN a.lat IS NULL OR a.lat = '' THEN '' ELSE a.lat::character varying END, 
    CASE WHEN a.lon IS NULL OR a.lon = '' THEN '' ELSE a.lon::character varying END
    FROM public.Asset a
	LEFT JOIN public.AssetDeployment ad ON ad.assetid = a.id
	LEFT JOIN public.Funcloc f ON f.id = ad.funclockid
    WHERE f.id = var_funclocid;
END;
$BODY$;





/* ------------- Get Func Loc ----------- */


CREATE OR REPLACE FUNCTION public.getfuncloc(
	var_funclocnodeid uuid,
	var_id uuid)
    RETURNS TABLE(id uuid, funclocnodeid uuid,
     name character varying, description character varying, installdate character varying, status character varying, funclocnodename character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT fl.id, fll.funclocnodeid,
    CASE WHEN fl.name IS NULL OR fl.name = '' THEN '' ELSE fl.name::character varying END,
    CASE WHEN fl.description IS NULL OR fl.description = '' THEN '' ELSE fl.description::character varying END,
    CASE WHEN ad.installdate IS NULL THEN '' ELSE ad.installdate::character varying END, 
    CASE WHEN ad.status IS NULL OR ad.status = '' THEN '' ELSE ad.status::character varying END, 
    CASE WHEN fln.name IS NULL OR fln.name = '' THEN '' ELSE fln.name::character varying END

    FROM public.FuncLoc fl
	INNER JOIN public.FuncLocLink fll ON fl.id = fll.funclocid
	INNER JOIN public.FuncLocNode fln ON fll.funclocnodeid = fln.id
    INNER JOIN public.AssetDeployment ad ON fl.Id = ad.funclockid
    WHERE ad.funclockid = var_id AND fll.funclocnodeid = var_funclocnodeid;
END;
$BODY$;




/* ------------- Get Func Loc Detail ----------- */


CREATE OR REPLACE FUNCTION public.getfunclocdetail(
	var_id uuid,
	OUT ret_id character varying,
	OUT ret_name character varying,
	OUT ret_description character varying)
    RETURNS record
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
BEGIN
IF EXISTS (SELECT 1 FROM public.Funcloc f WHERE f.id = var_id) THEN
	SELECT f.id, 
	CASE WHEN f.name IS NULL OR f.name = '' THEN '' ELSE f.name::character varying END,
	CASE WHEN f.description IS NULL OR f.description = '' THEN '' ELSE f.description::character varying END
    INTO ret_id, ret_name, ret_description
    FROM public.Funcloc f
	WHERE f.id = var_id;
 ELSE
        ret_id = 0;
        ret_name = '';
        ret_description = '';
    END IF;
END;
$BODY$;


/* ------------- Get Func Loc Spatial ----------- */


CREATE OR REPLACE FUNCTION public.getfunclocspatial(
	var_id uuid)
    RETURNS TABLE(name character varying, lat character varying, lon character varying, id uuid) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT 
    CASE WHEN fl.name IS NULL OR fl.name = '' THEN '' ELSE fl.name::character varying END,
    CASE WHEN fl.lat IS NULL OR fl.lat = '' THEN '' ELSE fl.lat::character varying END,
    CASE WHEN fl.long IS NULL OR fl.long = '' THEN '' ELSE fl.long::character varying END,
	fl.id
    FROM public.FuncLoc fl
    INNER JOIN public.AssetDeployment ad ON fl.id = ad.funclockid
    WHERE ad.funclockid = var_id;
END;
$BODY$;







/* ------------- Get All FuncLocNodes ----------- */


CREATE OR REPLACE FUNCTION public.getallfunclocnodes()
    RETURNS TABLE(parentid character varying, id uuid, name character varying, nodetype character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT 
    CASE WHEN fln.parentid IS NULL THEN '' ELSE fln.parentid::character varying END,
    fln.id ,
    CASE WHEN fln.name IS NULL OR fln.name = '' THEN '' ELSE fln.name::character varying END,
    CASE WHEN n.name IS NULL OR n.name = '' THEN '' ELSE n.name::character varying END
    FROM public.FuncLocNode fln
    INNER JOIN public.NodeType n ON n.id = fln.nodetype;
END;
$BODY$;






/* ------------- Get All FuncLocs ----------- */


CREATE OR REPLACE FUNCTION public.getallfunclocs()
    RETURNS TABLE(parentid character varying, id uuid, name character varying, nodetype character varying) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$
BEGIN
	RETURN QUERY
	SELECT 
    CASE WHEN fll.funclocnodeid IS NULL THEN '' ELSE fll.funclocnodeid::character varying END,
    fl.id ,
    CASE WHEN fl.name IS NULL OR fl.name = '' THEN '' ELSE fl.name::character varying END,
    CASE WHEN n.name IS NULL OR n.name = '' THEN '' ELSE n.name::character varying END
    FROM public.FuncLocLink fll
    INNER JOIN public.FuncLoc fl ON fl.id = fll.funclocid
    INNER JOIN public.FuncLocNode fln ON fln.id = fll.funclocnodeid
    INNER JOIN public.NodeType n ON n.id = fln.nodetype;
END;
$BODY$;









/* -------------- Data -------------- */






/* ------------ CriticalityTypeLookup --------- */



INSERT INTO public.CriticalityTypeLookup(ID,Code,name,description, consequenceOfFailiure) 
VALUES ('66C178A0-0E9E-4E27-B444-17D493119951',1,'Cursory','Is readily absorbed under normal operating conditions','Insignificant');
INSERT INTO public.CriticalityTypeLookup(ID,Code,name,description, consequenceOfFailiure) 
VALUES ('CFEF377A-70C9-4732-AEA3-234EC8A91283',2,'Non-Critical','Can be managed under normal operating conditions','Minor');
INSERT INTO public.CriticalityTypeLookup(ID,Code,name,description, consequenceOfFailiure) 
VALUES ('72078ACC-8D84-41E8-8B9E-CEF7AD453A38',3,'Important','Can be managed but requires additional resources and management effort','Moderate');
INSERT INTO public.CriticalityTypeLookup(ID,Code,name,description, consequenceOfFailiure) 
VALUES ('C7B2C6EA-BE96-4A9F-B805-6A7961360216',4,'Critical','Will have a prolonged impact and extensive consequences','Major');
INSERT INTO public.CriticalityTypeLookup(ID,Code,name,description, consequenceOfFailiure) 
VALUES ('9A1AE6DB-C715-459E-A8D9-7B23FCA30242',5,'Most Critical','Irreversible and extensive impacts, or significantly undermining key business objectives','Catastrophic');














/* -------------------- Compatible Unit ---------------------- */







INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2F0CA3B1-5AD5-4EC8-820C-15186EC6000D',1209,'WIRELESS CONTROLLER','WIRELESS CONTROLLER----','4','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6574D764-A6BA-4B43-8660-0CD0775100BD',1210,'Indoor WAP','Indoor WAP----','4','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('548151E0-48B1-44CA-B97E-1E803FF3E1D2',1211,'Outdoor WAP','Outdoor WAP----','4','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1002A155-B569-43E8-A664-9CDB1DCB957E',1212,'Winch','Winch----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('39E0D671-04D2-48C6-AD91-91E1679B00E5',1213,'Bts','Bts----','5','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('49E5C540-F1AB-467B-BEF0-152D681EFF47',1214,'NETWORK ROUTER','NETWORK ROUTER----','4','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5EDDD35D-D069-484A-9513-C8506D0DD605',1215,'COMMUNICATION SWITCH','COMMUNICATION SWITCH----','4','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FDCA95CC-49CF-4AA1-BF5C-8B05A659BEBE',1216,'ATTENA','ATTENA----','5','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A0A420CC-17F6-4627-8C19-7D92FFEA18D9',1217,'PDU','PDU----','8','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E865C6DB-D641-4DA9-838F-47AD0E85BDD7',1218,'SURGE ARRESTOR','SURGE ARRESTOR----','12','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('05AA654F-D6AA-4A31-A806-AB90C439A05B',1219,'UPS','UPS----','8','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BA287706-F3B8-406B-8847-D20770E955D2',1220,'BACKUP BATTERY','BACKUP BATTERY----','12','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2BFB6A4F-4D68-463E-BF4E-5E8AE877591B',1221,'EQUIPMENT BOX','EQUIPMENT BOX----','12','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9541D9B5-3358-44B3-937E-7DD64C951DE9',1222,'POWERBOX','POWERBOX----','12','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CD1C2AF4-64B5-4645-8584-7348A284ABD2',1223,'Wet Scrubber','Wet Scrubber----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('57BDF73C-B206-436C-B2C6-814674D4C4FE',1224,'Well & lining','Well & lining----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BFE8FD90-B7D5-4274-8DDE-15AA46BC1CB1',1225,'Weighbridge','Weighbridge----','15','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('06AA4BF3-BB74-461E-9377-87F371C6217F',1226,'Raw water supply system','Raw water supply system----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E6CECCDA-D12C-49FD-8D9A-561C4BC3560B',1227,'Treatment (demineralisation)','Treatment (demineralisation)----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7C65735E-6156-4A92-8126-7D2078EBCCC0',1228,'Mag-flow','Mag-flow-200---mm','10','0','200','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C989CAE9-72D5-4BCE-AD35-5A2E4418DAE9',1229,'Mag-flow','Mag-flow-300---mm','10','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4DF2706C-F199-468A-AA25-EA896551FAA9',1230,'Mag-flow','Mag-flow-500---mm','10','0','500','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B782924D-1DCF-437B-AA9B-0544DD397772',1231,'Mag-flow','Mag-flow-700---mm','10','0','700','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3611CE28-7ED2-4424-BEB1-C5BFA98C2441',1232,'Mag-flow','Mag-flow-900---mm','10','0','900','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D61F5A69-EB26-446D-AAEB-AB46C44FED4D',1233,'Mechanical','Mechanical-20---mm','10','0','20','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('94E497DB-EF49-4C4D-965F-754241061348',1234,'Mechanical','Mechanical-25---mm','10','0','25','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E6E7E309-DCA9-4D26-9AC3-70D7163650E5',1235,'Mechanical','Mechanical-40---mm','10','0','40','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1B78FDBE-6E54-422A-8E05-50DA1308DA03',1236,'Mechanical','Mechanical-50---mm','10','0','50','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('911B789C-70B2-41D8-895C-E987BCB32164',1237,'Mechanical','Mechanical-80---mm','10','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C9E4875B-A9D5-4E6E-9FC4-5CB9D5F8A6E4',1238,'Mechanical','Mechanical-100---mm','10','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B96E76D7-91C1-4CA1-A6FF-49956E0386BF',1239,'Mechanical','Mechanical-150---mm','10','0','150','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6F36E3CE-DFD6-47BA-A797-D22DCC4231E9',1240,'Mechanical','Mechanical-200---mm','10','0','200','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('02509580-4175-4318-BC14-6FB63EDFF8AE',1241,'Pre-pay meters','Pre-pay meters-15---mm','10','0','15','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('796472D6-66F8-4031-BD39-2E9E50C44B3D',1242,'Pre-pay meters','Pre-pay meters-20---mm','10','0','20','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('58B414F6-BA3C-487B-A498-FEBB3AAC2EEE',1243,'Mag-flow','Mag-flow-80---mm','10','0','80','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3EE14392-26F9-4095-AB63-AE3FE5A8F609',1244,'Mag-flow','Mag-flow-800---mm','10','0','800','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C8BFC913-2EDF-4DE8-95DE-FC3C7BD28180',1245,'Mag-flow','Mag-flow-600---mm','10','0','600','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7FD1A440-AC8C-453A-9AB4-FFABBE512BB9',1246,'Mechanical','Mechanical-15---mm','10','0','15','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A217E55B-076C-4F9E-ABC4-DD86EEA68572',1247,'Mag-flow','Mag-flow-100---mm','10','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1D217E77-90C1-48BE-B32C-97F29E4AA1C5',1248,'Mag-flow','Mag-flow-50---mm','10','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('99DA43FE-B40F-4A90-87A9-94901925DAB9',1249,'Mechanical','Mechanical-800---mm','10','0','800','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8F35FC28-DEE2-4658-8EBD-666E592F37B0',1250,'Mechanical','Mechanical-250---mm','10','0','250','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DF30B784-5C28-4E1F-B26A-A7817E0C9801',1251,'Mechanical','Mechanical-600---mm','10','0','600','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('79E1D22B-1F40-44C2-8B59-1318496710C3',1252,'Mechanical','Mechanical-500---mm','10','0','500','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A24D115F-B44A-458D-AFB2-FF1A90546F28',1253,'Mechanical','Mechanical-400---mm','10','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CF3A6BA8-5400-41DB-A482-378FB5AE08B7',1254,'Mechanical','Mechanical-300---mm','10','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('48BA25D4-19EE-49A1-9AB5-9654BDF1CA48',1255,'Mechanical','Mechanical-700---mm','10','0','700','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9A56B2AB-4243-46B1-A385-2E63FA77210A',1256,'Mag-flow','Mag-flow-400---mm','10','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4AA6ACEB-31F7-4AE3-9720-F549AB550EEC',1257,'Mag-flow','Mag-flow-250---mm','10','0','250','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('42CE5757-60DB-4F64-A45B-C16D6CD4AB32',1258,'Face brick','Face brick----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('66AD3AFE-0401-42B1-9D2A-00AB4D099D60',1259,'Fibre cement board, timber frame, plaster board','Fibre cement board, timber frame, plaster board----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3415962D-5737-412F-9567-8EFA83E793DD',1260,'Metal sheet , plaster board','Metal sheet , plaster board----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A6F53238-3085-4C99-9805-E7510583BF1F',1261,'Plastered brick','Plastered brick----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('01F48EEC-D59F-4B75-9099-C6855C2A9865',1262,'Semi-face brick','Semi-face brick----','60','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1B41F50B-072F-4BD5-8751-772D05BF3886',1263,'Glass panel','Glass panel----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9B6FC250-5C73-4009-90A3-63FC08E00023',1264,'VPN CONCENTRATOR','VPN CONCENTRATOR----','4','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C890CC12-73FB-45D8-A152-940481F2CE9A',1265,'MV','MV--22-33kV--','45','0','','','22-33kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E5AE6D3F-9EC6-415B-96E8-01D2AB0F62A4',1266,'MV','MV--6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('256680E0-644A-422C-AEAC-D0109D9C8073',1267,'HV','HV--88-132kV--','45','0','','','88-132kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('849FF638-65F4-4DA6-8FE4-35AB5C680D65',1268,'HV','HV--275kV--','45','0','','','275kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('992E0DAA-4B0A-4D8B-A861-7AE4A9F6C221',1269,'HV','HV--11kV--','45','0','','','11kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1BB09628-AFCE-41EB-A2E6-C0C44B9E9D79',1270,'VIRTUAL REALITY HARDWARE','VIRTUAL REALITY HARDWARE----','4','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B5A1134E-4902-4C4A-BF01-AFD8EAF6F186',1271,'Double','Double----','15','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9D63A932-5F44-4274-BE63-ADADE5E63EDB',1272,'Single','Single----','5','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('10E88F6C-2209-4930-ACFE-03E1DF3018AA',1273,'Vending Station','Vending Station----','25','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('79BA3C53-4A31-47F7-BE8D-C387B8870C42',1274,'Air release (Water)','Air release (Water)-80---mm','15','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7C78A6E7-B93E-46B7-A998-49EA137B59EE',1275,'Air release (Water)','Air release (Water)-100---mm','15','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6AD8F926-173D-4915-906E-3698C4E27D7F',1276,'Air release (Water)','Air release (Water)-150---mm','15','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E0790DE1-C71F-4D66-BF74-500EA5E154DD',1277,'Butterfly (Water)','Butterfly (Water)-200---mm','20','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A7DA0962-3F87-43F4-AD64-EEAC68615837',1278,'Butterfly (Water)','Butterfly (Water)-250---mm','20','0','250','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2133C2CA-0C0E-4F60-BC5C-40C3B4519DF3',1279,'Butterfly (Water)','Butterfly (Water)-300---mm','20','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7557E985-6E0E-411F-90EF-2B76CFBA44EA',1280,'Butterfly (Water)','Butterfly (Water)-350---mm','20','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('75E773B8-D5E5-487F-812C-5B0752A832F7',1281,'Butterfly (Water)','Butterfly (Water)-400---mm','20','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D9F5EBBE-A274-4FEC-8B03-2956B2AC5AA2',1282,'Butterfly (Water)','Butterfly (Water)-450---mm','20','0','450','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('760D0986-AFBF-4E3C-B135-9B81ED1849B6',1283,'Butterfly (Water)','Butterfly (Water)-500---mm','20','0','500','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('19FC2934-6573-42CA-A5BC-40F2E46C2B4B',1284,'Butterfly (Water)','Butterfly (Water)-600---mm','20','0','600','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3544CB41-5DC8-45F2-8E5B-01FEB3F4E28E',1285,'Butterfly (Water)','Butterfly (Water)-750---mm','20','0','750','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A29194EE-20F7-4ED7-8F5D-9A5869635DB4',1286,'Butterfly (Water)','Butterfly (Water)-900---mm','20','0','900','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E7B0EF32-3813-44F7-BD94-6F4B1290E73D',1287,'Butterfly (Water)','Butterfly (Water)-1000---mm','20','0','1000','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FD263D78-E8FB-40E9-B84A-69BA2B20A22F',1288,'Non-return (Water)','Non-return (Water)-100---mm','15','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CD995722-3B6C-4140-AAB5-93988C0EB5D6',1289,'Non-return (Water)','Non-return (Water)-150---mm','15','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7A98A757-BCC3-4C99-9D69-201AB50466EF',1290,'Non-return (Water)','Non-return (Water)-200---mm','15','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('643E2AED-F852-4701-9585-B234338EB309',1291,'Non-return (Water)','Non-return (Water)-300---mm','15','0','300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('42DCFD2E-C589-444B-90E1-9FAE3275E4DB',1292,'Pressure Reducing (Water)','Pressure Reducing (Water)-50---mm','15','0','50','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E546FC22-F643-4854-B34E-AE1C1DA47DF5',1293,'Pressure Reducing (Water)','Pressure Reducing (Water)-80---mm','15','0','80','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A7D55904-4FFD-4CC8-B4F8-09C605D94594',1294,'Pressure Reducing (Water)','Pressure Reducing (Water)-100---mm','15','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F614878D-68FF-440A-AEF8-58F2723C76F4',1295,'Pressure Reducing (Water)','Pressure Reducing (Water)-150---mm','15','0','150','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C95089C5-833E-42A5-8D79-053853A10646',1296,'Pressure Reducing (Water)','Pressure Reducing (Water)-200---mm','15','0','200','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0D3343D8-7791-43AC-82A9-0DF1E6596457',1297,'Pressure Reducing (Water)','Pressure Reducing (Water)-250---mm','15','0','250','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('279DD03E-3591-4B5E-A10B-121B151D014E',1298,'Pressure Reducing (Water)','Pressure Reducing (Water)-300---mm','15','0','300','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0795C6CF-F73A-45C8-876C-1FE3E8F1FEA1',1299,'Resilient seal (Water)','Resilient seal (Water)-50---mm','20','0','50','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('47C8F5A2-6E73-4078-B866-709D5E8BA482',1300,'Resilient seal (Water)','Resilient seal (Water)-80---mm','20','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('69438B2E-8E67-4652-920C-D9A8ABF1EC7B',1301,'Resilient seal (Water)','Resilient seal (Water)-100---mm','20','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3C79EE1C-2BBF-4488-B9A2-21AB08F69984',1302,'Resilient seal (Water)','Resilient seal (Water)-150---mm','20','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('368C5E22-37F7-4D13-AF12-8D2860E686D3',1303,'Resilient seal (Water)','Resilient seal (Water)-200---mm','20','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C45BB4AA-C9D1-4662-B6EC-9E2C8CEA0453',1304,'Resilient seal (Water)','Resilient seal (Water)-250---mm','20','0','250','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1EDACED6-E09E-4412-8581-A137878114CC',1305,'Resilient seal (Water)','Resilient seal (Water)-300---mm','20','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AEF8DFCD-29FB-4DF8-9363-AF3E493F6311',1306,'Resilient seal (Water)','Resilient seal (Water)-350---mm','20','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0CE9D4B7-BB84-4F17-BEBE-08F85BEEE77B',1307,'Resilient seal (Water)','Resilient seal (Water)-400---mm','20','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('04785773-9C4E-4818-9D2E-C674009A421F',1308,'Actuated Resilient seal (Water)','Actuated Resilient seal (Water)-400---mm','20','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0D2439BB-5C5C-4EF0-B6F5-1A5D616A4CA0',1309,'Actuated Resilient seal (Water)','Actuated Resilient seal (Water)-350---mm','20','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0E56DCA4-A72E-4766-9D00-A41F0E22CA23',1310,'Actuated Resilient seal (Water)','Actuated Resilient seal (Water)-300---mm','20','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('329905D8-ACBC-419D-9897-F432ED68ABA4',1311,'Actuated Resilient seal (Water)','Actuated Resilient seal (Water)-250---mm','20','0','250','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A24D1455-E8D5-48D6-80B0-7AD8D60B463F',1312,'Actuated Resilient seal (Water)','Actuated Resilient seal (Water)-200---mm','20','0','200','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('59A05974-8C67-458B-928E-24EFCA81F48C',1313,'Actuated Resilient seal (Water)','Actuated Resilient seal (Water)-150---mm','20','0','150','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B3ACE95E-E8DE-45A4-98BE-2FACD0426AB9',1314,'Actuated Resilient seal (Water)','Actuated Resilient seal (Water)-100---mm','20','0','100','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C339D110-C56F-4110-A995-7309C80FC762',1315,'Actuated Resilient seal (Water)','Actuated Resilient seal (Water)-80---mm','20','0','80','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6753602A-B945-453B-AB44-59F18488B6CB',1316,'Actuated Resilient seal (Water)','Actuated Resilient seal (Water)-50---mm','20','0','50','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('16BC8749-59E2-4937-9C19-C74B08290609',1317,'Actuated Pressure Reducing (Water)','Actuated Pressure Reducing (Water)-300---mm','15','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6E2D824F-FBA5-41BF-9301-AA194C4E5742',1318,'Actuated Pressure Reducing (Water)','Actuated Pressure Reducing (Water)-250---mm','15','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3A2D1535-906A-4FC0-9B3E-24B8B6756027',1319,'Actuated Pressure Reducing (Water)','Actuated Pressure Reducing (Water)-200---mm','15','0','200','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('228B1D7B-178A-4DCA-852C-3F45E309241B',1320,'Actuated Pressure Reducing (Water)','Actuated Pressure Reducing (Water)-150---mm','15','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C5E5B69F-6FC1-439A-9A93-B223DB7381A9',1321,'Actuated Pressure Reducing (Water)','Actuated Pressure Reducing (Water)-100---mm','15','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F24A51CD-169C-4A1C-8CA7-E105DBB2AFA3',1322,'Actuated Pressure Reducing (Water)','Actuated Pressure Reducing (Water)-80---mm','15','0','80','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('57DE3705-4F4A-44A1-8A48-9D17EFE840FB',1323,'Actuated Pressure Reducing (Water)','Actuated Pressure Reducing (Water)-50---mm','15','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8CECAFA9-F251-4A48-8942-35FA147EF0CB',1324,'Actuated Butterfly (Water)','Actuated Butterfly (Water)-1000---mm','20','0','1000','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('748A488D-F734-4136-92B1-804B4E351110',1325,'Actuated Butterfly (Water)','Actuated Butterfly (Water)-900---mm','20','0','900','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FCE7792F-1895-42F8-9722-0CCD525CBFA4',1326,'Actuated Butterfly (Water)','Actuated Butterfly (Water)-750---mm','20','0','750','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2AD1797E-FC0D-46CB-BF46-F98DFC2E224B',1327,'Actuated Butterfly (Water)','Actuated Butterfly (Water)-600---mm','20','0','600','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('05D82A61-4FA8-43B1-9856-09166AA83411',1328,'Actuated Butterfly (Water)','Actuated Butterfly (Water)-500---mm','20','0','500','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('29816520-2E2A-4023-8CBD-BE529555D3BD',1329,'Actuated Butterfly (Water)','Actuated Butterfly (Water)-450---mm','20','0','450','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('30B028E5-481A-4353-BA3F-AB943FA9C211',1330,'Actuated Butterfly (Water)','Actuated Butterfly (Water)-400---mm','20','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5E86E191-71AF-4E65-A925-9BFA24E1B112',1331,'Actuated Butterfly (Water)','Actuated Butterfly (Water)-350---mm','20','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('79648A70-BF3B-40FA-88D8-3A7B53DDCD02',1332,'Actuated Butterfly (Water)','Actuated Butterfly (Water)-300---mm','20','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A5C75936-9511-4522-8612-147D25A535B5',1333,'Actuated Butterfly (Water)','Actuated Butterfly (Water)-250---mm','20','0','250','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A2E1846A-109D-49AC-9780-92FB9AAC49CB',1334,'Actuated Butterfly (Water)','Actuated Butterfly (Water)-200---mm','20','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('50C99301-C5B7-4FAA-87F2-1866AD92B522',1335,'Actuated Air release (Water)','Actuated Air release (Water)-150---mm','15','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8C0FD068-9482-4801-AA16-A099460A2DA5',1336,'Actuated Air release (Water)','Actuated Air release (Water)-100---mm','15','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('076FD703-50CA-4B17-B744-B509C8AF0693',1337,'Actuated Air release (Water)','Actuated Air release (Water)-80---mm','15','0','80','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C87D55D1-9140-42B7-B8F9-5139AC6513CE',1338,'Non-return (Water)','Non-return (Water)-1000---mm','15','0','1000','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0FCF7600-2C7B-4C43-8334-3FED625FB837',1339,'Non-return (Water)','Non-return (Water)-900---mm','15','0','900','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FDE426C9-8D4F-4A43-ACF6-AE51F1E12C58',1340,'Non-return (Water)','Non-return (Water)-750---mm','15','0','750','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C4F096F6-D4BA-4EEC-839E-A17CE7A2C331',1341,'Non-return (Water)','Non-return (Water)-600---mm','15','0','600','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C7023490-82E8-4FB7-B730-CD25A901193A',1342,'Non-return (Water)','Non-return (Water)-500---mm','15','0','500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F9A3B942-FCF1-4410-BA27-51BFD1FBF213',1343,'Non-return (Water)','Non-return (Water)-450---mm','15','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6D1B3C4D-8CE2-4591-B720-36DE515BFC2A',1344,'Non-return (Water)','Non-return (Water)-400---mm','15','0','400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('343BBFB7-DD7E-48DA-93EF-D6CD76E108C4',1345,'Non-return (Water)','Non-return (Water)-350---mm','15','0','350','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C9179828-EA23-4D15-A369-692EAF3100D0',1346,'Resilient seal (Water)','Resilient seal (Water)-450---mm','20','0','450','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0A774DC8-9246-45D2-9161-519F21F4F798',1347,'Butterfly (Water)','Butterfly (Water)-800---mm','20','0','800','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C9D25502-E93B-489B-A6AA-20F2063013D4',1348,'Pressure Reducing (Water)','Pressure Reducing (Water)-400---mm','15','0','400','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E6E539E2-42D0-4B60-AE54-11BA1D836C84',1349,'Resilient seal (Water)','Resilient seal (Water)-355---mm','20','0','355','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BA5C4AE6-1D23-46CC-AFCA-40837FB57C13',1350,'Resilient seal (Water)','Resilient seal (Water)-315---mm','20','0','315','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6EAB808D-3B36-41AD-A042-1A68FDF72CCF',1351,'Air release (Water)','Air release (Water)-350---mm','15','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EC2D8D0B-F96D-43A1-B2C7-8BE7150A78F9',1352,'Valve (Generic)','Valve (Generic)-1100---mm','20','0','1100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D47389F8-5630-4C07-9731-EC158CB01630',1353,'Valve (Generic)','Valve (Generic)-1200---mm','20','0','1200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FF97CB7A-A6A6-414D-A7C1-27D5B330B4DD',1354,'Valve (Generic)','Valve (Generic)-381---mm','20','0','381','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5773492A-104D-4F68-BD44-78091DA2CB79',1355,'Valve (Generic)','Valve (Generic)-475---mm','20','0','475','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('098BF57E-7641-4871-826E-45A9E5B06B9E',1356,'Valve (Generic)','Valve (Generic)-675---mm','20','0','675','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('03E7F155-0F4F-4E64-AC13-F36EF8E257D6',1357,'Valve (Generic)','Valve (Generic)-825---mm','20','0','825','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6CA26DD1-A134-4239-8001-887583B12A19',1358,'Valve (Generic)','Valve (Generic)-850---mm','20','0','850','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EBA8400E-815F-4287-810C-E1D24D24C885',1359,'Valve (Generic)','Valve (Generic)-99---mm','15','0','99','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4347A04E-D83B-49A7-9A85-5EF7D629BD61',1360,'Air Valve (Generic)','Air Valve (Generic)-1100---mm','20','0','1100','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6E4F0A1B-8AC2-4A6C-B62A-119B883541E1',1361,'Air Valve (Generic)','Air Valve (Generic)-1200---mm','20','0','1200','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D1922361-C15B-4462-80D7-C098E792ED89',1362,'Air Valve (Generic)','Air Valve (Generic)-375---mm','20','0','375','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0622814E-1AE4-4977-8D32-951049DA320C',1363,'Air Valve (Generic)','Air Valve (Generic)-675---mm','20','0','675','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F5A66256-8866-4580-81FF-AF36F16C17A4',1364,'Air Valve (Generic)','Air Valve (Generic)-1000---mm','20','0','1000','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('82F935F7-B3E8-4751-BA01-B4B200704CBD',1365,'Air Valve (Generic)','Air Valve (Generic)-100---mm','20','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6C66A2A0-AD2A-4DF4-AFA8-1E08321D6973',1366,'Air Valve (Generic)','Air Valve (Generic)-110---mm','20','0','110','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('08A94788-5E62-4388-ACB3-AAFBE9D6881E',1367,'Air Valve (Generic)','Air Valve (Generic)-150---mm','20','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F36977B3-BF4C-4CFC-B50C-CEEC0A584D93',1368,'Air Valve (Generic)','Air Valve (Generic)-160---mm','20','0','160','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('96B4AD5F-8408-47F7-8529-AC988FB3F663',1369,'Air Valve (Generic)','Air Valve (Generic)-200---mm','20','0','200','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B682A3F0-5B88-4D8C-96BC-0B1776C3D35C',1370,'Air Valve (Generic)','Air Valve (Generic)-225---mm','20','0','225','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9BCDEF06-DFE2-4072-BB17-07823B85B5EF',1371,'Air Valve (Generic)','Air Valve (Generic)-250---mm','20','0','250','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E0E40AF1-F77C-435A-AADD-0E48EC53FF35',1372,'Air Valve (Generic)','Air Valve (Generic)-300---mm','20','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4E5FB2CE-0B43-43D9-8319-D3B778360336',1373,'Air Valve (Generic)','Air Valve (Generic)-315---mm','20','0','315','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F163B278-7F53-4DDC-B4E2-3293CC79140B',1374,'Air Valve (Generic)','Air Valve (Generic)-350---mm','20','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D56640D5-F306-409D-8369-B786A7BBB273',1375,'Air Valve (Generic)','Air Valve (Generic)-355---mm','20','0','355','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D432439E-E23D-40B1-A0F2-DCE171D907FE',1376,'Air Valve (Generic)','Air Valve (Generic)-400---mm','20','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('85AB9349-5FEE-4607-8339-AD8C4073754D',1377,'Air Valve (Generic)','Air Valve (Generic)-450---mm','20','0','450','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8A4F9FE2-8A60-4A6A-8B10-2E61639425D0',1378,'Air Valve (Generic)','Air Valve (Generic)-500---mm','20','0','500','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BD5BE0AD-22F4-4E7D-9CDB-17FBCA3193CB',1379,'Air Valve (Generic)','Air Valve (Generic)-50---mm','20','0','50','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F9084F5C-4210-405D-83BB-44C1ABC62AE2',1380,'Air Valve (Generic)','Air Valve (Generic)-525---mm','20','0','525','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C6FF51CA-1B2B-4CB2-BE9A-B402D38AF05A',1381,'Air Valve (Generic)','Air Valve (Generic)-550---mm','20','0','550','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('46126E2C-F745-4141-99F3-751AB24B4CCF',1382,'Air Valve (Generic)','Air Valve (Generic)-600---mm','20','0','600','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('87E134D1-FBA0-4C38-BD9C-F5EDC845C97D',1383,'Air Valve (Generic)','Air Valve (Generic)-63---mm','20','0','63','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AF2B2A60-F510-4A55-B040-E00DCBD1C64A',1384,'Air Valve (Generic)','Air Valve (Generic)-650---mm','20','0','650','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0C37570F-5E7F-4EAD-A5BC-AC41778C88E7',1385,'Air Valve (Generic)','Air Valve (Generic)-700---mm','20','0','700','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8EB759FF-514F-444D-8916-B6204FF569FB',1386,'Air Valve (Generic)','Air Valve (Generic)-710---mm','20','0','710','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('38F6208B-4683-4594-A651-67616F6ABF54',1387,'Air Valve (Generic)','Air Valve (Generic)-750---mm','20','0','750','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5AF43A26-ECF2-45DD-9FF1-6F88B50EEC64',1388,'Air Valve (Generic)','Air Valve (Generic)-75---mm','20','0','75','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9D25DA97-4A29-43E0-BA0C-460F7490E598',1389,'Air Valve (Generic)','Air Valve (Generic)-800---mm','20','0','800','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1F556E33-29DB-4FF5-9FC5-9790272D04A9',1390,'Air Valve (Generic)','Air Valve (Generic)-80---mm','20','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8C7EB407-9C0B-43EA-A30D-847CB7979283',1391,'Air Valve (Generic)','Air Valve (Generic)-900---mm','20','0','900','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3AE7E632-5730-4C7B-B1A3-2D8D3DCC824F',1392,'Air Valve (Generic)','Air Valve (Generic)-90---mm','20','0','90','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('37609983-1C98-4483-BA6E-F4DD088E7395',1393,'Closed Valve (Generic)','Closed Valve (Generic)-110---mm','20','0','110','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('75C90610-11EA-4B59-916E-3B77D376BF27',1394,'Closed Valve (Generic)','Closed Valve (Generic)-150---mm','20','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7DE9FED3-48B9-4C53-A39D-B799C16D3466',1395,'Closed Valve (Generic)','Closed Valve (Generic)-160---mm','20','0','160','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D2944CFB-8C32-4DE0-8F56-906E7C9A5106',1396,'Closed Valve (Generic)','Closed Valve (Generic)-200---mm','20','0','200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('25C93776-DFBF-4321-AE5C-1ABD6358E4DC',1397,'Closed Valve (Generic)','Closed Valve (Generic)-225---mm','20','0','225','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('40779DCF-C371-4CD0-BFD2-C8D6D024D481',1398,'Closed Valve (Generic)','Closed Valve (Generic)-300---mm','20','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DA4F9249-A20B-42C9-AF43-BAA625D5B78E',1399,'Closed Valve (Generic)','Closed Valve (Generic)-375---mm','20','0','375','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6E28667F-9EBD-4FAC-A296-7A7074EC94F4',1400,'Closed Valve (Generic)','Closed Valve (Generic)-400---mm','20','0','400','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E50EECF1-63BD-4DD4-A63E-42BEA07D74C6',1401,'Closed Valve (Generic)','Closed Valve (Generic)-80---mm','20','0','80','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9BBCA6B0-41C4-4944-83FC-8849B280B085',1402,'Non-Return Valve (Generic)','Non-Return Valve (Generic)-110---mm','20','0','110','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('77C99E1C-2D17-4307-B991-9633C6068BC0',1403,'Valve (Generic)','Valve (Generic)-0---mm','20','0','0','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('25DAE094-E10B-410E-B712-3F0E1A6BFF3B',1404,'Valve (Generic)','Valve (Generic)-1000---mm','20','0','1000','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('11D3087D-17CC-49ED-B9CB-ABAFAD149C59',1405,'Valve (Generic)','Valve (Generic)-100---mm','20','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BFD30532-CAC4-434F-9324-9593D46AB32E',1406,'Valve (Generic)','Valve (Generic)-110---mm','20','0','110','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3E99DB18-C5B0-4BA4-98CE-078436C605D4',1407,'Valve (Generic)','Valve (Generic)-125---mm','20','0','125','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('78959710-3726-4F1C-B9B3-D2D8A54F627C',1408,'Valve (Generic)','Valve (Generic)-140---mm','20','0','140','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0318A351-16D4-42E1-9BA7-FEA0BC6D8C7F',1409,'Valve (Generic)','Valve (Generic)-145---mm','20','0','145','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AEED8CA9-0FEF-47FE-98A2-605C7D5216E3',1410,'Valve (Generic)','Valve (Generic)-150---mm','20','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8AE30303-A764-43EC-8B52-6EACA21FF0B8',1411,'Valve (Generic)','Valve (Generic)-160---mm','20','0','160','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D699D0F1-B08B-40C2-A277-32E304882F54',1412,'Valve (Generic)','Valve (Generic)-180---mm','20','0','180','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C191DC6B-0AC8-4004-9F13-701278A2DE01',1413,'Valve (Generic)','Valve (Generic)-200---mm','20','0','200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0743B6B2-F94D-4001-9BB4-AB553FF14551',1414,'Valve (Generic)','Valve (Generic)-20---mm','20','0','20','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BDD87ADC-5070-4F2D-A663-DCE12FCD0370',1415,'Valve (Generic)','Valve (Generic)-220---mm','20','0','220','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E9346FBE-E07D-4AF5-A53C-3F3259A154C5',1416,'Valve (Generic)','Valve (Generic)-225---mm','20','0','225','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6A24E2C5-65DA-4896-8C52-D4DA3F122E0F',1417,'Valve (Generic)','Valve (Generic)-250---mm','20','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DB0FD282-791D-4A64-9923-CAAE31349E4B',1418,'Valve (Generic)','Valve (Generic)-25---mm','20','0','25','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1B500A6C-0419-483D-91FA-53BB359540ED',1419,'Valve (Generic)','Valve (Generic)-300---mm','20','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6A4F4741-5873-41E8-B73E-970659073DD5',1420,'Valve (Generic)','Valve (Generic)-315---mm','20','0','315','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('90111427-69B5-4B9F-8A48-8AD140A39C1D',1421,'Valve (Generic)','Valve (Generic)-32---mm','20','0','32','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EDFBD2D4-B999-48A3-A1F5-90E250BB3C50',1422,'Valve (Generic)','Valve (Generic)-335---mm','20','0','335','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D427EC89-54B4-4218-AFD3-220D75C31911',1423,'Valve (Generic)','Valve (Generic)-350---mm','20','0','350','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('90487E43-F343-4F02-B84E-7DC279B92613',1424,'Valve (Generic)','Valve (Generic)-355---mm','20','0','355','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D52B7645-526E-4568-864F-98136D6332C1',1425,'Valve (Generic)','Valve (Generic)-375---mm','20','0','375','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8755F3A0-D649-433C-B02C-080E7A18E32A',1426,'Valve (Generic)','Valve (Generic)----mm','20','0','','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B6BC4ED7-C108-4F01-9637-DFAFAB30A7D8',1427,'Valve (Generic)','Valve (Generic)-400---mm','20','0','400','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B07E02D8-A2BD-4944-84DC-335CF0523DAF',1428,'Valve (Generic)','Valve (Generic)-40---mm','20','0','40','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ADED7998-E5CC-439B-9A33-210586A3F7CA',1429,'Valve (Generic)','Valve (Generic)-450---mm','20','0','450','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7D6ED636-D400-4592-B2FA-25A5DA02A644',1430,'Valve (Generic)','Valve (Generic)-500---mm','20','0','500','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3C86E939-F7EA-40C2-B6B6-38C01108FBFC',1431,'Valve (Generic)','Valve (Generic)-50---mm','20','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('19732203-BB22-4BB7-8AA4-8998C0A391F7',1432,'Valve (Generic)','Valve (Generic)-525---mm','20','0','525','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0DF7EC74-331E-4CF7-A962-B6DB477A79F6',1433,'Valve (Generic)','Valve (Generic)-550---mm','20','0','550','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8D3905B6-C9BC-47F1-B296-0AC59C3B8C4C',1434,'Valve (Generic)','Valve (Generic)-600---mm','20','0','600','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2B19F23C-ADFF-4981-AEFE-1C327DB1A618',1435,'Valve (Generic)','Valve (Generic)-610---mm','20','0','610','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2453F5EF-6598-47E8-AE3C-A16141AA9F74',1436,'Valve (Generic)','Valve (Generic)-630---mm','20','0','630','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('50541C3A-A5B8-41F6-A658-1BCABC0ED9DF',1437,'Valve (Generic)','Valve (Generic)-63---mm','20','0','63','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6237C752-EC08-49B9-B0B1-12668F4F53B0',1438,'Valve (Generic)','Valve (Generic)-650---mm','20','0','650','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CB4F9BBB-30F6-4095-A78A-8175584CF914',1439,'Valve (Generic)','Valve (Generic)-700---mm','20','0','700','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('30476620-88A5-4FF8-9137-49B84DB3F02F',1440,'Valve (Generic)','Valve (Generic)-710---mm','20','0','710','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('72E54EF1-F967-4CA3-826B-14F4ABEE1FCF',1441,'Valve (Generic)','Valve (Generic)-750---mm','20','0','750','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9AD15A50-DEB3-4740-9491-AFC005AD3FC9',1442,'Valve (Generic)','Valve (Generic)-75---mm','20','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E69225B8-AC23-4A4A-98CB-FC4B421B56F4',1443,'Valve (Generic)','Valve (Generic)-800---mm','20','0','800','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1E1260D4-D5FA-45D2-B3A0-51C770F5E581',1444,'Valve (Generic)','Valve (Generic)-80---mm','20','0','80','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3BDC6339-043F-4095-A8EF-8C52C4F5162E',1445,'Valve (Generic)','Valve (Generic)-900---mm','20','0','900','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5066F5C7-4285-4A12-A43A-8C0CEA9B2663',1446,'Valve (Generic)','Valve (Generic)-90---mm','20','0','90','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('02BC4DE0-F86F-4D09-A854-95EAE92213DA',1447,'Valve (Generic)','Valve (Generic)-Unknown---mm','20','0','','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2003EA98-63E7-43D9-A604-0A1054125BA1',1448,'Resilient seal (Water)','Resilient seal (Water)-630---mm','20','0','630','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D01D522E-95ED-45D4-8318-FE64F619EEFE',1449,'Air release (Steam)','Air release (Steam)-80---mm','15','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ECAC97D5-450B-497C-8721-FFDEA9E3EB66',1450,'Air release (Steam)','Air release (Steam)-100---mm','15','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('784925CB-4C75-4338-8145-1D00E6969A92',1451,'Air release (Steam)','Air release (Steam)-150---mm','15','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('54044C56-B3AC-4C82-9300-48B8EC5277DB',1452,'Butterfly (Steam)','Butterfly (Steam)-200---mm','20','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C3D46E49-6DEE-4600-A815-FC598872749A',1453,'Butterfly (Steam)','Butterfly (Steam)-250---mm','20','0','250','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1327E923-D51B-4F2F-ACCF-69FF83F21D57',1454,'Butterfly (Steam)','Butterfly (Steam)-300---mm','20','0','300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C997A7AC-954D-4A7F-9D27-556AC75B0126',1455,'Butterfly (Steam)','Butterfly (Steam)-350---mm','20','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D66BBD13-B8B4-45C4-BE8E-CFD4E7D3F29F',1456,'Butterfly (Steam)','Butterfly (Steam)-400---mm','20','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3FC982FF-33ED-4331-BFCA-F7BE26AFAA69',1457,'Butterfly (Steam)','Butterfly (Steam)-450---mm','20','0','450','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3A31846D-68D6-43F3-908F-FBCEDDA6FF62',1458,'Butterfly (Steam)','Butterfly (Steam)-500---mm','20','0','500','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CE310AAB-C850-4342-96BC-D72783AA78EF',1459,'Butterfly (Steam)','Butterfly (Steam)-600---mm','20','0','600','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A2A56EB7-8A51-4247-A7A0-852BCC7E64A8',1460,'Butterfly (Steam)','Butterfly (Steam)-750---mm','20','0','750','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F3764A8D-A60D-4B0A-A92B-EEE0F5C7F2A2',1461,'Butterfly (Steam)','Butterfly (Steam)-900---mm','20','0','900','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('158E4EBE-DDD0-4D60-8847-EBD9FFF3A9E3',1462,'Butterfly (Steam)','Butterfly (Steam)-1000---mm','20','0','1000','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FE4131B4-93FE-47EF-B3D8-FA84FB9B49EB',1463,'Non-return (Steam)','Non-return (Steam)-100---mm','15','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E38B7CD7-BBC3-4460-AFD1-B729EFB7385C',1464,'Non-return (Steam)','Non-return (Steam)-150---mm','15','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('239BF503-7997-4DF5-BADA-6BB44B416FEF',1465,'Non-return (Steam)','Non-return (Steam)-200---mm','15','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8659AF00-AA51-4F0A-A6C6-9050BB6492B1',1466,'Non-return (Steam)','Non-return (Steam)-300---mm','15','0','300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5D883A84-0736-48B3-A610-1C6D17C8467C',1467,'Pressure Reducing (Steam)','Pressure Reducing (Steam)-50---mm','15','0','50','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('46C867A3-0414-4C63-924E-4AA8170ACF05',1468,'Pressure Reducing (Steam)','Pressure Reducing (Steam)-80---mm','15','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6719980F-22C7-495D-ADC1-C815FEAD77B5',1469,'Pressure Reducing (Steam)','Pressure Reducing (Steam)-100---mm','15','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D471E6A2-84AB-4D81-A765-0C5C95DD2D4E',1470,'Pressure Reducing (Steam)','Pressure Reducing (Steam)-150---mm','15','0','150','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('506B2F1F-A6BB-44E6-AA2C-0B50D8822A0E',1471,'Pressure Reducing (Steam)','Pressure Reducing (Steam)-200---mm','15','0','200','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B8223B8F-EE85-4BD8-9268-E855272EED91',1472,'Pressure Reducing (Steam)','Pressure Reducing (Steam)-250---mm','15','0','250','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('895DD5B1-EDA7-4E6E-8A38-E6E0BE4B6C2C',1473,'Pressure Reducing (Steam)','Pressure Reducing (Steam)-300---mm','15','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B736BF60-8A40-46CF-8B32-68B09EAD4C70',1474,'Resilient seal (Steam)','Resilient seal (Steam)-50---mm','20','0','50','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9347F568-C30B-4996-B639-712644EC8FAE',1475,'Resilient seal (Steam)','Resilient seal (Steam)-80---mm','20','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1CBDBF39-3D2F-4E2F-8137-8A41FCB80B38',1476,'Resilient seal (Steam)','Resilient seal (Steam)-100---mm','20','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AE698EF0-6FC5-4AB7-8895-CAEA0BE46482',1477,'Resilient seal (Steam)','Resilient seal (Steam)-150---mm','20','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E9D5D94D-C18E-4F1C-9A74-65778409D9AF',1478,'Resilient seal (Steam)','Resilient seal (Steam)-200---mm','20','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('11BF8341-3CD2-45D6-9BE5-AA4B234A98EC',1479,'Resilient seal (Steam)','Resilient seal (Steam)-250---mm','20','0','250','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AB56AAE8-9C9B-4D37-92FD-21DDD97DE6A5',1480,'Resilient seal (Steam)','Resilient seal (Steam)-300---mm','20','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E17272DF-F1B1-44C6-BF54-A07502ED3C6D',1481,'Resilient seal (Steam)','Resilient seal (Steam)-350---mm','20','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A40901DA-16E3-4105-8D45-68AB52D660FD',1482,'Resilient seal (Steam)','Resilient seal (Steam)-400---mm','20','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('59CDDDEF-EA0D-4336-BD0C-F6469628F4C2',1483,'Actuated Air release (Sewer)','Actuated Air release (Sewer)-80---mm','15','0','80','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('35D3ABBF-9DF5-4CD3-A164-4E5A5B201FE7',1484,'Actuated Air release (Sewer)','Actuated Air release (Sewer)-100---mm','15','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A55CFF0D-F0B8-4F10-8753-1627DDEC8203',1485,'Actuated Air release (Sewer)','Actuated Air release (Sewer)-150---mm','15','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('567853C2-B68A-4E08-9992-52276D1E68EA',1486,'Actuated Butterfly (Sewer)','Actuated Butterfly (Sewer)-200---mm','20','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('52A325D7-7BE2-4111-B91B-D5FBC3CB54F3',1487,'Actuated Butterfly (Sewer)','Actuated Butterfly (Sewer)-250---mm','20','0','250','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('944DEB5A-A417-4B7B-B013-71EB26E8E11D',1488,'Actuated Butterfly (Sewer)','Actuated Butterfly (Sewer)-300---mm','20','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('396A4357-382A-4B31-B4DB-8E1AA3F9FBDE',1489,'Actuated Butterfly (Sewer)','Actuated Butterfly (Sewer)-350---mm','20','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F9EB22C7-B825-4AE3-B472-EC137EA9D1AC',1490,'Actuated Butterfly (Sewer)','Actuated Butterfly (Sewer)-400---mm','20','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C120F7D4-D6A0-42D8-A2C2-99E2DAF13BE6',1491,'Actuated Butterfly (Sewer)','Actuated Butterfly (Sewer)-450---mm','20','0','450','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CC906A41-145C-400B-9BD3-F8F8B10A7A66',1492,'Actuated Butterfly (Sewer)','Actuated Butterfly (Sewer)-500---mm','20','0','500','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9AF22AD9-E922-41DB-832E-BAA766F90293',1493,'Actuated Butterfly (Sewer)','Actuated Butterfly (Sewer)-600---mm','20','0','600','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('65123F37-5DD2-4684-A587-5EA749C033C0',1494,'Actuated Butterfly (Sewer)','Actuated Butterfly (Sewer)-750---mm','20','0','750','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C2FE4292-DB7D-4973-9BEF-7AC4991A56D9',1495,'Actuated Butterfly (Sewer)','Actuated Butterfly (Sewer)-900---mm','20','0','900','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3CA22BA4-97F1-4577-B38A-E372F09B7434',1496,'Actuated Butterfly (Sewer)','Actuated Butterfly (Sewer)-1000---mm','20','0','1000','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E1374708-3D68-4AF6-B3B5-DA01949A0763',1497,'Actuated Pressure Reducing (Sewer)','Actuated Pressure Reducing (Sewer)-50---mm','15','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('405FD363-4BAC-44C6-B9C3-D9C36E214C5D',1498,'Actuated Pressure Reducing (Sewer)','Actuated Pressure Reducing (Sewer)-80---mm','15','0','80','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7E9E7EFF-9D1D-40A4-A8F5-C36241F2AF4D',1499,'Actuated Pressure Reducing (Sewer)','Actuated Pressure Reducing (Sewer)-100---mm','15','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('12D576AF-A920-4BD2-8F5F-0746DDB20BE0',1500,'Actuated Pressure Reducing (Sewer)','Actuated Pressure Reducing (Sewer)-150---mm','15','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6116F404-1332-45D7-8AC1-BBA95BE03362',1501,'Actuated Pressure Reducing (Sewer)','Actuated Pressure Reducing (Sewer)-200---mm','15','0','200','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7213D0D4-1142-4045-9EE9-AB517C2A7834',1502,'Actuated Pressure Reducing (Sewer)','Actuated Pressure Reducing (Sewer)-250---mm','15','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9DB4C132-CB16-4315-971C-16AC80246205',1503,'Actuated Pressure Reducing (Sewer)','Actuated Pressure Reducing (Sewer)-300---mm','15','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3A2B6DA8-508A-44F2-A05B-689B61E37AA3',1504,'Actuated Resilient seal (Sewer)','Actuated Resilient seal (Sewer)-50---mm','20','0','50','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9D118BF4-F228-49F8-BD04-8053296EB12A',1505,'Actuated Resilient seal (Sewer)','Actuated Resilient seal (Sewer)-80---mm','20','0','80','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5928E937-81E5-4FEC-BEA5-F6CD7FC60B25',1506,'Actuated Resilient seal (Sewer)','Actuated Resilient seal (Sewer)-100---mm','20','0','100','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9E03213F-CD0B-4117-9610-63EB656F70EC',1507,'Actuated Resilient seal (Sewer)','Actuated Resilient seal (Sewer)-150---mm','20','0','150','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A158041E-5DA9-4EEF-9EC5-E68CE2BA9832',1508,'Actuated Resilient seal (Sewer)','Actuated Resilient seal (Sewer)-200---mm','20','0','200','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0C47247F-617B-4BF9-B745-7F65129C49E4',1509,'Actuated Resilient seal (Sewer)','Actuated Resilient seal (Sewer)-250---mm','20','0','250','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B52F7F9B-E5CE-4A52-A000-2E5E02F9A210',1510,'Actuated Resilient seal (Sewer)','Actuated Resilient seal (Sewer)-300---mm','20','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2C1BAB26-E93D-4A78-A0B4-D35C70F074D3',1511,'Actuated Resilient seal (Sewer)','Actuated Resilient seal (Sewer)-350---mm','20','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F9E0F2CC-13CD-40F9-AE05-B041BF60628F',1512,'Actuated Resilient seal (Sewer)','Actuated Resilient seal (Sewer)-400---mm','20','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('34FB745F-6280-498F-9181-F9597940863A',1513,'Resilient seal (Sewer)','Resilient seal (Sewer)-400---mm','20','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7498FF3C-1212-45A9-84FB-FEA5F13EFB4C',1514,'Resilient seal (Sewer)','Resilient seal (Sewer)-350---mm','20','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5EDE8F27-17ED-4BD9-A93E-83E43DDB0813',1515,'Resilient seal (Sewer)','Resilient seal (Sewer)-300---mm','20','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2EBFA827-ED15-4133-90D5-F33B7165773F',1516,'Resilient seal (Sewer)','Resilient seal (Sewer)-250---mm','20','0','250','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('51BDEE1A-968B-4B55-A42A-4D0E283EA760',1517,'Resilient seal (Sewer)','Resilient seal (Sewer)-200---mm','20','0','200','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9E8C36EA-8BED-4CDE-B483-4C74F2B57621',1518,'Resilient seal (Sewer)','Resilient seal (Sewer)-150---mm','20','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CAEFC1B4-BE8F-4B36-BBA8-7E888D3653AA',1519,'Resilient seal (Sewer)','Resilient seal (Sewer)-100---mm','20','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2990AB28-403C-414E-A0CB-8260BC01B07A',1520,'Resilient seal (Sewer)','Resilient seal (Sewer)-80---mm','20','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('078B0DDE-D4C9-4D1F-986E-81FAFEE65C9E',1521,'Resilient seal (Sewer)','Resilient seal (Sewer)-50---mm','20','0','50','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('011585F2-84B1-4A6B-AF25-2036C058352F',1522,'Pressure Reducing (Sewer)','Pressure Reducing (Sewer)-300---mm','15','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EA51F68E-EDE4-4B5A-82BC-DCB160230451',1523,'Pressure Reducing (Sewer)','Pressure Reducing (Sewer)-250---mm','15','0','250','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('71DF79B1-517A-4F76-A158-752D633A19A0',1524,'Pressure Reducing (Sewer)','Pressure Reducing (Sewer)-200---mm','15','0','200','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('59F9A525-11DD-48F8-8BCC-8D3682D26651',1525,'Pressure Reducing (Sewer)','Pressure Reducing (Sewer)-150---mm','15','0','150','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DF96E93F-6495-490D-8A26-742D422B2A39',1526,'Pressure Reducing (Sewer)','Pressure Reducing (Sewer)-100---mm','15','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1EB77B35-F053-42BE-8C10-2B27BDEE3412',1527,'Pressure Reducing (Sewer)','Pressure Reducing (Sewer)-80---mm','15','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2C96032B-8DA3-43CD-854F-7D068CA5BF53',1528,'Pressure Reducing (Sewer)','Pressure Reducing (Sewer)-50---mm','15','0','50','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4B561724-E9BF-44E6-8D6B-B969E7022C9F',1529,'Non-return (Sewer)','Non-return (Sewer)-300---mm','15','0','300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('58C4458A-BA48-42F8-80C5-E300D40A00AC',1530,'Non-return (Sewer)','Non-return (Sewer)-200---mm','15','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('48BBBB99-B754-4784-B52B-FF5EF2EA9C81',1531,'Non-return (Sewer)','Non-return (Sewer)-150---mm','15','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C36EDBFD-113D-4948-B565-C7C97E2E6C37',1532,'Non-return (Sewer)','Non-return (Sewer)-100---mm','15','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7361943C-E9D4-48F3-8E02-19C3D0DF3276',1533,'Butterfly (Sewer)','Butterfly (Sewer)-1000---mm','20','0','1000','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DEFFA344-9759-4AA3-AFA2-25E291FCFFC8',1534,'Butterfly (Sewer)','Butterfly (Sewer)-900---mm','20','0','900','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C3167CFE-502C-4AC0-BCC8-D785E7EFDC32',1535,'Butterfly (Sewer)','Butterfly (Sewer)-750---mm','20','0','750','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A506516B-6093-434F-997F-8D55A9257E27',1536,'Butterfly (Sewer)','Butterfly (Sewer)-600---mm','20','0','600','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('932135C3-C88F-4E79-83FD-0104860F98FA',1537,'Butterfly (Sewer)','Butterfly (Sewer)-500---mm','20','0','500','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('70ED8B62-65AB-4894-B395-A439B4EEF594',1538,'Butterfly (Sewer)','Butterfly (Sewer)-450---mm','20','0','450','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4032F783-D45A-436F-BA25-E75C99804645',1539,'Butterfly (Sewer)','Butterfly (Sewer)-400---mm','20','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('51C4C0A5-8A98-4502-B003-59634503DF7F',1540,'Butterfly (Sewer)','Butterfly (Sewer)-350---mm','20','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FE189FE4-5573-4D25-AD80-DBA24C98B3F0',1541,'Butterfly (Sewer)','Butterfly (Sewer)-300---mm','20','0','300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8BBA1310-FD3C-4AA7-8A15-9A7D34EEDD2A',1542,'Butterfly (Sewer)','Butterfly (Sewer)-250---mm','20','0','250','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BC30FC23-B321-444A-A4E7-F1D7460A8F51',1543,'Butterfly (Sewer)','Butterfly (Sewer)-200---mm','20','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('55512F06-67B6-411C-AFC4-3345C1C8FC77',1544,'Air release (Sewer)','Air release (Sewer)-150---mm','15','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9AF06D60-789A-44C6-806A-66346F357543',1545,'Air release (Sewer)','Air release (Sewer)-100---mm','15','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BFB29BDD-92E0-448B-B2FC-F210DF6298EA',1546,'Air release (Sewer)','Air release (Sewer)-80---mm','15','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D619855E-93A2-4B16-AC13-C089722FB578',1547,'Air release (Gas)','Air release (Gas)-80---mm','15','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3F25DA81-E5C1-49DA-9EA0-8C5BA9D7E1CA',1548,'Air release (Gas)','Air release (Gas)-100---mm','15','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D6A1D5A8-72F3-4E71-9F26-AC8A2EBEBB8D',1549,'Air release (Gas)','Air release (Gas)-150---mm','15','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('56F7219E-B08F-4DA1-A6BA-A99A42E41C27',1550,'Butterfly (Gas)','Butterfly (Gas)-200---mm','20','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C0480142-328D-4891-99CC-9AC6A8113C87',1551,'Butterfly (Gas)','Butterfly (Gas)-250---mm','20','0','250','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9D9950F6-395E-4B2F-9E6D-D45617DFB8FE',1552,'Butterfly (Gas)','Butterfly (Gas)-300---mm','20','0','300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1E6D2B68-9A0A-4BEA-91FD-A9EE84E5D77D',1553,'Butterfly (Gas)','Butterfly (Gas)-350---mm','20','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('24A3DBB3-FB58-47C0-9003-97089AC356B2',1554,'Butterfly (Gas)','Butterfly (Gas)-400---mm','20','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('73A41918-215F-44EF-8E02-2E15506C5993',1555,'Butterfly (Gas)','Butterfly (Gas)-450---mm','20','0','450','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('436EA97A-5DBD-42D6-BD0D-C3119F94A852',1556,'Butterfly (Gas)','Butterfly (Gas)-500---mm','20','0','500','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DE21B6FE-4DC1-4E86-82CA-47811DC21E3B',1557,'Butterfly (Gas)','Butterfly (Gas)-600---mm','20','0','600','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E4559D02-8010-4EA5-B174-6B950A2A2991',1558,'Butterfly (Gas)','Butterfly (Gas)-750---mm','20','0','750','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3C1D3A56-401F-470D-8522-571E0DC82AC2',1559,'Butterfly (Gas)','Butterfly (Gas)-900---mm','20','0','900','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('016247AD-DB2F-4AD4-898F-9B1D85B945B2',1560,'Butterfly (Gas)','Butterfly (Gas)-1000---mm','20','0','1000','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E3A97C44-958C-44BE-B9A4-B53A058D2670',1561,'Non-return (Gas)','Non-return (Gas)-100---mm','15','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E95F5CF9-25C2-4701-95E7-230F427C9B4E',1562,'Non-return (Gas)','Non-return (Gas)-150---mm','15','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7B012E6B-7EA8-4540-869F-B297F7C340DD',1563,'Non-return (Gas)','Non-return (Gas)-200---mm','15','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F657D952-0D0A-49A6-B4A7-3D3BAEB15BF2',1564,'Non-return (Gas)','Non-return (Gas)-300---mm','15','0','300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CB4CBC6E-4381-48DD-B48B-16291D24757B',1565,'Pressure Reducing (Gas)','Pressure Reducing (Gas)-50---mm','15','0','50','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A417926D-644A-4B35-811C-E1E7C62D2125',1566,'Pressure Reducing (Gas)','Pressure Reducing (Gas)-80---mm','15','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9F3A79F5-9160-4C45-8E6F-7FFAD7CB44D5',1567,'Pressure Reducing (Gas)','Pressure Reducing (Gas)-100---mm','15','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D55C8AA0-174D-4ED9-93B8-16A379F7F5CE',1568,'Pressure Reducing (Gas)','Pressure Reducing (Gas)-150---mm','15','0','150','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F212645E-F6F7-4113-9E69-025418ED649E',1569,'Pressure Reducing (Gas)','Pressure Reducing (Gas)-200---mm','15','0','200','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('705369AB-A13C-407A-B85F-AC699C286ECF',1570,'Pressure Reducing (Gas)','Pressure Reducing (Gas)-250---mm','15','0','250','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6DDA192F-755C-4C9C-A11E-AC711F3056EF',1571,'Pressure Reducing (Gas)','Pressure Reducing (Gas)-300---mm','15','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EB6D7C20-8D16-4553-AC77-5D53089C73B7',1572,'Resilient seal (Gas)','Resilient seal (Gas)-50---mm','20','0','50','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7227052B-BA41-41FD-9658-BBAA8F07766B',1573,'Resilient seal (Gas)','Resilient seal (Gas)-80---mm','20','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('077F9C30-7652-49C7-8802-B76E46AFEDB4',1574,'Resilient seal (Gas)','Resilient seal (Gas)-100---mm','20','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BBAB88A7-45D8-454C-BBA8-128F94961B97',1575,'Resilient seal (Gas)','Resilient seal (Gas)-150---mm','20','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BE06F495-C1B3-4FE1-93F2-F546AFEB83CF',1576,'Resilient seal (Gas)','Resilient seal (Gas)-200---mm','20','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D33DA02A-25B9-423C-A890-79617FF0A228',1577,'Resilient seal (Gas)','Resilient seal (Gas)-250---mm','20','0','250','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7F739253-CC12-463A-B6E9-1CD33012E067',1578,'Resilient seal (Gas)','Resilient seal (Gas)-300---mm','20','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F7C9E9D0-93E7-494B-9AD2-BECD6A7577E1',1579,'Resilient seal (Gas)','Resilient seal (Gas)-350---mm','20','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2125246C-B802-4BD6-A8DC-DE0484433DCE',1580,'Resilient seal (Gas)','Resilient seal (Gas)-400---mm','20','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('438FAEAD-50A9-4DE0-B28C-80D34C83693B',1581,'Air release (Fuel)','Air release (Fuel)-80---mm','15','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('943B03AE-0881-469A-B4EA-F373973D276B',1582,'Air release (Fuel)','Air release (Fuel)-100---mm','15','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C102EEBD-B60D-4EDA-829B-ADD2A9B8F3EE',1583,'Air release (Fuel)','Air release (Fuel)-150---mm','15','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2E60F2C5-00D2-4ACD-8AE2-2BC711D67C37',1584,'Butterfly (Fuel)','Butterfly (Fuel)-200---mm','20','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('19DBB1D1-1B51-4E0C-B20F-BC38E9E8F6FA',1585,'Butterfly (Fuel)','Butterfly (Fuel)-250---mm','20','0','250','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7023A590-73EC-418B-B53A-2B379272139A',1586,'Butterfly (Fuel)','Butterfly (Fuel)-300---mm','20','0','300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('80099C1D-6375-4F93-B41A-1BBF977D4155',1587,'Butterfly (Fuel)','Butterfly (Fuel)-350---mm','20','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7304427D-A51E-4E44-9818-4C14D835D302',1588,'Butterfly (Fuel)','Butterfly (Fuel)-400---mm','20','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D78429A5-E115-4044-8C4B-B0C1BA011E2A',1589,'Butterfly (Fuel)','Butterfly (Fuel)-450---mm','20','0','450','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9FFB6F19-57E6-4451-8073-5226BC946CCB',1590,'Butterfly (Fuel)','Butterfly (Fuel)-500---mm','20','0','500','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8776D561-450E-4754-8F2C-E5DF8687AA4D',1591,'Butterfly (Fuel)','Butterfly (Fuel)-600---mm','20','0','600','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5F7D9F78-5F31-473B-8B97-B89C703A0E51',1592,'Butterfly (Fuel)','Butterfly (Fuel)-750---mm','20','0','750','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('393BA641-CC27-4646-B28B-F214760FE857',1593,'Butterfly (Fuel)','Butterfly (Fuel)-900---mm','20','0','900','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('871F2CE8-58B0-4945-AD78-5D1326E7DDEF',1594,'Butterfly (Fuel)','Butterfly (Fuel)-1000---mm','20','0','1000','mm','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7101DD61-D5DB-4754-95B1-E621A6047BAC',1595,'Non-return (Fuel)','Non-return (Fuel)-100---mm','15','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B97DF4B5-1324-4F00-88CC-752464DC97FB',1596,'Non-return (Fuel)','Non-return (Fuel)-150---mm','15','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3A18BBA5-6272-419F-8281-C5F353C016C1',1597,'Non-return (Fuel)','Non-return (Fuel)-200---mm','15','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('93EE1AC1-71C1-405C-864F-CEDC271352AE',1598,'Non-return (Fuel)','Non-return (Fuel)-300---mm','15','0','300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6826793A-AF3C-4AD2-A5E1-445240590D43',1599,'Pressure Reducing (Fuel)','Pressure Reducing (Fuel)-50---mm','15','0','50','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1352D3FF-7F96-4BF7-ABCB-F49516AA3104',1600,'Pressure Reducing (Fuel)','Pressure Reducing (Fuel)-80---mm','15','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0C644801-A454-4692-9133-C1F101AC41EB',1601,'Pressure Reducing (Fuel)','Pressure Reducing (Fuel)-100---mm','15','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('88900EB0-0C30-41E4-86C6-45FE05E7CA63',1602,'Pressure Reducing (Fuel)','Pressure Reducing (Fuel)-150---mm','15','0','150','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E66C61A7-045B-4791-9345-80F562B949FE',1603,'Pressure Reducing (Fuel)','Pressure Reducing (Fuel)-200---mm','15','0','200','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0AD83E99-11E4-4787-9AE0-E058EA7A05A8',1604,'Pressure Reducing (Fuel)','Pressure Reducing (Fuel)-250---mm','15','0','250','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F97919AD-FB27-475D-A451-104381A3A44A',1605,'Pressure Reducing (Fuel)','Pressure Reducing (Fuel)-300---mm','15','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9851A8D4-9A86-4B81-B84D-976AF8860303',1606,'Resilient seal (Fuel)','Resilient seal (Fuel)-50---mm','20','0','50','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('62F21C2F-412D-45C6-8D53-1795B1BF9DAB',1607,'Resilient seal (Fuel)','Resilient seal (Fuel)-80---mm','20','0','80','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EB00FFBB-947C-4544-B66D-CC60DBCEB7EB',1608,'Resilient seal (Fuel)','Resilient seal (Fuel)-100---mm','20','0','100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9B2AC04E-75B5-4592-A975-8670E3A50DAE',1609,'Resilient seal (Fuel)','Resilient seal (Fuel)-150---mm','20','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5F8DDBB2-1904-40BF-8F13-7D407AC69F6A',1610,'Resilient seal (Fuel)','Resilient seal (Fuel)-200---mm','20','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('549A01EC-52F4-47D5-8BA0-F86791CB2631',1611,'Resilient seal (Fuel)','Resilient seal (Fuel)-250---mm','20','0','250','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0B3884FC-EAA1-4239-8C3A-56EC482F548A',1612,'Resilient seal (Fuel)','Resilient seal (Fuel)-300---mm','20','0','300','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('682837BE-BEDB-4E0D-B3AD-8E295C81172D',1613,'Resilient seal (Fuel)','Resilient seal (Fuel)-350---mm','20','0','350','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E97BE5B8-5296-4859-ACAF-2EBFA91EC8A2',1614,'Resilient seal (Fuel)','Resilient seal (Fuel)-400---mm','20','0','400','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('12D272DE-4B59-461E-B4FB-087D496C54A1',1615,'UPS 40 - 80 kVA','UPS 40 - 80 kVA----','20','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F6B25DF0-C864-40C2-83DC-79587BBB2B57',1616,'UNINTERRUPTED POWER SUPPLY - UPS GENERAL','UNINTERRUPTED POWER SUPPLY - UPS GENERAL----','4','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F60E9198-3FA2-4758-AEE9-5790B716D908',1617,'Generator','Generator----','40','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A656B9BD-B2E6-45FD-AF81-85B4EE53D5C4',1618,'Exciter','Exciter----','40','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('22B95E69-1512-4C2C-8E7D-AE1BE069B80E',1619,'Generator power export system','Generator power export system----','40','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D6C9344E-9A58-4226-86CA-68B0368F5795',1620,'Feedwater piping and deaerator tank','Feedwater piping and deaerator tank----','20','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('03F9C28D-87B6-409B-BE80-4FB8ADA6A8A6',1621,'Boiler feedpumps','Boiler feedpumps----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DDD1CF19-834D-4892-A014-429F81518EA2',1622,'High pressure heater','High pressure heater----','20','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5C0677E1-2152-416F-A4C4-3C39006ABE8A',1623,'Main steam piping system','Main steam piping system----','20','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1411D20C-66B3-45F4-AF03-A05BF4A611E8',1624,'Auxiliary steam supply','Auxiliary steam supply----','20','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CF3A4BE7-CE9A-4E73-86D2-C2DFCE07EE2B',1625,'Main condensate piping system','Main condensate piping system----','20','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('661FFF74-ADE6-4C4A-A86C-7250B87FD8EC',1626,'Extraction pumps','Extraction pumps----','20','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('67031E18-C492-40E4-AB0C-06D447509AF4',1627,'Low pressure heaters','Low pressure heaters----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6F30A7A5-CFC9-4A59-9291-A10D32E7765D',1628,'High pressure turbine','High pressure turbine----','20','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9DE11248-DDFF-4C73-8696-F104E1A83F00',1629,'Low pressure turbine','Low pressure turbine----','20','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('55CCD722-3CB2-4A4E-B083-CF61ED8DCEB8',1630,'Condensing system','Condensing system----','20','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4D63DBEE-4A1F-40A7-962A-233B0B0660F7',1631,'Air evacuation system','Air evacuation system----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C3B28829-7F98-456F-B53E-BCD44C9B255F',1632,'Cooling water piping system ­','Cooling water piping system ­----','20','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('35F943DF-1D28-4A87-AD38-D97602D1C2EE',1633,'Cooling water pumping system ­','Cooling water pumping system ­----','20','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D044C3DA-236F-4FB3-B738-4ADB3FD3637E',1634,'Cooling towers ­','Cooling towers ­----','20','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9E3022C6-ECFC-43EC-8921-8B2C65536472',1635,'Main cooling water treatment','Main cooling water treatment----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('383AEFC6-D311-4C7F-830A-F8FBDB02B435',1636,'Structure for main machine set','Structure for main machine set----','20','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B13CE1D7-B638-4C57-B351-355733AC5A5E',1637,'Tunnel bore structure','Tunnel bore structure----','100','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('84C5094F-55F7-437F-8F51-5A236F81E6B3',1638,'Transformer NER','Transformer NER--11kV/420V--','45','0','','','11kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F3E2DEE6-BC43-49B5-B354-F35FC41BF9EC',1639,'Transformer NEC','Transformer NEC--11kV/420V--','45','0','','','11kV/420V','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('77344DC9-9469-426C-89DD-A3BFB201C83F',1640,'Transformer NECR','Transformer NECR--11kV/420V--','45','0','','','11kV/420V','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6E59731D-1805-492B-9B06-96CF1F041F5E',1641,'Transducers','Transducers----','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('17DCAC0A-E7A0-4636-B7F9-F78F57C78BBF',1642,'SX','SX----','5','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8A2D56A8-5841-4CE5-B7CA-6D3133E3BCDE',1643,'LX','LX----','5','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6C065F99-8B72-4302-A67C-946226A9A98F',1644,'BX','BX----','5','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F85F7B8C-DF2D-48DF-9250-E7BF1949408D',1645,'ZX','ZX----','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0B2DD322-F440-45C6-84E2-06F63089D356',1646,'LH','LH----','5','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AD8A457A-114C-4241-808E-CB7079065EB5',1647,'LR','LR----','5','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A754DACC-AFF8-42E6-94EB-82622A5D7CFB',1648,'SR','SR----','5','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B428CE5F-01F6-4443-BC94-BCCB44A6265B',1649,'ER','ER----','5','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('042B22D6-FA74-424C-9F82-F6CAFCE931EE',1650,'ZR','ZR----','5','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D60C174C-6FB3-40ED-A60B-24E12B356089',1651,'SFP-T','SFP-T----','5','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1337286F-404C-4E93-9EC5-C4ECD73B2CA1',1652,'SFP General','SFP General----','5','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B2C25EA3-1A5C-401C-A949-E42187673C2C',1653,'Double lane-double carriageway','Double lane-double carriageway----','20','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B3088E16-A081-489A-9F72-B3E1D6BE2222',1654,'Double lane-single carriageway','Double lane-single carriageway----','20','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DCB35BFC-0902-4F77-8308-D24DCB85EE62',1655,'Pelican crossing (pedestrian traffic lights)','Pelican crossing (pedestrian traffic lights)----','20','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B1CB1EA9-2534-4DFE-ABEC-FBE4D95D4FCD',1656,'Single lane-single carriageway','Single lane-single carriageway----','20','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('30616135-681D-4485-97E9-29BA378582D5',1657,'Traffic island','Traffic island----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D420AAD8-8D5B-4C51-A005-0DA520C1F84B',1658,'Timber','Timber----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EC3D3A3F-B8C9-490D-A88D-3C5DBD332919',1659,'Floodlit','Floodlit----','15','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A0E6AC05-F4DD-4013-9F1C-DE5A9EB2335C',1660,'Standard','Standard----','15','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AF404472-7F7A-4A58-B4EA-59FFC6F80397',1661,'Standard Telemetry','Standard Telemetry----','15','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8A2FCAA8-06AA-4467-95DC-85E39E333E29',1662,'Conventional','Conventional----','25','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4514213D-687E-43A6-BFA4-47132FF10D52',1663,'Micro duct','Micro duct----','25','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9BCB8889-BE88-43FE-ACBB-2CED8B38D44E',1664,'Aggressive materials','Aggressive materials---volume (kl)-','15','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('82F04A10-3218-4800-A51A-B58DD822B992',1665,'Galvanised steel panel','Galvanised steel panel---volume (kl)-','30','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('62D1B1C1-1E93-46B0-B98F-73B9C72C61A6',1666,'Plastic','Plastic---volume (kl)-','15','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2FC10609-B1E0-4BF4-A16D-8F7BD814BC1A',1667,'Fibreglass','Fibreglass---volume (kl)-','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FA81BADD-C194-4703-B497-C1829FED04DC',1668,'Synthetic surface','Synthetic surface----','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3D3B409A-3D7F-48DE-8906-EDE4732CCACA',1669,'10m x 5m','10m x 5m----','20','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EC2ECDB4-953C-4EE6-A0DF-9FC0133F38EA',1670,'25m x 20m','25m x 20m----','20','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('97A3110A-3457-42DA-AC5D-56BE23CC4CB0',1671,'Olympic','Olympic----','20','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('303BA8D1-719D-45DC-9404-74C856E693C8',1672,'Surge Arrestor','Surge Arrestor--11kV--','30','0','','','11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8B55EB34-1200-4A4A-AE7C-9F6112D80736',1673,'Surge Arrestor','Surge Arrestor--22kV--','30','0','','','22kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('09F0D946-E413-4B92-83D2-C70179AB1A67',1674,'Surge Arrestor','Surge Arrestor--33kV--','30','0','','','33kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BDCF9E16-E346-447A-9F49-E098F8A1A6B1',1675,'Surge Arrestor','Surge Arrestor--132kV--','30','0','','','132kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('84076633-BAAA-406F-9237-2C6F063B56BA',1676,'Surge Arrestor','Surge Arrestor--400kV--','30','0','','','400kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('10A261E2-170A-48D5-A303-B273772DAC0C',1677,'Surge Arrestor','Surge Arrestor--88kV--','30','0','','','88kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('00A97D10-4013-4688-9EB4-9341C0718F6A',1678,'Surge Arrestor','Surge Arrestor--275kV--','30','0','','','275kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('92464661-8FB8-461F-8AA7-E24405F22478',1679,'Super Heater','Super Heater----','45','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8B7270E3-F120-4C30-8423-638B88EA2D31',1680,'Dewatering sub-soil drain','Dewatering sub-soil drain----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0F62CBD2-556B-4328-A07B-2B8B2DB60BE1',1681,'Concrete rubbish bin','Concrete rubbish bin----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('56339C7D-0FE0-48E5-82F8-E033C0A7F750',1682,'Metal','Metal----','10','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DB460E3D-095F-4418-8F6B-EB80CCD116FE',1683,'Plastic bin','Plastic bin-240---litres','10','0','240','litres','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9EE02209-6106-4637-B15E-6FC0DFD1354A',1684,'Streetlight shared with LV network','Streetlight shared with LV network----','45','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0B413D92-7B83-433D-AA30-426858021E5C',1685,'Streetlight with its own network','Streetlight with its own network----','45','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('86EB3551-058D-4689-A22A-3394691EA763',1686,'Business and retail','Business and retail----','0','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('53CE0812-1811-4D69-87E9-3E254AFE49DE',1687,'Farms (commercial)','Farms (commercial)----','0','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A7A40A7E-A222-492A-A07B-E8B9B0058ACF',1688,'Farms (vacant)','Farms (vacant)----','0','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CE6DB95E-E00D-45DE-A789-B909970863C7',1689,'Formal residential (high income)','Formal residential (high income)----','0','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AAC6507D-07E6-40D5-B09A-37346AD8076E',1690,'Formal residential (low income)','Formal residential (low income)----','0','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('42EA545F-B58D-450C-8749-4ABDEA35AA77',1691,'Formal residential (medium income)','Formal residential (medium income)----','0','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DC6BB72B-0381-4926-B63C-B1BB02C3ABF7',1692,'Formal residential (undevelopable land)','Formal residential (undevelopable land)----','0','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('22B72B3F-489B-44B5-970C-DC9931B1E54F',1693,'Government institutions','Government institutions----','0','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1D378A1A-CAEA-4278-99C5-F8B8FC89A3CA',1694,'Informal residential','Informal residential----','0','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('13549B30-DE13-47BA-B09F-28EE7B2F503E',1695,'Open space (developable land)','Open space (developable land)----','0','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DE3C49F5-51BB-48F8-9660-75A92EF65EA6',1696,'Open space (un-developable land)','Open space (un-developable land)----','0','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('957802E1-1E39-4C4E-926E-5712F901245A',1697,'PPE Land','PPE Land----','0','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B6A63040-8F1E-4189-B2E2-3E4065CEDF7C',1698,'Fibre channel switch','Fibre channel switch----','5','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1CC06B0E-C6BE-474F-BABF-EBCF6077940A',1699,'Isci disk array','Isci disk array----','5','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('16157DDB-F70B-40CB-8C9D-BA6306752D5E',1700,'Network attached storage bay','Network attached storage bay----','5','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('22A69DE2-E093-4C08-AD9C-A969439243F7',1701,'Storage controller','Storage controller----','5','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CBFFADC5-EF95-4B75-B2D6-F8EA52EBD76A',1702,'Stone Screen','Stone Screen----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('384A65EF-0D21-46FC-B8DE-0E4583E1049F',1703,'Stainless steel','Stainless steel--Aggressive exposure--','20','0','','','Aggressive exposure','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('90870F47-CAAB-4D70-8EF7-CE076980D65F',1704,'Stainless steel','Stainless steel--Mild exposure--','40','0','','','Mild exposure','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('47436AD3-FB3A-4F3D-8AAE-297FE1B48E5A',1705,'Galvanised steel','Galvanised steel----','20','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2DBECB54-B368-4201-A291-4FA3C2619810',1706,'Mild steel','Mild steel--Aggressive exposure--','10','0','','','Aggressive exposure','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('79E00D90-161D-4432-9161-E9E1B7340F6C',1707,'Mild steel','Mild steel--Mild exposure--','20','0','','','Mild exposure','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('20D540AB-5169-40F8-9D0A-06AC9BE9220D',1708,'Station earthing − mat and electrodes','Station earthing − mat and electrodes----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('984387A1-F3C4-4062-A554-255524DBBDF6',1709,'Regulation size - indoor','Regulation size - indoor----','30','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('97A91F71-B578-4398-937D-691EC37D7B4E',1710,'Cricket','Cricket----','30','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B2D59355-1B45-49A7-A7B6-FA0D89FD4126',1711,'Rugby / soccer','Rugby / soccer----','30','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('604181B2-32F0-4DB8-9140-3EF3A517BAE0',1712,'Concrete speed hump','Concrete speed hump----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E51B7FF2-CABA-402F-AA0A-B198684F9F78',1713,'Metal speed hump','Metal speed hump----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B9CDB652-306E-42F8-9EFD-13CB10D00B3F',1714,'Asphalt speed hump','Asphalt speed hump----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FEF3EE0D-7811-46EE-8ED6-9F5E9C6680FB',1715,'Block Paving speed hump','Block Paving speed hump----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('02EF328C-0A50-494B-A7E0-9CFBD7A233E0',1716,'RAISED PEDESTRIAN CROSSINGS','RAISED PEDESTRIAN CROSSINGS----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('127C9155-12E9-4839-B29D-E8E60F565F1A',1717,'Brick structure with roof and terraces','Brick structure with roof and terraces----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('313F872A-A0C7-4B6F-8338-6CD82B254D22',1718,'Open structure with stepped terraces','Open structure with stepped terraces----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5E9E37F6-5967-4588-BB99-8E50F6D42A7F',1719,'Structure with roof and stepped terraces','Structure with roof and stepped terraces----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3B43E359-FCB8-4AB4-828D-727ACD053985',1720,'Solar Agitator','Solar Agitator----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3C3C86B7-F462-46B0-9EAE-F93EFA58F82C',1721,'Brick, block walls & concrete roof slab','Brick, block walls & concrete roof slab----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B305D24F-DBAA-443B-A10E-192B38F4C577',1722,'Brick, block walls & other roof','Brick, block walls & other roof----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('321EC8C8-697A-4785-88B3-03E39B29E74F',1723,'Steel cage','Steel cage----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4FA62779-1E91-4875-B424-A7EB6C15ADEF',1724,'Steel shed','Steel shed----','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('263538AF-8370-42FE-BFB0-CDDB952B1495',1725,'Wood shed','Wood shed----','25','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('21CC686A-642A-47F0-9823-15EED47D1273',1726,'SLUDGE BELT PRESS','SLUDGE BELT PRESS----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('53456D07-58EA-4AF3-952E-8EAAC020403D',1727,'CENTRIFUGE','CENTRIFUGE----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1C4C48AD-6354-44A8-A490-7381BECEE025',1728,'Rail signal','Rail signal----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4186D930-D30F-4C51-8200-B2E5C525FD12',1729,'Signal modulator','Signal modulator----','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9CA97F29-830C-4318-82CC-BA8FB41E23B3',1730,'Signal filters','Signal filters----','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FFD560BA-50A0-405A-A448-78B585A1D6D6',1731,'Signal demodulator','Signal demodulator----','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0E8C7800-43F6-4787-885E-98C30369C53F',1732,'Signal amplifiers','Signal amplifiers----','5','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BC54C918-3E46-413A-B663-CE79E64A2ACC',1733,'Overhead gantry cantilever','Overhead gantry cantilever----','15','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EB84DBEA-11E4-4AC4-B44F-5DFB25F94E6D',1734,'Overhead gantry portal','Overhead gantry portal----','15','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7A936783-5AE8-4154-B003-7650A66F53EC',1735,'Road signs (e.g. Warning, Law, information, street signs, etc)','Road signs (e.g. Warning, Law, information, street signs, etc)----','7','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A9DF5BF6-A7BD-454B-B864-2D9D7CE3AF9A',1736,'Standard sign','Standard sign----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('33452967-A549-4ADD-8E2F-B924D3265181',1737,'Large sign','Large sign----','15','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('962C8508-BCEA-4967-BB9F-AEBBA019C684',1738,'Very large sign','Very large sign----','15','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F30AB6C4-53E9-4FCC-AD62-2A6A6493D17A',1739,'Sidewalk Block','Sidewalk Block----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C4EB554C-6E78-4F13-958F-3C90E3FB55ED',1740,'Sidewalk Concrete','Sidewalk Concrete----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D2228D67-8A11-458D-93E4-2FCAF9B13185',1741,'Sidewalk Gravel/Shingle','Sidewalk Gravel/Shingle----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7FDC3CF2-C91B-4589-A1AF-1D0148273F27',1742,'Scraping mechanism','Scraping mechanism----','30','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('801CD057-A380-4B66-BD65-176AC2E4DCDC',1743,'Bridge drive','Bridge drive----','30','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1672B5C1-021D-4F3A-AA3C-19C438B69CA6',1744,'Server','Server----','4','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('21C1FE1A-08E4-4185-98FA-D6C4BB1AE794',1745,'Septic Tank','Septic Tank----','40','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B5B90750-C08C-481E-B957-107AEFCC0696',1746,'Alarm & sensors','Alarm & sensors----','10','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C34050C6-464D-4877-AD4D-506DB6AA01E9',1747,'Security and access control (burglar bars, turnstiles, barriers)','Security and access control (burglar bars, turnstiles, barriers)----','10','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BA6C4B9F-3943-429E-85FB-FDD7D4D7998F',1748,'Security and access control (CCTV on its own pole including communication)','Security and access control (CCTV on its own pole including communication)----','10','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('47305CF2-BA0F-46CC-8339-60C68FB31B80',1749,'Security and access control (CCTV)','Security and access control (CCTV)----','10','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7B73057A-8B43-4693-A13B-86FAFE08AED8',1750,'Sectionaliser','Sectionaliser--22kV--','45','0','','','22kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C0D51C19-B77C-4FF7-B6C0-7D27F087DFB0',1751,'Sectionaliser','Sectionaliser--6.6-11kV--','45','0','','','6.6-11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B24B9AE1-856A-4D59-A895-379471986A2C',1752,'Controller','Controller----','12','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E7DFDB35-5B22-4D9E-97D4-C664BEFF7DA3',1753,'SCADA RTU','SCADA RTU----','12','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('846A8D4B-8EC5-4511-A0EF-66E7730D3BF1',1754,'Modem','Modem----','12','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('00BAABC8-88F5-439D-BD98-F5897706FC8B',1755,'Sewer','Sewer-5---kW','15','0','5','kW','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('493FBDFE-04F2-41C4-85BB-881666B17206',1756,'Sewer','Sewer-10---kW','15','0','10','kW','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('98AD7099-411D-46C8-9DFA-EF33B7DBFA41',1757,'Sewer','Sewer-25---kW','15','0','25','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('13665C41-CF04-4AC9-851C-155CE1942913',1758,'Sewer','Sewer-50---kW','15','0','50','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('663EC189-773E-4514-A582-5272BD5447E5',1759,'Sewer','Sewer-75---kW','15','0','75','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('13E7C121-22B1-48ED-AD1D-312A56689F61',1760,'Sewer','Sewer-100---kW','15','0','100','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A0A8ECF2-C9E8-4108-9120-727A6103C058',1761,'Sewer','Sewer-150---kW','15','0','150','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F293B53A-D02D-48B3-8785-3C1D30AE9A4E',1762,'Sewer','Sewer-200---kW','15','0','200','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4FD55F0A-3CF3-47D4-B4F4-836B2E162B30',1763,'Sewer','Sewer-250---kW','15','0','250','kW','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('09E2A0F2-9139-4411-88D1-DC592B942B12',1764,'Same band combiner','Same band combiner----','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('024032F3-FD69-44BB-A1CC-D49F1DEB598E',1765,'Rural (120 km/h)','Rural (120 km/h)----','10','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F45226DD-1414-44B9-9E72-4E3CCB1EDFA8',1766,'Urban (60km/h)','Urban (60km/h)----','10','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9D078EE9-7CDF-4542-AFA0-9CBC2D929F5E',1767,'Core Router','Core Router----','4','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A5C107E9-1EEB-4BDD-88A7-1B05ED41D95D',1768,'Wireless core router','Wireless core router----','4','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D5121EB7-8773-4864-B89E-69B715A67BF8',1769,'flat concrete (170mm thick)','flat concrete (170mm thick)----','40','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('144A049B-7403-468A-80C1-E23E085966C6',1770,'Sheet metal','Sheet metal----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C72A5AA3-FF5A-45BC-A95F-7B29DB976A87',1771,'Thatch','Thatch----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('88A0350C-F4B9-49A9-AF89-5EA946333564',1772,'Tiled','Tiled----','40','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E6198B0B-30EA-4EB2-9256-033925D04137',1773,'Motor operated (bigger than 15sqm)','Motor operated (bigger than 15sqm)----','15','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('948B71E8-8EC2-45C8-B3ED-92A731E980FC',1774,'Crank operated (bigger than 15sqm)','Crank operated (bigger than 15sqm)----','15','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('04E5F90D-13E2-4690-B933-1861E279CEF7',1775,'R1 Road Surface','R1 Road Surface-Asphalt--width (m)-','12','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('83AA96BD-1403-4995-8385-BF842F67C314',1776,'R1 Road Surface','R1 Road Surface-Concrete--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C3C3BE11-2630-465E-B63D-79932219DB8F',1777,'R2 Road Surface','R2 Road Surface-Asphalt--width (m)-','12','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('277B41FA-143F-47EF-A6F8-5C57A7F6FAC8',1778,'R2 Road Surface','R2 Road Surface-Concrete--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2CA6580C-3A50-4320-A399-371339D5AACB',1779,'R2 Road Surface','R2 Road Surface-Earth Road--width (m)-','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('49D29C2D-909F-41AE-83FF-98817E3254E8',1780,'R2 Road Surface','R2 Road Surface-Gravel road--width (m)-','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('66A1AEA7-7B56-4746-9514-A6F6D158476B',1781,'R3 Road Surface','R3 Road Surface-Asphalt--width (m)-','12','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('02A3A6B6-623C-4A48-AAE7-D645E65240C3',1782,'R3 Road Surface','R3 Road Surface-Concrete--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6ED68864-F83B-4049-9A70-AFBDFD2C1269',1783,'R3 Road Surface','R3 Road Surface-Earth Road--width (m)-','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FBC6F098-561A-4A2E-BAB9-A1CDED26A1BB',1784,'R3 Road Surface','R3 Road Surface-Gravel road--width (m)-','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DA43F959-D46C-4DC6-89C4-6D4B09024AF8',1785,'R4 Road Surface','R4 Road Surface-Asphalt--width (m)-','9','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('162BC593-4633-49A3-9E28-C12BDDFD9D66',1786,'R4 Road Surface','R4 Road Surface-Block--width (m)-','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F06D888C-40F5-4FFF-8DE9-C312DE9936E6',1787,'R4 Road Surface','R4 Road Surface-Concrete--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('277BE53D-AE90-45CB-A7DF-0D8D0C0D5451',1788,'R4 Road Surface','R4 Road Surface-Earth Road--width (m)-','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A688C81B-1004-41F5-B1B0-B93BDFC21F96',1789,'R4 Road Surface','R4 Road Surface-Gravel road--width (m)-','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('89B8A083-3D57-4B78-B5CE-63ABE3039DB0',1790,'R4 Road Surface','R4 Road Surface-Seal--width (m)-','9','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0C53C0AC-A5C2-4027-A810-886A08155BEC',1791,'R5 Road Surface','R5 Road Surface-Asphalt--width (m)-','7','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E97E61C7-A3BF-4B40-852D-F6BE64F252A3',1792,'R5 Road Surface','R5 Road Surface-Block--width (m)-','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1921E06A-2A70-41C5-B695-20AF2B44039E',1793,'R5 Road Surface','R5 Road Surface-Concrete--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7E6D2415-ABBA-4002-AFB8-DF7A736D8C20',1794,'R5 Road Surface','R5 Road Surface-Earth Road--width (m)-','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('81DD2B32-CA0A-41E3-8205-B7E76DA40658',1795,'R5 Road Surface','R5 Road Surface-Gravel road--width (m)-','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C5FC6961-6F44-4D64-B684-92B9C8CFAF0E',1796,'R5 Road Surface','R5 Road Surface-Seal--width (m)-','7','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C4CE8EF9-CB30-4B86-A253-6ED6AEACD9C7',1797,'U1 Road Surface','U1 Road Surface-Asphalt--width (m)-','12','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4C10F5C3-CB55-40A3-9820-741153512D88',1798,'U1 Road Surface','U1 Road Surface-Concrete--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4359530A-2ADF-49F8-A594-945DC7266739',1799,'U2 Road Surface','U2 Road Surface-Asphalt--width (m)-','12','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D32C97A3-5CCC-4CCE-BF97-2B8E45DB4E44',1800,'U2 Road Surface','U2 Road Surface-Concrete--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E0A09AAF-B954-44FC-8FF6-3F63F7671390',1801,'U3 Road Surface','U3 Road Surface-Asphalt--width (m)-','12','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B427493E-61C5-4CCA-9329-F5A3D2F3A878',1802,'U3 Road Surface','U3 Road Surface-Concrete--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('94DDCDCB-5F1B-411A-9DC6-CC323F3BE0F1',1803,'U3 Road Surface','U3 Road Surface-Earth Road--width (m)-','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F130C57B-6070-417A-B1A5-84DCD42FC2FD',1804,'U3 Road Surface','U3 Road Surface-Gravel road--width (m)-','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('73B5BD6D-0F67-4A33-8816-F2142C7B0B44',1805,'U4 Road Surface','U4 Road Surface-Asphalt--width (m)-','9','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3B4F98B1-3D7C-44D5-80A9-8BD105B1468D',1806,'U4 Road Surface','U4 Road Surface-Block--width (m)-','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('68ECD013-DF52-43FB-B602-F0928DF8876F',1807,'U4 Road Surface','U4 Road Surface-Concrete--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ED08E0FD-9250-410B-8D50-3B9AAD21FAAC',1808,'U4 Road Surface','U4 Road Surface-Earth Road--width (m)-','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E94B96BF-D225-4E5F-81AE-8E70E171F5FB',1809,'U4 Road Surface','U4 Road Surface-Gravel road--width (m)-','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('39AE1438-372A-4B32-8920-DAB3D5EB758E',1810,'U4 Road Surface','U4 Road Surface-Seal--width (m)-','9','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('65937EAA-6776-4602-B512-AAF47594C17B',1811,'U5 Road Surface','U5 Road Surface-Asphalt--width (m)-','7','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('67B1E8FF-768A-4C4D-93F1-F06FD94E6826',1812,'U5 Road Surface','U5 Road Surface-Block--width (m)-','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0F3FE5E1-6229-4760-A584-6C76735A16A9',1813,'U5 Road Surface','U5 Road Surface-Concrete--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4399651B-E302-41FA-805D-12C296CFCF9A',1814,'U5 Road Surface','U5 Road Surface-Earth Road--width (m)-','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('13321439-2669-42D6-A0CE-C5BB2FA3D83A',1815,'U5 Road Surface','U5 Road Surface-Gravel road--width (m)-','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BF2DFAC1-731B-49D1-803B-3A2A9B62DEDA',1816,'U5 Road Surface','U5 Road Surface-Seal--width (m)-','7','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('75FF666B-DE3F-4CE5-994C-AF448615C244',1817,'R1 Road Structure','R1 Road Structure-Asphalt--width (m)-','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('24645C30-8107-4D25-AFB5-6DC2C67E8BFD',1818,'R1 Road Structure','R1 Road Structure-Concrete--width (m)-','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A7D4F6AF-DB6B-409C-A53B-B36C1BB4F965',1819,'R2 Road Structure','R2 Road Structure-Asphalt--width (m)-','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CAFF88B5-C8A4-4D07-9171-C4129C97C75F',1820,'R2 Road Structure','R2 Road Structure-Concrete--width (m)-','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4805732B-0B86-4531-BD1D-1A7BB981BFC9',1821,'R2 Road Structure','R2 Road Structure-Gravel road--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5FC77F77-A582-496F-A868-01C24AE73A78',1822,'R3 Road Structure','R3 Road Structure-Asphalt--width (m)-','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('88D7A418-A92B-4FBC-BA95-9D33F5D2CB8E',1823,'R3 Road Structure','R3 Road Structure-Block--width (m)-','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F7BD75BA-DBBB-4048-A21C-A986271C4E41',1824,'R3 Road Structure','R3 Road Structure-Concrete--width (m)-','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0D5423A8-5803-4833-8D05-AC7B86ED8502',1825,'R3 Road Structure','R3 Road Structure-Gravel road--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A98A762E-7C38-41EE-B3D0-BF316C6A8664',1826,'R4 Road Structure','R4 Road Structure-Asphalt--width (m)-','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('84B2F48A-D3AE-4D21-B93B-E58CE929E228',1827,'R4 Road Structure','R4 Road Structure-Block--width (m)-','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5832CBC3-824A-49D6-AA96-09EB2BD65E80',1828,'R4 Road Structure','R4 Road Structure-Concrete--width (m)-','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('31D90CC1-1420-425E-BAD4-1D457A83F8B2',1829,'R4 Road Structure','R4 Road Structure-Gravel road--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A31A4127-7B9E-40FC-A2B1-BFBCCD9245E7',1830,'R4 Road Structure','R4 Road Structure-Seal--width (m)-','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9CD880F3-5608-4DEA-B12D-42CBABE2F4FB',1831,'R5 Road Structure','R5 Road Structure-Asphalt--width (m)-','80','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7B152F9C-08E9-46C5-A2BA-7E1C3886038C',1832,'R5 Road Structure','R5 Road Structure-Block--width (m)-','80','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E9ADD89E-8105-4BF1-BD71-738C17B29B59',1833,'R5 Road Structure','R5 Road Structure-Concrete--width (m)-','80','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E0757162-26DD-46C4-AF3F-3918223FB95A',1834,'R5 Road Structure','R5 Road Structure-Gravel road--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9C5D7874-F9DC-4D0C-AEF3-3B95005706C3',1835,'R5 Road Structure','R5 Road Structure-Seal--width (m)-','80','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C6A01027-E902-4779-B1AE-E2931A343FC4',1836,'U1 Road Structure','U1 Road Structure-Asphalt--width (m)-','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('726022C4-4522-47EE-BFB2-1F58F6644F7A',1837,'U1 Road Structure','U1 Road Structure-Concrete--width (m)-','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D8869F1F-85C0-4A9C-B0F4-95935F824C43',1838,'U2 Road Structure','U2 Road Structure-Asphalt--width (m)-','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('08A63ED5-DBB8-44CD-85E9-555085BCFE72',1839,'U2 Road Structure','U2 Road Structure-Concrete--width (m)-','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('03AE5912-857A-4764-9C30-BB84DEC7B6F9',1840,'U3 Road Structure','U3 Road Structure-Asphalt--width (m)-','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4E549A44-290E-474A-A2E0-D14292405030',1841,'U3 Road Structure','U3 Road Structure-Block--width (m)-','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D77B2DDF-2B87-4511-AA6B-C21A5D6962CC',1842,'U3 Road Structure','U3 Road Structure-Concrete--width (m)-','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('78996634-B5D9-4AD1-98C7-A78BBC47430C',1843,'U3 Road Structure','U3 Road Structure-Gravel road--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CB056BCE-8FD3-4829-9F31-A130652A5605',1844,'U4 Road Structure','U4 Road Structure-Asphalt--width (m)-','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9CBCD9BA-2C7A-4872-9E92-B5EBAFCD1660',1845,'U4 Road Structure','U4 Road Structure-Block--width (m)-','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F65E2F6D-28D6-4DF8-8D40-D17AB9CDE1B5',1846,'U4 Road Structure','U4 Road Structure-Concrete--width (m)-','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('46DBC50E-25B0-47A4-AD8C-4F89A5A97D83',1847,'U4 Road Structure','U4 Road Structure-Gravel road--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('01795B01-C466-40C0-9B6F-C8DF84B325EF',1848,'U4 Road Structure','U4 Road Structure-Seal--width (m)-','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('91ADD8C1-904B-4F8B-AD50-83382E0CEA47',1849,'U5 Road Structure','U5 Road Structure-Asphalt--width (m)-','80','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('65E48366-F097-4389-8DEB-6A43830D928C',1850,'U5 Road Structure','U5 Road Structure-Block--width (m)-','80','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E1919020-9D57-4F90-8053-B7438E6E04C4',1851,'U5 Road Structure','U5 Road Structure-Concrete--width (m)-','80','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6A802639-3A9F-4F5D-9852-FDA0EA845628',1852,'U5 Road Structure','U5 Road Structure-Gravel road--width (m)-','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('937344AE-1FC5-42B7-984A-26F05C109668',1853,'U5 Road Structure','U5 Road Structure-Seal--width (m)-','80','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BF700C06-12BD-49EE-ACBD-40F3A32868CD',1854,'Road bridge superstructure','Road bridge superstructure----','80','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('92856AEE-C692-47DD-9FBD-648CA643DDD8',1855,'Road bridge substructure','Road bridge substructure----','80','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('34697A98-63F3-454E-8694-4273A1C04AF3',1856,'Road bridge side barrier','Road bridge side barrier----','80','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9D760CB2-3D7D-4867-A347-39155F913053',1857,'Road bridge abutment','Road bridge abutment----','80','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('480F8A68-9705-4E24-B9EE-FE7F33A50E65',1858,'Outdoor switch (ODSW)','Outdoor switch (ODSW)--6.6-11kV--','45','0','','','6.6-11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9C3EC398-8FB4-4B0F-BA03-A56951BBDBC7',1859,'Ring main unit - 3 way','Ring main unit - 3 way-315 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A1AA55AD-ACEE-4FB7-AAA1-41D7A969D2C5',1860,'Ring main unit - 3 way','Ring main unit - 3 way-400 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C8E0851F-DB11-4D14-AE61-0AD85E457119',1861,'Ring main unit - 3 way','Ring main unit - 3 way-800 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D84FFAC5-ED07-451A-BCA6-09CAF69CAA40',1862,'Ring main unit - 3 way','Ring main unit - 3 way-1200 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('78F8202C-079A-4A0B-BA89-EB8DD88E1124',1863,'Ring main unit - 4 way','Ring main unit - 4 way-315 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AF0BD561-A387-4D21-8CB1-44C0D40BC15B',1864,'Ring main unit - 4 way','Ring main unit - 4 way-400 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('339F95AF-4CD7-401E-8B53-40190B288AFA',1865,'Ring main unit - 3 way','Ring main unit - 3 way-200 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DE063E3A-39A6-40ED-9624-D549223F1D98',1866,'Ring main unit - 3 way metering','Ring main unit - 3 way metering-200 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5F5B230C-B4F2-480C-8AB2-5BF259442BC0',1867,'Ring main unit - 4 way metering','Ring main unit - 4 way metering-400 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('985CD905-E1A9-4E5D-A369-563F961C5BBA',1868,'Ring main unit - 4 way metering','Ring main unit - 4 way metering-315 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('35BF404F-22BF-4ED2-992E-86A681E5CE43',1869,'Ring main unit - 3 way metering','Ring main unit - 3 way metering-800 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('79EB49DC-4899-491D-B87A-C79BA500A160',1870,'Ring main unit - 3 way metering','Ring main unit - 3 way metering-315 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C7FB7948-5C35-49EE-BEB7-395E8DE6DF7C',1871,'Ring main unit - 3 way metering','Ring main unit - 3 way metering-1200 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C3D22917-2B1B-442D-8AC4-7D60CB49BE9E',1872,'Ring main unit - 3 way metering','Ring main unit - 3 way metering-400 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AE979858-198A-4A59-8BDF-38D31C83829A',1873,'Ring main unit - 4 way','Ring main unit - 4 way-630 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B8FACB68-3745-4A09-BD7A-1DFDDB396194',1874,'Ring main unit - 3 way','Ring main unit - 3 way-630 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3579E218-4E3C-4397-9EB0-CE9B345C79A9',1875,'Ring main unit - 3 way','Ring main unit - 3 way-500 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C6A7DA08-838D-45B7-BD77-72D9A5322271',1876,'Brick','Brick----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('94414C41-B882-4124-970F-C979B800BB8C',1877,'Concrete wall','Concrete wall----','60','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4935625C-C832-4669-9BF0-4C96E2507A24',1878,'Retaining blocks','Retaining blocks----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('863F3986-F84F-4DFE-8A55-6245925BA24B',1879,'Stone wall','Stone wall----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('181EA43E-FA53-43E2-AAF3-2BB4EB446FDF',1880,'Analogue','Analogue----','4','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5523B5EC-4081-4F13-82A3-8C364A635C73',1881,'Optic','Optic----','4','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('17C183B6-88E7-475A-949E-BA37BEE7CD0A',1882,'Radio','Radio----','4','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2BBBD672-35C6-422A-B5BD-1A0E3205A298',1883,'Reheater','Reheater----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6430E523-868B-4CD1-B116-6CF3A02AB2D8',1884,'Quarry restored area','Quarry restored area----','100','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1535B304-CACE-490A-B057-32F39603AD89',1885,'Refrigerating plant','Refrigerating plant----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('60974D09-1CAC-47F5-938D-32753B050FF1',1886,'Reactor','Reactor----','50','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C64914D1-B359-4B1D-9D30-7E59A54BBD2D',1887,'Above ground structure','Above ground structure----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2C736BBA-3A84-4D20-8012-CC968DB2EFE7',1888,'Below ground structure','Below ground structure----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5959537A-0486-4D8D-9945-AFCFC0B75710',1889,'Mass concrete','Mass concrete----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('760972DF-991F-4122-B91F-443BED231637',1890,'Shuttered RC eng structure','Shuttered RC eng structure----','80','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('442A3876-70A4-4D8E-A20E-D7AFD82A14E5',1891,'Shuttered RC eng structure - water retaining','Shuttered RC eng structure - water retaining----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('87461514-9304-49EA-91D6-F2B9DD8ADA8D',1892,'Manholes','Manholes----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4CB79557-8CB7-405C-8229-F3B15AF27769',1893,'Rail lines','Rail lines----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FE0527F4-05F2-4789-8E81-B4C5A894F640',1894,'Rail bridge superstructure','Rail bridge superstructure----','80','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('03673A31-2A96-453F-90C6-2B94CB6BA4AF',1895,'Rail bridge substructure','Rail bridge substructure----','80','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B2FBD861-185A-4208-8A95-926F296AF9E7',1896,'Rail bridge side barrier','Rail bridge side barrier----','80','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('684E5171-385C-4849-BA9A-17C59CCE1B24',1897,'Rail bridge abutments','Rail bridge abutments----','80','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('357C142A-8ECC-4257-A861-1CE1B17B749A',1898,'RADIO UNIT','RADIO UNIT----','12','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('355ABC14-C3DE-4736-ABFC-1565FDAE5FC7',1899,'Radio infrastructure','Radio infrastructure----','10','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D80CBAF7-6223-4C4C-9921-6775121709CD',1900,'Pump as turbine','Pump as turbine-57---kW','15','0','57','kW','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('447407FE-3569-4C5E-820E-6DA81347D193',1901,'Pump - water','Pump - water-50---Pump outflow pipe diameter (mm)','15','0','50','Pump outflow pipe diameter (mm)','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5D4894E8-32DB-4ABC-BB38-763E3C60C00D',1902,'Pump - water','Pump - water-75---Pump outflow pipe diameter (mm)','15','0','75','Pump outflow pipe diameter (mm)','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('444E2538-F4A6-41C1-9264-07D73BFC6A76',1903,'Pump - water','Pump - water-100---Pump outflow pipe diameter (mm)','15','0','100','Pump outflow pipe diameter (mm)','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4C8D467A-3164-47DD-A5A4-2ACCE9799C11',1904,'Pump - water','Pump - water-150---Pump outflow pipe diameter (mm)','15','0','150','Pump outflow pipe diameter (mm)','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A0BA6504-0970-4F3A-941F-57656184411B',1905,'Pump - water','Pump - water-200---Pump outflow pipe diameter (mm)','15','0','200','Pump outflow pipe diameter (mm)','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A80193EA-E9F3-4941-AB79-99DBA33FEF1D',1906,'Pump - water','Pump - water-250---Pump outflow pipe diameter (mm)','15','0','250','Pump outflow pipe diameter (mm)','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9022C9F3-53ED-41E0-92CF-B4C623CB10C4',1907,'Pump - water','Pump - water-300---Pump outflow pipe diameter (mm)','15','0','300','Pump outflow pipe diameter (mm)','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7EDD528C-ADBD-4E45-A48D-076313F8F95E',1908,'Pump - submersible','Pump - submersible-0.5---kW','10','0','0.5','kW','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9C7B6AB9-D3F6-484D-8F52-38AD2C5815A8',1909,'Pump - submersible','Pump - submersible-1---kW','10','0','1','kW','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('962FC483-23C4-41FB-B41E-347BDF316582',1910,'Pump - submersible','Pump - submersible-3---kW','10','0','3','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C2055975-846A-4083-AF47-8830D2058E51',1911,'Pump - submersible','Pump - submersible-7.5---kW','10','0','7.5','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EAF7E630-EB01-4EFD-9CF6-DF63DAF5A489',1912,'Pump - submersible','Pump - submersible-18.5---kW','10','0','18.5','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F0635E38-49EC-4290-8CFB-8136629DCB87',1913,'Pump - sewer','Pump - sewer-50---Pump outflow pipe diameter (mm)','15','0','50','Pump outflow pipe diameter (mm)','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('987A4B31-116C-4914-A922-C7785495305A',1914,'Pump - sewer','Pump - sewer-75---Pump outflow pipe diameter (mm)','15','0','75','Pump outflow pipe diameter (mm)','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6AA399EA-098D-47D2-97A0-F0AE410A283D',1915,'Pump - sewer','Pump - sewer-100---Pump outflow pipe diameter (mm)','15','0','100','Pump outflow pipe diameter (mm)','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8674F792-DE65-4FD7-8ADA-6C4727F48F9B',1916,'Pump - sewer','Pump - sewer-150---Pump outflow pipe diameter (mm)','15','0','150','Pump outflow pipe diameter (mm)','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ED910720-B306-4E76-A6B3-3AF67B538C7C',1917,'Pump - sewer','Pump - sewer-200---Pump outflow pipe diameter (mm)','15','0','200','Pump outflow pipe diameter (mm)','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2C7AB821-8605-4415-9906-313692AADD5E',1918,'Pump - sewer','Pump - sewer-250---Pump outflow pipe diameter (mm)','15','0','250','Pump outflow pipe diameter (mm)','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('271E5EBE-D93C-41A8-BFD5-F15BDDFB3307',1919,'Pump - hand','Pump - hand----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7AF3FDAB-643D-4F16-9EBC-2D24158C8DDF',1920,'Pulveriser','Pulveriser----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A3BFBA59-854A-4E0C-ABE6-9279A4B60300',1921,'Protection interlocking','Protection interlocking----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('26A840B7-7093-4664-955E-81FBF3F5CA6A',1922,'Alarm system','Alarm system----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('73A8905E-30DF-4F91-96E9-C99B482C5330',1923,'Unit co-ordinator level','Unit co-ordinator level----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DB3B50F5-5777-4A81-A171-11991470513C',1924,'Process computer systems','Process computer systems----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3DED5D36-5327-4C2F-A1C5-BF3A93CFC4F7',1925,'Control rooms','Control rooms----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('67001AFB-699A-4466-A9EB-D03BE3861273',1926,'Tele-communication equipment','Tele-communication equipment----','15','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9F62BB84-743E-4845-ADA9-AF88A9F4B962',1927,'Functional group control','Functional group control----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D2772751-57DF-4E38-B071-B78A77B296F9',1928,'Measurement, registration, recording','Measurement, registration, recording----','15','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D8E5B0D1-6459-4188-AB8E-3A09556F679F',1929,'Pressure vessel','Pressure vessel---volume (kl)-','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BE801E3F-9C4E-4721-9A68-F62B155467EC',1930,'Prepayment meters','Prepayment meters--3 phase--','10','0','','','3 phase','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D6225F1E-EA90-4004-B280-274DB4662050',1931,'Prepayment meters','Prepayment meters--single phase--','10','0','','','single phase','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2FF043FF-91DB-4E2E-9937-30CB6828630D',1932,'Precipitator','Precipitator----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DFB92D21-94D5-44B0-ADAD-BD854FB6AD03',1933,'Economiser system','Economiser system----','60','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F59331D8-4B00-4B77-AF24-FF224A7FFAB0',1934,'Boiler drum system (evaporator)','Boiler drum system (evaporator)----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('28630CCF-0393-45D7-911E-AA7D6B191F12',1935,'Superheater system','Superheater system----','60','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9E96A7D6-14A3-44F9-AAE3-88732A3B8427',1936,'Supporting structure, skin casing, combustion chamber','Supporting structure, skin casing, combustion chamber----','60','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ACA9EC6C-0EFA-4BA0-A806-889A0BE05EF8',1937,'Cleaning equipment (sootblowing)','Cleaning equipment (sootblowing)----','60','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('32B87D09-EA71-4550-AE70-6F0BDE46B04E',1938,'Ash and slag handling','Ash and slag handling----','60','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('650D0191-5F02-4152-A8CE-02028FBD779C',1939,'Bunker, feeder and mill system','Bunker, feeder and mill system----','60','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B8770A40-2C00-4DE4-98EA-98731A6A8D29',1940,'Main firing system','Main firing system----','60','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1E880012-BB41-4DA3-838E-A468B3B30EBE',1941,'Combustion air system','Combustion air system----','60','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('27FE1BF2-3B33-488B-AC10-BB6D4740CB77',1942,'Flue gas exhaust','Flue gas exhaust----','60','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1026BFF5-992B-461F-95AF-332C54EEE58C',1943,'Structure for conventional heat generation','Structure for conventional heat generation----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0C9463F2-4D6D-479F-BBB6-BC44434AC20E',1944,'Power distribution unit AC voltage','Power distribution unit AC voltage----','8','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('48D9FE54-73F4-481F-8090-B55E368F955B',1945,'Power distribution unit DC voltage','Power distribution unit DC voltage----','8','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B0E7005C-5201-41EF-AF98-967D40F87B2C',1946,'standard installation','standard installation----','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0A9EE3BA-C557-4484-BD89-2C8630B90904',1947,'Pipe bridge superstructure','Pipe bridge superstructure----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B8A89541-2FCE-4AAC-B7B8-EF0A14FA32DE',1948,'Pipe bridge substructure','Pipe bridge substructure----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('553F2350-455E-47EB-A8CF-D27797C7B806',1949,'Pipe bridge railing','Pipe bridge railing----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AB1064A8-4DDC-4E63-8AF4-9ED32EC8CA8E',1950,'Pipe bridge abutment','Pipe bridge abutment----','50','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ED0B119E-AD7E-4D0F-BE7E-470B92475A9E',1951,'HDPE (Water)','HDPE (Water)-50---mm','80','0','50','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3D4AAF98-0826-4ABA-98C7-D233D5E6E0A0',1952,'HDPE (Water)','HDPE (Water)-75---mm','80','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6A4E2C3C-634A-4365-9580-DED609B2B54F',1953,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-110---mm','80','0','110','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D93D9335-1274-41B8-9E5D-13C183281A8E',1954,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-160---mm','80','0','160','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8984979B-86A4-4297-9DE1-6643C91B3711',1955,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-200---mm','80','0','200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E6D7382D-D958-4860-A06E-8C3EAB293324',1956,'uPVC (Water)','uPVC (Water)-63---mm','80','0','63','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3AD0C7C5-ADF8-451D-9FF3-63629E04EA06',1957,'uPVC (Water)','uPVC (Water)-75---mm','80','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8467199B-1839-4AFF-9F13-23CDDC41BC00',1958,'uPVC (Water)','uPVC (Water)-90---mm','80','0','90','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2D333B7D-D90B-422E-B17B-07269E71E04F',1959,'unknown (assumed HDPE) (Water)','unknown (assumed HDPE) (Water)-50---mm','80','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('06434C10-4392-4C60-81DB-D5D4F6B4D11E',1960,'unknown (assumed steel) (Water)','unknown (assumed steel) (Water)-300---mm','80','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('63150F67-471D-4973-AE1D-1270BE8A5014',1961,'unknown (assumed steel) (Water)','unknown (assumed steel) (Water)-350---mm','80','0','350','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('00180257-3C3B-4A01-A874-9D873A291D38',1962,'unknown (assumed steel) (Water)','unknown (assumed steel) (Water)-400---mm','80','0','400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E54EE33B-F18E-4184-8EC7-4E3459A15932',1963,'unknown (assumed steel) (Water)','unknown (assumed steel) (Water)-450---mm','80','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('49825D38-685F-441B-ABC8-4549157149FD',1964,'unknown (assumed steel) (Water)','unknown (assumed steel) (Water)-500---mm','80','0','500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EE4DE778-CA09-41A4-9D29-D69183F96D73',1965,'unknown (assumed steel) (Water)','unknown (assumed steel) (Water)-600---mm','80','0','600','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3DF2854B-D817-494B-B6AE-B78576108161',1966,'unknown (assumed steel) (Water)','unknown (assumed steel) (Water)-750---mm','80','0','750','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DB3E8449-247F-4D0C-913A-1F86B4030B96',1967,'unknown (assumed steel) (Water)','unknown (assumed steel) (Water)-900---mm','80','0','900','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('48036334-E055-46DF-AAF2-E6A9B505D43F',1968,'AC (Water)','AC (Water)-50---mm','40','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('48735521-D491-42B1-A6D6-29A3C400BDE0',1969,'AC (Water)','AC (Water)-75---mm','40','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7095CE7B-034B-414C-AFDE-5500174D42AF',1970,'AC (Water)','AC (Water)-90---mm','40','0','90','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9FD9CF6C-0AE7-46EF-ABBF-F7DE04904678',1971,'AC (Water)','AC (Water)-110---mm','40','0','110','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FABCF318-BF59-478C-AAEF-595369024AF9',1972,'AC (Water)','AC (Water)-160---mm','40','0','160','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7ED36ADB-DEEC-40EA-B766-2CFADEDC0621',1973,'AC (Water)','AC (Water)-200---mm','40','0','200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('840B5A56-C352-4818-85AD-06955F047EFA',1975,'AC (Water)','AC (Water)-250---mm','40','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A0E4AC7B-472A-4D7F-9A15-FC8B7340A5CE',1976,'AC (Water)','AC (Water)-300---mm','40','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7027A042-0BC6-460D-B284-CCEA83C5DC2A',1977,'AC (Water)','AC (Water)-350---mm','40','0','350','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('86F23282-C4F9-45E5-B5C6-5D647CB1E9B3',1978,'GRP (Water)','GRP (Water)-300---mm','80','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3F2E7E3A-5D2A-4196-A4B1-15037289E022',1979,'GRP (Water)','GRP (Water)-600---mm','80','0','600','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C69402DD-7E3C-4B10-A272-6DED1E7ACD34',1980,'GRP (Water)','GRP (Water)-750---mm','80','0','750','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5822C323-7664-4149-B514-1AC91CDF9538',1981,'GRP (Water)','GRP (Water)-900---mm','80','0','900','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E573B6DA-B530-43F7-A063-E79A1CB0404F',1982,'HDPE (Water)','HDPE (Water)-20---mm','80','0','20','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D6ED4CAF-1C40-4DD6-8271-F697CA89A669',1983,'HDPE (Water)','HDPE (Water)-25---mm','80','0','25','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6D4B6120-8B1A-491A-ACCC-CEA0BC0EB2AC',1984,'HDPE (Water)','HDPE (Water)-32---mm','80','0','32','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4A38ED95-1AD8-42CB-A625-A6CE9C08E8B7',1985,'HDPE (Water)','HDPE (Water)-40---mm','80','0','40','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BF495AD5-DFF6-4EDD-8A3A-85F5E107C555',1986,'HDPE (Water)','HDPE (Water)-63---mm','80','0','63','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EFF476B3-E935-4895-9D48-F5D2682EE08F',1987,'HDPE (Water)','HDPE (Water)-90---mm','80','0','90','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2B8F7DFE-5C7F-4386-9750-D398620C2A2E',1988,'HDPE (Water)','HDPE (Water)-160---mm','80','0','160','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9D08F744-EE12-4510-870E-1182B04030B9',1989,'HDPE (Water)','HDPE (Water)-200---mm','80','0','200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7EAE0236-3DFC-4EA8-8AEB-CD4C48171D2A',1990,'HDPE (Water)','HDPE (Water)-250---mm','80','0','250','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5BEFCB12-A711-43FC-BFE9-C965E49A01E3',1991,'HDPE (Water)','HDPE (Water)-280---mm','80','0','280','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1E6612E7-CB9E-4241-93A7-CC3FD6CA6597',1992,'HDPE (Water)','HDPE (Water)-315---mm','80','0','315','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('425335A9-92AA-4938-8E8C-C37A47EE51E5',1993,'Steel (Water)','Steel (Water)-25---mm','40','0','25','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7838C135-3F20-41A2-88FD-0981DEA5F1E8',1994,'Steel (Water)','Steel (Water)-50---mm','80','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CED23469-9171-4902-A99C-3B8A90868CD6',1995,'Steel (Water)','Steel (Water)-75---mm','80','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3023431E-EF5C-4107-BD5F-384CD6FB8561',1996,'Steel (Water)','Steel (Water)-100---mm','80','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EE82782C-4AF4-40A0-9B19-03E55593BED5',1997,'Steel (Water)','Steel (Water)-150---mm','80','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4E81E962-0D00-4D09-8338-0A266FB8B105',1998,'Steel (Water)','Steel (Water)-200---mm','80','0','200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C7367B5B-A647-4B96-AB17-8B44ED9F91EB',1999,'Steel (Water)','Steel (Water)-250---mm','80','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3AA794E7-D2E5-47AC-8936-DBDD9B85670D',2000,'Steel (Water)','Steel (Water)-300---mm','80','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('37B1818B-A000-48C6-B834-593B4DC88D04',2001,'Steel (Water)','Steel (Water)-350---mm','80','0','350','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CDF23DDD-7C6B-4070-9D03-3E7C1EA25CDC',2002,'Steel (Water)','Steel (Water)-400---mm','80','0','400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BCA6B1C7-397D-44E5-864C-CA4CC688458D',2003,'unknown (assumed steel) (Water)','unknown (assumed steel) (Water)-1000---mm','80','0','1000','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B4ED42CB-4FF4-4E04-8E98-EF0E752A39FD',2004,'unknown (assumed steel) (Water)','unknown (assumed steel) (Water)-1200---mm','80','0','1200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('919C6642-03A9-492A-92E8-9DA64C92AC5C',2005,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-50---mm','80','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1FC24E58-0094-4B7C-93C7-FC16E312DF2C',2006,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-63---mm','80','0','63','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3090F90D-5D12-4335-B061-87A0215F50CD',2007,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-75---mm','80','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('013CE2B8-3264-4C12-88CB-5AE1C5F8AC92',2008,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-90---mm','80','0','90','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('230E5B37-86FE-4876-9156-A0A7D7917353',2009,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-250---mm','80','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('63F2E09A-A5B7-4354-8500-631FA504F311',2010,'uPVC (Water)','uPVC (Water)-50---mm','80','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('41EDFBE9-8F0D-4BFB-93CB-60E2686B1A0A',2011,'uPVC (Water)','uPVC (Water)-110---mm','80','0','110','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('62C11BC3-7496-4242-96BD-38C3C8CA8037',2012,'uPVC (Water)','uPVC (Water)-160---mm','80','0','160','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5EC403C7-A063-479B-AC6A-2D071099AFAD',2013,'uPVC (Water)','uPVC (Water)-200---mm','80','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('308848B0-7388-42D8-8093-F6721C2B590D',2014,'uPVC (Water)','uPVC (Water)-250---mm','80','0','250','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8556A553-AF66-4D52-B78B-CEF9597421F1',2015,'uPVC (Water)','uPVC (Water)-300---mm','80','0','300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BFACCB03-C712-4925-AE76-4AD82A3C54C6',2016,'uPVC (Water)','uPVC (Water)-315---mm','80','0','315','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('53451C5F-9BF7-46E7-A73E-CE9C65277D72',2017,'uPVC (Water)','uPVC (Water)-355---mm','80','0','355','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('10C2C8F7-C69E-4032-A421-A82C155BA20C',2018,'uPVC (Water)','uPVC (Water)-400---mm','80','0','400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F457E238-E891-4DA9-936F-68A2BB087E7A',2019,'Steel (Water)','Steel (Water)-450---mm','80','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7FEC0BA2-115A-488B-A6F0-B7D625569A2C',2020,'Steel (Water)','Steel (Water)-500---mm','80','0','500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FF0AB65B-49A0-4EA2-9762-A3C4D734C82C',2021,'Steel (Water)','Steel (Water)-600---mm','80','0','600','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2E99302F-FB1D-4C34-85FD-89C0F76138E2',2022,'Steel (Water)','Steel (Water)-750---mm','80','0','750','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('58FE46DD-55D3-4332-9534-5BB5FBD85B00',2023,'Steel (Water)','Steel (Water)-900---mm','80','0','900','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('98488F50-0B55-4A98-8A34-F09C05F85C63',2024,'Steel (Water)','Steel (Water)-1000---mm','80','0','1000','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1F410118-DE2D-4C40-952F-614C3EF7E83E',2025,'Steel (Water)','Steel (Water)-1200---mm','80','0','1200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EB5C48D2-06E2-4478-9F91-9A3624419FDF',2026,'HDPE (Water)','HDPE (Water)-225---mm','80','0','225','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7F2BC5EB-4901-4C05-BCCB-6509942A010C',2027,'HDPE (Water)','HDPE (Water)-355---mm','80','0','355','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A8A566CA-9BB0-4A6E-863A-E3FFCE4CE29E',2028,'unknown (assumed HDPE) (Water)','unknown (assumed HDPE) (Water)-20---mm','80','0','20','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4AAB9790-2394-4DB9-A600-4F89DA40C020',2029,'unknown (assumed HDPE) (Water)','unknown (assumed HDPE) (Water)-25---mm','80','0','25','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('26650B38-8FAC-416A-9002-BE0C54A3D56D',2030,'unknown (assumed HDPE) (Water)','unknown (assumed HDPE) (Water)-32---mm','80','0','32','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('89DD0BC7-12CB-44B6-9C5C-5C7DD07AABF1',2031,'unknown (assumed HDPE) (Water)','unknown (assumed HDPE) (Water)-40---mm','80','0','40','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2F680477-0FA3-4902-B17C-477FC8909FFC',2032,'HDPE (Water)','HDPE (Water)-450---mm','80','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E6A25FD0-6FC3-4D85-81FC-F80535CAF2F1',2033,'HDPE (Water)','HDPE (Water)-400---mm','80','0','400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EA283447-1FA1-4FC9-88DE-70F4841D41BE',2034,'HDPE (Water)','HDPE (Water)-110---mm','80','0','110','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3814BEE9-21C7-4D5B-9F0A-64EFEB74BDF2',2035,'uPVC (Water)','uPVC (Water)-500---mm','80','0','500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E00C2231-C46C-4D57-BF59-A3A43E313692',2036,'o-PVC (Water)','o-PVC (Water)-50---mm','80','0','50','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0589A3F9-7EC1-4DB2-B763-71096098BE58',2037,'o-PVC (Water)','o-PVC (Water)-63---mm','80','0','63','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('96D44F73-638E-4FB4-94B9-AB18865D1D66',2038,'o-PVC (Water)','o-PVC (Water)-75---mm','80','0','75','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9811042E-D466-4D08-9644-7694FA5A7026',2039,'o-PVC (Water)','o-PVC (Water)-90---mm','80','0','90','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('88EC3428-640A-4244-A3BC-BFBAC9FFD49C',2040,'o-PVC (Water)','o-PVC (Water)-110---mm','80','0','110','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('09294DFB-BC10-4736-8CA7-A3EC0DCA8C3B',2041,'o-PVC (Water)','o-PVC (Water)-160---mm','80','0','160','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D22644E1-AF61-469F-A091-8183788F68F4',2042,'o-PVC (Water)','o-PVC (Water)-200---mm','80','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('94B5E5D5-9E2D-4F7E-964B-795A21C53768',2043,'o-PVC (Water)','o-PVC (Water)-250---mm','80','0','250','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6D0CB3CD-C880-41CD-8DDB-11687ED592DF',2044,'o-PVC (Water)','o-PVC (Water)-300---mm','80','0','300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('27DFC2E7-3592-4764-8628-B2F3A4F01676',2045,'o-PVC (Water)','o-PVC (Water)-315---mm','80','0','315','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('875D767F-174E-4934-B787-3431463BD8C0',2046,'o-PVC (Water)','o-PVC (Water)-355---mm','80','0','355','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('384AA8D9-5025-4625-892C-906C0010B2CC',2047,'o-PVC (Water)','o-PVC (Water)-400---mm','80','0','400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DF48D276-0A93-4447-BF2C-C20F8A2B24E5',2048,'o-PVC (Water)','o-PVC (Water)-500---mm','80','0','500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7AD77833-EEFE-43E8-A1DB-FFCB3A364DE8',2049,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-450---mm','80','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A7F1BC4F-885C-472B-A5E3-A12532AB61BD',2050,'uPVC (Water)','uPVC (Water)-450---mm','80','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('437A74FA-5E99-40C4-A4EF-B763E198ED4F',2051,'o-PVC (Water)','o-PVC (Water)-450---mm','80','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C8963A22-A96D-418C-B7B1-2FB04770107F',2052,'Steel (Water)','Steel (Water)-20---mm','80','0','20','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5F799091-CF63-4F8F-A874-6EF35B58AB77',2053,'Steel (Water)','Steel (Water)-800---mm','80','0','800','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9BE2F399-90A7-436D-9249-EAF191FA8E89',2054,'HDPE (Water)','HDPE (Water)-1000---mm','80','0','1000','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BD3B84BB-9ED2-469C-9402-9C4CB0CFB961',2055,'HDPE (Water)','HDPE (Water)-710---mm','80','0','710','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('71D0BC04-585E-47EE-9D6E-FF2779ADDFF2',2056,'HDPE (Water)','HDPE (Water)-500---mm','80','0','500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('29FBD207-081C-462D-A526-3ACDBED1ED07',2057,'Steel (Water)','Steel (Water)-265---mm','80','0','265','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('740E1BC3-F81F-413E-A73C-BCE390BF0FF5',2058,'Steel (Water)','Steel (Water)-1400---mm','80','0','1400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('598B9192-7F35-4769-8708-6FF6FB6FD5E5',2059,'Steel (Water)','Steel (Water)-700---mm','80','0','700','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9E616378-79C6-4F37-8CD6-D44CDC08D68E',2060,'Steel (Water)','Steel (Water)-650---mm','80','0','650','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('07EFE28D-3B8A-4941-999D-95BC694282C0',2061,'Steel (Water)','Steel (Water)-610---mm','80','0','610','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('39157306-FEB7-495F-A8BA-5D018B14652B',2062,'Steel (Water)','Steel (Water)-550---mm','80','0','550','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9E9254A5-8771-462C-9D41-78FF45B73ED7',2063,'CI (Water)','CI (Water)-200---mm','80','0','200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FB541B39-A3DB-4F47-B28C-223376744AF0',2064,'Steel (Water)','Steel (Water)-375---mm','80','0','375','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('225474CB-FBE2-48F9-82C7-6EE6F589EC29',2065,'AC (Water)','AC (Water)-150---mm','40','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BB2FB638-298C-4EC4-AC6B-41EF386F784B',2066,'Steel (Water)','Steel (Water)-225---mm','80','0','225','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B3C35251-8CAF-4D44-AD02-CE5D254D82D5',2067,'Steel (Water)','Steel (Water)-220---mm','80','0','220','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('14E2569F-DD60-42EB-8BF3-CD02B4B6E742',2068,'Steel (Water)','Steel (Water)-210---mm','80','0','210','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('33363B9F-0D87-496B-8FC4-7DFA2DFDA672',2069,'Steel (Water)','Steel (Water)-160---mm','80','0','160','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('663B583D-E9D0-4020-8F71-4AF593559884',2070,'Steel (Water)','Steel (Water)-125---mm','80','0','125','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7564D921-F5EF-4618-B302-DA0A94B1757A',2071,'Steel (Water)','Steel (Water)-110---mm','80','0','110','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('83D5DC1C-EC2C-4F56-8EC1-AC0A2FBDC5A6',2072,'Steel (Water)','Steel (Water)-525---mm','80','0','525','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0E5FA7A9-93C9-4172-A8F4-6339FDC3E053',2073,'AC (Water)','AC (Water)-600---mm','40','0','600','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1A9D08E9-D3EB-4333-BB90-F13407855165',2074,'CI (Water)','CI (Water)-100---mm','80','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('43043656-6ED6-48AC-87D9-F7E74C5C85D3',2075,'CI (Water)','CI (Water)-90---mm','80','0','90','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BB3F4A0A-62E3-4D5D-8AB6-A1E356F4A45B',2076,'CI (Water)','CI (Water)-50---mm','80','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('84C52320-E7A0-4066-9004-C26F7B83EC6A',2077,'DI (Water)','DI (Water)-500---mm','80','0','500','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('08BDFEEE-78B8-4021-A8C9-04B271D3B297',2078,'DI (Water)','DI (Water)-450---mm','80','0','450','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A5009BF3-6E8C-401D-A517-D571D981E548',2079,'DI (Water)','DI (Water)-400---mm','80','0','400','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7097E83F-1981-480D-9FF4-3C549F75A7E6',2080,'AC (Water)','AC (Water)-100---mm','40','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CF54BD61-74A0-4CF5-BF72-118E36BC41AC',2081,'GRP (Water)','GRP (Water)-500---mm','80','0','500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('05700DF3-17D3-45DC-8C0F-F2C399AB95AD',2082,'AC (Water)','AC (Water)-125---mm','40','0','125','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FEF3257B-006F-4870-966A-2B0F771855FA',2083,'AC (Water)','AC (Water)-500---mm','40','0','500','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('13B482E5-BEBB-4DC6-A565-F5B2CE138224',2084,'AC (Water)','AC (Water)-450---mm','40','0','450','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('92C448CE-337D-481C-8782-C27418EB9A9D',2085,'AC (Water)','AC (Water)-400---mm','40','0','400','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DA62D686-B3F0-4A57-B1DF-9E14AD30B971',2086,'AC (Water)','AC (Water)-375---mm','40','0','375','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5D0BCAEA-F965-43C4-AC1A-5558D4EAAD2F',2087,'AC (Water)','AC (Water)-225---mm','40','0','225','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('492B54DD-F60F-4BFB-9DF0-98301C2C0A04',2088,'HDPE (Water)','HDPE (Water)-630---mm','80','0','630','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('37408BDB-23F2-4FE7-8AC7-FCC6B252D784',2089,'DI (Water)','DI (Water)-350---mm','80','0','350','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('37462849-E380-40FC-83D5-EB58A6717272',2090,'uPVC (Water)','uPVC (Water)-32---mm','80','0','32','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6AB8E803-D2CE-465D-A34B-29350D68D512',2091,'CI (Water)','CI (Water)-500---mm','80','0','500','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AAB23DE8-2BEF-4F5B-9CD5-73EC2DCA5960',2092,'uPVC (Water)','uPVC (Water)-16---mm','80','0','16','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0DFE54FB-E3B1-4B5E-BB1C-15700176515B',2093,'Steel (Water)','Steel (Water)-80---mm','80','0','80','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AF2D2B9E-2A3F-4216-B169-5C8BB5345EA9',2094,'uPVC (Water)','uPVC (Water)-25---mm','80','0','25','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('96BBBC83-0347-478C-A862-0E2AFD07044A',2095,'Steel (Water)','Steel (Water)-40---mm','80','0','40','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('39692E1E-7B37-4843-A488-5B47947B9F6C',2096,'uPVC (Water)','uPVC (Water)-40---mm','80','0','40','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8D59F00A-133B-4112-8A5E-28880E91CF0A',2097,'uPVC (Water)','uPVC (Water)-100---mm','80','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1CB247EE-3722-4466-9DB3-BE759AFAFF91',2098,'uPVC (Water)','uPVC (Water)-125---mm','80','0','125','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DFC2B65B-9F30-4447-9CD6-5C22AF7E0703',2099,'uPVC (Water)','uPVC (Water)-140---mm','80','0','140','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D8B4B879-B7E3-4F7D-BFEC-E25FFED44CCC',2100,'uPVC (Water)','uPVC (Water)-145---mm','80','0','145','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EACD60AF-0C3E-4FF7-9C56-E0DCCD77F036',2101,'HDPE (Water)','HDPE (Water)-350---mm','80','0','350','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AEDD521E-8F02-427F-94CE-7C03D7CDA41A',2102,'uPVC (Water)','uPVC (Water)-20---mm','80','0','20','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F247948D-39EB-41EE-8951-44BDC43B5C50',2103,'uPVC (Water)','uPVC (Water)-225---mm','80','0','225','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('98B99F8C-E395-47DB-BCA2-EAE0E6533028',2104,'HDPE (Water)','HDPE (Water)-125---mm','80','0','125','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E91BE9B3-8051-4463-A2DE-B8A3A185A864',2105,'m-PVC (Water)','m-PVC (Water)-355---mm','80','0','355','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('842F6F0E-3406-4F68-961E-CCB83378C8BA',2106,'m-PVC (Water)','m-PVC (Water)-250---mm','80','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6A6F6021-ECF6-455E-B55B-51CA3AB9551B',2107,'m-PVC (Water)','m-PVC (Water)-160---mm','80','0','160','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D449E225-AA6E-4327-82DF-064D8A0688D9',2108,'m-PVC (Water)','m-PVC (Water)-110---mm','80','0','110','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('052BB77A-6F52-404B-8E73-E1172CEBD8CA',2109,'uPVC (Water)','uPVC (Water)-375---mm','80','0','375','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('82ADFE94-1B91-48DC-8B74-1CB86E131CF7',2110,'AC (Water)','AC (Water)-1000---mm','40','0','1000','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('00D83970-D466-41F8-BD43-1FD0B6D0DC34',2111,'AC (Water)','AC (Water)-525---mm','40','0','525','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7FA37909-C736-4193-ADF3-1F15A722CDB7',2112,'AC (Water)','AC (Water)-700---mm','40','0','700','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DA524D8B-B9A9-4495-B2CA-375116D68546',2113,'AC (Water)','AC (Water)-800---mm','40','0','800','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('98F32CEA-E147-4817-819F-3CB6D9545150',2114,'AC (Water)','AC (Water)-900---mm','40','0','900','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B9084BAD-6402-4CEB-9BA6-B05B5151305C',2115,'CI (Water)','CI (Water)-300---mm','80','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('196C50AC-471D-4FE6-A9A2-449440ECA186',2116,'CI (Water)','CI (Water)-350---mm','80','0','350','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('501CDD79-6545-4CAC-A47E-1E5BD6C43372',2117,'CI (Water)','CI (Water)-600---mm','80','0','600','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B59D65C3-D266-4A74-B335-016FAA0A612D',2118,'DI (Water)','DI (Water)-250---mm','80','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C53AFF69-D14C-460C-9902-2EBD37B210A8',2119,'DI (Water)','DI (Water)-700---mm','80','0','700','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('090133EC-3E71-4BFC-9308-215A8251CC80',2120,'GRP (Water)','GRP (Water)-350---mm','80','0','350','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2BB56E9C-B815-4BCB-8ED1-988B2152D44B',2121,'GRP (Water)','GRP (Water)-700---mm','80','0','700','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('65F63122-6112-4966-80E2-8EC78B455D3F',2122,'HDPE (Water)','HDPE (Water)-150---mm','80','0','150','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BE0EA1AC-E6B5-4397-89F6-8C48C7A2D7AD',2123,'HDPE (Water)','HDPE (Water)-800---mm','80','0','800','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E57A0B77-0BAF-41CD-B47D-F99C0C1339D3',2124,'Steel (Water)','Steel (Water)-1100---mm','80','0','1100','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9E12A999-A08C-4C6E-8E0D-AEC95F4F45FA',2125,'Steel (Water)','Steel (Water)-1300---mm','80','0','1300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('10AC8705-8B10-47F0-9C0D-1284AC9ACB0D',2126,'Steel (Water)','Steel (Water)-2000---mm','80','0','2000','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('64503C1B-533E-459B-861C-EBAF0603F4D7',2127,'Steel (Water)','Steel (Water)-2120---mm','80','0','2120','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B0A40608-8E35-4F73-905A-423C8D44564A',2128,'Steel (Water)','Steel (Water)-240---mm','80','0','240','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8089ECD0-933E-4E74-817D-CAE19B3456BA',2129,'Steel (Water)','Steel (Water)-270---mm','80','0','270','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('73D43127-6CED-4C7A-99D1-7534C359045D',2130,'Steel (Water)','Steel (Water)-290---mm','80','0','290','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9BABE442-A691-4B51-A140-F0E316666F2D',2131,'Steel (Water)','Steel (Water)-320---mm','80','0','320','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7A42322B-228A-40B6-A058-06A943F5702B',2132,'Steel (Water)','Steel (Water)-340---mm','80','0','340','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DADFC54A-E2F4-400A-9EB8-A7D267E4D2A7',2133,'Steel (Water)','Steel (Water)-360---mm','80','0','360','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1326B7DF-3C62-437C-A0C3-DC8D01A3E9D4',2134,'Steel (Water)','Steel (Water)-370---mm','80','0','370','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('437A7E51-C348-4158-AA5A-B9217BA10914',2135,'Steel (Water)','Steel (Water)-380---mm','80','0','380','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('60CC7A91-733B-4AC7-B155-BC992BB1B8DF',2136,'Steel (Water)','Steel (Water)-405---mm','80','0','405','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B08770D3-E7CC-408A-9256-0F01AED3E7F8',2137,'Steel (Water)','Steel (Water)-475---mm','80','0','475','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('73F72C64-A648-4701-B9FE-198F1C32B9BB',2138,'Steel (Water)','Steel (Water)-675---mm','80','0','675','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F2591825-5183-4D06-BF8E-617E0284A27E',2139,'Steel (Water)','Steel (Water)-710---mm','80','0','710','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EDA4008D-4E24-477E-80C0-C50880DC0BFB',2140,'Steel (Water)','Steel (Water)-825---mm','80','0','825','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('649E0E1B-5A27-4B65-9803-78B00B52F2C9',2141,'Steel (Water)','Steel (Water)-850---mm','80','0','850','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B8066911-7DC8-4382-B8BF-27BDE38C8F4C',2142,'Steel (Water)','Steel (Water)-890---mm','80','0','890','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9700EF2B-DBF7-4240-9122-147AC9A84034',2143,'unknown (assumed steel) (Water)','unknown (assumed steel) (Water)-650---mm','80','0','650','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('64589317-8FBF-4D0B-94C6-C3AA11E8CA93',2144,'unknown (assumed steel) (Water)','unknown (assumed steel) (Water)-675---mm','80','0','675','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B64F4BDF-DCB0-4F18-976F-FAD560D32554',2145,'unknown (assumed steel) (Water)','unknown (assumed steel) (Water)-700---mm','80','0','700','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8863AD24-49A7-4A45-AC3A-EFE7EE23E2AA',2146,'unknown (assumed steel) (Water)','unknown (assumed steel) (Water)-800---mm','80','0','800','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BA5FE37E-7B89-4F0B-9867-55E3E64F328B',2147,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-125---mm','80','0','125','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B3EE11ED-42D1-4503-9F55-73B493BAA4D3',2148,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-180---mm','80','0','180','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7C192E6C-EC30-4BAF-92A4-DEDAF81F73A5',2149,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-225---mm','80','0','225','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F82E881E-4C30-41A7-B638-6FA67F59DCD5',2150,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-255---mm','80','0','255','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('88281161-BD0A-46BC-9234-6C93992BF352',2151,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-270---mm','80','0','270','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E7A6A29C-077F-479A-BDF8-274ADE0DA935',2152,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-310---mm','80','0','310','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('26A0669D-4C1C-481A-86EC-B0E30FC75617',2153,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-315---mm','80','0','315','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('13B228A3-C083-4CDD-A1F1-B3E15BD21AD2',2154,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-325---mm','80','0','325','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('45E3184C-9541-43F3-A065-4A27266CAD66',2155,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-340---mm','80','0','340','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('06C8FC99-7EF8-4ED5-93C2-CC32B8AA9788',2156,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-3430---mm','80','0','3430','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('658C50EB-4825-455B-BBAF-F3CB61202DDC',2157,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-420---mm','80','0','420','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('215513E7-5FF6-4B81-B93D-FC29E55A782E',2158,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-435---mm','80','0','435','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E8C37257-AACE-4746-B068-76CD561DF763',2159,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-485---mm','80','0','485','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E5EB4DC9-A0CE-4CBE-AC4F-64F90F60C4CA',2160,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-495---mm','80','0','495','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5CD4F04A-6665-4A62-BFD2-B9F01E2E8FB7',2161,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-525---mm','80','0','525','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C489FEAD-A5EC-42E6-AE2F-53193964215C',2162,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-530---mm','80','0','530','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DA6A291A-61F8-4BCB-B33E-3C8B7D785569',2163,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-570---mm','80','0','570','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('42A505B8-8762-45C4-A58D-F187B3F5C172',2164,'AC (Water)','AC (Water)-175---mm','40','0','175','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0735EF6D-2781-4918-88DE-204A3F0FDBF5',2165,'GAL (Water)','GAL (Water)-100---mm','80','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C248836C-1191-4392-AF83-185C9EC5D77A',2166,'Steel (Water)','Steel (Water)-219---mm','80','0','219','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ECB6B131-75D7-48FF-B7C9-FD59CAFCA331',2167,'Steel (Water)','Steel (Water)-264---mm','80','0','264','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('90EB3407-6CBF-4E65-B255-FFF2B7814E5B',2168,'Steel (Water)','Steel (Water)-315---mm','80','0','315','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6B37CB1B-BD6C-4A44-B3AB-A85B7DD13D48',2169,'Steel (Water)','Steel (Water)-341---mm','80','0','341','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('57F08246-D001-4780-8034-CF25CF5CD6CB',2170,'Steel (Water)','Steel (Water)-347---mm','80','0','347','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DE8FD307-C19B-45AE-8457-9634E3645BF4',2171,'Steel (Water)','Steel (Water)-381---mm','80','0','381','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('31C31D8C-2B67-468D-B8D4-8B2F341496DD',2172,'Steel (Water)','Steel (Water)-397---mm','80','0','397','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('23720A67-724D-4BD5-9FBA-878D5BBA061B',2173,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-100---mm','80','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2EC65799-269B-4B47-8515-EA263711255F',2174,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-135---mm','80','0','135','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AFFE47AD-8DCE-4ED6-B611-6A49183F3A68',2175,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-1400---mm','80','0','1400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('74768BEB-538F-4FCA-AD4D-F3EC8E60A51B',2176,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-140---mm','80','0','140','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('96CA2330-B65A-486B-9007-DD251E0A3F4D',2177,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-145---mm','80','0','145','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('75F096B2-7EE1-452A-950A-E806EAD7C331',2178,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-150---mm','80','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D0521F31-6115-4EC0-B5FA-86C90F2CE150',2179,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-155---mm','80','0','155','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5299FD16-455C-4FE4-A583-AF3E3EC3FB71',2180,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-170---mm','80','0','170','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F6BD48F3-7D41-4155-94AD-EA1236EF8C2E',2181,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-175---mm','80','0','175','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E658CA3D-6FBA-4C84-A686-4C1B10461107',2182,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-220---mm','80','0','220','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('516ADE01-D591-4D81-BF55-0BCB380A2C17',2183,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-230---mm','80','0','230','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0D99AB64-194C-40E2-91FF-89886B45B541',2184,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-280---mm','80','0','280','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1879A5FD-C4C4-4040-9939-D1CB9FFBDD66',2185,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-300---mm','80','0','300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DE3F83EE-EDB7-492C-BB48-ED1E980E8F51',2186,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-330---mm','80','0','330','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('090364E5-9FC5-4FB5-9C0D-F950C18872C5',2187,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-350---mm','80','0','350','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('48AA711D-D30C-4A93-8E34-244C834AA569',2188,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-375---mm','80','0','375','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C8B36765-3B80-4017-B213-34593634DFC4',2189,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-380---mm','80','0','380','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6509E5AA-B5E0-44D4-92E4-191332123E74',2190,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-400---mm','80','0','400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('51184995-E199-446B-A8B7-E3329C18E739',2191,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-500---mm','80','0','500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D227D921-4BEE-4983-96F2-7FB76407EDFF',2192,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-550---mm','80','0','550','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EBA2722C-8817-4B55-8A53-FE1D0BA64FCC',2193,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-600---mm','80','0','600','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('989207A3-618F-45E1-88FF-E55B4DDE610F',2194,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-80---mm','80','0','80','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('95A919F7-32A0-4D27-A3EB-90E37C0BB250',2195,'unknown (assumed uPVC) (Water)','unknown (assumed uPVC) (Water)-95---mm','80','0','95','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6E360CF0-9E8F-492C-9106-A61C6E329B77',2196,'Steel (Water)','Steel (Water)-355---mm','80','0','355','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C1734762-BC41-45B8-9A42-981015307D38',2197,'Concrete (Storm Water)','Concrete (Storm Water)-450---mm','50','0','450','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0373F5AA-7B6C-4B93-98AC-0609C72C7056',2198,'Concrete (Storm Water)','Concrete (Storm Water)-600---mm','50','0','600','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('08F18BF4-92ED-4EBB-B025-E245C882302C',2199,'Concrete (Storm Water)','Concrete (Storm Water)-750---mm','50','0','750','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3DAA77C4-24B5-4CF4-92B5-CACBF013286B',2200,'Concrete (Storm Water)','Concrete (Storm Water)-900---mm','50','0','900','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DE29B035-70D7-4DD6-B6DB-3D77891F2CD7',2201,'Concrete (Storm Water)','Concrete (Storm Water)-300---mm','50','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CD956188-51A7-43C6-8C86-906D0F8CAB9B',2202,'Concrete (Storm Water)','Concrete (Storm Water)-375---mm','50','0','375','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EE62A302-655A-4AD2-AA3E-85350A6AB6C9',2203,'Concrete (Storm Water)','Concrete (Storm Water)-525---mm','50','0','525','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E1F2220A-550B-4990-A5A9-4CD18EE9F795',2204,'Concrete (Storm Water)','Concrete (Storm Water)-675---mm','50','0','675','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('07BA8938-849F-4938-BF08-862E0D3AC211',2205,'Concrete (Storm Water)','Concrete (Storm Water)-875---mm','50','0','875','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5FA08CAC-AFC3-4F94-8C5E-C13827046232',2206,'Concrete (Storm Water)','Concrete (Storm Water)-1050---mm','50','0','1050','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8A50FEFC-7CA4-4BF9-89FB-C95EF622E197',2207,'Concrete (Storm Water)','Concrete (Storm Water)-1200---mm','50','0','1200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C47F62EF-8EB7-4C91-A903-66C36294C797',2208,'Concrete (Storm Water)','Concrete (Storm Water)-1500---mm','50','0','1500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2A9DAE4D-6D49-47A8-80B1-28BE3C9A5A53',2209,'Concrete (Storm Water)','Concrete (Storm Water)-1800---mm','50','0','1800','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2619461C-9B72-4A35-8BEA-066719CA8CB1',2210,'HDPE (Steam)','HDPE (Steam)-20---mm','80','0','20','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7046B3C7-68C0-4531-962F-C0EE182B896F',2211,'HDPE (Steam)','HDPE (Steam)-25---mm','80','0','25','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BD4872B5-0401-4F65-9529-AA5063DDB72C',2212,'HDPE (Steam)','HDPE (Steam)-32---mm','80','0','32','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B936F1F6-9B64-4A3E-A790-E01DE7AB4383',2213,'HDPE (Steam)','HDPE (Steam)-40---mm','80','0','40','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('22037916-6340-4A9C-8A63-34F5B722EF51',2214,'HDPE (Steam)','HDPE (Steam)-50---mm','80','0','50','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0D567090-F50B-4EEA-B51A-545ACACFC545',2215,'HDPE (Steam)','HDPE (Steam)-63---mm','80','0','63','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AF1BF2F4-F04F-404C-AAAD-B4A342594B1F',2216,'HDPE (Steam)','HDPE (Steam)-75---mm','80','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EE913754-6261-48D0-874B-77E89A9D7C70',2217,'HDPE (Steam)','HDPE (Steam)-90---mm','80','0','90','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B8B5D357-819C-4A5E-84D8-12F70F7C362B',2218,'Steel (Steam)','Steel (Steam)-25---mm','40','0','25','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CF6DD7F3-33F0-4AF4-B3F0-8581D0F5FA6C',2219,'Steel (Steam)','Steel (Steam)-50---mm','80','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E30EBADD-72F4-4D5A-B8D5-4CC2E4313A15',2220,'Steel (Steam)','Steel (Steam)-75---mm','80','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CAF54068-97E0-4886-B044-F0BEE826D50B',2221,'Steel (Steam)','Steel (Steam)-100---mm','80','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3A9CA7AD-19DA-4654-BEA5-886AEE4CC2B9',2222,'Steel (Steam)','Steel (Steam)-150---mm','80','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3FB782C5-FE24-4F02-B59C-D823BF00D1CC',2223,'Steel (Steam)','Steel (Steam)-200---mm','80','0','200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9D577744-E4A8-42D4-B83C-899D3B81B729',2224,'Steel (Steam)','Steel (Steam)-250---mm','80','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ABDC058E-7215-4380-AD87-6B680EEA480D',2225,'Steel (Steam)','Steel (Steam)-300---mm','80','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('354032D8-23DC-4100-AD2D-16A8BE57A64B',2226,'Steel (Steam)','Steel (Steam)-350---mm','80','0','350','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4E6F4722-749F-4CD7-B943-06CE3BA10910',2227,'Steel (Steam)','Steel (Steam)-400---mm','80','0','400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7C4DC9DA-7936-49F2-B63F-CCEA893D4A7F',2228,'Steel (Steam)','Steel (Steam)-450---mm','80','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4774A780-C30C-4270-BF8A-9C5847033E82',2229,'Steel (Steam)','Steel (Steam)-500---mm','80','0','500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B23F1078-B0C9-4E6F-80AB-8E04B727332D',2230,'Steel (Steam)','Steel (Steam)-600---mm','80','0','600','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5AF3D34A-39E2-4AE4-9D69-9CA22719A897',2231,'Steel (Steam)','Steel (Steam)-750---mm','80','0','750','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1C46DA4E-6211-480B-A841-E091567375F6',2232,'Steel (Steam)','Steel (Steam)-900---mm','80','0','900','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('32156D42-6443-4C3D-BF65-BF3BC22D96AE',2233,'Steel (Steam)','Steel (Steam)-1000---mm','80','0','1000','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('612BFAFB-6074-4590-B981-34D5E0A28808',2234,'Steel (Steam)','Steel (Steam)-1200---mm','80','0','1200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D8320771-7537-4608-BFEE-DC99F4AF360D',2235,'unknown (assumed HDPE) (Steam)','unknown (assumed HDPE) (Steam)-20---mm','80','0','20','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2C8219D5-32C2-4E9D-85D0-956DB8088AB2',2236,'unknown (assumed HDPE) (Steam)','unknown (assumed HDPE) (Steam)-25---mm','80','0','25','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('33130B83-E20A-440D-AA33-A68FBA3AA7D3',2237,'unknown (assumed HDPE) (Steam)','unknown (assumed HDPE) (Steam)-32---mm','80','0','32','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EC04F0BF-149C-4247-92CF-7BA7F6710106',2238,'unknown (assumed HDPE) (Steam)','unknown (assumed HDPE) (Steam)-40---mm','80','0','40','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('720D4556-37D7-464F-AE79-8B8E05FD057F',2239,'unknown (assumed HDPE) (Steam)','unknown (assumed HDPE) (Steam)-50---mm','80','0','50','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E32F069E-7146-48AC-A1DD-67B7A52FCD74',2240,'unknown (assumed steel) (Steam)','unknown (assumed steel) (Steam)-300---mm','80','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C85A5F37-9774-49C8-B97B-E566F0D55203',2241,'unknown (assumed steel) (Steam)','unknown (assumed steel) (Steam)-350---mm','80','0','350','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A6A7E568-F369-48B7-B4EE-DA1611BD90E1',2242,'unknown (assumed steel) (Steam)','unknown (assumed steel) (Steam)-400---mm','80','0','400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('15C6F9CC-0998-41C9-A167-7C3C1B466325',2243,'unknown (assumed steel) (Steam)','unknown (assumed steel) (Steam)-450---mm','80','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1C8E692F-FB42-4BD2-939E-C0F1B787A147',2244,'unknown (assumed steel) (Steam)','unknown (assumed steel) (Steam)-500---mm','80','0','500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('784D7F2B-5CD5-4BAE-8DBC-19BCB492F28C',2245,'unknown (assumed steel) (Steam)','unknown (assumed steel) (Steam)-600---mm','80','0','600','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('436B70CE-2309-4C56-8E93-13CA521B20EF',2246,'unknown (assumed steel) (Steam)','unknown (assumed steel) (Steam)-750---mm','80','0','750','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C8132E2F-A49C-4684-B73F-6A7D5AEBFA09',2247,'unknown (assumed steel) (Steam)','unknown (assumed steel) (Steam)-900---mm','80','0','900','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D6E1C4B3-2063-4A27-B8DC-9272ADDB46D8',2248,'unknown (assumed steel) (Steam)','unknown (assumed steel) (Steam)-1000---mm','80','0','1000','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('52212A94-50D2-49AB-B7FB-8035E236E415',2249,'unknown (assumed steel) (Steam)','unknown (assumed steel) (Steam)-1200---mm','80','0','1200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3E183E7C-9AB0-4241-AC1A-9B15FFA57A3D',2250,'Clay (Sewer)','Clay (Sewer)-150---mm','100','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0420A0FD-84B7-4ED8-9855-D7F0AE3CB019',2251,'Clay (Sewer)','Clay (Sewer)-200---mm','100','0','200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D199ACE1-92AC-403A-95C0-76E92F097770',2252,'Clay (Sewer)','Clay (Sewer)-250---mm','100','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A5CF9EC0-2D12-411A-9A54-0A0027B0BE0E',2253,'Clay (Sewer)','Clay (Sewer)-300---mm','100','0','300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('22AEAEC9-BE93-49DA-BEF6-2E72C292B497',2254,'Concrete (Sewer)','Concrete (Sewer)-375---mm','40','0','375','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9F98F92A-A61C-4DF2-8E28-83DD37FD8A3F',2255,'Concrete (Sewer)','Concrete (Sewer)-450---mm','40','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9A217AE9-2B1D-49D9-ABE5-B5774AACE69C',2256,'Concrete (Sewer)','Concrete (Sewer)-525---mm','40','0','525','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F29E96A0-B5BD-43F7-A8B7-01AE47B6E7FB',2257,'Concrete (Sewer)','Concrete (Sewer)-600---mm','40','0','600','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4CB3F2F1-C2E1-4AAE-926E-A7EE1644F400',2258,'Concrete (Sewer)','Concrete (Sewer)-750---mm','40','0','750','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('66CF3F24-14E1-408A-A666-76E1066C1B0E',2259,'Concrete (Sewer)','Concrete (Sewer)-900---mm','40','0','900','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0C2439FC-EF12-446C-BD95-08A14597EA88',2260,'Concrete (Sewer)','Concrete (Sewer)-1050---mm','40','0','1050','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6093ADB9-78BD-486C-B190-61AFE9928167',2261,'Steel (Sewer)','Steel (Sewer)-50---mm','80','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('778C3A49-E7CE-4A36-B7CD-D1E1B1E3A5EB',2262,'Steel (Sewer)','Steel (Sewer)-75---mm','80','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B354F59D-160A-4F6E-96CF-178F2DF1FF7B',2263,'Steel (Sewer)','Steel (Sewer)-100---mm','80','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9144263F-3E5F-4F5A-9488-807B40EA526E',2264,'Steel (Sewer)','Steel (Sewer)-150---mm','80','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('93E55BB5-EACC-4FB1-84E9-FE174DBB7311',2265,'Steel (Sewer)','Steel (Sewer)-200---mm','80','0','200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FE53E537-5581-4D35-A806-3C7365ACCE05',2266,'Steel (Sewer)','Steel (Sewer)-250---mm','80','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D46CABFD-61B1-496A-BDC7-29B50A052642',2267,'Steel (Sewer)','Steel (Sewer)-300---mm','80','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F22FE2E4-9540-4C60-8674-94B1D568FD7D',2268,'Steel (Sewer)','Steel (Sewer)-350---mm','80','0','350','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4A5B88CE-816B-45C9-BFCF-BE530478B341',2269,'Steel (Sewer)','Steel (Sewer)-400---mm','80','0','400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A0DA363F-BD0F-4D3F-A0E3-22893AD5F043',2270,'Steel (Sewer)','Steel (Sewer)-450---mm','80','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0DDCEFC4-F113-4DE4-9080-E3197AD8E95E',2271,'Steel (Sewer)','Steel (Sewer)-500---mm','80','0','500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C0EFC615-37AC-4153-9870-9685845386CB',2272,'Steel (Sewer)','Steel (Sewer)-600---mm','80','0','600','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8717CF42-D046-494F-8D23-A9830712B9F2',2273,'Steel (Sewer)','Steel (Sewer)-750---mm','80','0','750','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AB717D8A-E6DE-431C-B6BC-69006C84693B',2274,'Steel (Sewer)','Steel (Sewer)-900---mm','80','0','900','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D42E9F07-6213-40BD-8D29-F28E72740766',2275,'Steel (Sewer)','Steel (Sewer)-1000---mm','80','0','1000','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FBA8B943-58E6-47F8-9434-F0EB8F9DB33D',2276,'Steel (Sewer)','Steel (Sewer)-1200---mm','80','0','1200','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('138AF268-0D80-4FD7-AE34-1F0CBD8455FC',2277,'unknown (assumed clay) (Sewer)','unknown (assumed clay) (Sewer)-110---mm','100','0','110','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F92D25C8-B235-49B1-B9D8-FAB0234D7AF3',2278,'unknown (assumed clay) (Sewer)','unknown (assumed clay) (Sewer)-150---mm','100','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FDADDF86-C646-443B-93B2-1D3CF5EA8400',2279,'unknown (assumed clay) (Sewer)','unknown (assumed clay) (Sewer)-200---mm','100','0','200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6CDE8A73-9D7B-401B-AEE6-0B1ABADB22D2',2280,'unknown (assumed clay) (Sewer)','unknown (assumed clay) (Sewer)-250---mm','100','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('176A4BFC-909B-4335-B649-24BF76CB7716',2281,'unknown (assumed clay) (Sewer)','unknown (assumed clay) (Sewer)-300---mm','100','0','300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('340D6966-839C-48CF-87A6-B35E7DA3CCAA',2282,'unknown (assumed concrete) (Sewer)','unknown (assumed concrete) (Sewer)-375---mm','40','0','375','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9C0945C0-4405-4084-A139-BD96071213E4',2283,'unknown (assumed concrete) (Sewer)','unknown (assumed concrete) (Sewer)-450---mm','40','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A5C30AD4-7F0B-4BC9-BF9C-18DEA51606CD',2284,'unknown (assumed concrete) (Sewer)','unknown (assumed concrete) (Sewer)-525---mm','40','0','525','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0536C83A-2CF7-46CA-B1FF-ED3AFB41BCF5',2285,'unknown (assumed concrete) (Sewer)','unknown (assumed concrete) (Sewer)-600---mm','40','0','600','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4CFFB48B-EFF6-4230-B5B6-018CE879E68F',2286,'unknown (assumed concrete) (Sewer)','unknown (assumed concrete) (Sewer)-750---mm','40','0','750','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('18839DF8-E6EB-4D40-9F2B-D206E67EDDBC',2287,'unknown (assumed concrete) (Sewer)','unknown (assumed concrete) (Sewer)-900---mm','40','0','900','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C16B5F36-4F5E-4573-BA67-50412F08A467',2288,'unknown (assumed concrete) (Sewer)','unknown (assumed concrete) (Sewer)-1050---mm','40','0','1050','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EA1CFB35-BDE5-4426-B101-6976F84866B1',2289,'uPVC (Sewer)','uPVC (Sewer)-110---mm','80','0','110','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5562D1DE-3113-4D52-9520-0D7CFB275CA9',2290,'uPVC (Sewer)','uPVC (Sewer)-160---mm','80','0','160','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('588EF1FC-17D2-4A82-96CF-C652FF735ADA',2291,'uPVC (Sewer)','uPVC (Sewer)-200---mm','80','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('31E451AB-B1C4-4B95-9EA9-F76C1B375F7B',2292,'uPVC (Sewer)','uPVC (Sewer)-250---mm','80','0','250','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AF0139F8-3527-4D5C-9231-EF62AD2D377C',2293,'HDPE (Sewer)','HDPE (Sewer)-20---mm','80','0','20','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E821DE75-725F-46D5-B4A2-E9518B198A57',2294,'HDPE (Sewer)','HDPE (Sewer)-25---mm','80','0','25','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CEF607D4-2B41-4E7F-A09B-FEE8640BB0B2',2295,'HDPE (Sewer)','HDPE (Sewer)-32---mm','80','0','32','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BA9897AD-4760-4BC7-9409-BBAE1B7952F0',2296,'HDPE (Sewer)','HDPE (Sewer)-40---mm','80','0','40','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DFDF2A9A-0CAA-46E7-9108-45A4215CFEBB',2297,'HDPE (Sewer)','HDPE (Sewer)-50---mm','80','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E560A95E-D49C-4BD8-9B46-589EBDE3B928',2298,'HDPE (Sewer)','HDPE (Sewer)-63---mm','80','0','63','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CAE8F3B8-52BB-4FED-BC45-8EBC16B5DD3E',2299,'HDPE (Sewer)','HDPE (Sewer)-75---mm','80','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AEF50767-A93A-435A-96EA-D7735EFDE496',2300,'HDPE (Sewer)','HDPE (Sewer)-90---mm','80','0','90','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B964B2CC-F1BF-40A3-B75B-FF82DEC5C0DF',2301,'HDPE (Sewer)','HDPE (Sewer)-160---mm','80','0','160','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('09F4E36F-AB92-4081-801E-C7832272BC8C',2302,'HDPE (Sewer)','HDPE (Sewer)-200---mm','80','0','200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('00EF80C6-B307-4D72-B946-4FF169E32881',2303,'HDPE (Sewer)','HDPE (Sewer)-250---mm','80','0','250','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0B1680FD-1ECE-4B12-B9F2-F564D3816B08',2304,'HDPE (Sewer)','HDPE (Sewer)-280---mm','80','0','280','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('443FD772-3BD4-4774-8B33-771E6635AEB5',2305,'HDPE (Sewer)','HDPE (Sewer)-315---mm','80','0','315','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ED0D1893-9CC4-4B5F-9E8F-A0A25789B137',2306,'HDPE (Sewer)','HDPE (Sewer)-225---mm','80','0','225','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5C92FBE1-3C21-41D8-AFF7-3890773271C0',2307,'HDPE (Sewer)','HDPE (Sewer)-355---mm','80','0','355','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('78C03B93-E437-42BB-BBA7-9C70E071C52B',2308,'uPVC (Sewer)','uPVC (Sewer)-315---mm','80','0','315','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7B81100D-06F0-44A9-8113-FED099DD333B',2309,'uPVC (Sewer)','uPVC (Sewer)-355---mm','80','0','355','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('20C81BED-443B-4470-BF35-4F27E38D19D7',2310,'uPVC (Sewer)','uPVC (Sewer)-400---mm','80','0','400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('519C3296-0799-4FFB-9CF7-70D27615F426',2311,'uPVC (Sewer)','uPVC (Sewer)-150---mm','80','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1099BB66-E5AD-4914-AFBA-6763A2D8720A',2312,'uPVC (Sewer)','uPVC (Sewer)-450---mm','80','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4E8A12FC-A2D5-4724-A12F-A8DD2F32E979',2313,'uPVC (Sewer)','uPVC (Sewer)-300---mm','80','0','300','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7A7B06F8-1022-44E7-9945-787A3D82FCD8',2314,'unknown (assumed uPVC) (Sewer)','unknown (assumed uPVC) (Sewer)-450---mm','80','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('66103EF4-39E1-4A98-8A69-ED5A748118D3',2315,'uPVC (Sewer)','uPVC (Sewer)-100---mm','80','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5EEFE2C3-FA11-4961-A63D-E8498ECF6DB7',2316,'uPVC (Sewer)','uPVC (Sewer)-500---mm','80','0','500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('755B5C26-62EA-45F9-85B1-052423ECE31C',2317,'Steel (Sewer)','Steel (Sewer)-25---mm','80','0','25','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CCE0BF4A-C320-4C11-956C-9F2BF4230E74',2318,'GRP (Gas)','GRP (Gas)-300---mm','80','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E49E0A4B-04CF-4842-9C63-B07FC5CD7258',2319,'GRP (Gas)','GRP (Gas)-600---mm','80','0','600','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('14F91310-5AEA-400B-B84A-EA295E925D2D',2320,'GRP (Gas)','GRP (Gas)-750---mm','80','0','750','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CAA0F4DF-7DDA-4451-9EEB-6AB3EE9D227D',2321,'GRP (Gas)','GRP (Gas)-900---mm','80','0','900','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1F034547-3AAB-4C32-8E7B-652DB8F4D835',2322,'HDPE (Gas)','HDPE (Gas)-20---mm','80','0','20','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('464262F1-20A5-4E26-B190-7E5A4CD8AD94',2323,'HDPE (Gas)','HDPE (Gas)-25---mm','80','0','25','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('719A47F3-ADC6-43BF-8BB7-E75F85E7C10B',2324,'HDPE (Gas)','HDPE (Gas)-32---mm','80','0','32','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('18BBDCCE-8AE9-4748-B9A4-E963D901B561',2325,'HDPE (Gas)','HDPE (Gas)-40---mm','80','0','40','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('70354EDA-6539-498C-BD25-A9F3A9B5B1B5',2326,'HDPE (Gas)','HDPE (Gas)-50---mm','80','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1724B533-0A42-4239-BE85-04C632C29F39',2327,'HDPE (Gas)','HDPE (Gas)-63---mm','80','0','63','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2C31C72D-A72A-4605-882F-C71B37A21737',2328,'HDPE (Gas)','HDPE (Gas)-75---mm','80','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1CBE15FF-4B68-4E2E-B2A2-C8FD7E1F0DF8',2329,'HDPE (Gas)','HDPE (Gas)-90---mm','80','0','90','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1B9B7138-0D7E-4CB8-A00D-66C24EAAD6B3',2330,'Steel (Gas)','Steel (Gas)-25---mm','40','0','25','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('96570586-6E56-451E-B7AD-78AC9540CE41',2331,'Steel (Gas)','Steel (Gas)-50---mm','80','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('293B8F73-CD74-40CC-901E-B064A3C0A5E4',2332,'Steel (Gas)','Steel (Gas)-75---mm','80','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1768A383-699C-4CA3-B030-6B4817AB95D8',2333,'Steel (Gas)','Steel (Gas)-100---mm','80','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3DDAFA33-E4D4-4824-953B-B8A24BB59399',2334,'Steel (Gas)','Steel (Gas)-150---mm','80','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9989143C-909F-475D-838E-0A01FAFC700C',2335,'Steel (Gas)','Steel (Gas)-200---mm','80','0','200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FF51ADA4-5241-4D42-8CC1-11A8A95ECE5E',2336,'Steel (Gas)','Steel (Gas)-250---mm','80','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('546FE7F9-4B8B-44F7-9692-AE868C6497EF',2337,'Steel (Gas)','Steel (Gas)-300---mm','80','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B926C5F2-B8FF-4BB8-893D-781E8838EC3B',2338,'Steel (Gas)','Steel (Gas)-350---mm','80','0','350','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6B9CAF11-6F22-4D3C-9B1B-934196B81160',2339,'Steel (Gas)','Steel (Gas)-400---mm','80','0','400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('364058A3-7C70-4897-9745-28131B23BF99',2340,'Steel (Gas)','Steel (Gas)-450---mm','80','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D78D8C2B-E61E-4E27-ACC9-F1611594A22F',2341,'Steel (Gas)','Steel (Gas)-500---mm','80','0','500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B9863F81-497B-412A-A22A-6C87CC200F2C',2342,'Steel (Gas)','Steel (Gas)-600---mm','80','0','600','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('84A749C2-D76F-4D5C-8983-A2D21DBD8FAC',2343,'Steel (Gas)','Steel (Gas)-750---mm','80','0','750','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('42D790B3-F8DE-4C8E-A6DC-BB1571FA841E',2344,'Steel (Gas)','Steel (Gas)-900---mm','80','0','900','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9382EBD6-A10D-49E5-8EC6-69A4B7C06006',2345,'Steel (Gas)','Steel (Gas)-1000---mm','80','0','1000','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0B3237BA-539F-45E8-A809-4A6C67E0AC48',2346,'Steel (Gas)','Steel (Gas)-1200---mm','80','0','1200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('00287783-39C6-4F98-A03D-99B9600BEFB7',2347,'unknown (assumed HDPE) (Gas)','unknown (assumed HDPE) (Gas)-20---mm','80','0','20','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9EE2C417-6D89-4138-A815-9DBCE6B39005',2348,'unknown (assumed HDPE) (Gas)','unknown (assumed HDPE) (Gas)-25---mm','80','0','25','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('00A24EF8-F247-4EC5-BAE4-C24B847A2855',2349,'unknown (assumed HDPE) (Gas)','unknown (assumed HDPE) (Gas)-32---mm','80','0','32','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('454B2F01-DCAF-4820-965D-88315826AAF4',2350,'unknown (assumed HDPE) (Gas)','unknown (assumed HDPE) (Gas)-40---mm','80','0','40','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5AB988E5-83D7-4DA4-92BC-C3DF1A467007',2351,'unknown (assumed HDPE) (Gas)','unknown (assumed HDPE) (Gas)-50---mm','80','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E380F5E4-D244-4090-B5A7-8F43E67DB182',2352,'unknown (assumed steel) (Gas)','unknown (assumed steel) (Gas)-300---mm','80','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('278421D1-5935-4A0B-91EA-8440685275A3',2353,'unknown (assumed steel) (Gas)','unknown (assumed steel) (Gas)-350---mm','80','0','350','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F2DB144E-B272-4208-87C8-F95BB678EAC3',2354,'unknown (assumed steel) (Gas)','unknown (assumed steel) (Gas)-400---mm','80','0','400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A0E53697-D270-43C7-AC6D-1C00E2F4A0A0',2355,'unknown (assumed steel) (Gas)','unknown (assumed steel) (Gas)-450---mm','80','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('00C2F5C6-8C0D-4528-9DB7-21B2E20B343F',2356,'unknown (assumed steel) (Gas)','unknown (assumed steel) (Gas)-500---mm','80','0','500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C94B7AD7-2BA7-4833-8E98-836CDD9A6FDA',2357,'unknown (assumed steel) (Gas)','unknown (assumed steel) (Gas)-600---mm','80','0','600','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('065AFD2F-3B2B-4332-87ED-D21CCFD9180E',2358,'unknown (assumed steel) (Gas)','unknown (assumed steel) (Gas)-750---mm','80','0','750','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1B98EDBC-4AE3-40EC-ADC4-9836DDD5E60B',2359,'unknown (assumed steel) (Gas)','unknown (assumed steel) (Gas)-900---mm','80','0','900','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('46D2706A-559B-4425-8BBB-C143BA6AF90D',2360,'unknown (assumed steel) (Gas)','unknown (assumed steel) (Gas)-1000---mm','80','0','1000','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A123F826-5C0B-4C6A-AF98-0E5AE45752F9',2361,'unknown (assumed steel) (Gas)','unknown (assumed steel) (Gas)-1200---mm','80','0','1200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D9A56805-0A2B-4EDA-97E2-0472CE09AA4F',2362,'unknown (assumed uPVC) (Gas)','unknown (assumed uPVC) (Gas)-50---mm','80','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DC701A2D-EA35-4BB0-9932-48BD9C17537C',2363,'unknown (assumed uPVC) (Gas)','unknown (assumed uPVC) (Gas)-63---mm','80','0','63','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C244670E-EFD0-4D9F-AFA2-DF4D707AB8D0',2364,'unknown (assumed uPVC) (Gas)','unknown (assumed uPVC) (Gas)-75---mm','80','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BBE1DB23-D84D-4FF7-BE4B-695E8A74A53A',2365,'unknown (assumed uPVC) (Gas)','unknown (assumed uPVC) (Gas)-90---mm','80','0','90','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1F451E23-C255-4D29-BBB2-E5DAE9F79E07',2366,'unknown (assumed uPVC) (Gas)','unknown (assumed uPVC) (Gas)-110---mm','80','0','110','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D4E330D5-929F-4A9C-8D7F-70CE65E8AF5F',2367,'unknown (assumed uPVC) (Gas)','unknown (assumed uPVC) (Gas)-160---mm','80','0','160','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F5847C84-24F5-4667-BA6B-9B45A1C03808',2368,'unknown (assumed uPVC) (Gas)','unknown (assumed uPVC) (Gas)-200---mm','80','0','200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0F8B9DBB-95D9-4DA8-AF07-E458AA8B981D',2369,'unknown (assumed uPVC) (Gas)','unknown (assumed uPVC) (Gas)-250---mm','80','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CC0BF938-EC16-421B-9015-C63ADD82F93D',2370,'uPVC (Gas)','uPVC (Gas)-50---mm','80','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8A7E1C34-D62B-409D-9CA6-22769E90E4AA',2371,'uPVC (Gas)','uPVC (Gas)-63---mm','80','0','63','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('00D432A0-6465-4CB1-BCAE-3A3D22AFB056',2372,'uPVC (Gas)','uPVC (Gas)-75---mm','80','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9ED8C554-000B-4E2C-A4E1-7CFE1FBE9397',2373,'uPVC (Gas)','uPVC (Gas)-90---mm','80','0','90','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A3B60F2C-8949-4F55-916C-13F3BA330B22',2374,'uPVC (Gas)','uPVC (Gas)-110---mm','80','0','110','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('661EFE66-F9A0-42DB-BD92-B5D8D4DC1AD9',2375,'uPVC (Gas)','uPVC (Gas)-160---mm','80','0','160','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3558E4E5-6955-4FDC-95BE-AFFB2F77F16D',2376,'uPVC (Gas)','uPVC (Gas)-200---mm','80','0','200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A2F2DB81-B5F3-4F02-BBA9-E4BB42983BFC',2377,'uPVC (Gas)','uPVC (Gas)-250---mm','80','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('100B128E-49DD-4A7D-BA37-B942B2E01C1A',2378,'uPVC (Gas)','uPVC (Gas)-300---mm','80','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('434046AB-9598-4874-B2E7-C9CF0579CF44',2379,'uPVC (Gas)','uPVC (Gas)-400---mm','80','0','400','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('02BE4634-3A45-4E98-A7CD-01539B76DBDF',2380,'Steel (Fuel)','Steel (Fuel)-25---mm','40','0','25','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B8ACE2C0-04DE-44D1-A618-C47374DAB5EF',2381,'Steel (Fuel)','Steel (Fuel)-50---mm','80','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('95E66AE9-8F48-48B8-9DEE-EE8003E6234E',2382,'Steel (Fuel)','Steel (Fuel)-75---mm','80','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C3AD8C9D-BD87-45EB-AB53-A687892C0E91',2383,'Steel (Fuel)','Steel (Fuel)-100---mm','80','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D544CDF3-A65A-4E68-BC5B-B256900A83DC',2384,'Steel (Fuel)','Steel (Fuel)-150---mm','80','0','150','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E0C6E0D9-A873-40FC-9DA2-42CAAE913B57',2385,'Steel (Fuel)','Steel (Fuel)-200---mm','80','0','200','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4C7D2341-C9FE-4344-B5C0-BF77616120FD',2386,'Steel (Fuel)','Steel (Fuel)-250---mm','80','0','250','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('210D9096-9639-4A30-8A66-C3547CD9D53D',2387,'Steel (Fuel)','Steel (Fuel)-300---mm','80','0','300','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('92C7ADB3-73A7-4012-A05D-655AB1DB5440',2388,'Steel (Fuel)','Steel (Fuel)-350---mm','80','0','350','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('01E15138-D770-4167-BC95-91DB57330D1E',2389,'Steel (Fuel)','Steel (Fuel)-400---mm','80','0','400','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('891B07AF-7887-41E7-9735-55861D7B7539',2390,'Steel (Fuel)','Steel (Fuel)-450---mm','80','0','450','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7DFF117D-00DD-4D2B-9834-899364B88A3B',2391,'Steel (Fuel)','Steel (Fuel)-500---mm','80','0','500','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D70DF56D-B09B-478E-8C10-9127BA2C97B0',2392,'Steel (Fuel)','Steel (Fuel)-600---mm','80','0','600','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('51A5BFD2-738E-4CEC-9A46-CDE83B2DB7CB',2393,'Steel (Fuel)','Steel (Fuel)-750---mm','80','0','750','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('95426D3B-50AA-49EE-9551-A0129CF3461B',2394,'Steel (Fuel)','Steel (Fuel)-900---mm','80','0','900','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2AA22AC0-0157-4B7C-9E29-50B8C7757057',2395,'Steel (Fuel)','Steel (Fuel)-1000---mm','80','0','1000','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1BCB0287-C08F-46E7-802A-80067A8FB0B7',2396,'Steel (Fuel)','Steel (Fuel)-1200---mm','80','0','1200','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7502F40C-7C3C-4413-A608-C3DAE3E2B1F8',2397,'Steel (Bitumen)','Steel (Bitumen)-25---mm','40','0','25','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5181DF85-3922-4B10-B4FE-D502984810DF',2398,'Steel (Bitumen)','Steel (Bitumen)-50---mm','80','0','50','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A874C258-4465-4E45-9C63-9153F3C88248',2399,'Steel (Bitumen)','Steel (Bitumen)-75---mm','80','0','75','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('15F4EAE6-2AE2-4D2D-94FB-47F5CA07F58A',2400,'Steel (Bitumen)','Steel (Bitumen)-100---mm','80','0','100','mm','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('617AE05F-6741-4583-9BA7-684DEA0BB028',2401,'Brick wall','Brick wall-1.8---m','30','0','1.8','m','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('31DC1C3D-99E0-4B29-8FA8-DDC874E8699A',2402,'Clear View fencing','Clear View fencing-2---m','30','0','2','m','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('63DA73C6-224E-44D1-86E1-A8E9D09306A9',2403,'Concrete bollard','Concrete bollard----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D00B1674-9FE1-4822-B4E6-2ECA1FF5A437',2404,'Concrete palisade fencing','Concrete palisade fencing----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0E99026E-3833-445F-86AF-DF58F87E1ED3',2405,'Diamond mesh','Diamond mesh-1.2---m','15','0','1.2','m','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AEA555E1-DD11-4A3F-AABA-C2755230CB94',2406,'Diamond mesh','Diamond mesh-1.8---m','15','0','1.8','m','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3A6938F5-2D0D-4266-9871-E055C41F053A',2407,'GSM Type Fencing','GSM Type Fencing-2.35---m','20','0','2.35','m','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AC60B330-4078-4188-9319-AB71EA8B7436',2408,'Precast concrete wall','Precast concrete wall----','30','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('91F3273B-A38D-45DF-9AAB-C02BB2B9AEB1',2409,'Razor mesh fence','Razor mesh fence----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7B9A2C18-8713-437D-A07D-9F71A799AA5A',2410,'Steel bollard','Steel bollard----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ACF90109-01E1-4F80-8EC2-7C86B9529ADB',2411,'Steel palisade fencing','Steel palisade fencing----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5DF4F563-D25B-48EE-AA40-FD2CD0059EF9',2412,'Vibrocrete fence','Vibrocrete fence----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AC27B8BB-A78C-4E7E-8316-97BD28C25869',2413,'Wooden bollard','Wooden bollard----','10','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('04F7CFB1-B8D3-4507-A832-69B8C69F05F3',2414,'Wooden fence','Wooden fence----','10','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('966D887E-59DD-4689-8C39-6105E5CE4E91',2415,'Diamond mesh','Diamond mesh-2.4---m','15','0','2.4','m','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8C4E81EA-A4DA-4905-B052-2396C8293B9A',2416,'Pedestrian bridge superstructure','Pedestrian bridge superstructure----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A4ECBE7D-83B6-4597-A8B4-64C01CCDD58E',2417,'Pedestrian bridge substructure','Pedestrian bridge substructure----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3EEB4312-363A-43CE-AE02-D6E9DEC60997',2418,'Pedestrian bridge railing','Pedestrian bridge railing----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F9D9666B-5D85-4725-9708-A7E4C07B6221',2419,'Asphalt','Asphalt----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('942AE4F4-742E-4D6F-8C82-5DE4CFA05A7D',2420,'Block paving','Block paving----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E07AA7A8-4D15-4F21-B6D6-B71C81C80BFB',2421,'Concrete surface','Concrete surface----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7A647A2C-3B27-4A53-A6F0-1D6187F972B2',2422,'Gravel','Gravel----','10','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('898EA5FF-9C76-47E7-8642-754882895664',2423,'Traditional PABX','Traditional PABX----','12','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5F8823D8-F6E1-4B2F-AF7E-7E494FE34688',2424,'HDPE Manholes','HDPE Manholes----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C845FAEC-8860-497C-B394-07FBA362C74A',2425,'Oil Burner','Oil Burner----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E11C0766-84D7-4C67-BCF6-13E21D7550BE',2426,'Odour Removal System','Odour Removal System----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1C5264C9-BDB9-4B1E-9944-DB5DFA2C2845',2427,'NETWORK SECURITY APPLIANCE','NETWORK SECURITY APPLIANCE----','3','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E5CB13B8-59BC-49D5-A158-B65FCE2E690B',2428,'NETWORK CONTROL KIOSK','NETWORK CONTROL KIOSK----','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('063E9CE4-F81A-452E-BC41-303BDF23036E',2429,'Transformer','Transformer-16 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('10FE369F-DD87-4B40-94FB-5055D9905296',2430,'Transformer','Transformer-630 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6A29153F-03CE-4A74-A53E-05A30B764E7B',2431,'Transformer','Transformer-800 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('98C82705-D5DD-47C5-81E1-465BA87E54BA',2432,'Transformer','Transformer-50 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('434FDD97-BA54-4576-9C6C-FBF2FA0378AB',2433,'Transformer','Transformer-50 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('12A75F9B-F963-4C16-8E5F-682A9B97F598',2434,'Transformer','Transformer-100 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EFB50E8B-D3C7-4B52-9E3E-33E86C0039A6',2435,'Transformer','Transformer-100 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B8E54B97-5CA9-40F9-920D-149B4E4C7F21',2436,'Transformer','Transformer-200 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4A6FF83B-FD3B-4DEF-BEEA-C94FAAB43C89',2437,'Transformer','Transformer-200 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B6132F66-0CA3-4548-8EA2-64E8A4BFA4A4',2438,'Transformer','Transformer-250 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4EBE77F4-8464-4FEA-AD6A-20BB8153D113',2439,'Transformer','Transformer-400 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('508B743C-1081-486C-8E07-0D3217464091',2440,'Transformer','Transformer-400 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A42576A4-12FA-4031-B594-554677258261',2441,'Transformer','Transformer-500 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9CAF58FB-EF32-4AC7-9DCE-48BFBA76FC27',2442,'Transformer','Transformer-500 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('87C3B13E-07D7-417B-A68F-2788A36ABEA5',2443,'Transformer','Transformer-1000 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EA8BE8C0-F424-41CF-A91F-3EFFB36EBBFB',2444,'Transformer','Transformer-1000 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('82C199E0-1F4A-4142-B756-93838234DB93',2445,'Transformer','Transformer-1250 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('35CE7EAC-CC0C-4FBC-ACF2-2B971CE160A9',2446,'Transformer','Transformer-1600 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4388F73B-550D-4EBD-BB14-A57ED683CA27',2447,'Transformer','Transformer-2000 kVA-6.6-11kV/3300V--','45','0','','','6.6-11kV/3300V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E0C4084A-E51D-48AA-9F7F-3BD10AAC8145',2448,'Transformer','Transformer-2500 kVA-6.6-11kV/3300V--','45','0','','','6.6-11kV/3300V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('05C80C02-EDDD-4F19-A3E9-719E95A4BAAE',2449,'Transformer','Transformer-2500 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ADD568AD-E51A-4937-96B5-8E254B576889',2450,'Transformer','Transformer-315 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('72A345FB-FF15-4E6E-A45C-A739AA5D566A',2451,'Transformer','Transformer-5000 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A7EC7106-EA71-40B4-9B30-BA2D9B025DE5',2452,'Transformer','Transformer-10000 kVA-6.6-11kV/420V--','45','0','','','6.6-11kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4E91F402-026B-45E8-90CC-76E68EE9551E',2453,'Transformer','Transformer-16 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4A834D1B-5392-4703-AA10-DBA2FADC1D6E',2454,'Transformer','Transformer-630 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('93ACC7BA-8BB5-4A93-AF02-C0679EBCDBCC',2455,'Transformer','Transformer-800 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5BD4918F-F194-450A-9A6E-62A8BE67C61A',2456,'Transformer','Transformer-1250 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('80E51550-5CE7-4A7E-8E72-0BFBC2B19B9D',2457,'Transformer','Transformer-1600 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2686E4DB-C558-4862-8D57-AE97842EFFD7',2458,'Transformer','Transformer-2000 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('52ECF628-2FEE-4B89-8FC1-963C9768EADC',2459,'Transformer','Transformer-2500 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('67C777F7-C33B-4CD4-B7B8-2F68935B41FE',2460,'Transformer','Transformer-250 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A70AC5F6-DA21-47B7-90C0-7C39E88989CA',2461,'Transformer','Transformer-25 kVA-11kV/420V--','45','0','','','11kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('32D4C9E7-FD82-4982-A681-19AC64D773D3',2462,'Transformer','Transformer-25 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E6D0DD7A-64A1-4E9A-80B9-56DFA57D3BB1',2463,'Transformer','Transformer-315 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A3A4D98D-C78D-4A9C-A49A-DDBD59022E16',2464,'Bear','Bear----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5B79B837-384F-4D47-80CD-AB97C1721FC4',2465,'Fox','Fox----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('34716374-75AD-44F7-8DF7-9EBFA2F074E2',2466,'Goat','Goat----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A87B6C0C-63E2-460F-9281-7415FEC72143',2467,'Hare','Hare----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('06E3F5FE-AF3C-4193-9D31-A28B18D6B82A',2472,'Pelican','Pelican----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7C78E083-E416-4422-BB50-37ABEC617CCD',2473,'Wolf','Wolf----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E5ADE703-0ACA-4C96-8102-EB3DC531E210',2474,'Rabbit','Rabbit----','50','','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4C529BD1-633D-4AAA-862A-32C4C8484F87',2475,'Medium voltage aerial bundle conductor','Medium voltage aerial bundle conductor-120 sq mm---A','45','0','','A','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1C5E9C84-DBE8-4D89-9D00-A661357897C5',2476,'Earth switches','Earth switches--33kV--','50','0','','','33kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A7940101-69BE-4150-89E6-A9A618C81D43',2477,'Mv isolator','Mv isolator-800 A-6.6-11kV--','30','0','','','6.6-11kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3CB0DFD3-FF28-40B7-8EB9-860812E5B0F9',2478,'Mv isolator','Mv isolator-2000 A-6.6-11kV--','30','0','','','6.6-11kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7A225C45-69C7-4419-9951-E997899B6B82',2479,'Mv isolator','Mv isolator-1600 A-6.6-11kV--','30','0','','','6.6-11kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A0E9AC15-DACF-4C2A-97CD-C0BEAFA0822A',2480,'Mv isolator','Mv isolator-1600 A-33kV--','30','0','','','33kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A1C66A7E-A429-42FA-A306-A842ACA6219D',2481,'Pole mounted ganglink','Pole mounted ganglink--11 - 33 kV--','45','0','','','11 - 33 kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('84CB79A5-8380-4F9A-AD48-653D93A51024',2482,'Transformer NEC','Transformer NEC--6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('226E540D-C5B7-446D-A034-1C7CC05284D3',2483,'Bus-section panel - double busbar','Bus-section panel - double busbar-2000 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4F4DEF2E-444A-4CF9-A7A2-D5447C34446E',2484,'Bus-section/coupler panel','Bus-section/coupler panel-1250 A-22kV--','45','0','','','22kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('92EE3E6B-1A22-4E4E-8C7D-11EAE52AB831',2485,'Bus-section/coupler panel','Bus-section/coupler panel-2000 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5A328A08-F880-4E99-8257-7E9426D3EAF2',2486,'Feeder panel','Feeder panel-630 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E6034191-ADAA-4B31-BC41-0113F7A2BD9C',2487,'Feeder panel','Feeder panel-800 A-22kV--','45','0','','','22kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5CEBD591-C835-4EC9-8C87-BDD4CF1D6A19',2488,'Feeder panel','Feeder panel-800 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4DBC54A2-2CFA-4A8C-94AB-06AC3C82AE63',2489,'Feeder panel','Feeder panel-1250 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('668F42EE-B0FE-4503-B50A-592BD54DCD85',2490,'Feeder panel','Feeder panel-2000 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D97768CB-130D-4A18-9DD2-E50CA0AE061A',2491,'Feeder panel - double busbar','Feeder panel - double busbar-630 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0D850832-D43B-45D7-8105-9DF27A5CC369',2492,'Feeder panel - double busbar','Feeder panel - double busbar-800 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1D77C14D-61EE-4EEA-AD2D-A01B5D271AC2',2493,'Feeder panel - double busbar','Feeder panel - double busbar-1250 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('53737342-EE5E-4239-B839-7EB2BEDC7B92',2494,'Feeder panel - double busbar','Feeder panel - double busbar-2000 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('87FB45D6-15E3-4946-9041-839606F7AC9D',2495,'Incomer panel','Incomer panel-800 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9A848546-59FA-49FE-B289-3C3542D508C0',2496,'Incomer panel','Incomer panel-1250 A-22kV--','45','0','','','22kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('57B4AF40-06FF-4AE8-B49E-8B7E31C996B3',2497,'Incomer panel','Incomer panel-2000 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('82D18C82-7BA3-4404-98DF-243EA5241546',2498,'Incomer panel - double busbar','Incomer panel - double busbar-2000 A-6.6-11kV--','45','0','','','6.6-11kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DBB17AB3-6260-4153-A4FE-0A523948DAB8',2499,'Mv Al 3 core PILCSWA','Mv Al 3 core PILCSWA-50 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7739F492-3C79-4B49-9673-CB3711CBF857',2500,'Mv Al 3 core PILCSWA','Mv Al 3 core PILCSWA-70 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4AD9E51C-1EA1-4E3E-AEDC-1B5F931B0A2E',2501,'Mv Cu 3 core PILCSWA','Mv Cu 3 core PILCSWA-95 sq mm-11kV--','50','0','','','11kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F9EDDEE9-BD7D-41BC-8698-E2D9C045080B',2502,'Mv Al 3 core PILCSWA','Mv Al 3 core PILCSWA-150 sq mm-11kV--','50','0','','','11kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('42F18BCD-E91F-47A1-91B3-6A310823E76A',2503,'Mv Al 3 core PILCSWA','Mv Al 3 core PILCSWA-185 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('31ABAE73-663F-4AB0-83D9-71FF30142BE1',2504,'Mv Al 3 core PILCSWA','Mv Al 3 core PILCSWA-240 sq mm-11kV--','50','0','','','11kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('44E6C2CB-587D-49E0-B5D0-C0B628689A68',2505,'Mv Al 3 core PILCSWA','Mv Al 3 core PILCSWA-300 sq mm-11kV--','50','0','','','11kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('75B25D98-6B02-43B0-AFA0-2897711FFC26',2506,'Mv Cu 3 core PILCSWA','Mv Cu 3 core PILCSWA-150 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('65EA9634-6A52-4763-8101-95C5C37C73B5',2507,'Mv Cu 3 core PILCSWA','Mv Cu 3 core PILCSWA-185 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('467B9265-7619-40B3-8671-8FE335265C95',2508,'Mv Cu 3 core PILCSWA','Mv Cu 3 core PILCSWA-240 sq mm-11kV--','50','0','','','11kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('73A0CE89-D214-47B6-AB36-E3E14404D520',2509,'Mv Cu 3 core PILCSWA','Mv Cu 3 core PILCSWA-300 sq mm-11kV--','50','0','','','11kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C6A7DDBC-58FC-4BEB-875B-39FBFFEB32F6',2510,'Mv Cu 3 core PILCSWA','Mv Cu 3 core PILCSWA-50 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('90D7B1C9-AF8C-4684-840A-6F62F0B48865',2511,'Mv Cu 3 core PILCSWA','Mv Cu 3 core PILCSWA-70 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BA9A03D9-693D-4312-A98F-14A9ED688055',2512,'Mv Cu single core PILC','Mv Cu single core PILC-400 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('35144F17-390B-44F8-B511-1484195962AF',2513,'Mv Cu 3 core XLPE','Mv Cu 3 core XLPE-70 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7110ABA3-B774-4ADD-AEE8-FD7B15001E1D',2514,'Mv Cu 3 core XLPE','Mv Cu 3 core XLPE-185 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6F2C49EF-82A2-4C24-ADEF-B38B20D973BD',2515,'Mv Cu 3 core PILCSWA','Mv Cu 3 core PILCSWA-120 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7DD7AAF3-0B80-467C-87CA-F830C8A3B728',2516,'Mv Cu 3 core XLPE','Mv Cu 3 core XLPE-240 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B47672C7-5E72-405A-983F-C188D3CC8978',2517,'Mv Cu 3 core XLPE','Mv Cu 3 core XLPE-95 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2F6F8F38-22BA-49E0-A1F3-D2786CCA15AD',2518,'Mv Cu single core PVC','Mv Cu single core PVC-185 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EC263A2B-CB53-4737-8C27-56C3029CBD04',2519,'Mv Cu single core PILC','Mv Cu single core PILC-630 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1B8CFA59-3DDB-4D27-BD92-AD62040BA638',2520,'Mv Cu 3 core XLPE','Mv Cu 3 core XLPE-50 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A76E0F52-B690-4AFB-819D-D90B3838325F',2521,'Mv Cu 3 core XLPE','Mv Cu 3 core XLPE-35 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('17E6D9C2-529B-4E4D-A89B-E18FA0DE5E0D',2522,'Mv Cu single core PVC','Mv Cu single core PVC-150 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E134E0F7-6C72-447B-BC19-A744B6418D19',2539,'Mv Cu single core PVC','Mv Cu single core PVC-70 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E28DDE23-76F8-43D1-80BF-31C1A0F91510',2540,'Mv Al 3 core PILCSWA','Mv Al 3 core PILCSWA-95 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1DB4AF0A-9FFE-43E8-A24F-99A18FEF4D42',2541,'Mv Cu 3 core XLPE','Mv Cu 3 core XLPE-120 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('91B1F6D9-40E1-4D14-8EB7-8BD3445757FE',2542,'Mv Cu 3 core PILCSWA','Mv Cu 3 core PILCSWA-35 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('09286084-9892-4C09-A8D4-C9B396D68A63',2543,'Mv Al 3 core PILCSWA','Mv Al 3 core PILCSWA-120 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('79E4265B-5F63-4D5A-B720-B005BDB0ACC7',2544,'Mv Cu single core xlpe','Mv Cu single core xlpe-630 sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C54F9E89-D531-46CC-87DC-1BF93718ED0A',2545,'Mv UNK 3 core UNK','Mv UNK 3 core UNK-UNK sq mm-11kV--','50','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AD86D701-8149-44B5-B31C-1AD862B476EE',2546,'Mv Cu 3 core PILCSWA','Mv Cu 3 core PILCSWA-500 sq mm-11kV--','50','0','','','11kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C1226C8B-CABC-4921-A7FD-8A886C7614F5',2547,'Busbar Indoor','Busbar Indoor--11kV--','60','0','','','11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FE0D566B-B388-4A3C-AFC2-78C751C9F682',2548,'Muncher','Muncher----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5DD6C24C-90F7-4896-832B-62A9C5383EA6',2549,'Analogue Multiplexer','Analogue Multiplexer----','4','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('59038D0B-63BB-4CB2-BA74-C8DE529A3E88',2550,'Digital Multiplexer','Digital Multiplexer----','5','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1B0F0FCE-72D4-4F90-8F69-87EB9101335A',2551,'PROTOCOL MODULE','PROTOCOL MODULE----','12','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B0018580-69A4-4E7C-9BE2-AC0063D3E77A',2552,'DIGITAL MODULE/CARD','DIGITAL MODULE/CARD----','4','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8E79EA87-F9E8-482D-AD93-EB492E2DC8C8',2553,'Multi band combiners','Multi band combiners----','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6C3EA83D-826B-48BC-B624-9E799F9E2BBB',2554,'Electrical','Electrical-5---kW','15','0','5','kW','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('58EA3C98-35E9-4EAB-8CD7-F6FA4700CC51',2555,'Electrical','Electrical-10---kW','15','0','10','kW','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('76D4036B-17D4-445F-995C-4867DFC8EB94',2556,'Electrical','Electrical-25---kW','15','0','25','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0692CC36-590B-4BFA-95D3-F02DCDFBF18F',2557,'Electrical','Electrical-50---kW','15','0','50','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4E72AB88-E828-4F81-96B9-3CF6D8006992',2558,'Electrical','Electrical-75---kW','15','0','75','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3A2483B8-1F66-4335-918E-66ECB0AB01CD',2559,'Electrical','Electrical-100---kW','15','0','100','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8E000A67-78FB-4F41-8540-DC607A19B632',2560,'Electrical','Electrical-150---kW','15','0','150','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('200FBB0E-75C2-4345-A1DC-AD405CFF2345',2561,'Electrical','Electrical-200---kW','15','0','200','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D5861B9B-E1E6-402B-998D-0765107ECB58',2562,'Electrical','Electrical-250---kW','15','0','250','kW','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ED5781B8-43D9-46BF-9FE1-0ECE9565D991',2563,'Motor control centre','Motor control centre----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6FA64E66-7D49-4F31-A715-D6B023C7C35A',2564,'Water','Water-5---kW','15','0','5','kW','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8FA6E11E-3166-4FEA-9247-B07CBB0536BC',2565,'Water','Water-10---kW','15','0','10','kW','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DFB98C3F-CAF1-447D-9CED-714011564955',2566,'Water','Water-25---kW','15','0','25','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('40C9ECF6-A850-48EE-BB20-F965A585A63C',2567,'Water','Water-50---kW','15','0','50','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('233CEA66-98B8-4506-AE75-743870742D05',2568,'Water','Water-75---kW','15','0','75','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('72DFE66F-7BAE-4DE5-887F-3942FEA4823E',2569,'Water','Water-100---kW','15','0','100','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C2995D8E-A0E4-4F12-A26B-B50887031017',2570,'Water','Water-150---kW','15','0','150','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1E9B13FA-FEDC-4410-B5EC-0BA74740295E',2571,'Water','Water-200---kW','15','0','200','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DB655849-9B51-4970-8367-67BF277D8F40',2572,'Water','Water-250---kW','15','0','250','kW','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CCAC5AC6-797E-4C7A-9314-8F20A33572C4',2573,'Asphault Stone Mixer','Asphault Stone Mixer----','12','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4B54DD0C-68EC-4931-BE45-3036B23421FC',2574,'Submersible','Submersible-4---kW','15','0','4','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4A300510-503B-4289-B277-9E5287D51DC3',2575,'Submersible','Submersible-5.5---kW','15','0','5.5','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C446FAB7-08BC-478D-A5FC-3F3FBE289E48',2576,'Submersible','Submersible-7.5---kW','15','0','7.5','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1F2B8B89-D14A-4903-A360-97C4A24E4863',2577,'Submersible','Submersible-10---kW','15','0','10','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E3944267-7C5B-4034-B2F9-7E3166254A96',2578,'MIXED REALITY HARDWARE','MIXED REALITY HARDWARE----','3','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BC7FAA9B-5AF5-4522-A293-48E7397379FC',2579,'Mini-sub','Mini-sub-1000 kVA-6.6-11kV / 420V--','45','0','','','6.6-11kV / 420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D0C63B43-0A8C-4B68-89BA-30576A581D45',2580,'Mini-sub','Mini-sub-100 kVA-6.6-11kV / 420V--','45','0','','','6.6-11kV / 420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('931794AC-C916-4A3D-BE8E-14A2A70D047D',2581,'Mini-sub','Mini-sub-200 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5CA62D1E-13F5-482E-9B9B-5B34B3B615B7',2582,'Mini-sub','Mini-sub-200 kVA-6.6-11kV / 420V--','45','0','','','6.6-11kV / 420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('151B2F78-CB0D-41B3-89BC-68E4C89E10AB',2583,'Mini-sub','Mini-sub-315 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1A4409E6-4A85-4FDC-8FE3-B38470466BBB',2584,'Mini-sub','Mini-sub-315 kVA-6.6-11kV / 420V--','45','0','','','6.6-11kV / 420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('48848F05-A4A0-488D-8706-92E59DF6D20B',2585,'Mini-sub','Mini-sub-500 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('80B57142-CBE8-4A39-92F3-64CC410A0778',2586,'Mini-sub','Mini-sub-500 kVA-6.6-11kV / 420V--','45','0','','','6.6-11kV / 420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1223E55D-4FE5-4574-9D68-30A996A4D489',2587,'Mini-sub','Mini-sub-50 kVA-6.6-11kV / 420V--','45','0','','','6.6-11kV / 420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('926AB051-5A01-437D-952D-CEEB63EC32A1',2588,'Mini-sub','Mini-sub-630 kVA-6.6-11kV / 420V--','45','0','','','6.6-11kV / 420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('565A00B7-CB3D-46A7-BA59-CC1BAA60E67B',2589,'Mini-sub','Mini-sub-630 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A592EB7B-62EB-437F-B6B2-1140C8C9C0FD',2590,'Mini-sub','Mini-sub-800 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6D165AB1-AAC9-4BC3-A5D2-4E34EF8E9343',2591,'Mini-sub','Mini-sub-800 kVA-6.6-11kV / 420V--','45','0','','','6.6-11kV / 420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7BD44F88-5010-4810-97A3-888EF1643118',2592,'Mini-sub','Mini-sub-250 kVA-6.6-11kV / 420V--','45','0','','','6.6-11kV / 420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9B798390-2E2E-49E7-944F-F19200D411D8',2593,'Mini-sub','Mini-sub-250 kVA-22kV/420V--','45','0','','','22kV/420V','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0CC5794C-2EE0-4DA9-8F92-FB9FCDC4101A',2594,'Mini round-about','Mini round-about----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E23D36E4-3078-4D26-9A9C-336088EBC463',2595,'Horn antennas','Horn antennas----','4','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5FD80553-5550-49EA-A3D6-CA419276BB91',2596,'Mimo antennas','Mimo antennas----','4','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2EAA1D66-F27F-4338-B21F-406113599D01',2597,'Parabolic antennas','Parabolic antennas----','4','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0470E15C-766E-4C51-BDF2-20D48FC072B4',2598,'Patch antennas','Patch antennas----','4','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D0247815-716B-4A83-AB35-D42FCB41B200',2599,'Plasma antennas','Plasma antennas----','4','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7020F075-219E-4ED1-B1C9-58B2AAC64E4B',2600,'Mast','Mast----','12','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('054CB1E5-D454-45C0-9174-9DB8EE332F5C',2601,'General','General----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('58CBEBF9-94BB-4995-BE0D-3751795D9C5D',2602,'Masonry manholes','Masonry manholes----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B4CE3A7A-7F8B-43DF-8FE3-12CD470AC39E',2603,'Low voltage aerial bundle conductor','Low voltage aerial bundle conductor-95 sq mm---A','45','0','','A','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0E0C3F61-DD9F-4FCF-879B-DFDC567868F1',2604,'Low voltage aerial bundle conductor','Low voltage aerial bundle conductor-120 sq mm---A','45','0','','A','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DD76DE88-E264-4DFD-A770-EEB2AD26FD94',2605,'LV - open wire','LV - open wire----','45','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('716586C1-D6B2-4016-BD81-EC3AEF2D10D0',2606,'LV overhead service connection (per 30m service)','LV overhead service connection (per 30m service)--single phase--','45','0','','','single phase','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A323BBB5-C352-4C53-9D19-D9505B07DC86',2607,'LV overhead service connection (per 30m service)','LV overhead service connection (per 30m service)--three phase--','45','0','','','three phase','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('022D7516-0262-49AC-8A29-31C2F04CBCE9',2608,'LV underground service connection (per 30m service)','LV underground service connection (per 30m service)--single phase--','60','0','','','single phase','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('22649894-27A1-4124-AEE8-5F069290D263',2609,'LV underground service connection (per 30m service)','LV underground service connection (per 30m service)--three phase--','60','0','','','three phase','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6581D871-A1A1-46A6-9CC9-102C3D0DB7B9',2610,'Lv Cu 4 core PVCSWA','Lv Cu 4 core PVCSWA-6 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D6544C29-B3EF-41F6-80A0-34C6FB77832A',2611,'Lv Cu 4 core PVC','Lv Cu 4 core PVC-240 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0D3E15D4-1387-41E1-AFF7-0BBD1A80E1BF',2612,'Lv Cu 4 core PVCSWA','Lv Cu 4 core PVCSWA-16 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E447EB07-C97D-4D44-A96A-4141D40523E7',2613,'Lv Cu single core PVC','Lv Cu single core PVC-25 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('213EFD6F-7880-419E-944C-1DBC4FEC5407',2614,'Lv Cu 4 core PVC','Lv Cu 4 core PVC-185 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1DDCBC09-2183-434D-B49B-9EEDF5C0B880',2615,'Lv Cu 4 core PVCSWA and ECC','Lv Cu 4 core PVCSWA and ECC-120 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BCD34105-7BB2-48E4-ABB1-C015879539D4',2616,'Lv Cu 4 core PVCSWA','Lv Cu 4 core PVCSWA-10 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BFDCB633-487C-440C-8439-E385737792B6',2617,'Lv Cu 4 core PVC','Lv Cu 4 core PVC-95 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('14186A06-0376-4FFA-B327-02947C7C8916',2618,'Lv Cu 4 core PVCSWA','Lv Cu 4 core PVCSWA-25 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3FBC5E24-BE42-45F8-AAA8-EE16F94FE962',2619,'Lv Cu 4 core PVCSWA and ECC','Lv Cu 4 core PVCSWA and ECC-35 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FC634FAF-E3B0-44B2-90B3-60AD957111A0',2620,'Lv Cu 4 core PVC','Lv Cu 4 core PVC-150 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('03361AA6-104E-4C5A-92BF-88F7687222B6',2621,'Lv Cu single core PVC','Lv Cu single core PVC-70 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('19C700D7-69BE-4BAD-AE38-FA00116A78A9',2622,'Lv Cu 4 core PVC','Lv Cu 4 core PVC-50 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A22EF8E2-D751-4AFF-9E70-6B00B11A5D8A',2623,'Lv Cu single core PVC','Lv Cu single core PVC-120 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E5F46D56-A114-4175-A13D-422635257AA0',2624,'Lv Cu 4 core PVC','Lv Cu 4 core PVC-70 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('99BB73D5-40D2-4ED3-82FF-994D9E578519',2625,'Lv Cu single core PVC','Lv Cu single core PVC-35 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BB30FA2C-DE05-43FB-B093-84308F10E4DB',2626,'Lv Cu 4 core PVCSWA and ECC','Lv Cu 4 core PVCSWA and ECC-240 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('73694E6C-C665-4212-BE95-C3F40547FFB8',2627,'Lv Cu 4 core PVCSWA and ECC','Lv Cu 4 core PVCSWA and ECC-185 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('810A3166-A5D6-438C-9B41-5EFD7149EAD3',2628,'Lv Cu 4 core PVCSWA and ECC','Lv Cu 4 core PVCSWA and ECC-50 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('457EBE24-B8D8-4E0F-A87A-D6E8E22A8014',2629,'Lv Cu 4 core PVCSWA and ECC','Lv Cu 4 core PVCSWA and ECC-25 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5E5EC990-9564-41DB-A1C3-65E590D57B1F',2630,'Lv Cu single core PVC','Lv Cu single core PVC-400 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EDBC60C9-B760-481B-A2E4-F9987EA58A33',2631,'Lv Al 4 core PVCSWA and ECC','Lv Al 4 core PVCSWA and ECC-120 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4A81CAAE-DEBC-4C55-A7F6-9024A8D7BCFE',2632,'Lv Al 4 core PVCSWA and ECC','Lv Al 4 core PVCSWA and ECC-240 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ACC5CB7C-BE57-45CE-88E4-2BC9FD2663C5',2633,'Lv Al single core PVC','Lv Al single core PVC-400 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ED193C8A-9276-4849-85B1-E7F84C57A660',2634,'Lv Al 4 core PVCSWA and ECC','Lv Al 4 core PVCSWA and ECC-25 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7B77B5BE-6CFA-4C7F-B527-FDB96E1A409E',2635,'Lv Al 4 core PVCSWA','Lv Al 4 core PVCSWA-6 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AA6837A4-60A7-4D29-85EE-7B40F83F2CFF',2636,'Lv Al 4 core PVCSWA and ECC','Lv Al 4 core PVCSWA and ECC-185 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CDAC4697-88F9-4283-B160-F6DA175A8206',2637,'Lv Al single core PVC','Lv Al single core PVC-35 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B1582F57-3D3D-4F61-ADBC-413EB3A87F2E',2638,'Lv Al 4 core PVC','Lv Al 4 core PVC-70 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FF9EA0D0-D132-4D6F-8B3A-05EE9F3CF482',2639,'Lv Al single core PVC','Lv Al single core PVC-120 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('02C39B9F-4003-4D1A-9577-64E7B8CAAC0B',2640,'Lv Al 4 core PVC','Lv Al 4 core PVC-50 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A09F4EBB-981B-48B4-9350-7BDD0D91FC27',2641,'Lv Al single core PVC','Lv Al single core PVC-70 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B341029B-5D2E-43F6-947E-998E38140BE8',2642,'Lv Al 4 core PVC','Lv Al 4 core PVC-150 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4612DCB0-9AC9-4DBF-A3CD-144E4A2D03A2',2643,'Lv Al 4 core PVCSWA and ECC','Lv Al 4 core PVCSWA and ECC-35 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F0433418-42E7-4C2D-8F33-3895C7B3AED8',2644,'Lv Al 4 core PVC','Lv Al 4 core PVC-240 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A6A4D141-F756-4FE2-9FA1-7A5992D8919B',2645,'Lv Al 4 core PVC','Lv Al 4 core PVC-95 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FBA36F79-0CF3-4969-9FDB-0A1CE19FB5BC',2646,'Lv Al 4 core PVCSWA','Lv Al 4 core PVCSWA-10 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('779141C4-2A89-4996-85DA-348D49BCA83A',2647,'Lv Al 4 core PVC','Lv Al 4 core PVC-185 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('91819D59-0916-4CFD-A516-C821A1A47B56',2648,'Lv Al single core PVC','Lv Al single core PVC-25 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0F291EEC-A0B9-4CB0-9402-14475CC29048',2649,'Lv Al 4 core PVCSWA','Lv Al 4 core PVCSWA-16 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1408F35C-72D3-4CC8-905A-878C5AD2FBC4',2650,'Lv Al 4 core PVCSWA and ECC','Lv Al 4 core PVCSWA and ECC-50 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('76ACA822-B6F7-4A98-BEA2-B7DC3F1EC16C',2651,'Lv Al 4 core PVCSWA','Lv Al 4 core PVCSWA-25 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B622FEAA-0EC2-40DD-96E0-A7430B66B0D3',2652,'Lv Al 3 core PVCSWA','Lv Al 3 core PVCSWA-16 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0628FA34-59BE-4C35-A364-01BC630B1DBC',2653,'Lv Cu 3 core PVCSWA','Lv Cu 3 core PVCSWA-16 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BCA86196-D1DD-402E-AA40-9365C17E02E3',2654,'Lv Al 3 core PVCSWA','Lv Al 3 core PVCSWA-25 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ACC674DA-2B19-43BA-BA87-B5EEF51C4DE3',2655,'Lv Cu 3 core PVCSWA','Lv Cu 3 core PVCSWA-25 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E3E508F6-478D-4B4D-B373-C0113B850F21',2656,'Lv Cu 4 core PVCSWA','Lv Cu 4 core PVCSWA-4 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DD021B67-8737-46D0-A517-612831F83C4F',2657,'Lv Al 4 core PVCSWA','Lv Al 4 core PVCSWA-4 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('48F7E33F-D335-47A1-8E42-51897E3B020F',2658,'Lv Cu 3 core PVCSWA','Lv Cu 3 core PVCSWA-10 sq mm---','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('86D1D1A1-26A0-4E69-BE13-51C1C780965B',2659,'Load control master station - injection','Load control master station - injection----','20','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CD325CB8-B72B-4D12-8242-C5AB6EB99E12',2660,'Load control master station - radio','Load control master station - radio----','20','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D0286DD8-DFE7-4802-AE9B-84CB15803A2E',2661,'Lining - landfill','Lining - landfill----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3E7F3482-CABF-4AED-A008-603A1E87AB2B',2662,'Lightning mast and shield wiring','Lightning mast and shield wiring----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6CEEED95-4852-475E-8A6E-7C89BF06C78D',2663,'Lifts','Lifts---No of floors-','30','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DD3AB5DD-D877-4793-A5C7-2118493A5597',2664,'Parcel Lifts','Parcel Lifts---No of floors-','15','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D7DCED1D-F767-4D1B-B2CA-69C87DC0DD55',2665,'Wheelchair Lift','Wheelchair Lift---No of floors-','15','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('805E5B24-D179-4C03-996B-95A87134E11A',2666,'Flower beds, shrubs & trees','Flower beds, shrubs & trees----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('09B19B8F-DEAA-4681-825D-DA48F2D18B59',2667,'Lawns','Lawns----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('32239F2A-CD5C-4919-9219-52E00ECDFAC4',2668,'Landfill restored area','Landfill restored area----','100','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BF0D811B-ACB2-432A-ADDB-EF59E40E3882',2669,'Ticket Booth','Ticket Booth----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DD6398FA-85D7-45DD-B6A7-BD0D11B5F400',2670,'Kerb Inlet','Kerb Inlet----','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DBB2EE5F-4574-45BD-92D4-D957E48AE541',2671,'Barrier kerb','Barrier kerb----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('38CF0841-E38F-47A3-B741-491503407E3C',2672,'Mountable kerb','Mountable kerb----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7B091F16-4075-4D0B-8401-600DF3EC2265',2673,'Jukskei court','Jukskei court----','15','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DC3113CE-0926-41FE-BD00-437DCB9B1768',2674,'Automatic sprinkler system','Automatic sprinkler system----','10','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CD7DFC31-73CF-4D58-B53B-B6E43F76C3AD',2675,'Screen fine drum','Screen fine drum----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A0F5F0ED-932F-4C8F-AEF0-4D70F3275600',2676,'Screen Course','Screen Course----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AFD2EA85-9D3D-4295-8909-E016C24DF15C',2677,'Screen/Wash Press','Screen/Wash Press----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5453315D-2386-49CA-9965-A85D5204451F',2678,'Grid Classifier','Grid Classifier----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AF5DD179-8EEE-4BE0-AD5B-BE2648194380',2679,'Incinerator','Incinerator----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('31C52D27-B0F7-4942-9E71-4CF6667B437C',2680,'Hydrant','Hydrant----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('43F1F487-11C0-486F-B554-220519203405',2681,'Transformer','Transformer-250 MVA-275/132kV--','50','0','','','275/132kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FA91DF85-E211-472B-AC28-B3BDEAF2549B',2682,'Transformer','Transformer-250 MVA-400/132kV--','50','0','','','400/132kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('568F76F8-F58C-40F7-9794-6996542BB30E',2683,'Transformer','Transformer-5 MVA-22/11kV--','50','0','','','22/11kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B38E67E9-5BA9-460F-9378-C77F579AED9D',2684,'Transformer','Transformer-5 MVA-33/11kV--','50','0','','','33/11kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('64B1ABC7-1508-4F54-BC7D-1F4628BF078F',2685,'Transformer','Transformer-10 MVA-22/11kV--','50','0','','','22/11kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('07FA2119-327A-4DEF-B978-7485188CE152',2686,'Transformer','Transformer-10 MVA-33/11kV--','50','0','','','33/11kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6BD4989A-D056-4B0B-A773-841391239B49',2687,'Transformer','Transformer-20 MVA-132/11kV--','50','0','','','132/11kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0274FEE8-44C0-4AAB-8364-E7E97A2C5D2B',2688,'Transformer','Transformer-30 MVA-275/132kV--','50','0','','','275/132kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('741F07B2-1562-4DBF-A776-9C23EFA8C4D8',2689,'Transformer','Transformer-30 MVA-400/132kV--','50','0','','','400/132kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('38DBA9AC-065B-4F45-984C-1D8E8808CC3F',2690,'Transformer','Transformer-35 MVA-132/11kV--','50','0','','','132/11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DA8D039E-5863-47ED-A043-4BF28D414AFD',2691,'Transformer','Transformer-40 MVA-132/11kV--','50','0','','','132/11kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8F7EF225-171E-4027-BE83-3EFAAC7FE8D0',2692,'Transformer','Transformer-75 MVA-132/11kV--','50','0','','','132/11kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7FADBF9F-EBD3-4F00-814A-8AA4E4076E62',2693,'Transformer','Transformer-75 MVA-132/22kV--','50','0','','','132/22kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5D91EBC6-4D0F-4F05-98CD-3FA0A7BA5BF9',2694,'Transformer','Transformer-75 MVA-132/33kV--','50','0','','','132/33kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('17465B09-C958-4752-9BAC-D7F8B20A9200',2695,'Transformer','Transformer-140 MVA-275/33kV--','50','0','','','275/33kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C18C4F8E-9210-4C4F-A9BB-2CA392A45BB5',2696,'Transformer','Transformer-315 MVA-400/132kV--','50','0','','','400/132kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9BC1B4AE-FF4A-4D4B-94BB-BF15E1720E1B',2697,'Transformer','Transformer-120 MVA-132/11kV--','50','0','','','132/11kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D1440C76-BE6F-4B77-9F92-54DDA8FA716F',2698,'Transformer','Transformer-45 MVA-132/33kV--','50','0','','','132/33kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('82681F40-31F4-4206-92AF-F6CADF30F6DB',2699,'Transformer','Transformer-80 MVA-132/33kV--','50','0','','','132/33kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0EB13DE9-75D1-431D-B10E-0D3F79EA2EF9',2700,'Transformer','Transformer-50 MVA-132/88/11kV--','50','0','','','132/88/11kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('86FB9D34-C3A0-49AC-9505-2ACB3F4700A7',2701,'Transformer','Transformer-45 MVA-132/11kV--','50','0','','','132/11kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6CA94A7F-F8BC-43AA-A9DC-929B16339D2C',2702,'Transformer','Transformer-40 MVA-132/66/22kV--','50','0','','','132/66/22kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DA96B75F-4BF8-440E-91B7-FC26B745BB03',2703,'Transformer','Transformer-40 MVA-132/33kV--','50','0','','','132/33kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5FC4F60B-09C6-47CC-9EEB-C4CA822B6BD4',2704,'Transformer','Transformer-315 MVA-400/88/22kV--','50','0','','','400/88/22kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('072E7BDB-9151-4EE6-8124-3AB8D1697B4D',2705,'Transformer','Transformer-30 MVA-33/11kV--','50','0','','','33/11kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('342DE7C9-01EF-48FA-A3FC-EA6AE45F6570',2706,'Transformer','Transformer-30 MVA-132/11kV--','50','0','','','132/11kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ADCA13A0-8269-4930-BB1F-BA91D6AC33F4',2707,'Transformer','Transformer-20 MVA-88/11kV--','50','0','','','88/11kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6E2AD530-53E3-40F2-A274-EAACCF523D01',2708,'Transformer','Transformer-20 MVA-33/11kV--','50','0','','','33/11kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A4B916C6-31B5-4A57-B48C-FF8F48CB2C01',2709,'Transformer','Transformer-20 MVA-132/88/11kV--','50','0','','','132/88/11kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('025AFF04-5C39-4387-9F3B-DF39E75987BF',2710,'Transformer','Transformer-80 MVA-88/33kV--','50','0','','','88/33kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F2A3F67A-7664-473C-B33B-E7844F76176A',2711,'Concrete pole','Concrete pole----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DF1048C0-8BC1-4962-A572-00B322245039',2712,'Steel lattice tower','Steel lattice tower----','50','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A60C4511-0181-4FDB-89E3-7D698BFAA93F',2713,'Wooden pole','Wooden pole----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B585A99D-7DF5-4DCC-8A9A-260F79241EF7',2714,'TWIN CONDUCTOR DOUBLE CIRCUIT TOWER','TWIN CONDUCTOR DOUBLE CIRCUIT TOWER----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3F370A2B-F7C4-4E09-99B2-DD946BCD7B43',2715,'TWIN CONDUCTOR DOUBLE CIRCUIT TOWER 30 BEND','TWIN CONDUCTOR DOUBLE CIRCUIT TOWER 30 BEND----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DAA00305-B16E-43C1-B22C-9F6EE4705D0D',2716,'TWIN CONDUCTOR DOUBLE CIRCUIT 60 BEND','TWIN CONDUCTOR DOUBLE CIRCUIT 60 BEND----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5E8D7DDE-CB43-4E53-95B8-9EEBC5ED37B1',2717,'TWIN CONDUCTOR DOUBLE CIRCUIT TOWER 90 BEND','TWIN CONDUCTOR DOUBLE CIRCUIT TOWER 90 BEND----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0F22B46C-C639-447F-8959-4FB50E7D81D6',2718,'SINGLE CONDUCTOR DOUBLE CIRCUIT TOWER','SINGLE CONDUCTOR DOUBLE CIRCUIT TOWER----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('729BFEB2-BDCA-4596-BEFD-0224F67C2BDC',2719,'SINGLE CONDUCTOR DOUBLE CIRCUIT TOWER 30 BEND','SINGLE CONDUCTOR DOUBLE CIRCUIT TOWER 30 BEND----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('156CEAE8-9721-44FF-B03F-B4D4AFB9518C',2720,'SINGLE CONDUCTOR DOUBLE CIRCUIT 60 BEND','SINGLE CONDUCTOR DOUBLE CIRCUIT 60 BEND----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9563DCCC-877D-44A2-87B8-7306F4D9D933',2721,'SINGLE CONDUCTOR DOUBLE CIRCUIT TOWER 90 BEND','SINGLE CONDUCTOR DOUBLE CIRCUIT TOWER 90 BEND----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D139E1CA-63FA-44B6-9291-FBE011A2E35F',2722,'Monopole pole','Monopole pole----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('746AF215-55AC-4E8D-9988-95C5FD3CA203',2723,'TWIN CONDUCTOR DOUBLE CIRCUIT TERMINAL TOWER','TWIN CONDUCTOR DOUBLE CIRCUIT TERMINAL TOWER----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('83B4B27F-4968-4499-BB42-BA7DCC1EA6E4',2724,'SINGLE CONDUCTOR DOUBLE CIRCUIT TERMINAL TOWER 90 BEND','SINGLE CONDUCTOR DOUBLE CIRCUIT TERMINAL TOWER 90 BEND----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5ABBEC2E-C4C0-4723-B463-2A5620A3D769',2725,'SINGLE CONDUCTOR DOUBLE CIRCUIT TERMINAL TOWER','SINGLE CONDUCTOR DOUBLE CIRCUIT TERMINAL TOWER----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('606793A3-3942-4294-B207-1C24DC52EC7A',2726,'TWIN CONDUCTOR DOUBLE CIRCUIT TERMINAL TOWER 90 BEND','TWIN CONDUCTOR DOUBLE CIRCUIT TERMINAL TOWER 90 BEND----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C66E656D-780B-4708-B3AB-46B22F6D0CB6',2727,'Twin Bear','Twin Bear----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EB72679B-5A64-4A86-A0E7-BD9A7482F178',2728,'Twin Fox','Twin Fox----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6A145583-F3B6-475B-BD7E-00FEBF67F503',2729,'Twin Bull','Twin Bull----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C8228662-A9F4-49A0-ACB1-FDD11B020542',2730,'Twin Hare','Twin Hare----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('510D769A-47BC-4696-B222-D625423AE787',2731,'Twin Pelican','Twin Pelican----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C35BF8E0-BAE5-4774-82F1-A2E9B3D3479A',2732,'Twin Wolf','Twin Wolf----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2F6EBA29-8DA4-4390-A919-5FE5D5848F38',2733,'Twin Rabbit','Twin Rabbit----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FD9A4BB3-A878-4CAA-AC6E-088B7797D611',2734,'Quad Bear','Quad Bear----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E0776B3B-FABA-4762-988F-ED01F7751E9C',2735,'Bull','Bull----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8967A40D-EB10-4538-BEFF-317CAEB4DB81',2736,'Outdoor','Outdoor-2000 A-33kV--','50','0','','','33kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2C96AFD5-2662-4A23-B6B6-065A31DA96DB',2737,'Outdoor hand operated','Outdoor hand operated-2000 A-132kV--','50','0','','','132kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D76A17C2-295F-4212-9162-0EBEC5E37526',2738,'Outdoor hand operated','Outdoor hand operated-2000 A-88kV--','50','0','','','88kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DFF5CF4B-8BFE-4EE9-AC48-3E962C520682',2739,'Outdoor hand operated','Outdoor hand operated-3000 A-132kV--','50','0','','','132kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C26D02DD-F191-464C-8225-65C659515C0E',2740,'Outdoor motorised','Outdoor motorised-1600 A-132kV--','50','0','','','132kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F347470A-07C9-4407-9046-AF1F8B3EF0F1',2741,'Outdoor motorised','Outdoor motorised-1600 A-275kV--','50','0','','','275kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('88E04D5E-EECA-4CB1-8EC9-581AB3B21D0F',2742,'Outdoor motorised','Outdoor motorised-2000 A-132kV--','50','0','','','132kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F097485D-EEA2-4C3B-8CAB-728BF2F20495',2743,'Outdoor motorised','Outdoor motorised-2000 A-88kV--','50','0','','','88kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6850AB60-A468-4D95-A886-902544010091',2744,'Outdoor motorised','Outdoor motorised-3000 A-132kV--','50','0','','','132kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('62FEA767-447D-4876-81E0-05E352EBDA01',2745,'Outdoor motorised','Outdoor motorised-3000 A-275kV--','50','0','','','275kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('53EC8764-050E-49FE-8084-1422837FF2D8',2746,'Outdoor motorised - ais pantograph','Outdoor motorised - ais pantograph-2000 A-132kV--','50','0','','','132kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('10F0DD99-CC56-488F-925A-61DF9752A7A7',2747,'Outdoor motorised - ais pantograph','Outdoor motorised - ais pantograph-2000 A-275kV--','50','0','','','275kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EA3FEBE9-7128-47E4-9476-2F7F9770BB79',2748,'Outdoor motorised - ais pantograph','Outdoor motorised - ais pantograph-2000 A-88kV--','50','0','','','88kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('506C3583-9F4A-4A05-8E43-F4E96E87EBED',2749,'Outdoor hand operated','Outdoor hand operated-2000 A-400kV--','50','0','','','400kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6EFA9619-7C55-4CF4-BCBA-8EDEA2AAFBA7',2750,'Outdoor motorised - ais pantograph','Outdoor motorised - ais pantograph-2000 A-400kV--','50','0','','','400kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D064E55F-6DB5-486F-8846-D2625A5D0BEF',2751,'Outdoor motorised','Outdoor motorised-1600 A-400kV--','50','0','','','400kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E3796A63-8F10-4232-A824-63900068CC1D',2752,'Outdoor','Outdoor-2000 A-400kV--','50','0','','','400kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0E52FB7C-E56B-423B-ACD5-ACF0B244CA9C',2753,'Indoor','Indoor-2000 A-400kV--','50','0','','','400kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1ECC891A-EC46-4193-9E00-55E6F78D500C',2754,'Outdoor hand operated','Outdoor hand operated-1250 A-132kV--','50','0','','','132kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1C283186-0193-4136-B010-15FA2299DEE8',2755,'Outdoor motorised - ais pantograph','Outdoor motorised - ais pantograph-1250 A-132kV--','50','0','','','132kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7378BC83-BEDF-46A7-9D67-924B30EE26B5',2756,'Outdoor motorised','Outdoor motorised-2500 A-132kV--','50','0','','','132kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('528B455F-00B8-4CEA-8E2D-00DDDB015795',2757,'Earth switches','Earth switches--132kV--','50','0','','','132kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('11CA760A-6064-4395-A3C5-76477032AE60',2758,'Earth switches','Earth switches--275kV--','50','0','','','275kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A90AE1BA-9905-4172-BBE1-6FBAFCFC42A9',2759,'Earth switches','Earth switches--88kV--','50','0','','','88kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B108F5BE-A336-4B0F-935A-477CB18A3A98',2760,'Earth switches','Earth switches--400kV--','50','0','','','400kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F8ACF6CA-ADF9-4548-8C3B-B39A0D1B9A32',2761,'Outdoor','Outdoor-400 A-88kV--','50','0','','','88kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('82CA96DF-0D49-49BE-8AFB-5DF7213D696C',2762,'Outdoor','Outdoor-500 A-33kV--','50','0','','','33kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E74D486D-5F2A-46A4-9365-039A21735A1F',2763,'Outdoor','Outdoor-800 A-88kV--','50','0','','','88kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3FEB9220-BCD7-493F-9B87-7F3C81429C7C',2764,'Outdoor','Outdoor-1000 A-33kV--','50','0','','','33kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B11DD570-B5A7-4784-B4D9-49851487EA89',2765,'Outdoor','Outdoor-1000 A-88kV--','50','0','','','88kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B051A6CC-A7E1-4980-98B1-09990416B19E',2766,'Outdoor','Outdoor-1600 A-132kV--','50','0','','','132kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9AAB2C68-E116-448B-B77F-CC517A657BD3',2767,'Outdoor','Outdoor-1600 A-275kV--','50','0','','','275kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F5F0F7A2-3CE4-4151-BA9F-E529A4040A62',2768,'Outdoor','Outdoor-1600 A-33kV--','50','0','','','33kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('64359522-A209-46B3-924A-78BA5EFB4A03',2769,'Outdoor','Outdoor-1600 A-88kV--','50','0','','','88kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4FCC3343-620A-452A-ABC9-6F1B55D11629',2770,'Outdoor','Outdoor-2000 A-132kV--','50','0','','','132kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2060BE75-177B-4D15-BC5F-414C2517580A',2771,'Outdoor','Outdoor-2000 A-275kV--','50','0','','','275kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('06BB910E-763A-462D-BCC8-0B5EDA5345EE',2772,'Outdoor','Outdoor-2500 A-132kV--','50','0','','','132kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('422DE0A9-1ABD-41A2-AA00-477379481ABB',2773,'Outdoor','Outdoor-2500 A-275kV--','50','0','','','275kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('37E4CC36-15A9-4201-952F-BBD408234FAD',2774,'Outdoor','Outdoor-2500 A-33kV--','50','0','','','33kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('564F0E46-1783-4BBC-A2AE-E6845E3A447D',2775,'Outdoor','Outdoor-2500 A-88kV--','50','0','','','88kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('27FD4DCF-0DF3-4FC6-8809-0B5AB66B73A7',2776,'Outdoor','Outdoor-3000 A-132kV--','50','0','','','132kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2DB17A65-1450-4C02-B060-5072204C9607',2777,'Outdoor','Outdoor-3000 A-275kV--','50','0','','','275kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4ADFC75C-149D-4DB3-8369-07FA765427C4',2778,'Outdoor','Outdoor-3500 A-132kV--','50','0','','','132kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('78A3425A-496F-44F1-8297-8493B2BDA835',2779,'Outdoor','Outdoor-400 A-33kV--','50','0','','','33kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1727DB1D-921C-4003-8D26-2FDE27559FD1',2780,'Outdoor','Outdoor-3150 A-132kV--','50','0','','','132kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('81D2980E-75C1-48EF-B58A-FE7B3CF5CFA4',2781,'HV Al pilc three core','HV Al pilc three core-300 sq mm-33kV--','50','0','','','33kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('379D43A9-D2FB-473E-B801-03A73525B361',2782,'HV Al xlpe single core','HV Al xlpe single core-350 sq mm-132kV--','50','0','','','132kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F355FE24-83AD-43F7-A327-9D12AD7F60C9',2783,'HV Al xlpe single core','HV Al xlpe single core-500 sq mm-132kV--','50','0','','','132kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1D0B5DD5-2E32-4ABC-B404-6C902B55F946',2784,'HV Al xlpe single core','HV Al xlpe single core-800 sq mm-132kV--','50','0','','','132kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AFEA8F97-FA48-4A90-970C-F0D332885C22',2785,'HV Al xlpe single core','HV Al xlpe single core-1000 sq mm-132kV--','50','0','','','132kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3ECFA799-CC46-4DD9-B2E3-B3F69F011424',2786,'HV Cu pilc three core','HV Cu pilc three core-70 sq mm-33kV--','50','0','','','33kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1179C5C3-BCE0-4794-9F50-943116F37DEC',2787,'HV Cu pilc three core','HV Cu pilc three core-185 sq mm-33kV--','50','0','','','33kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('36ED56CA-61A2-4457-8DAC-6FA9382642EA',2788,'HV Cu pilc three core','HV Cu pilc three core-240 sq mm-33kV--','50','0','','','33kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7638D96A-EE14-4FFD-ACD4-717F77AD5556',2789,'HV Cu pilc three core','HV Cu pilc three core-300 sq mm-33kV--','50','0','','','33kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('39D39C74-A147-46CE-BE5D-3D6903412A73',2790,'HV Cu xlpe single core','HV Cu xlpe single core-630 sq mm-33kV--','50','0','','','33kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EC1C642A-B1F9-4FB1-ABB6-623FAC03F3C5',2791,'HV Cu xlpe three core','HV Cu xlpe three core-120 sq mm-33kV--','50','0','','','33kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('23EFA8E2-6A5B-4053-B83D-1CA00AF4137C',2792,'Hv Cu oil cooled single core cable','Hv Cu oil cooled single core cable-70 sq mm-33kV--','50','0','','','33kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C7935708-014A-4C8A-9F75-CC6A9189C575',2793,'Hv Cu oil cooled single core cable','Hv Cu oil cooled single core cable-150 sq mm-33kV--','50','0','','','33kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('32352F5E-9ABF-4895-8871-75A192C13E6E',2794,'Hv Cu oil cooled single core cable','Hv Cu oil cooled single core cable-150 sq mm-132kV--','50','0','','','132kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('27E6CAD0-2DB9-4F54-B42D-9F998F860DCB',2795,'Hv Cu oil cooled single core cable','Hv Cu oil cooled single core cable-240 sq mm-33kV--','50','0','','','33kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B10101C0-7D1E-41A7-A3A9-A78127272B8E',2796,'Hv Cu oil cooled single core cable','Hv Cu oil cooled single core cable-240 sq mm-132kV--','50','0','','','132kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CFFB9697-C0C9-4A3D-AEB8-213D1F6088E8',2797,'Hv Cu oil cooled single core cable','Hv Cu oil cooled single core cable-400 sq mm-33kV--','50','0','','','33kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F72CD8FD-A0F2-4729-8DFD-F21D4293BBDF',2798,'Hv Cu oil cooled single core cable','Hv Cu oil cooled single core cable-400 sq mm-132kV--','50','0','','','132kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C44FB3CB-E2A1-4A93-A608-D0F8F7C67986',2799,'Hv Cu single core xlpe cable','Hv Cu single core xlpe cable-150 sq mm-33kV--','50','0','','','33kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1FCBDDFE-C5C8-4250-B927-731CDDD46944',2800,'Hv Cu single core xlpe cable','Hv Cu single core xlpe cable-150 sq mm-132kV--','50','0','','','132kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('10EA9D9A-E793-4934-A558-A7E739748A10',2801,'Hv Cu single core xlpe cable','Hv Cu single core xlpe cable-240 sq mm-33kV--','50','0','','','33kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5569609F-DDCD-4EC0-85C4-5B7FCFAD864D',2802,'Hv Cu single core xlpe cable','Hv Cu single core xlpe cable-240 sq mm-132kV--','50','0','','','132kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FDC39874-5B11-4595-97D8-D2D77D3D99E6',2803,'Hv Cu single core xlpe cable','Hv Cu single core xlpe cable-400 sq mm-33kV--','50','0','','','33kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DED84AA9-C8C6-4808-A020-B6C898B6381A',2804,'Hv Cu single core xlpe cable','Hv Cu single core xlpe cable-400 sq mm-132kV--','50','0','','','132kV','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('315D1BB4-F43C-4DC4-A895-EE33D60EBBD5',2805,'Hv Al oil cooled cable','Hv Al oil cooled cable-150 sq mm-33kV--','50','0','','','33kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A884D42C-2E82-47A2-A627-91AFE4973184',2806,'Hv Al oil cooled cable','Hv Al oil cooled cable-150 sq mm-132kV--','50','0','','','132kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C0D58DE2-8998-4F71-9B09-00398CAFA347',2807,'Hv Al oil cooled cable','Hv Al oil cooled cable-240 sq mm-33kV--','50','0','','','33kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B543AA03-2EEF-4360-87C5-85CE307F020A',2808,'Hv Al oil cooled cable','Hv Al oil cooled cable-240 sq mm-132kV--','50','0','','','132kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F505129E-26AE-4C4E-BFEB-21C0C3AB7A97',2809,'Hv Al oil cooled cable','Hv Al oil cooled cable-400 sq mm-33kV--','50','0','','','33kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4F00CAAA-ADA3-43AA-A6A9-7BC1FF4B49E2',2810,'Hv Al oil cooled cable','Hv Al oil cooled cable-400 sq mm-132kV--','50','0','','','132kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('487B11AA-F54F-4F56-B869-DACE8E970643',2811,'Hv Al oil cooled cable','Hv Al oil cooled cable-70 sq mm-33kV--','50','0','','','33kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2070BC83-499C-4398-A39C-150DD0884774',2812,'Hv Al single core xlpe cable','Hv Al single core xlpe cable-150 sq mm-33kV--','50','0','','','33kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('513F82FF-9FF0-4E73-A3A2-BE1964ADBF52',2813,'Hv Al single core xlpe cable','Hv Al single core xlpe cable-150 sq mm-132kV--','50','0','','','132kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('131E6F99-A55A-4D45-9071-2E5B9D3344AB',2814,'Hv Al single core xlpe cable','Hv Al single core xlpe cable-240 sq mm-33kV--','50','0','','','33kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C59E5B82-204F-4D98-89C1-0EC66A78D40C',2815,'Hv Al single core xlpe cable','Hv Al single core xlpe cable-240 sq mm-132kV--','50','0','','','132kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B8E3ADCB-E987-4B10-86A2-35C61E286011',2816,'Hv Al single core xlpe cable','Hv Al single core xlpe cable-400 sq mm-33kV--','50','0','','','33kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D9ECC5C6-1ADF-4E30-979A-A0E66C044F19',2817,'Hv Al single core xlpe cable','Hv Al single core xlpe cable-400 sq mm-132kV--','50','0','','','132kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('557F1170-82A4-4FD5-8D31-4411FC1D7979',2818,'HV Cu xlpe single core','HV Cu xlpe single core-1000 sq mm-132kV--','50','0','','','132kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('856FE5BB-4E8D-4692-A9EA-B7A4E57E61B5',2819,'Hv Cu oil cooled single core cable','Hv Cu oil cooled single core cable-300 sq mm-132kV--','50','0','','','132kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6CCDD034-5E62-46E3-8CC9-CA854282AAF2',2820,'HV Cu xlpe single core','HV Cu xlpe single core-300 sq mm-132kV--','50','0','','','132kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('66E0AE7F-D032-4F2B-87DC-0DCA6D094C83',2821,'Busbar Outdoor','Busbar Outdoor--132kV--','60','0','','','132kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('46EF1AA7-259D-4700-A20A-7A68E03C63C9',2852,'Busbar Outdoor','Busbar Outdoor--400kV--','60','0','','','400kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CF0CE8D2-AFEA-4764-8582-FE12C07584A7',2853,'Busbar Outdoor','Busbar Outdoor--33kV--','60','0','','','33kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('13D724F4-E16D-45E1-B38B-83A3E9398357',2854,'Busbar Outdoor','Busbar Outdoor--88kV--','60','0','','','88kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('30ED6E58-C070-46A2-9484-79A14B6F2C3E',2855,'Busbar Outdoor','Busbar Outdoor--275kV--','60','0','','','275kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F49AB144-3E06-43DD-ABA1-6B432657218C',2856,'Busbar Outdoor','Busbar Outdoor--66kV--','60','0','','','66kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('56F0D099-7A30-4707-BC66-5DF78C5E92D5',2857,'Busbar Indoor','Busbar Indoor--132kV--','60','0','','','132kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EEE95EE0-EA7B-418A-85C8-3BA9F353A8DB',2858,'Busbar Indoor','Busbar Indoor--33kV--','60','0','','','33kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E09C6E05-2DB3-4256-9CC9-BC40DCBBADDD',2859,'Hopper','Hopper----','45','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D33DDFC0-A1FC-4255-AD6F-92EE0B777F9E',2860,'High mast','High mast-25---height (m)','45','0','25','height (m)','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('31619350-C445-41CA-9EDD-62A87929038C',2861,'High mast','High mast-40---height (m)','45','0','40','height (m)','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A26F6042-4E18-49BD-89A4-7F4678602CDB',2862,'Solar powered High mast','Solar powered High mast-25---height (m)','45','0','25','height (m)','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AAFB6958-6009-4519-9FB6-552561665688',2863,'High mast','High mast-15---height (m)','45','0','15','height (m)','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BFD141F6-46A2-4447-99BB-5C201D7F0EFA',2864,'High mast','High mast-35---height (m)','45','0','35','height (m)','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4B7767C6-9CAA-493C-B5A7-FE14A0B6A366',2865,'High mast','High mast-30---height (m)','45','0','30','height (m)','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('03BFF165-5E35-47B4-BB56-DF9893CC6BB6',2866,'Heated Bitumen Storage','Heated Bitumen Storage---volume (kl)-','30','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('81D86532-F3DE-4C3A-91A4-3A892454287E',2867,'Heat Exchanger','Heat Exchanger----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0232822E-181C-4ADD-B3FD-AAEC2D26CD57',2868,'Handrail','Handrail----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EEE3AC4A-3FB8-4F7F-85FF-76D648C3F4EF',2869,'Armco','Armco----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1A9827C2-8A28-4D93-BAC7-6FC0523E9A97',2870,'Cable','Cable----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('408D74A6-C35F-452B-BEEC-CC21005B45C4',2871,'Grid Inlet','Grid Inlet----','30','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5A785853-FCAA-4289-8DD7-206DF6B34DB8',2872,'Glass','Glass----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6543F90C-7CEF-4AC6-AD17-019BE72C8E78',2873,'Shade netting','Shade netting----','10','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F0D5A837-3468-4D65-B274-6C30BB4B32BC',2874,'Plastic','Plastic----','10','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EEFB5147-BA98-4D2B-B5F7-7D6018D4C439',2875,'Gps devices','Gps devices----','3','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6AEAE1B0-627B-49D6-ABEA-0069DA8D589A',2876,'Mache','Mache-9---holes','50','0','9','holes','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4EFDE889-6DA1-419D-A5DA-5FB3E51143DC',2877,'Municipal','Municipal-9---holes','50','0','9','holes','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1B4C2811-89C3-45F4-BB0E-47CCF521FF86',2878,'Municipal','Municipal-18---holes','50','0','18','holes','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A5215EBC-F837-4803-8A46-4E005FBAEA7E',2879,'Indoor gis bays','Indoor gis bays-3000 A-132kV--','50','0','','','132kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0FF4289F-B10C-4A14-9163-3DB72084D2B2',2880,'Indoor gis bays','Indoor gis bays-3000 A-275kV--','50','0','','','275kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('30D288B5-1336-4369-8493-6BF8CDF2BBD1',2881,'Indoor gis bays','Indoor gis bays-3000 A-33kV--','50','0','','','33kV','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8A66B956-7377-49A8-95B4-30A35A27FF6C',2882,'Indoor gis bays','Indoor gis bays-3000 A-88kV--','50','0','','','88kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B2A910AB-E36C-481D-91C7-FCCE15DBA21B',2883,'Gis bus ducting','Gis bus ducting-3000 A-132kV--','50','0','','','132kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5CEBF4FD-9765-475A-A03A-68D629ADA9DD',2884,'Gis bus ducting','Gis bus ducting-3000 A-33kV--','50','0','','','33kV','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('28117CAD-2265-48AC-B739-D12F2E6ED466',2885,'Copper bar','Copper bar-1000 A-11kV--','60','0','','','11kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3F69D436-5890-47AC-B486-6C21D15BEE64',2886,'Copper bar','Copper bar-1000 A-33kV--','60','0','','','33kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('155DE8BA-C97B-4F62-A0C1-C510C9C08D8D',2887,'Copper bar','Copper bar-1000 A-6.6kV--','60','0','','','6.6kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D8FDA34C-1910-4931-B6A1-1D5ABD452722',2888,'Strung conductor (m)','Strung conductor (m)-1000 A-33kV--','60','0','','','33kV','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EF7CA39B-C439-426C-8E03-6299C8E78B67',2889,'Tubular conductor','Tubular conductor-3000 A-33kV--','50','0','','','33kV','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7F97C10A-E4EA-493C-A6E9-BC25B7FB3CF4',2890,'DC/AC Inverter','DC/AC Inverter-11---kW','10','0','11','kW','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D06BDD2C-E859-47B2-B2BF-4958DFC1AB56',2891,'Gas Chiller - Bio Generation','Gas Chiller - Bio Generation-2000---m3/h','15','0','2000','m3/h','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F1D6950C-3BC7-4BAF-9135-80C80E30A357',2892,'Gas turbine - Bio Generation','Gas turbine - Bio Generation-1---MW','20','0','1','MW','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DF162A47-E9F1-4D72-A040-5E75320F3CDF',2893,'Petrol or diesel','Petrol or diesel-Bigger than 10---kW','20','0','','kW','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('59BA4532-6049-459B-80C1-DD8D734D8E94',2894,'Petrol or diesel','Petrol or diesel-1 to 10---kW','20','0','','kW','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8A01A190-AD6E-4379-8F46-188E7083F274',2895,'PV Panels - Solar','PV Panels - Solar-230 W---','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3514FCE2-4F7C-487A-8EEC-3406725C063A',2896,'Petrol or diesel','Petrol or diesel-110---kW','20','0','110','kW','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1BFA9DBE-7007-4382-8CF7-34C444D32785',2897,'Drive motor','Drive motor-6---kW','15','0','6','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1D941D16-F033-491A-AB89-5CCB1B2DE772',2898,'Drive motor','Drive motor-45---kW','15','0','45','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D8270DEE-C451-4D78-94C0-38F2E749A0CB',2899,'Drive motor','Drive motor-400---kW','15','0','400','kW','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('87A5E249-52E3-4308-8A65-4BD69604DCDC',2900,'Gasometer','Gasometer----','12','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2B739C1E-843B-48AF-9756-208CA82737D9',2901,'Fuel oil pumping system','Fuel oil pumping system----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FFAD60BD-D035-41CE-9B90-810DB08B7521',2902,'Fuel oil tanks','Fuel oil tanks----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('866D9BE2-8936-4BD4-A597-74B5919EE49A',2903,'Petrol Pump','Petrol Pump----','30','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('34DDFB98-C8CE-4545-B2F0-6C88CDB8DAFE',2904,'RC surface bed','RC surface bed----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B3C97D66-5DC3-429E-A8F6-E2B68ACE1BFA',2905,'Shuttered RC suspended floor slab','Shuttered RC suspended floor slab----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7912E471-1042-4976-BA35-32FF6B0C656D',2906,'DREDGER','DREDGER----','10','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('38B3E7B2-6A6D-4E12-8B3B-ABFD8896A16A',2907,'Flare stack','Flare stack----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4F1EAD49-D8CF-4084-B350-95050B822439',2908,'Firewall','Firewall----','3','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('447B7DC0-626A-4CDB-B717-F862F9653866',2909,'Extinguishers, hose reels only','Extinguishers, hose reels only----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8FC4876E-5B45-4ABC-804F-E0C7454C768D',2910,'Extinguishers, hose reels, full sprinkler system with booster pump','Extinguishers, hose reels, full sprinkler system with booster pump----','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('21565703-3101-43D0-A0FA-A5F9EE875DE1',2911,'Extinguishers, hose reels, limited sprinklers','Extinguishers, hose reels, limited sprinklers----','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F6C635E5-A6B2-4235-BDD6-1A45474749E7',2912,'Bathroom','Bathroom----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('678C6D3C-EA41-425A-B402-5E0DE1206840',2913,'Kitchen','Kitchen----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CD37143C-512C-44E4-8819-C46A54AD3F11',2914,'Office','Office----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2E9C3DD9-429B-43A0-B0FB-3541C6C19F65',2915,'Store','Store----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6FE8A282-013F-4F69-BEAD-06BA09953842',2916,'Workshop','Workshop----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C86CFA90-F8C2-43B0-8E36-472083A43E40',2917,'Civic centre / Community hall','Civic centre / Community hall----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('70729A59-8F08-4783-9B5F-BE89E85D6027',2918,'Clinics and day hospitals','Clinics and day hospitals----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('75B12B78-AD37-41AA-8E98-E0311AB18C22',2919,'Council chamber','Council chamber----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DCDBCBEF-1C7D-40EE-AC4F-C5BB8638DFD7',2920,'Executive office / Banquette hall','Executive office / Banquette hall----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6A51DCF1-C383-412B-A753-949BA06E7C71',2921,'Library','Library----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E33B0FA2-E14F-459B-A4A4-6CCAE816323B',2922,'Cold room','Cold room----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E97A12A8-4EDD-4FCE-A044-CAD83FF0B81D',2923,'Laboratory','Laboratory----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('332BE73B-3E51-43A9-86DD-FC2689C992A5',2924,'Multi mode','Multi mode----','25','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C0C12E41-0598-4DC5-AEFB-52B18D8E2E5B',2925,'Single mode','Single mode----','25','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5A16A35E-E114-41B8-A969-1DCA991AFBBA',2926,'FEEDER POLYELECTROLYTE','FEEDER POLYELECTROLYTE----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A688F39A-6BD3-483D-AB0C-2A382ACFC41C',2927,'Fan','Fan----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('524B7D60-55EE-486D-A807-ACB132490C72',2928,'Stairs','Stairs----','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DEE8AEE7-12D3-4104-B5E2-3AD4BD08F91D',2929,'Tank elevation structure','Tank elevation structure----','30','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EFA1163A-BE41-43FF-9526-B931D4D271AF',2930,'Walkways grid','Walkways grid----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7E3B0599-F530-4F63-80CF-47B6DD5BA670',2931,'Walkways including handrail','Walkways including handrail----','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('45441359-210B-4F13-972F-99ADBB9E3A35',2932,'Cooling tower','Cooling tower----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3B96E5AF-988A-4E7C-8F58-B1326C38E1B1',2933,'Beams','Beams----','20','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('57029C85-97F3-47AD-975F-2E061BFB444A',2934,'MECHANICAL BRIDGE','MECHANICAL BRIDGE----','40','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4A8C56EA-F291-4829-B41D-8E3E0E6875E8',2935,'Extraction blower','Extraction blower----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E1AF9F0B-268A-456E-8460-C9CD53256407',2936,'Bollard-type','Bollard-type----','45','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DB17603B-9C76-40C7-A27B-93B5F4F0B675',2937,'Floodlights','Floodlights----','30','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C2D74F1C-B9F0-4C29-9001-C4144A7F7BF9',2938,'Streetlight with its network','Streetlight with its network----','45','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FEA5FB5E-1AD0-4C3D-A64B-3F1D55D5393D',2939,'Runway edge lights','Runway edge lights----','30','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8952D65E-12EF-4CAA-BB62-BCF971BAFB0B',2940,'Runway approach lights','Runway approach lights----','30','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('283E4385-6023-4389-A744-77D5269412CC',2941,'Paapi lights','Paapi lights----','30','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3C4E0397-8B42-4BD2-8090-727196A67C3D',2942,'Taxiway edge lights ','Taxiway edge lights ----','30','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8BF40078-E698-4795-9B62-B8C87169FA2D',2943,'Taxiway lights','Taxiway lights----','30','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A8FFDE74-2C86-411A-A7CB-88954A5EEAC3',2944,'3 seater concrete bench','3 seater concrete bench----','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('101DCE2A-0FE8-4FD8-B08A-83D38A57B089',2945,'Children`s play equipment (jungle gym)','Children`s play equipment (jungle gym)----','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B8705576-3336-4CE8-9E67-65FFEA7B2003',3023,'Concrete table (rectangular)','Concrete table (rectangular)----','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C99788D9-1D2F-4A7D-ACCF-BE559949C4A8',3024,'Large planter pot (> 1m diameter)','Large planter pot (> 1m diameter)----','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C6CC7C9D-DBF1-4EA1-AC78-7BBD0841AE2F',3025,'Medium planter pot (< 1m diameter)','Medium planter pot (< 1m diameter)----','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C594C07D-D476-40C6-A85D-2198616C7CE4',3026,'Playground equipment','Playground equipment----','20','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('19F33989-2AAE-4702-BF00-65E3C134FAEF',3027,'Water feature - park','Water feature - park----','20','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B9B40135-B575-4C0E-9AB8-84334F252021',3044,'Water feature (large)','Water feature (large)----','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('22C9F633-1309-41BD-8F85-95F2CE206A9E',3045,'Water feature (small)','Water feature (small)----','20','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('62C90FDF-E17F-407D-AEE0-A1287AC9C3D3',3046,'3 seater steel bench','3 seater steel bench----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('59A45C45-ED22-4735-BE0B-0FC528FE73A9',3047,'3 SEATER GALVANISED STEEL BENCH','3 SEATER GALVANISED STEEL BENCH----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('393F2FE9-C678-46A2-ADA9-33E6A7E9C124',3048,'Dust removal','Dust removal----','30','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B41EF347-9E85-4333-A7EC-31E47B2589F2',3049,'Gabions','Gabions----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('167A7FC3-BF5A-46C7-A709-CB0920560B27',3050,'Rip rap','Rip rap----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3BA7EF4E-8D18-4039-8D9F-1F2263B02E30',3051,'Brick wall','Brick wall----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('93631177-9A46-4848-854E-827900004F11',3052,'Stone Pitching','Stone Pitching----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('97CD89EC-C582-4750-82E5-68DA85B5368C',3053,'Gas','Gas-3---kW','15','0','3','kW','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('956A2E26-81FE-4F06-AE81-B3AD0C2B75BB',3054,'Gas','Gas-4---kW','15','0','4','kW','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5B8528FD-FCD6-4D35-9ECB-DD94FD4EE655',3055,'Gas','Gas-6---kW','15','0','6','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5F257C6D-E632-4F85-8B85-5DB7134829A8',3056,'Gas','Gas-10---kW','15','0','10','kW','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('00F7372A-7952-4B44-8092-06B2DD077E06',3057,'Credit lpu (large power users) meter','Credit lpu (large power users) meter--3 phase--','20','0','','','3 phase','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E6D76172-BBCB-4AE7-91A5-B8622CD5629A',3062,'Credit lpu 3 - 0 hv including metering unit','Credit lpu 3 - 0 hv including metering unit--3 phase--','20','0','','','3 phase','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('269A1098-3DA7-4EE9-84BA-F12A6F15FA10',3063,'Lv overhead','Lv overhead--3 phase--','50','0','','','3 phase','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DFBBDE2A-87C0-4E9E-B467-89D0D46B376D',3064,'Lv overhead','Lv overhead--single phase--','50','0','','','single phase','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CE4380C0-6ECA-4829-9D9C-D7F460AFCDB9',3065,'Lv underground','Lv underground--3 phase--','50','0','','','3 phase','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ED05CE92-13D7-40BA-8AAC-072FAD18987F',3066,'Lv underground','Lv underground--single phase--','50','0','','','single phase','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5D58BE6C-C833-4F4C-BDB7-5812DABEA5C6',3067,'Electrical installation','Electrical installation----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('12055309-D746-45D5-9C13-AEE3727CC97B',3068,'Economiser','Economiser----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('05861F77-8588-4835-A8E0-FF59130DFA55',3069,'Flat terrain','Flat terrain--Channels--','80','0','','','Channels','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AE88D5AC-FDC4-47F2-8A1C-F918BBCA528E',3070,'Flat terrain','Flat terrain--Construction platform--','80','0','','','Construction platform','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('83428347-756D-4997-8D5C-2EC10EF61422',3071,'Mountainous terrain','Mountainous terrain--Channels--','80','0','','','Channels','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1EA627BF-8BD7-4407-B70A-E3A10E7376A7',3072,'Mountainous terrain','Mountainous terrain--Construction platform--','80','0','','','Construction platform','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3BFEFB65-6DC9-454E-96BB-2187354E4CF7',3073,'Rolling terrain','Rolling terrain--Channels--','80','0','','','Channels','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AE9C100D-8892-457F-BED9-89FF23E33711',3074,'Rolling terrain','Rolling terrain--Construction platform--','80','0','','','Construction platform','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7FA6E659-BDF9-4448-A9F7-F8E9B2E0B2DB',3075,'Flat terrain','Flat terrain--R1 Road--','80','0','','','R1 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('27DB8B4A-2E9E-4A4F-86FC-49DD0FC42A9D',3076,'Flat terrain','Flat terrain--R2 Road--','80','0','','','R2 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3F707EA6-B313-4E39-B2A2-FA4EFA79B2C9',3077,'Flat terrain','Flat terrain--R3 Road--','80','0','','','R3 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('80698BDB-EB49-492A-ADA4-1313374EB02F',3078,'Flat terrain','Flat terrain--R4 Road--','80','0','','','R4 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AAF951BA-23B5-46FF-ACBF-49D75A434917',3079,'Flat terrain','Flat terrain--U1 Road--','80','0','','','U1 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('95AA7EB3-DDD1-469E-8DB0-09C19C6AC370',3080,'Flat terrain','Flat terrain--U2 Road--','80','0','','','U2 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8AB3C97D-DDBE-4B1A-8EC0-A58970820F6E',3081,'Flat terrain','Flat terrain--U3 Road--','80','0','','','U3 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A7034EF0-568B-4E17-BF70-CDD2EE26F5F3',3082,'Flat terrain','Flat terrain--U4 Road--','80','0','','','U4 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8E290046-03F2-424A-AF14-072CCE45C22D',3083,'Mountainous terrain','Mountainous terrain--R1 Road--','80','0','','','R1 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9BC1A7DA-658F-4DA4-A8E5-48992D2272C4',3084,'Mountainous terrain','Mountainous terrain--R2 Road--','80','0','','','R2 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('76C94F95-2660-4C18-9998-66AA243B6005',3085,'Mountainous terrain','Mountainous terrain--R3 Road--','80','0','','','R3 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('01A30EC7-4078-4D5A-A4D4-C86911A255FF',3086,'Mountainous terrain','Mountainous terrain--R4 Road--','80','0','','','R4 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EA4D071B-020A-40A3-8336-9D763E3D717C',3089,'Mountainous terrain','Mountainous terrain--U1 Road--','80','0','','','U1 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('01B803D7-2EA2-48D0-B171-B3D6A312E51E',3090,'Mountainous terrain','Mountainous terrain--U2 Road--','80','0','','','U2 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FE169BA5-0223-4C48-87FF-F3D07060987B',3091,'Mountainous terrain','Mountainous terrain--U3 Road--','80','0','','','U3 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A091E100-DDC6-4859-A350-713958179BF2',3092,'Mountainous terrain','Mountainous terrain--U4 Road--','80','0','','','U4 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4FD546FD-31EE-449D-B8A7-DBD588C578E4',3093,'Rolling terrain','Rolling terrain--R1 Road--','80','0','','','R1 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F4FCD8C0-C726-4B11-ACF9-6D6885A54386',3094,'Rolling terrain','Rolling terrain--R2 Road--','80','0','','','R2 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EE099B2C-D1AA-4A4D-8A61-45C9687768EC',3095,'Rolling terrain','Rolling terrain--R3 Road--','80','0','','','R3 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1827FA7D-C052-499C-B1B6-F4FD616C6AFD',3096,'Rolling terrain','Rolling terrain--R4 Road--','80','0','','','R4 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('057FD0E2-BEE9-4BA0-9D60-06815C201DF1',3097,'Rolling terrain','Rolling terrain--U1 Road--','80','0','','','U1 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C2721F4D-2BD1-49DA-AB45-A454DBE370E0',3098,'Rolling terrain','Rolling terrain--U2 Road--','80','0','','','U2 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('09D5413F-4D9F-437D-8F21-8DEC8198CEE4',3099,'Rolling terrain','Rolling terrain--U3 Road--','80','0','','','U3 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('35597713-A5E6-453D-9225-B2A0EE43290A',3100,'Rolling terrain','Rolling terrain--U4 Road--','80','0','','','U4 Road','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('527610B8-F581-4D5F-ABD0-0A89EF62C96C',3101,'Chlorine','Chlorine----','15','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('59193A32-EB5A-4166-8BB8-60C5010675D4',3102,'Water softener','Water softener----','15','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5733D7FE-5B85-4394-9C13-83034D4B923C',3103,'Ultraviolet','Ultraviolet----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B5CC2FE0-FF39-4613-BA61-47A73FA587F6',3104,'Scale dial','Scale dial----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E1345018-E3E3-439B-8C30-3487CF46DF69',3105,'Data Concentrator unit','Data Concentrator unit----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4BD47CF5-0C1E-44A3-BED8-6B7D70D5FCB0',3106,'Current Transformer','Current Transformer-11---kV','45','0','11','kV','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7A923EFD-7113-4BC9-8C66-6AB80C64E1C1',3107,'Current Transformer','Current Transformer-22---kV','45','0','22','kV','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E24602E8-B0A9-4D50-B91E-D50F58DB7388',3108,'Current Transformer','Current Transformer-33---kV','45','0','33','kV','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A3DDCC02-CC4C-4AF8-B818-4743886D8132',3109,'Current Transformer','Current Transformer-132---kV','45','0','132','kV','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BE32E7EA-1B28-48E8-9F36-535F73A9DC6C',3110,'Current Transformer','Current Transformer-88---kV','45','0','88','kV','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EBAB7427-EF65-42FD-A52B-101FFB261F57',3111,'1200 mm diameter pipe','1200 mm diameter pipe----','60','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('5339FC83-3E4B-47EB-BDCE-1F3DF1BAE112',3112,'1200x1200 box','1200x1200 box----mm','60','0','','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('49648E06-38FE-4EA2-B2DA-138085556446',3113,'1500 mm diameter pipe','1500 mm diameter pipe----','60','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A041390D-BDE3-46A2-A1A8-F14481F6577A',3114,'1500x1500 box','1500x1500 box----mm','60','0','','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F86C6503-6AB7-432E-8964-862C8D9DFA5B',3115,'1800 mm diameter pipe','1800 mm diameter pipe----','60','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3D67A0DC-E347-4F6D-BC25-5F9B80CA9CF6',3116,'1800x1800 box','1800x1800 box----mm','60','0','','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B69B068D-B16A-41F9-9D8D-C37CCB8494F7',3117,'2400 mm diameter pipe','2400 mm diameter pipe----','60','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BA8BD862-E666-4D69-AB13-7C7C679DA77B',3118,'2400x2400 box','2400x2400 box----mm','60','0','','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0B3BD04C-39F2-4C8B-95BC-ACA42944A2FD',3119,'3000 mm diameter pipe','3000 mm diameter pipe----','60','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3C149B29-8C7E-473F-8B8E-5FA001ADA0E0',3120,'3000x3000 box','3000x3000 box----mm','60','0','','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0BF7B877-B8F9-4D25-BD8F-ACC8C222F988',3121,'450 mm diameter pipe','450 mm diameter pipe----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('C1C07CB4-4305-4CF2-BF13-256D17BA22DA',3122,'4500 mm diameter pipe','4500 mm diameter pipe----','60','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F023770E-B0AB-4960-B4BA-31D0445831AC',3123,'4500x4500 box','4500x4500 box----mm','60','0','','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2123E309-25A4-45F6-BF7A-60248720FFD5',3124,'450x450 box','450x450 box----mm','60','0','','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F1476538-C324-4B55-88B2-F831569F29EA',3125,'600 mm diameter pipe','600 mm diameter pipe----','60','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('17047A92-7DF2-432A-9DD6-66D75C696667',3126,'600x600 box','600x600 box----mm','60','0','','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F47186D3-D783-4A7E-8395-495417C02598',3127,'900 mm diameter pipe','900 mm diameter pipe----','60','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D2F31E22-1CCE-4BB1-9E99-FA46E4FFECEE',3128,'900x900 box','900x900 box----mm','60','0','','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('09B95A0C-D3EE-4317-9869-CC5695A55F05',3129,'525 mm diameter pipe','525 mm diameter pipe----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('10E27D1E-63E9-4799-B85A-F86A0476E89E',3130,'675 mm diameter pipe','675 mm diameter pipe----','60','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7F3B34A4-373C-46EA-A245-34198E5D5BCD',3131,'750 mm diameter pipe','750 mm diameter pipe----','60','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4D6CA20B-7A64-46A7-9368-EE5154B98E65',3132,'1350 mm diameter pipe','1350 mm diameter pipe----','60','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E5E987AE-E30E-42FF-A4FF-6BA72A020A87',3133,'825 mm diameter pipe','825 mm diameter pipe----','60','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('10186167-80E0-43EB-A6E6-83FF6D2850C0',3134,'1050 mm diameter pipe','1050 mm diameter pipe----','60','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AD34E41B-D457-421F-A241-D322DB9B126F',3135,'4700x2900 box','4700x2900 box----mm','60','0','','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('F9B68CC9-9B88-434C-91ED-D15F85DB733B',3136,'3550x3550 box','3550x3550 box----mm','60','0','','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FBFE92DE-B0C7-483F-9040-27E04491C83E',3137,'2900x2900 box','2900x2900 box----mm','60','0','','mm','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FAE21B64-9EF7-4562-8499-ACBA8CF188C7',3138,'2160 mm diameter pipe','2160 mm diameter pipe----','60','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8984B619-2D4D-48AC-BD61-CC5563E2ED72',3139,'1800x1500 box','1800x1500 box----mm','60','0','','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FF254B58-1EF4-456C-98B3-7D94219DC9A2',3140,'1500x1200 box','1500x1200 box----mm','60','0','','mm','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('6E7475AF-3317-419B-A5FD-CC29A5658FC0',3141,'Jaw crusher','Jaw crusher----','30','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CE396D24-7FFB-44A6-A856-3E08E06E7286',3142,'Stone crusher','Stone crusher----','30','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3DD6033E-C89D-4FFE-9A29-16161941B100',3143,'Crane','Crane----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('ADFD1FB5-B9C5-424D-9E24-1FC6192EB832',3144,'FIBER SWITCH','FIBER SWITCH----','5','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AA483131-A956-4F22-8455-DF998138193B',3145,'COPPER SWITCH','COPPER SWITCH----','4','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FCF92CFB-440E-49D1-8B0E-B622D64BF61B',3150,'MPLS SWITCH','MPLS SWITCH----','5','0','','','','TRUE','9A1AE6DB-C715-459E-A8D9-7B23FCA30242');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AB16D35F-D109-4199-B194-0E4CBAF5217E',3151,'CHASSIS SWITCH','CHASSIS SWITCH----','5','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0620FB79-C687-4FA9-B296-95F87DB9FA73',3152,'Small','Small----','45','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('9441DA53-7482-444D-9CDC-AFF8253E75CF',3153,'Large','Large----','45','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('8F751B9B-F897-4B28-B761-3CFF17B0E914',3154,'Conveyor belt system','Conveyor belt system----','15','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7BEA356B-132B-4ABA-8D5E-6A252DBD087D',3155,'Conveyor belt','Conveyor belt----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A7AC299D-5F74-4A20-A862-931E31CC2DEF',3156,'Credit meter','Credit meter--3 phase--','20','0','','','3 phase','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('2F67174D-91C4-45B2-9CDB-0A504002C768',3157,'Credit meter','Credit meter--single phase--','20','0','','','single phase','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E9BF8FBF-5B7A-4524-BB0F-B491632CB403',3158,'Credit meter','Credit meter--Maximum demand--','20','0','','','Maximum demand','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('FCC42174-820E-4D7C-A9CE-D75A3DBC39B7',3159,'Controller (HMI)','Controller (HMI)----','12','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('7A6D4802-6903-412F-8BCD-F196C786633A',3160,'Equipment control panel','Equipment control panel----','50','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B30009F8-5509-47BD-92EB-477A6C5324AB',3161,'Network control panel','Network control panel--Electromechanical relays--','50','0','','','Electromechanical relays','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('DF32AEFE-F9BF-4EE7-A28A-3AA52F9D4BF0',3162,'Network control panel','Network control panel--Electronic relays--','50','0','','','Electronic relays','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('929618F1-015F-4786-A211-586A1A505346',3163,'Fibre Optic','Fibre Optic----','50','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('4A5A246E-4867-4426-BE0E-B2FDAE6AC9C3',3164,'Pilot cable','Pilot cable----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A1F4E00C-6943-4210-9B8A-8AB4261E50B5',3165,'Condenser Pump','Condenser Pump----kW','30','0','','kW','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EF5B3722-2491-48E9-A7EA-A3199C1E24C2',3166,'Condenser','Condenser----','30','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AB07FEA2-37A6-4944-BB62-89CD9539E47C',3167,'Workshop type - fixed','Workshop type - fixed----','10','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3FEA339C-CF14-4BA8-901F-2932A6838AF7',3168,'Compressed air supply','Compressed air supply----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('05DCBE3E-C950-4218-9A68-4B4560580F16',3169,'General control air supply','General control air supply----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('22B70B10-F4B7-45AA-B10A-E5EC8F5AC9EB',3170,'Compactor - C5','Compactor - C5----','15','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('86A36B83-754A-4A83-80F4-C68B629059DD',3171,'Compactor - C9','Compactor - C9----','15','0','','','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('73BC4649-32CC-43BD-9FAC-985C38E58E7A',3172,'Concrete commuter shelter','Concrete commuter shelter----','15','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('BC387185-0BFB-498B-B5E3-947AE1E2E688',3173,'Plastic commuter shelter','Plastic commuter shelter----','15','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0EE1E326-162F-41F3-BDA0-647F4597FE6B',3174,'Steel commuter shelter','Steel commuter shelter----','15','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3C108BDF-A83F-4017-9219-8BB57271CAB4',3175,'Optical line terminal Fixed port','Optical line terminal Fixed port----','5','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('17C83E5A-DF83-46F2-80F8-FDCBB27AD139',3176,'Optical line terminal Modular port','Optical line terminal Modular port----','5','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('574BB7C3-9353-41F9-83D3-78E7D5954F47',3177,'DISTRIBUTION','DISTRIBUTION----','4','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('41951777-61D4-4312-BC19-B33E21B0EEC8',3178,'EDGE','EDGE----','4','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('EAC11DAD-219F-400A-8683-5D83D217D3E2',3179,'Network switch (data only)','Network switch (data only)----','4','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1414BE5C-3649-43E2-BA88-01AEFC74991C',3180,'Network switch (data & poe+)','Network switch (data & poe+)----','4','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('AF465B66-8B75-4858-9186-5ADDD6F36863',3181,'Network switch (data & poe)','Network switch (data & poe)----','4','0','','','','TRUE','72078ACC-8D84-41E8-8B9E-CEF7AD453A38');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('0121EB7C-F67F-4502-84B6-B4E39251C5C1',3182,'Co-axial cable','Co-axial cable----','12','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('354A0CEC-F0B9-4A56-9F3D-B3500022FEC4',3183,'Communal standpipe - Pedestal','Communal standpipe - Pedestal----','10','0','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('66B22F8C-795C-42D4-A69E-66042358187B',3184,'Communal standpipe - Tap','Communal standpipe - Tap----','5','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('890965DD-F2E4-493F-952C-94BF8CB9F3C4',3185,'Coal distribution & intermediate storage','Coal distribution & intermediate storage----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('1B2EA3AE-81F2-4677-AF9D-A60EFA9F631C',3186,'Coal stockyard conveyor system','Coal stockyard conveyor system----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('CCFFCB79-B7B1-480D-BAE1-6B2ABBA7A6BB',3187,'Storage area (coal stockpile)','Storage area (coal stockpile)----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('640C23C8-9673-4DB0-8245-AF6C09A1AAF2',3188,'Drinking water supply','Drinking water supply----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('98C958CA-B7D0-46A8-84CC-561C2CC9BC07',3189,'Fire fighting water system','Fire fighting water system----','60','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('52BF579E-69E8-4EC0-AFEB-A099C4FFAB1D',3190,'Gas Chiller','Gas Chiller-2000---m3/h','15','0','2000','m3/h','','TRUE','C7B2C6EA-BE96-4A9F-B805-6A7961360216');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('3E1B63F8-A89C-402D-9DCD-08ADCAF0EF2C',3191,'Bus Bay Asphalt','Bus Bay Asphalt----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('A7326DBC-003D-4171-AAEB-ACD2DD06D112',3192,'Bus Bay Block','Bus Bay Block----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('E4100FC3-7F32-4D17-BA5A-CFD66FCF3033',3193,'Bus Bay Concrete','Bus Bay Concrete----','20','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('029A5F21-8C81-4342-BAED-8D454AFCD197',3194,'Bus Bay Gravel','Bus Bay Gravel----','10','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('74FAF0E6-F7AB-46C2-A270-774D3A4A6216',3195,'DOUBLE','DOUBLE----','','','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('D6299E61-B2C0-4C81-A4CF-99BD6E104248',3196,'SINGLE','SINGLE----','','','','','','TRUE','CFEF377A-70C9-4732-AEA3-234EC8A91283');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('78EB6BD5-D89C-4347-A797-F7DCDB5947CA',3197,'Sidewalk asphalt','Sidewalk asphalt----','50','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');
INSERT INTO public.CompatibleUnit(ID,Code,Name,Description,EULyears,ResidualValFactor,Size,SizeUnit,class,IsActive,CriticalityTypeLookupID) 
VALUES ('B8A9D195-EBCC-4BA0-8ED0-1816853B07D9',3199,'Inductive Loop Detector','Inductive Loop Detector----','15','0','','','','TRUE','66C178A0-0E9E-4E27-B444-17D493119951');











/* --------------- Asset ---------- */





