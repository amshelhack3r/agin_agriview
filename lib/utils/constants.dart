import 'package:flutter/material.dart';

const kTextColor = Color(0xFF535353);
const kTextLightColor = Color(0xFFACACAC);
const kDefaultPaddin = 20.0;

const BASEURL = "https://api.agin.co/AginMainPortal-war/rest";
const FETCH_COUNTRIES = '/country/list';

const REGISTER_AGGREGATOR = '/aggregator/register';
const REGISTER_FARMER = '/aggregator/register/farmer';
const CREATE_FARM_PRODUCE = '/production/farm/produce/register';
const PRODUCT_LIST = '/product/list';
const FARMERS_LIST = '/aggregator/farmers';
const AGGREGATOR_STATISTICS = '/aggregator/stats';
const CREATE_FARM = '/production/farm/register';
const FARMS = '/producer/farms';
const AGGREGATOR_LOGIN = '/aggregator/login';
const VERIFY_AGGREGATOR = '/aggregator/account/verify';
const CULTIVATION_MODES_OPTIONS = '/market/cultivationmodes/list';
const PRODUCT_STATUS = '/market/producestatus/list';
const UNIT_TYPES = '/market/unittypes/list';
const ADD_PRODUCE = '/market/add/produce';
const MARKET_PLACE_LISTING = '/market/list/by/aggregator';
const GET_PRODUCE = '/production/farm/produce/list/landaginid';
const COUNTY_LIST = '/county/list';
const PRODUCT_LISTINGS = '/product/list/bc/location/product/prices';
const UPLOAD_GPX = '/production/farm/upload';

//these are new apis using different api token
const P2M_API_TOKEN = "EA9CE1F94A0843C0A9ABA6B663D0E178";
const P2M_FORM_DROPDOWN = "/market/dropdowns/list";

const PREF_NAME = "name";
const PREF_AGINID = "aginId";
const PREF_MOBILE = "mobile";
const PREF_HAS_LOGGED_IN = "has_logged_in";
const PREF_DB_HAS_INITIALIZED = "db_initilized";

// const APIKEY = "e9567a76cc5f4da191a97945ba37b63a";
const APIKEY = "EA9CE1F94A0843C0A9ABA6B663D0E178";
const MAPBOX_TOKEN =
    "sk.eyJ1IjoiYW1zaGVsIiwiYSI6ImNranpreHhtZzA4bDgycHJydHF5bDM0ankifQ.iMqEwe2AcYjHrRD1lEsv7w";
