--
-- PostgreSQL database dump
--

\restrict GIhzTnVexQFIc3dACSQGxZIT1k94jR3BAvNUKQZPebVZNWHtdbOs7zzlPS2fyK3

-- Dumped from database version 18.3 (Debian 18.3-1.pgdg12+1)
-- Dumped by pg_dump version 18.3 (Ubuntu 18.3-1.pgdg24.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: refresh_dashboard_stats_view(); Type: FUNCTION; Schema: public; Owner: drwisedb01_user
--

CREATE FUNCTION public.refresh_dashboard_stats_view() RETURNS void
    LANGUAGE plpgsql
    AS $$
      BEGIN
        REFRESH MATERIALIZED VIEW CONCURRENTLY dashboard_stats_view;
      END;
      $$;


ALTER FUNCTION public.refresh_dashboard_stats_view() OWNER TO drwisedb01_user;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_attachments OWNER TO drwisedb01_user;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_attachments_id_seq OWNER TO drwisedb01_user;

--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    service_name character varying NOT NULL,
    byte_size bigint NOT NULL,
    checksum character varying,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.active_storage_blobs OWNER TO drwisedb01_user;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_blobs_id_seq OWNER TO drwisedb01_user;

--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


ALTER TABLE public.active_storage_variant_records OWNER TO drwisedb01_user;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNER TO drwisedb01_user;

--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- Name: agency_brokers; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.agency_brokers (
    id bigint NOT NULL,
    broker_name character varying,
    broker_code character varying,
    agency_code character varying,
    status boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.agency_brokers OWNER TO drwisedb01_user;

--
-- Name: agency_brokers_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.agency_brokers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.agency_brokers_id_seq OWNER TO drwisedb01_user;

--
-- Name: agency_brokers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.agency_brokers_id_seq OWNED BY public.agency_brokers.id;


--
-- Name: agency_codes; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.agency_codes (
    id bigint NOT NULL,
    insurance_type character varying,
    company_name character varying,
    agent_name character varying,
    code character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    broker_id bigint
);


ALTER TABLE public.agency_codes OWNER TO drwisedb01_user;

--
-- Name: agency_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.agency_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.agency_codes_id_seq OWNER TO drwisedb01_user;

--
-- Name: agency_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.agency_codes_id_seq OWNED BY public.agency_codes.id;


--
-- Name: ahoy_events; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.ahoy_events (
    id bigint NOT NULL,
    visit_id bigint,
    user_id bigint,
    name character varying,
    properties jsonb,
    "time" timestamp(6) without time zone
);


ALTER TABLE public.ahoy_events OWNER TO drwisedb01_user;

--
-- Name: ahoy_events_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.ahoy_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ahoy_events_id_seq OWNER TO drwisedb01_user;

--
-- Name: ahoy_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.ahoy_events_id_seq OWNED BY public.ahoy_events.id;


--
-- Name: ahoy_visits; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.ahoy_visits (
    id bigint NOT NULL,
    visit_token character varying,
    visitor_token character varying,
    user_id bigint,
    ip character varying,
    user_agent text,
    referrer text,
    referring_domain character varying,
    landing_page text,
    browser character varying,
    os character varying,
    device_type character varying,
    country character varying,
    region character varying,
    city character varying,
    latitude double precision,
    longitude double precision,
    utm_source character varying,
    utm_medium character varying,
    utm_term character varying,
    utm_content character varying,
    utm_campaign character varying,
    app_version character varying,
    os_version character varying,
    platform character varying,
    started_at timestamp(6) without time zone
);


ALTER TABLE public.ahoy_visits OWNER TO drwisedb01_user;

--
-- Name: ahoy_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.ahoy_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ahoy_visits_id_seq OWNER TO drwisedb01_user;

--
-- Name: ahoy_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.ahoy_visits_id_seq OWNED BY public.ahoy_visits.id;


--
-- Name: ai_report_histories; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.ai_report_histories (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    report_type character varying NOT NULL,
    filters json,
    ai_insights json,
    confidence_score integer,
    generated_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ai_report_histories OWNER TO drwisedb01_user;

--
-- Name: ai_report_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.ai_report_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ai_report_histories_id_seq OWNER TO drwisedb01_user;

--
-- Name: ai_report_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.ai_report_histories_id_seq OWNED BY public.ai_report_histories.id;


--
-- Name: all_policy_reports; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.all_policy_reports (
    id bigint NOT NULL,
    name character varying,
    policy_type character varying,
    report_data json,
    created_by_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.all_policy_reports OWNER TO drwisedb01_user;

--
-- Name: all_policy_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.all_policy_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.all_policy_reports_id_seq OWNER TO drwisedb01_user;

--
-- Name: all_policy_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.all_policy_reports_id_seq OWNED BY public.all_policy_reports.id;


--
-- Name: analytics_caches; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.analytics_caches (
    id bigint NOT NULL,
    cache_identifier character varying,
    cache_data text,
    last_updated timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.analytics_caches OWNER TO drwisedb01_user;

--
-- Name: analytics_caches_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.analytics_caches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.analytics_caches_id_seq OWNER TO drwisedb01_user;

--
-- Name: analytics_caches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.analytics_caches_id_seq OWNED BY public.analytics_caches.id;


--
-- Name: appointments; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.appointments (
    id bigint NOT NULL,
    customer_id bigint,
    customer_name character varying NOT NULL,
    customer_email character varying,
    customer_phone character varying,
    meeting_agenda text,
    notes text,
    appointment_date date NOT NULL,
    time_slot character varying NOT NULL,
    status character varying DEFAULT 'pending'::character varying NOT NULL,
    created_by_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.appointments OWNER TO drwisedb01_user;

--
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.appointments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.appointments_id_seq OWNER TO drwisedb01_user;

--
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.appointments.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.ar_internal_metadata OWNER TO drwisedb01_user;

--
-- Name: banner_documents; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.banner_documents (
    id bigint NOT NULL,
    banner_id bigint NOT NULL,
    document_type character varying,
    title character varying,
    description text,
    r2_file_key character varying,
    r2_filename character varying,
    r2_content_type character varying,
    r2_file_size bigint,
    uploaded_by character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.banner_documents OWNER TO drwisedb01_user;

--
-- Name: banner_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.banner_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.banner_documents_id_seq OWNER TO drwisedb01_user;

--
-- Name: banner_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.banner_documents_id_seq OWNED BY public.banner_documents.id;


--
-- Name: banners; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.banners (
    id bigint NOT NULL,
    title character varying,
    description character varying,
    redirect_link character varying,
    display_start_date date,
    display_end_date date,
    display_location character varying,
    status boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    display_order integer DEFAULT 0,
    r2_file_key character varying,
    r2_filename character varying,
    r2_content_type character varying,
    r2_file_size bigint,
    r2_public_url text
);


ALTER TABLE public.banners OWNER TO drwisedb01_user;

--
-- Name: banners_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.banners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.banners_id_seq OWNER TO drwisedb01_user;

--
-- Name: banners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.banners_id_seq OWNED BY public.banners.id;


--
-- Name: broker_codes; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.broker_codes (
    id bigint NOT NULL,
    broker_id bigint NOT NULL,
    broker_code character varying,
    company_name character varying,
    status boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    agent_name character varying
);


ALTER TABLE public.broker_codes OWNER TO drwisedb01_user;

--
-- Name: broker_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.broker_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.broker_codes_id_seq OWNER TO drwisedb01_user;

--
-- Name: broker_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.broker_codes_id_seq OWNED BY public.broker_codes.id;


--
-- Name: brokers; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.brokers (
    id bigint NOT NULL,
    name character varying NOT NULL,
    status character varying DEFAULT 'active'::character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    insurance_company_id bigint
);


ALTER TABLE public.brokers OWNER TO drwisedb01_user;

--
-- Name: brokers_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.brokers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.brokers_id_seq OWNER TO drwisedb01_user;

--
-- Name: brokers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.brokers_id_seq OWNED BY public.brokers.id;


--
-- Name: client_requests; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.client_requests (
    id bigint NOT NULL,
    ticket_number character varying NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    phone_number character varying NOT NULL,
    description text NOT NULL,
    status character varying DEFAULT 'pending'::character varying,
    priority character varying DEFAULT 'medium'::character varying,
    submitted_at timestamp(6) without time zone NOT NULL,
    admin_response text,
    resolved_at timestamp(6) without time zone,
    resolved_by_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    category character varying,
    submitter_type character varying,
    submitter_id integer,
    subject character varying,
    request_type character varying
);


ALTER TABLE public.client_requests OWNER TO drwisedb01_user;

--
-- Name: client_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.client_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.client_requests_id_seq OWNER TO drwisedb01_user;

--
-- Name: client_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.client_requests_id_seq OWNED BY public.client_requests.id;


--
-- Name: commission_payouts; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.commission_payouts (
    id bigint NOT NULL,
    policy_type character varying,
    policy_id integer,
    payout_to character varying,
    payout_amount numeric,
    payout_date date,
    status character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    transaction_id character varying,
    payment_mode character varying,
    reference_number character varying,
    commission_amount_received numeric(10,2),
    distribution_percentage numeric(5,2),
    notes text,
    processed_by character varying,
    processed_at timestamp(6) without time zone,
    payout_id bigint,
    lead_id character varying,
    invoiced boolean DEFAULT false,
    total_commission_amount numeric(10,2),
    tds_amount numeric(10,2)
);


ALTER TABLE public.commission_payouts OWNER TO drwisedb01_user;

--
-- Name: commission_payouts_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.commission_payouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.commission_payouts_id_seq OWNER TO drwisedb01_user;

--
-- Name: commission_payouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.commission_payouts_id_seq OWNED BY public.commission_payouts.id;


--
-- Name: commission_receipts; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.commission_receipts (
    id bigint NOT NULL,
    policy_type character varying NOT NULL,
    policy_id integer NOT NULL,
    total_commission_received numeric(12,2) NOT NULL,
    received_date date NOT NULL,
    insurance_company_name character varying,
    insurance_company_reference character varying,
    company_commission_percentage numeric(5,2),
    payment_mode character varying,
    transaction_id character varying,
    notes text,
    received_by character varying,
    auto_distributed boolean DEFAULT false,
    distributed_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.commission_receipts OWNER TO drwisedb01_user;

--
-- Name: commission_receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.commission_receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.commission_receipts_id_seq OWNER TO drwisedb01_user;

--
-- Name: commission_receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.commission_receipts_id_seq OWNED BY public.commission_receipts.id;


--
-- Name: corporate_members; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.corporate_members (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    company_name character varying,
    mobile character varying,
    email character varying,
    state character varying,
    city character varying,
    address text,
    annual_income numeric,
    pan_no character varying,
    gst_no character varying,
    additional_information text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.corporate_members OWNER TO drwisedb01_user;

--
-- Name: corporate_members_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.corporate_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.corporate_members_id_seq OWNER TO drwisedb01_user;

--
-- Name: corporate_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.corporate_members_id_seq OWNED BY public.corporate_members.id;


--
-- Name: customer_documents; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.customer_documents (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    document_type character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    r2_file_key character varying,
    r2_filename character varying,
    r2_content_type character varying,
    r2_file_size bigint
);


ALTER TABLE public.customer_documents OWNER TO drwisedb01_user;

--
-- Name: customer_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.customer_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customer_documents_id_seq OWNER TO drwisedb01_user;

--
-- Name: customer_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.customer_documents_id_seq OWNED BY public.customer_documents.id;


--
-- Name: customers; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.customers (
    id bigint NOT NULL,
    customer_type character varying,
    first_name character varying,
    last_name character varying,
    company_name character varying,
    email character varying,
    mobile character varying,
    address character varying,
    state character varying,
    city character varying,
    birth_date date,
    age integer,
    gender character varying,
    height character varying,
    weight character varying,
    education character varying,
    marital_status character varying,
    occupation character varying,
    job_name character varying,
    type_of_duty character varying,
    annual_income numeric,
    pan_number character varying,
    gst_number character varying,
    birth_place character varying,
    additional_info text,
    status boolean,
    added_by character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    nominee_name character varying,
    nominee_relation character varying,
    nominee_date_of_birth date,
    pincode character varying,
    sub_agent character varying DEFAULT 'Self'::character varying,
    middle_name character varying,
    height_feet character varying,
    weight_kg numeric(5,2),
    business_job character varying,
    business_name character varying,
    additional_information text,
    pan_no character varying,
    gst_no character varying,
    sub_agent_id integer,
    lead_id character varying,
    deactivated boolean DEFAULT false,
    r2_profile_image_key character varying,
    r2_profile_image_filename character varying,
    r2_profile_image_content_type character varying,
    r2_profile_image_size bigint,
    r2_profile_image_public_url text,
    policies_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.customers OWNER TO drwisedb01_user;

--
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.customers_id_seq OWNER TO drwisedb01_user;

--
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- Name: distributors; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.distributors (
    id bigint NOT NULL,
    first_name character varying NOT NULL,
    middle_name character varying,
    last_name character varying NOT NULL,
    mobile character varying NOT NULL,
    email character varying NOT NULL,
    role_id integer NOT NULL,
    state_id integer,
    city_id integer,
    birth_date date,
    gender character varying,
    pan_no character varying,
    gst_no character varying,
    company_name character varying,
    address text,
    bank_name character varying,
    account_no character varying,
    ifsc_code character varying,
    account_holder_name character varying,
    account_type character varying,
    upi_id character varying,
    status integer DEFAULT 0,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    affiliate_count integer DEFAULT 0 NOT NULL,
    deactivated boolean DEFAULT false,
    city character varying,
    state character varying,
    username character varying,
    password_digest character varying,
    original_password character varying,
    investor_id integer
);


ALTER TABLE public.distributors OWNER TO drwisedb01_user;

--
-- Name: health_insurances; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.health_insurances (
    id bigint NOT NULL,
    policy_id bigint,
    insurance_type character varying,
    claim_process character varying,
    main_agent_commission_percent numeric,
    main_agent_commission_amount numeric,
    main_agent_tds_percent numeric,
    main_agent_tds_amount numeric,
    reference_by_name character varying,
    broker_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    customer_id bigint,
    sub_agent_id bigint,
    agency_code_id bigint,
    broker_id bigint,
    policy_holder character varying,
    insurance_company_name character varying,
    plan_name character varying,
    policy_number character varying,
    policy_booking_date date,
    policy_start_date date,
    policy_end_date date,
    policy_term integer,
    payment_mode character varying,
    sum_insured numeric,
    net_premium numeric,
    gst_percentage numeric,
    total_premium numeric,
    main_agent_commission_percentage numeric,
    commission_amount numeric,
    tds_percentage numeric,
    tds_amount numeric,
    after_tds_value numeric,
    policy_type character varying,
    installment_autopay_start_date date,
    installment_autopay_end_date date,
    notification_dates text,
    is_customer_added boolean DEFAULT false,
    is_agent_added boolean DEFAULT false,
    is_admin_added boolean DEFAULT false,
    product_through_dr boolean DEFAULT true,
    main_agent_commission_received boolean DEFAULT false,
    main_agent_commission_transaction_id character varying,
    main_agent_commission_paid_date date,
    main_agent_commission_notes text,
    lead_id character varying,
    distributor_id bigint,
    investor_id bigint,
    ambassador_commission_percentage numeric,
    ambassador_commission_amount numeric,
    ambassador_tds_percentage numeric,
    ambassador_tds_amount numeric,
    ambassador_after_tds_value numeric,
    sub_agent_commission_percentage numeric,
    sub_agent_commission_amount numeric,
    sub_agent_tds_percentage numeric,
    sub_agent_tds_amount numeric,
    sub_agent_after_tds_value numeric,
    investor_commission_percentage numeric,
    investor_commission_amount numeric,
    investor_tds_percentage numeric,
    investor_tds_amount numeric,
    investor_after_tds_value numeric,
    company_expenses_percentage numeric,
    total_distribution_percentage numeric,
    profit_percentage numeric,
    profit_amount numeric,
    policy_added_by_admin boolean DEFAULT false,
    nominee_dob date,
    broker_code_type character varying,
    insurance_company_code character varying,
    main_policy_document_key character varying,
    main_policy_document_filename character varying,
    main_policy_document_content_type character varying,
    main_policy_document_size bigint,
    company_expenses_amount numeric,
    is_renewed boolean DEFAULT false,
    original_policy_id bigint,
    premium_frequency character varying(50),
    status character varying(50),
    start_date date,
    end_date date,
    additional_details text,
    nominee_name character varying(255),
    nominee_relation character varying(100),
    sum_insured_text character varying(255)
);


ALTER TABLE public.health_insurances OWNER TO drwisedb01_user;

--
-- Name: leads; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.leads (
    id bigint NOT NULL,
    name character varying,
    contact_number character varying,
    email character varying,
    referred_by character varying,
    product_interest character varying,
    current_stage character varying,
    created_date date,
    note text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    lead_id character varying,
    address text,
    city character varying,
    state character varying,
    lead_source character varying,
    call_disposition character varying,
    referral_amount numeric(10,2) DEFAULT 0.0,
    transferred_amount boolean DEFAULT false,
    notes text,
    attachments text,
    stage_updated_at timestamp(6) without time zone,
    converted_customer_id integer,
    policy_created_id integer,
    product_category character varying,
    product_subcategory character varying,
    is_direct boolean DEFAULT true,
    affiliate_id integer,
    first_name character varying,
    middle_name character varying,
    last_name character varying,
    birth_date date,
    gender character varying,
    pan_no character varying,
    gst_no character varying,
    company_name character varying,
    marital_status character varying,
    height character varying,
    weight character varying,
    birth_place character varying,
    education character varying,
    business_job character varying,
    business_name character varying,
    job_name character varying,
    occupation character varying,
    type_of_duty character varying,
    annual_income numeric,
    additional_information text,
    height_feet numeric(3,1),
    weight_kg numeric(5,1),
    business_job_type character varying,
    business_job_name character varying,
    duty_type character varying,
    is_branch_out boolean DEFAULT false,
    ambassador_id integer,
    customer_type character varying DEFAULT 'individual'::character varying,
    parent_lead_id integer
);


ALTER TABLE public.leads OWNER TO drwisedb01_user;

--
-- Name: life_insurances; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.life_insurances (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    sub_agent_id bigint,
    policy_holder character varying NOT NULL,
    insured_name character varying,
    insurance_company_name character varying NOT NULL,
    agency_code_id bigint,
    broker_id bigint,
    policy_type character varying NOT NULL,
    payment_mode character varying NOT NULL,
    policy_number character varying NOT NULL,
    policy_booking_date date,
    policy_start_date date NOT NULL,
    policy_end_date date NOT NULL,
    risk_start_date date,
    policy_term integer NOT NULL,
    premium_payment_term integer NOT NULL,
    plan_name character varying,
    sum_insured numeric(15,2) NOT NULL,
    net_premium numeric(15,2) NOT NULL,
    first_year_gst_percentage numeric(5,2) DEFAULT 18.0,
    second_year_gst_percentage numeric(5,2) DEFAULT 0.0,
    third_year_gst_percentage numeric(5,2) DEFAULT 0.0,
    total_premium numeric(15,2) NOT NULL,
    term_rider_amount numeric(15,2) DEFAULT 0.0,
    term_rider_note text,
    critical_illness_rider_amount numeric(15,2) DEFAULT 0.0,
    critical_illness_rider_note text,
    accident_rider_amount numeric(15,2) DEFAULT 0.0,
    accident_rider_note text,
    pwb_rider_amount numeric(15,2) DEFAULT 0.0,
    pwb_rider_note text,
    other_rider_amount numeric(15,2) DEFAULT 0.0,
    other_rider_note text,
    nominee_name character varying,
    nominee_relationship character varying,
    nominee_age integer,
    bank_name character varying,
    account_type character varying,
    account_number character varying,
    ifsc_code character varying,
    account_holder_name character varying,
    reference_by_name character varying,
    broker_name character varying,
    bonus numeric(15,2) DEFAULT 0.0,
    fund numeric(15,2) DEFAULT 0.0,
    extra_note text,
    main_agent_commission_percentage numeric(5,2) DEFAULT 0.0,
    commission_amount numeric(15,2) DEFAULT 0.0,
    tds_percentage numeric(5,2) DEFAULT 0.0,
    tds_amount numeric(15,2) DEFAULT 0.0,
    after_tds_value numeric(15,2) DEFAULT 0.0,
    installment_autopay_start_date date,
    installment_autopay_end_date date,
    active boolean DEFAULT true,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    notification_dates text,
    is_customer_added boolean DEFAULT false,
    is_agent_added boolean DEFAULT false,
    is_admin_added boolean DEFAULT false,
    distributor_id bigint,
    investor_id bigint,
    sub_agent_commission_percentage numeric(5,2) DEFAULT 2.0,
    sub_agent_commission_amount numeric(10,2),
    distributor_commission_percentage numeric(5,2) DEFAULT 1.0,
    distributor_commission_amount numeric(10,2),
    investor_commission_percentage numeric(5,2) DEFAULT 2.0,
    investor_commission_amount numeric(10,2),
    main_income_percentage numeric(5,2) DEFAULT 10.0,
    main_income_amount numeric(10,2),
    total_distribution_percentage numeric(5,2),
    company_expenses_percentage numeric(5,2),
    profit_percentage numeric(5,2),
    profit_amount numeric(10,2),
    sub_agent_tds_percentage numeric(5,2) DEFAULT 0.0,
    sub_agent_tds_amount numeric(10,2),
    sub_agent_after_tds_value numeric(10,2),
    distributor_tds_percentage numeric(5,2) DEFAULT 0.0,
    distributor_tds_amount numeric(10,2),
    distributor_after_tds_value numeric(10,2),
    investor_tds_percentage numeric(5,2) DEFAULT 0.0,
    investor_tds_amount numeric(10,2),
    investor_after_tds_value numeric(10,2),
    product_through_dr boolean DEFAULT true,
    main_agent_commission_received boolean DEFAULT false,
    main_agent_commission_transaction_id character varying,
    main_agent_commission_paid_date date,
    main_agent_commission_notes text,
    lead_id character varying,
    ambassador_commission_percentage numeric,
    ambassador_commission_amount numeric,
    ambassador_tds_percentage numeric,
    ambassador_tds_amount numeric,
    ambassador_after_tds_value numeric,
    broker_code_type character varying,
    policy_added_by_admin boolean DEFAULT false,
    original_policy_id integer,
    renewal_policy_id integer,
    is_renewed boolean DEFAULT false NOT NULL,
    insurance_company_code character varying,
    main_policy_document_key character varying,
    main_policy_document_filename character varying,
    main_policy_document_content_type character varying,
    main_policy_document_size bigint
);


ALTER TABLE public.life_insurances OWNER TO drwisedb01_user;

--
-- Name: motor_insurances; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.motor_insurances (
    id bigint NOT NULL,
    vehicle_type character varying,
    class_of_vehicle character varying,
    registration_number character varying,
    registration_date date,
    engine_number character varying,
    chassis_number character varying,
    mfy integer,
    make character varying,
    model character varying,
    variant character varying,
    seating_capacity integer,
    discount_loading_percent numeric,
    previous_policy_number character varying,
    ncb character varying,
    legal_liability character varying,
    electrical_accessories character varying,
    non_electrical_accessories character varying,
    zero_depreciation boolean,
    roadside_assistance boolean,
    engine_protector boolean,
    key_replacement boolean,
    return_to_invoice boolean,
    consumable_cover boolean,
    personal_accident_cover boolean,
    financier character varying,
    vehicle_idv numeric,
    cng_idv numeric,
    total_idv numeric,
    tp_premium numeric,
    payout_od numeric,
    payout_tp numeric,
    payout_net numeric,
    main_agent_commission_percent numeric,
    main_agent_commission_amount numeric,
    main_agent_tds_percent numeric,
    main_agent_tds_amount numeric,
    broker_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    notification_dates text,
    policy_end_date date,
    policy_start_date date,
    policy_booking_date date,
    insurance_company_name character varying,
    policy_holder character varying,
    policy_type character varying,
    gst_percentage numeric(8,2) DEFAULT 18.0,
    net_premium numeric(10,2),
    gst_amount numeric(10,2),
    after_tds_value numeric(10,2),
    is_customer_added boolean DEFAULT false,
    is_agent_added boolean DEFAULT false,
    is_admin_added boolean DEFAULT false,
    reference_by_name character varying,
    extra_note text,
    customer_id bigint NOT NULL,
    sub_agent_id bigint,
    agency_code_id bigint,
    broker_id bigint,
    insurance_type character varying,
    total_premium numeric(10,2),
    policy_number character varying,
    sum_insured numeric,
    status boolean,
    product_through_dr boolean DEFAULT false,
    main_agent_commission_received boolean DEFAULT false,
    main_agent_commission_transaction_id character varying,
    main_agent_commission_paid_date date,
    main_agent_commission_notes text,
    lead_id character varying,
    distributor_id bigint,
    investor_id bigint,
    sub_agent_commission_percentage numeric(8,2),
    sub_agent_commission_amount numeric(12,2),
    sub_agent_tds_percentage numeric(8,2),
    sub_agent_tds_amount numeric(12,2),
    sub_agent_after_tds_value numeric(12,2),
    distributor_commission_percentage numeric(8,2),
    distributor_commission_amount numeric(12,2),
    distributor_tds_percentage numeric(8,2),
    distributor_tds_amount numeric(12,2),
    distributor_after_tds_value numeric(12,2),
    investor_commission_percentage numeric(8,2),
    investor_commission_amount numeric(12,2),
    investor_tds_percentage numeric(8,2),
    investor_tds_amount numeric(12,2),
    investor_after_tds_value numeric(12,2),
    ambassador_commission_percentage numeric(8,2),
    ambassador_commission_amount numeric(12,2),
    ambassador_tds_percentage numeric(8,2),
    ambassador_tds_amount numeric(12,2),
    ambassador_after_tds_value numeric(12,2),
    total_distribution_percentage numeric(8,2),
    company_expenses_percentage numeric(8,2),
    profit_percentage numeric(8,2),
    profit_amount numeric(12,2),
    commission_amount numeric(12,2),
    tds_percentage numeric(8,2),
    tds_amount numeric(12,2),
    main_agent_commission_percentage numeric(8,2),
    policy_added_by_admin boolean DEFAULT false,
    payment_mode character varying,
    plan_name character varying,
    broker_code_type character varying,
    installment_autopay_start_date date,
    installment_autopay_end_date date,
    nominee_name character varying,
    nominee_relation character varying,
    nominee_dob date,
    insurance_company_code character varying,
    company_expenses_amount numeric,
    main_policy_document_key character varying,
    main_policy_document_filename character varying,
    main_policy_document_content_type character varying,
    main_policy_document_size bigint,
    main_policy_document_url character varying,
    vehicle_number character varying(255),
    vehicle_make character varying(255),
    vehicle_model character varying(255)
);


ALTER TABLE public.motor_insurances OWNER TO drwisedb01_user;

--
-- Name: sub_agents; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.sub_agents (
    id bigint NOT NULL,
    first_name character varying NOT NULL,
    middle_name character varying,
    last_name character varying NOT NULL,
    mobile character varying NOT NULL,
    email character varying NOT NULL,
    role_id integer NOT NULL,
    state_id integer,
    city_id integer,
    birth_date date,
    gender character varying,
    pan_no character varying,
    gst_no character varying,
    company_name character varying,
    address text,
    bank_name character varying,
    account_no character varying,
    ifsc_code character varying,
    account_holder_name character varying,
    account_type character varying,
    upi_id character varying,
    status integer DEFAULT 0,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    password_digest character varying,
    distributor_id bigint,
    plain_password character varying,
    original_password character varying,
    password_reset_at timestamp(6) without time zone,
    deactivated boolean DEFAULT false,
    city character varying,
    state character varying
);


ALTER TABLE public.sub_agents OWNER TO drwisedb01_user;

--
-- Name: dashboard_stats_view; Type: MATERIALIZED VIEW; Schema: public; Owner: drwisedb01_user
--

CREATE MATERIALIZED VIEW public.dashboard_stats_view AS
 WITH date_ranges AS (
         SELECT CURRENT_DATE AS today,
            (CURRENT_DATE + '30 days'::interval) AS future_30,
            date_trunc('month'::text, (CURRENT_DATE)::timestamp with time zone) AS current_month_start,
            date_trunc('month'::text, (CURRENT_DATE - '1 mon'::interval)) AS last_month_start,
            ((date_trunc('month'::text, (CURRENT_DATE - '1 mon'::interval)) + '1 mon'::interval) - '1 day'::interval) AS last_month_end
        ), affiliates_with_policies AS (
         SELECT DISTINCT sa.id
           FROM public.sub_agents sa
          WHERE (EXISTS ( SELECT 1
                   FROM public.health_insurances hi
                  WHERE (hi.sub_agent_id = sa.id)
                UNION
                 SELECT 1
                   FROM public.life_insurances li
                  WHERE (li.sub_agent_id = sa.id)
                UNION
                 SELECT 1
                   FROM public.motor_insurances mi
                  WHERE (mi.sub_agent_id = sa.id)))
        )
 SELECT now() AS calculated_at,
    ( SELECT count(*) AS count
           FROM public.customers) AS total_customers,
    ( SELECT count(*) AS count
           FROM public.customers
          WHERE (customers.status = true)) AS active_customers,
    ( SELECT count(*) AS count
           FROM public.customers
          WHERE (customers.created_at >= ( SELECT date_ranges.current_month_start
                   FROM date_ranges))) AS customers_this_month,
    ( SELECT count(*) AS count
           FROM public.leads) AS total_leads,
    ( SELECT count(*) AS count
           FROM public.leads
          WHERE ((leads.current_stage)::text = 'converted'::text)) AS converted_leads,
    ( SELECT count(*) AS count
           FROM public.leads
          WHERE ((leads.current_stage)::text = ANY ((ARRAY['lead_generated'::character varying, 'follow_up'::character varying, 'follow_up_successful'::character varying, 'consultation_scheduled'::character varying, 'one_on_one'::character varying])::text[]))) AS pending_leads,
    ( SELECT count(*) AS count
           FROM affiliates_with_policies) AS total_affiliates,
    ( SELECT count(*) AS count
           FROM public.sub_agents
          WHERE (sub_agents.status = 0)) AS active_sub_agents,
    ( SELECT count(*) AS count
           FROM public.distributors) AS total_distributors,
    ( SELECT count(*) AS count
           FROM public.health_insurances) AS health_insurance_count,
    ( SELECT COALESCE(sum(health_insurances.total_premium), (0)::numeric) AS "coalesce"
           FROM public.health_insurances) AS health_premium_total,
    ( SELECT COALESCE(sum(health_insurances.sum_insured), (0)::numeric) AS "coalesce"
           FROM public.health_insurances) AS health_sum_insured,
    ( SELECT count(*) AS count
           FROM public.health_insurances
          WHERE (health_insurances.policy_end_date >= CURRENT_DATE)) AS health_active,
    ( SELECT count(*) AS count
           FROM public.health_insurances
          WHERE (health_insurances.policy_end_date < CURRENT_DATE)) AS health_expired,
    ( SELECT count(*) AS count
           FROM public.health_insurances
          WHERE ((health_insurances.policy_end_date >= CURRENT_DATE) AND (health_insurances.policy_end_date <= (CURRENT_DATE + '30 days'::interval)))) AS health_expiring,
    ( SELECT count(*) AS count
           FROM public.life_insurances) AS life_insurance_count,
    ( SELECT COALESCE(sum(life_insurances.total_premium), (0)::numeric) AS "coalesce"
           FROM public.life_insurances) AS life_premium_total,
    ( SELECT COALESCE(sum(life_insurances.sum_insured), (0)::numeric) AS "coalesce"
           FROM public.life_insurances) AS life_sum_insured,
    ( SELECT count(*) AS count
           FROM public.life_insurances
          WHERE (life_insurances.policy_end_date >= CURRENT_DATE)) AS life_active,
    ( SELECT count(*) AS count
           FROM public.life_insurances
          WHERE (life_insurances.policy_end_date < CURRENT_DATE)) AS life_expired,
    ( SELECT count(*) AS count
           FROM public.life_insurances
          WHERE ((life_insurances.policy_end_date >= CURRENT_DATE) AND (life_insurances.policy_end_date <= (CURRENT_DATE + '30 days'::interval)))) AS life_expiring,
    ( SELECT COALESCE(sum(commission_payouts.payout_amount), (0)::numeric) AS "coalesce"
           FROM public.commission_payouts
          WHERE ((commission_payouts.status)::text = 'pending'::text)) AS commission_pending,
    ( SELECT COALESCE(sum(commission_payouts.payout_amount), (0)::numeric) AS "coalesce"
           FROM public.commission_payouts
          WHERE ((commission_payouts.status)::text = 'paid'::text)) AS commission_paid,
    ( SELECT COALESCE(sum(commission_payouts.payout_amount), (0)::numeric) AS "coalesce"
           FROM public.commission_payouts) AS commission_total
  WITH NO DATA;


ALTER MATERIALIZED VIEW public.dashboard_stats_view OWNER TO drwisedb01_user;

--
-- Name: distributor_assignments; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.distributor_assignments (
    id bigint NOT NULL,
    distributor_id bigint NOT NULL,
    sub_agent_id bigint NOT NULL,
    assigned_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.distributor_assignments OWNER TO drwisedb01_user;

--
-- Name: distributor_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.distributor_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.distributor_assignments_id_seq OWNER TO drwisedb01_user;

--
-- Name: distributor_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.distributor_assignments_id_seq OWNED BY public.distributor_assignments.id;


--
-- Name: distributor_documents; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.distributor_documents (
    id bigint NOT NULL,
    distributor_id bigint NOT NULL,
    document_type character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    r2_file_key character varying,
    r2_filename character varying,
    r2_content_type character varying,
    r2_file_size bigint
);


ALTER TABLE public.distributor_documents OWNER TO drwisedb01_user;

--
-- Name: distributor_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.distributor_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.distributor_documents_id_seq OWNER TO drwisedb01_user;

--
-- Name: distributor_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.distributor_documents_id_seq OWNED BY public.distributor_documents.id;


--
-- Name: distributor_payouts; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.distributor_payouts (
    id bigint NOT NULL,
    distributor_id bigint NOT NULL,
    policy_type character varying,
    policy_id integer,
    payout_amount numeric(10,2),
    payout_date date,
    status character varying DEFAULT 'pending'::character varying,
    transaction_id character varying,
    payment_mode character varying,
    reference_number character varying,
    notes text,
    processed_by character varying,
    processed_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    invoiced boolean DEFAULT false
);


ALTER TABLE public.distributor_payouts OWNER TO drwisedb01_user;

--
-- Name: distributor_payouts_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.distributor_payouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.distributor_payouts_id_seq OWNER TO drwisedb01_user;

--
-- Name: distributor_payouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.distributor_payouts_id_seq OWNED BY public.distributor_payouts.id;


--
-- Name: distributors_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.distributors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.distributors_id_seq OWNER TO drwisedb01_user;

--
-- Name: distributors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.distributors_id_seq OWNED BY public.distributors.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.documents (
    id bigint NOT NULL,
    document_type character varying,
    documentable_type character varying NOT NULL,
    documentable_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    title character varying,
    description text,
    uploaded_by character varying,
    r2_file_key character varying,
    r2_filename character varying,
    r2_content_type character varying,
    r2_file_size bigint
);


ALTER TABLE public.documents OWNER TO drwisedb01_user;

--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.documents_id_seq OWNER TO drwisedb01_user;

--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: family_members; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.family_members (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    first_name character varying,
    birth_date date,
    age integer,
    height character varying,
    weight character varying,
    gender character varying,
    relationship character varying,
    pan_no character varying,
    mobile character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    middle_name character varying,
    last_name character varying,
    height_feet character varying,
    weight_kg numeric(5,2),
    additional_information text
);


ALTER TABLE public.family_members OWNER TO drwisedb01_user;

--
-- Name: family_members_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.family_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.family_members_id_seq OWNER TO drwisedb01_user;

--
-- Name: family_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.family_members_id_seq OWNED BY public.family_members.id;


--
-- Name: health_insurance_documents; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.health_insurance_documents (
    id bigint NOT NULL,
    health_insurance_id bigint NOT NULL,
    document_type character varying,
    title character varying,
    description text,
    r2_file_key character varying,
    r2_filename character varying,
    r2_content_type character varying,
    r2_file_size bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.health_insurance_documents OWNER TO drwisedb01_user;

--
-- Name: health_insurance_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.health_insurance_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.health_insurance_documents_id_seq OWNER TO drwisedb01_user;

--
-- Name: health_insurance_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.health_insurance_documents_id_seq OWNED BY public.health_insurance_documents.id;


--
-- Name: health_insurance_members; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.health_insurance_members (
    id bigint NOT NULL,
    health_insurance_id bigint NOT NULL,
    member_name character varying,
    age integer,
    relationship character varying,
    sum_insured numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.health_insurance_members OWNER TO drwisedb01_user;

--
-- Name: health_insurance_members_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.health_insurance_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.health_insurance_members_id_seq OWNER TO drwisedb01_user;

--
-- Name: health_insurance_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.health_insurance_members_id_seq OWNED BY public.health_insurance_members.id;


--
-- Name: health_insurance_nominees; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.health_insurance_nominees (
    id bigint NOT NULL,
    health_insurance_id bigint NOT NULL,
    nominee_name character varying,
    relationship character varying,
    age integer,
    share_percentage numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.health_insurance_nominees OWNER TO drwisedb01_user;

--
-- Name: health_insurance_nominees_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.health_insurance_nominees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.health_insurance_nominees_id_seq OWNER TO drwisedb01_user;

--
-- Name: health_insurance_nominees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.health_insurance_nominees_id_seq OWNED BY public.health_insurance_nominees.id;


--
-- Name: health_insurances_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.health_insurances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.health_insurances_id_seq OWNER TO drwisedb01_user;

--
-- Name: health_insurances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.health_insurances_id_seq OWNED BY public.health_insurances.id;


--
-- Name: helpdesk_tickets; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.helpdesk_tickets (
    id bigint NOT NULL,
    ticket_number character varying,
    subject character varying,
    description text,
    status character varying,
    priority character varying,
    category character varying,
    submitter_type character varying,
    submitter_id integer,
    assigned_to integer,
    resolution_notes text,
    resolved_at timestamp(6) without time zone,
    sub_agent_id bigint NOT NULL,
    customer_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.helpdesk_tickets OWNER TO drwisedb01_user;

--
-- Name: helpdesk_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.helpdesk_tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.helpdesk_tickets_id_seq OWNER TO drwisedb01_user;

--
-- Name: helpdesk_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.helpdesk_tickets_id_seq OWNED BY public.helpdesk_tickets.id;


--
-- Name: insurance_companies; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.insurance_companies (
    id bigint NOT NULL,
    name character varying,
    status boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    code character varying,
    contact_person character varying,
    email character varying,
    mobile character varying,
    address text,
    insurance_type character varying
);


ALTER TABLE public.insurance_companies OWNER TO drwisedb01_user;

--
-- Name: insurance_companies_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.insurance_companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.insurance_companies_id_seq OWNER TO drwisedb01_user;

--
-- Name: insurance_companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.insurance_companies_id_seq OWNED BY public.insurance_companies.id;


--
-- Name: investments; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.investments (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    investment_type character varying,
    product_name character varying,
    investment_amount numeric,
    status boolean,
    investment_date date,
    maturity_date date,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.investments OWNER TO drwisedb01_user;

--
-- Name: investments_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.investments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.investments_id_seq OWNER TO drwisedb01_user;

--
-- Name: investments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.investments_id_seq OWNED BY public.investments.id;


--
-- Name: investor_documents; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.investor_documents (
    id bigint NOT NULL,
    investor_id bigint NOT NULL,
    document_type character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    r2_file_key character varying,
    r2_filename character varying,
    r2_content_type character varying,
    r2_file_size bigint
);


ALTER TABLE public.investor_documents OWNER TO drwisedb01_user;

--
-- Name: investor_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.investor_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.investor_documents_id_seq OWNER TO drwisedb01_user;

--
-- Name: investor_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.investor_documents_id_seq OWNED BY public.investor_documents.id;


--
-- Name: investors; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.investors (
    id bigint NOT NULL,
    first_name character varying NOT NULL,
    middle_name character varying,
    last_name character varying NOT NULL,
    mobile character varying NOT NULL,
    email character varying NOT NULL,
    role_id integer NOT NULL,
    state character varying,
    city character varying,
    birth_date date,
    gender character varying,
    pan_no character varying,
    gst_no character varying,
    company_name character varying,
    address text,
    bank_name character varying,
    account_no character varying,
    ifsc_code character varying,
    account_holder_name character varying,
    account_type character varying,
    upi_id character varying,
    status integer DEFAULT 0,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    password_digest character varying,
    username character varying,
    original_password character varying,
    invested_amount numeric,
    investment_percentage numeric,
    main_document_key character varying,
    main_document_filename character varying,
    main_document_content_type character varying,
    main_document_size bigint,
    number_of_shares integer
);


ALTER TABLE public.investors OWNER TO drwisedb01_user;

--
-- Name: investors_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.investors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.investors_id_seq OWNER TO drwisedb01_user;

--
-- Name: investors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.investors_id_seq OWNED BY public.investors.id;


--
-- Name: invoice_items; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.invoice_items (
    id bigint NOT NULL,
    invoice_id bigint NOT NULL,
    payout_type character varying,
    payout_id integer,
    description character varying,
    amount numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.invoice_items OWNER TO drwisedb01_user;

--
-- Name: invoice_items_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.invoice_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invoice_items_id_seq OWNER TO drwisedb01_user;

--
-- Name: invoice_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.invoice_items_id_seq OWNED BY public.invoice_items.id;


--
-- Name: invoices; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.invoices (
    id bigint NOT NULL,
    invoice_number character varying NOT NULL,
    payout_type character varying NOT NULL,
    payout_id integer NOT NULL,
    total_amount numeric(10,2) NOT NULL,
    status character varying DEFAULT 'pending'::character varying NOT NULL,
    invoice_date date NOT NULL,
    due_date date NOT NULL,
    paid_at timestamp(6) without time zone,
    recipient_name character varying,
    recipient_email character varying,
    recipient_address text,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.invoices OWNER TO drwisedb01_user;

--
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.invoices_id_seq OWNER TO drwisedb01_user;

--
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- Name: leads_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.leads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.leads_id_seq OWNER TO drwisedb01_user;

--
-- Name: leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.leads_id_seq OWNED BY public.leads.id;


--
-- Name: life_insurance_bank_details; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.life_insurance_bank_details (
    id bigint NOT NULL,
    life_insurance_id bigint NOT NULL,
    bank_name character varying,
    account_type character varying,
    account_number character varying,
    ifsc_code character varying,
    account_holder_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.life_insurance_bank_details OWNER TO drwisedb01_user;

--
-- Name: life_insurance_bank_details_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.life_insurance_bank_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.life_insurance_bank_details_id_seq OWNER TO drwisedb01_user;

--
-- Name: life_insurance_bank_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.life_insurance_bank_details_id_seq OWNED BY public.life_insurance_bank_details.id;


--
-- Name: life_insurance_documents; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.life_insurance_documents (
    id bigint NOT NULL,
    life_insurance_id bigint NOT NULL,
    document_type character varying,
    document_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.life_insurance_documents OWNER TO drwisedb01_user;

--
-- Name: life_insurance_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.life_insurance_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.life_insurance_documents_id_seq OWNER TO drwisedb01_user;

--
-- Name: life_insurance_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.life_insurance_documents_id_seq OWNED BY public.life_insurance_documents.id;


--
-- Name: life_insurance_nominees; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.life_insurance_nominees (
    id bigint NOT NULL,
    life_insurance_id bigint NOT NULL,
    nominee_name character varying,
    relationship character varying,
    age integer,
    share_percentage numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.life_insurance_nominees OWNER TO drwisedb01_user;

--
-- Name: life_insurance_nominees_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.life_insurance_nominees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.life_insurance_nominees_id_seq OWNER TO drwisedb01_user;

--
-- Name: life_insurance_nominees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.life_insurance_nominees_id_seq OWNED BY public.life_insurance_nominees.id;


--
-- Name: life_insurances_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.life_insurances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.life_insurances_id_seq OWNER TO drwisedb01_user;

--
-- Name: life_insurances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.life_insurances_id_seq OWNED BY public.life_insurances.id;


--
-- Name: loans; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.loans (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    loan_type character varying,
    loan_amount numeric,
    interest_rate numeric,
    loan_term integer,
    emi_amount numeric,
    loan_date date,
    status boolean,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.loans OWNER TO drwisedb01_user;

--
-- Name: loans_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.loans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.loans_id_seq OWNER TO drwisedb01_user;

--
-- Name: loans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.loans_id_seq OWNED BY public.loans.id;


--
-- Name: motor_insurance_documents; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.motor_insurance_documents (
    id bigint NOT NULL,
    motor_insurance_id bigint NOT NULL,
    document_type character varying,
    title character varying,
    description text,
    r2_file_key character varying,
    r2_filename character varying,
    r2_content_type character varying,
    r2_file_size bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    r2_url character varying
);


ALTER TABLE public.motor_insurance_documents OWNER TO drwisedb01_user;

--
-- Name: motor_insurance_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.motor_insurance_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.motor_insurance_documents_id_seq OWNER TO drwisedb01_user;

--
-- Name: motor_insurance_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.motor_insurance_documents_id_seq OWNED BY public.motor_insurance_documents.id;


--
-- Name: motor_insurance_nominees; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.motor_insurance_nominees (
    id bigint NOT NULL,
    motor_insurance_id bigint NOT NULL,
    nominee_name character varying,
    relationship character varying,
    age integer,
    share_percentage numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.motor_insurance_nominees OWNER TO drwisedb01_user;

--
-- Name: motor_insurance_nominees_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.motor_insurance_nominees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.motor_insurance_nominees_id_seq OWNER TO drwisedb01_user;

--
-- Name: motor_insurance_nominees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.motor_insurance_nominees_id_seq OWNED BY public.motor_insurance_nominees.id;


--
-- Name: motor_insurances_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.motor_insurances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.motor_insurances_id_seq OWNER TO drwisedb01_user;

--
-- Name: motor_insurances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.motor_insurances_id_seq OWNED BY public.motor_insurances.id;


--
-- Name: mutual_fund_nominees; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.mutual_fund_nominees (
    id bigint NOT NULL,
    mutual_fund_id bigint NOT NULL,
    nominee_name character varying NOT NULL,
    relationship character varying,
    age integer,
    share_percentage numeric(5,2),
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.mutual_fund_nominees OWNER TO drwisedb01_user;

--
-- Name: mutual_fund_nominees_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.mutual_fund_nominees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mutual_fund_nominees_id_seq OWNER TO drwisedb01_user;

--
-- Name: mutual_fund_nominees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.mutual_fund_nominees_id_seq OWNED BY public.mutual_fund_nominees.id;


--
-- Name: mutual_funds; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.mutual_funds (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    sub_agent_id bigint,
    distributor_id bigint,
    investment_type character varying NOT NULL,
    amount numeric(15,2) NOT NULL,
    fund_name character varying,
    folio_number character varying,
    plan_name character varying,
    start_date date,
    maturity_date date,
    bank_name character varying,
    account_type character varying,
    account_number character varying,
    ifsc_code character varying,
    account_holder_name character varying,
    reference_by_name character varying,
    broker_name character varying,
    bonus numeric(15,2) DEFAULT 0.0,
    fund numeric(15,2) DEFAULT 0.0,
    extra_note text,
    main_agent_commission_percentage numeric(8,2) DEFAULT 0.0,
    commission_amount numeric(15,2) DEFAULT 0.0,
    tds_percentage numeric(8,2) DEFAULT 0.0,
    tds_amount numeric(15,2) DEFAULT 0.0,
    after_tds_value numeric(15,2) DEFAULT 0.0,
    sub_agent_commission_percentage numeric(8,2) DEFAULT 2.0,
    sub_agent_commission_amount numeric(15,2) DEFAULT 0.0,
    sub_agent_tds_percentage numeric(8,2) DEFAULT 0.0,
    sub_agent_tds_amount numeric(15,2) DEFAULT 0.0,
    sub_agent_after_tds_value numeric(15,2) DEFAULT 0.0,
    distributor_commission_percentage numeric(8,2) DEFAULT 0.0,
    distributor_commission_amount numeric(15,2) DEFAULT 0.0,
    distributor_tds_percentage numeric(8,2) DEFAULT 0.0,
    distributor_tds_amount numeric(15,2) DEFAULT 0.0,
    distributor_after_tds_value numeric(15,2) DEFAULT 0.0,
    investor_commission_percentage numeric(8,2) DEFAULT 2.0,
    investor_commission_amount numeric(15,2) DEFAULT 0.0,
    company_expenses_percentage numeric(8,2) DEFAULT 0.0,
    company_expenses_amount numeric(15,2) DEFAULT 0.0,
    total_distribution_percentage numeric(8,2) DEFAULT 0.0,
    profit_percentage numeric(8,2) DEFAULT 0.0,
    profit_amount numeric(15,2) DEFAULT 0.0,
    main_policy_document_key character varying,
    main_policy_document_filename character varying,
    main_policy_document_content_type character varying,
    main_policy_document_size bigint,
    installment_autopay_start_date date,
    installment_autopay_end_date date,
    is_admin_added boolean DEFAULT false,
    is_customer_added boolean DEFAULT false,
    is_agent_added boolean DEFAULT false,
    active boolean DEFAULT true,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.mutual_funds OWNER TO drwisedb01_user;

--
-- Name: mutual_funds_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.mutual_funds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mutual_funds_id_seq OWNER TO drwisedb01_user;

--
-- Name: mutual_funds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.mutual_funds_id_seq OWNED BY public.mutual_funds.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.notifications (
    id bigint NOT NULL,
    recipient_type character varying,
    recipient_id integer,
    notification_type character varying,
    title character varying,
    message text,
    reference_type character varying,
    reference_id integer,
    is_read boolean,
    sent_at timestamp(6) without time zone,
    read_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.notifications OWNER TO drwisedb01_user;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO drwisedb01_user;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: other_insurance_documents; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.other_insurance_documents (
    id bigint NOT NULL,
    other_insurance_id bigint NOT NULL,
    document_type character varying,
    title character varying,
    description text,
    r2_file_key character varying,
    r2_filename character varying,
    r2_content_type character varying,
    r2_file_size bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.other_insurance_documents OWNER TO drwisedb01_user;

--
-- Name: other_insurance_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.other_insurance_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.other_insurance_documents_id_seq OWNER TO drwisedb01_user;

--
-- Name: other_insurance_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.other_insurance_documents_id_seq OWNED BY public.other_insurance_documents.id;


--
-- Name: other_insurance_nominees; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.other_insurance_nominees (
    id bigint NOT NULL,
    other_insurance_id bigint NOT NULL,
    nominee_name character varying,
    relationship character varying,
    age integer,
    share_percentage numeric,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.other_insurance_nominees OWNER TO drwisedb01_user;

--
-- Name: other_insurance_nominees_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.other_insurance_nominees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.other_insurance_nominees_id_seq OWNER TO drwisedb01_user;

--
-- Name: other_insurance_nominees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.other_insurance_nominees_id_seq OWNED BY public.other_insurance_nominees.id;


--
-- Name: other_insurances; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.other_insurances (
    id bigint NOT NULL,
    policy_id bigint,
    other_policy_type character varying,
    main_agent_commission_percent numeric,
    main_agent_commission_amount numeric,
    main_agent_tds_percent numeric,
    main_agent_tds_amount numeric,
    reference_by_name character varying,
    broker_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    notification_dates text,
    policy_end_date date,
    policy_start_date date,
    policy_booking_date date,
    product_through_dr boolean DEFAULT false,
    main_agent_commission_received boolean DEFAULT false,
    main_agent_commission_transaction_id character varying,
    main_agent_commission_paid_date date,
    main_agent_commission_notes text,
    lead_id character varying,
    distributor_id bigint,
    investor_id bigint,
    policy_holder character varying,
    broker_code_type character varying,
    agency_code_id integer,
    broker_id integer,
    gst_percentage numeric,
    payment_mode character varying,
    plan_name character varying,
    policy_term character varying,
    claim_process character varying,
    commission_amount numeric,
    tds_percentage numeric,
    tds_amount numeric,
    after_tds_value numeric,
    sub_agent_commission_percentage numeric,
    sub_agent_commission_amount numeric,
    sub_agent_tds_percentage numeric,
    sub_agent_tds_amount numeric,
    sub_agent_after_tds_value numeric,
    investor_commission_percentage numeric,
    investor_commission_amount numeric,
    investor_tds_percentage numeric,
    investor_tds_amount numeric,
    investor_after_tds_value numeric,
    ambassador_commission_percentage numeric,
    ambassador_commission_amount numeric,
    ambassador_tds_percentage numeric,
    ambassador_tds_amount numeric,
    ambassador_after_tds_value numeric,
    company_expenses_percentage numeric,
    total_distribution_percentage numeric,
    profit_percentage numeric,
    profit_amount numeric,
    installment_autopay_start_date date,
    installment_autopay_end_date date,
    main_agent_commission_percentage numeric,
    policy_type character varying,
    is_customer_added boolean DEFAULT false,
    is_agent_added boolean DEFAULT false,
    is_admin_added boolean DEFAULT false,
    policy_added_by_admin boolean DEFAULT false,
    is_renewed boolean,
    original_policy_id integer,
    insurance_company_code character varying,
    main_policy_document_key character varying,
    main_policy_document_filename character varying,
    main_policy_document_content_type character varying,
    main_policy_document_size bigint,
    company_expenses_amount numeric,
    total_premium numeric(15,2) DEFAULT 0.0,
    net_premium numeric(15,2) DEFAULT 0.0,
    sum_insured numeric(15,2),
    insurance_company_name character varying(255),
    customer_id bigint,
    insurance_type character varying(255),
    sub_agent_id integer,
    policy_number character varying(255)
);


ALTER TABLE public.other_insurances OWNER TO drwisedb01_user;

--
-- Name: other_insurances_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.other_insurances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.other_insurances_id_seq OWNER TO drwisedb01_user;

--
-- Name: other_insurances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.other_insurances_id_seq OWNED BY public.other_insurances.id;


--
-- Name: payout_audit_logs; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.payout_audit_logs (
    id bigint NOT NULL,
    auditable_type character varying,
    auditable_id integer,
    action character varying,
    changes json,
    performed_by character varying,
    ip_address character varying,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.payout_audit_logs OWNER TO drwisedb01_user;

--
-- Name: payout_audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.payout_audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payout_audit_logs_id_seq OWNER TO drwisedb01_user;

--
-- Name: payout_audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.payout_audit_logs_id_seq OWNED BY public.payout_audit_logs.id;


--
-- Name: payout_distributions; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.payout_distributions (
    id bigint NOT NULL,
    commission_receipt_id bigint NOT NULL,
    recipient_type character varying NOT NULL,
    recipient_id integer,
    distribution_percentage numeric(5,2) NOT NULL,
    calculated_amount numeric(10,2) NOT NULL,
    paid_amount numeric(10,2) DEFAULT 0.0,
    pending_amount numeric(10,2) DEFAULT 0.0,
    status character varying DEFAULT 'pending'::character varying,
    payment_date date,
    payment_mode character varying,
    transaction_id character varying,
    reference_number character varying,
    payment_notes text,
    processed_by character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.payout_distributions OWNER TO drwisedb01_user;

--
-- Name: payout_distributions_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.payout_distributions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payout_distributions_id_seq OWNER TO drwisedb01_user;

--
-- Name: payout_distributions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.payout_distributions_id_seq OWNED BY public.payout_distributions.id;


--
-- Name: payouts; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.payouts (
    id bigint NOT NULL,
    policy_type character varying,
    policy_id integer,
    customer_id integer,
    total_commission_amount numeric,
    status character varying,
    payout_date date,
    processed_by character varying,
    processed_at timestamp(6) without time zone,
    notes text,
    reference_number character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    main_agent_percentage numeric(8,2),
    main_agent_commission_amount numeric(10,2),
    main_agent_commission_id integer,
    affiliate_percentage numeric(8,2),
    affiliate_commission_amount numeric(10,2),
    affiliate_commission_id integer,
    ambassador_percentage numeric(8,2),
    ambassador_commission_amount numeric(10,2),
    ambassador_commission_id integer,
    investor_percentage numeric(8,2),
    investor_commission_amount numeric(10,2),
    investor_commission_id integer,
    company_expense_percentage numeric(8,2),
    company_expense_amount numeric(10,2),
    company_expense_commission_id integer,
    commission_summary text,
    net_premium numeric,
    main_agent_commission_received boolean,
    main_agent_commission_transaction_id character varying,
    main_agent_commission_paid_date date,
    main_agent_commission_notes text
);


ALTER TABLE public.payouts OWNER TO drwisedb01_user;

--
-- Name: payouts_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.payouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payouts_id_seq OWNER TO drwisedb01_user;

--
-- Name: payouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.payouts_id_seq OWNED BY public.payouts.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.permissions (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    module_name character varying(50) NOT NULL,
    action_type character varying(20) NOT NULL,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.permissions OWNER TO drwisedb01_user;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permissions_id_seq OWNER TO drwisedb01_user;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: policies; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.policies (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    user_id bigint NOT NULL,
    insurance_company_id bigint NOT NULL,
    agency_broker_id bigint NOT NULL,
    policy_number character varying,
    policy_type character varying,
    insurance_type character varying,
    plan_name character varying,
    payment_mode character varying,
    policy_booking_date date,
    policy_start_date date,
    policy_end_date date,
    policy_term_years integer,
    risk_start_date date,
    sum_insured numeric,
    net_premium numeric,
    gst_percentage numeric,
    total_premium numeric,
    bonus numeric,
    fund numeric,
    note text,
    status boolean,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    policy_holder character varying
);


ALTER TABLE public.policies OWNER TO drwisedb01_user;

--
-- Name: policies_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.policies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.policies_id_seq OWNER TO drwisedb01_user;

--
-- Name: policies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.policies_id_seq OWNED BY public.policies.id;


--
-- Name: policy_documents; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.policy_documents (
    id bigint NOT NULL,
    policy_type character varying NOT NULL,
    policy_id integer NOT NULL,
    document_type character varying NOT NULL,
    title character varying NOT NULL,
    description text,
    uploaded_by character varying,
    r2_file_key character varying,
    r2_filename character varying,
    r2_content_type character varying,
    r2_file_size bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.policy_documents OWNER TO drwisedb01_user;

--
-- Name: policy_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.policy_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.policy_documents_id_seq OWNER TO drwisedb01_user;

--
-- Name: policy_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.policy_documents_id_seq OWNED BY public.policy_documents.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.reports (
    id bigint NOT NULL,
    name character varying,
    report_type character varying,
    filters text,
    report_data text,
    status boolean,
    generated_at timestamp(6) without time zone,
    created_by_id integer,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.reports OWNER TO drwisedb01_user;

--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.reports_id_seq OWNER TO drwisedb01_user;

--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.reports_id_seq OWNED BY public.reports.id;


--
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.role_permissions (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    permission_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.role_permissions OWNER TO drwisedb01_user;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.role_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_permissions_id_seq OWNER TO drwisedb01_user;

--
-- Name: role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.role_permissions_id_seq OWNED BY public.role_permissions.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    status boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.roles OWNER TO drwisedb01_user;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO drwisedb01_user;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO drwisedb01_user;

--
-- Name: session_activities; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.session_activities (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    activity_type character varying,
    occurred_at timestamp(6) without time zone,
    ip_address character varying,
    user_agent text,
    session_id character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.session_activities OWNER TO drwisedb01_user;

--
-- Name: session_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.session_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.session_activities_id_seq OWNER TO drwisedb01_user;

--
-- Name: session_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.session_activities_id_seq OWNED BY public.session_activities.id;


--
-- Name: solid_cache_entries; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.solid_cache_entries (
    id bigint NOT NULL,
    key bytea NOT NULL,
    value bytea NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    key_hash bigint NOT NULL,
    byte_size integer NOT NULL
);


ALTER TABLE public.solid_cache_entries OWNER TO drwisedb01_user;

--
-- Name: solid_cache_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.solid_cache_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_cache_entries_id_seq OWNER TO drwisedb01_user;

--
-- Name: solid_cache_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.solid_cache_entries_id_seq OWNED BY public.solid_cache_entries.id;


--
-- Name: solid_queue_blocked_executions; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.solid_queue_blocked_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    queue_name character varying NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    concurrency_key character varying NOT NULL,
    expires_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_blocked_executions OWNER TO drwisedb01_user;

--
-- Name: solid_queue_blocked_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.solid_queue_blocked_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_blocked_executions_id_seq OWNER TO drwisedb01_user;

--
-- Name: solid_queue_blocked_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.solid_queue_blocked_executions_id_seq OWNED BY public.solid_queue_blocked_executions.id;


--
-- Name: solid_queue_claimed_executions; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.solid_queue_claimed_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    process_id bigint,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_claimed_executions OWNER TO drwisedb01_user;

--
-- Name: solid_queue_claimed_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.solid_queue_claimed_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_claimed_executions_id_seq OWNER TO drwisedb01_user;

--
-- Name: solid_queue_claimed_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.solid_queue_claimed_executions_id_seq OWNED BY public.solid_queue_claimed_executions.id;


--
-- Name: solid_queue_failed_executions; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.solid_queue_failed_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    error text,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_failed_executions OWNER TO drwisedb01_user;

--
-- Name: solid_queue_failed_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.solid_queue_failed_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_failed_executions_id_seq OWNER TO drwisedb01_user;

--
-- Name: solid_queue_failed_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.solid_queue_failed_executions_id_seq OWNED BY public.solid_queue_failed_executions.id;


--
-- Name: solid_queue_jobs; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.solid_queue_jobs (
    id bigint NOT NULL,
    queue_name character varying NOT NULL,
    class_name character varying NOT NULL,
    arguments text,
    priority integer DEFAULT 0 NOT NULL,
    active_job_id character varying,
    scheduled_at timestamp(6) without time zone,
    finished_at timestamp(6) without time zone,
    concurrency_key character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_jobs OWNER TO drwisedb01_user;

--
-- Name: solid_queue_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.solid_queue_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_jobs_id_seq OWNER TO drwisedb01_user;

--
-- Name: solid_queue_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.solid_queue_jobs_id_seq OWNED BY public.solid_queue_jobs.id;


--
-- Name: solid_queue_pauses; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.solid_queue_pauses (
    id bigint NOT NULL,
    queue_name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_pauses OWNER TO drwisedb01_user;

--
-- Name: solid_queue_pauses_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.solid_queue_pauses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_pauses_id_seq OWNER TO drwisedb01_user;

--
-- Name: solid_queue_pauses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.solid_queue_pauses_id_seq OWNED BY public.solid_queue_pauses.id;


--
-- Name: solid_queue_processes; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.solid_queue_processes (
    id bigint NOT NULL,
    kind character varying NOT NULL,
    last_heartbeat_at timestamp(6) without time zone NOT NULL,
    supervisor_id bigint,
    pid integer NOT NULL,
    hostname character varying,
    metadata text,
    created_at timestamp(6) without time zone NOT NULL,
    name character varying NOT NULL
);


ALTER TABLE public.solid_queue_processes OWNER TO drwisedb01_user;

--
-- Name: solid_queue_processes_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.solid_queue_processes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_processes_id_seq OWNER TO drwisedb01_user;

--
-- Name: solid_queue_processes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.solid_queue_processes_id_seq OWNED BY public.solid_queue_processes.id;


--
-- Name: solid_queue_ready_executions; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.solid_queue_ready_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    queue_name character varying NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_ready_executions OWNER TO drwisedb01_user;

--
-- Name: solid_queue_ready_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.solid_queue_ready_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_ready_executions_id_seq OWNER TO drwisedb01_user;

--
-- Name: solid_queue_ready_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.solid_queue_ready_executions_id_seq OWNED BY public.solid_queue_ready_executions.id;


--
-- Name: solid_queue_recurring_executions; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.solid_queue_recurring_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    task_key character varying NOT NULL,
    run_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_recurring_executions OWNER TO drwisedb01_user;

--
-- Name: solid_queue_recurring_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.solid_queue_recurring_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_recurring_executions_id_seq OWNER TO drwisedb01_user;

--
-- Name: solid_queue_recurring_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.solid_queue_recurring_executions_id_seq OWNED BY public.solid_queue_recurring_executions.id;


--
-- Name: solid_queue_recurring_tasks; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.solid_queue_recurring_tasks (
    id bigint NOT NULL,
    key character varying NOT NULL,
    schedule character varying NOT NULL,
    command character varying(2048),
    class_name character varying,
    arguments text,
    queue_name character varying,
    priority integer DEFAULT 0,
    static boolean DEFAULT true NOT NULL,
    description text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_recurring_tasks OWNER TO drwisedb01_user;

--
-- Name: solid_queue_recurring_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.solid_queue_recurring_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_recurring_tasks_id_seq OWNER TO drwisedb01_user;

--
-- Name: solid_queue_recurring_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.solid_queue_recurring_tasks_id_seq OWNED BY public.solid_queue_recurring_tasks.id;


--
-- Name: solid_queue_scheduled_executions; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.solid_queue_scheduled_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    queue_name character varying NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    scheduled_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_scheduled_executions OWNER TO drwisedb01_user;

--
-- Name: solid_queue_scheduled_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.solid_queue_scheduled_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_scheduled_executions_id_seq OWNER TO drwisedb01_user;

--
-- Name: solid_queue_scheduled_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.solid_queue_scheduled_executions_id_seq OWNED BY public.solid_queue_scheduled_executions.id;


--
-- Name: solid_queue_semaphores; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.solid_queue_semaphores (
    id bigint NOT NULL,
    key character varying NOT NULL,
    value integer DEFAULT 1 NOT NULL,
    expires_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.solid_queue_semaphores OWNER TO drwisedb01_user;

--
-- Name: solid_queue_semaphores_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.solid_queue_semaphores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.solid_queue_semaphores_id_seq OWNER TO drwisedb01_user;

--
-- Name: solid_queue_semaphores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.solid_queue_semaphores_id_seq OWNED BY public.solid_queue_semaphores.id;


--
-- Name: sub_agent_documents; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.sub_agent_documents (
    id bigint NOT NULL,
    sub_agent_id bigint NOT NULL,
    document_type character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    r2_file_key character varying,
    r2_filename character varying,
    r2_content_type character varying,
    r2_file_size bigint
);


ALTER TABLE public.sub_agent_documents OWNER TO drwisedb01_user;

--
-- Name: sub_agent_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.sub_agent_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sub_agent_documents_id_seq OWNER TO drwisedb01_user;

--
-- Name: sub_agent_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.sub_agent_documents_id_seq OWNED BY public.sub_agent_documents.id;


--
-- Name: sub_agents_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.sub_agents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sub_agents_id_seq OWNER TO drwisedb01_user;

--
-- Name: sub_agents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.sub_agents_id_seq OWNED BY public.sub_agents.id;


--
-- Name: system_settings; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.system_settings (
    id bigint NOT NULL,
    key character varying NOT NULL,
    value text,
    description text,
    setting_type character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    default_main_agent_commission numeric(5,2),
    default_affiliate_commission numeric(5,2),
    default_ambassador_commission numeric(5,2),
    default_company_expenses numeric(5,2),
    terms_and_conditions text,
    investment_amount numeric(15,2) DEFAULT 0.0,
    company_name character varying,
    company_phone character varying,
    company_email character varying,
    company_address text
);


ALTER TABLE public.system_settings OWNER TO drwisedb01_user;

--
-- Name: system_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.system_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.system_settings_id_seq OWNER TO drwisedb01_user;

--
-- Name: system_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.system_settings_id_seq OWNED BY public.system_settings.id;


--
-- Name: tax_services; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.tax_services (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    service_type character varying,
    financial_year character varying,
    filing_date date,
    amount numeric,
    status boolean,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.tax_services OWNER TO drwisedb01_user;

--
-- Name: tax_services_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.tax_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tax_services_id_seq OWNER TO drwisedb01_user;

--
-- Name: tax_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.tax_services_id_seq OWNED BY public.tax_services.id;


--
-- Name: travel_packages; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.travel_packages (
    id bigint NOT NULL,
    customer_id bigint NOT NULL,
    travel_type character varying,
    destination character varying,
    travel_date date,
    return_date date,
    package_amount numeric,
    status boolean,
    notes text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.travel_packages OWNER TO drwisedb01_user;

--
-- Name: travel_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.travel_packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.travel_packages_id_seq OWNER TO drwisedb01_user;

--
-- Name: travel_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.travel_packages_id_seq OWNED BY public.travel_packages.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.user_roles (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description text,
    status boolean DEFAULT true NOT NULL,
    display_order integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.user_roles OWNER TO drwisedb01_user;

--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_roles_id_seq OWNER TO drwisedb01_user;

--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.user_roles_id_seq OWNED BY public.user_roles.id;


--
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.user_sessions (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    session_id character varying NOT NULL,
    ip_address character varying,
    user_agent text,
    started_at timestamp(6) without time zone NOT NULL,
    ended_at timestamp(6) without time zone,
    duration integer,
    status character varying DEFAULT 'active'::character varying,
    location character varying,
    device_type character varying,
    browser character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


ALTER TABLE public.user_sessions OWNER TO drwisedb01_user;

--
-- Name: user_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.user_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_sessions_id_seq OWNER TO drwisedb01_user;

--
-- Name: user_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.user_sessions_id_seq OWNED BY public.user_sessions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: drwisedb01_user
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    first_name character varying,
    last_name character varying,
    email character varying,
    mobile character varying,
    pan_number character varying,
    gst_number character varying,
    date_of_birth date,
    gender character varying,
    height character varying,
    weight character varying,
    education character varying,
    marital_status character varying,
    occupation character varying,
    job_name character varying,
    type_of_duty character varying,
    annual_income numeric,
    birth_place character varying,
    address character varying,
    state character varying,
    city character varying,
    user_type character varying,
    role character varying,
    status boolean,
    additional_info text,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp(6) without time zone,
    remember_created_at timestamp(6) without time zone,
    role_id bigint,
    user_role_id bigint,
    plain_password character varying,
    original_password character varying,
    sidebar_permissions text,
    role_name character varying,
    password_reset_at timestamp(6) without time zone,
    crud_permissions text
);


ALTER TABLE public.users OWNER TO drwisedb01_user;

--
-- Name: COLUMN users.password_reset_at; Type: COMMENT; Schema: public; Owner: drwisedb01_user
--

COMMENT ON COLUMN public.users.password_reset_at IS 'When password was last reset';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: drwisedb01_user
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO drwisedb01_user;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: drwisedb01_user
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- Name: agency_brokers id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.agency_brokers ALTER COLUMN id SET DEFAULT nextval('public.agency_brokers_id_seq'::regclass);


--
-- Name: agency_codes id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.agency_codes ALTER COLUMN id SET DEFAULT nextval('public.agency_codes_id_seq'::regclass);


--
-- Name: ahoy_events id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.ahoy_events ALTER COLUMN id SET DEFAULT nextval('public.ahoy_events_id_seq'::regclass);


--
-- Name: ahoy_visits id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.ahoy_visits ALTER COLUMN id SET DEFAULT nextval('public.ahoy_visits_id_seq'::regclass);


--
-- Name: ai_report_histories id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.ai_report_histories ALTER COLUMN id SET DEFAULT nextval('public.ai_report_histories_id_seq'::regclass);


--
-- Name: all_policy_reports id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.all_policy_reports ALTER COLUMN id SET DEFAULT nextval('public.all_policy_reports_id_seq'::regclass);


--
-- Name: analytics_caches id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.analytics_caches ALTER COLUMN id SET DEFAULT nextval('public.analytics_caches_id_seq'::regclass);


--
-- Name: appointments id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.appointments ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- Name: banner_documents id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.banner_documents ALTER COLUMN id SET DEFAULT nextval('public.banner_documents_id_seq'::regclass);


--
-- Name: banners id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.banners ALTER COLUMN id SET DEFAULT nextval('public.banners_id_seq'::regclass);


--
-- Name: broker_codes id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.broker_codes ALTER COLUMN id SET DEFAULT nextval('public.broker_codes_id_seq'::regclass);


--
-- Name: brokers id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.brokers ALTER COLUMN id SET DEFAULT nextval('public.brokers_id_seq'::regclass);


--
-- Name: client_requests id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.client_requests ALTER COLUMN id SET DEFAULT nextval('public.client_requests_id_seq'::regclass);


--
-- Name: commission_payouts id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.commission_payouts ALTER COLUMN id SET DEFAULT nextval('public.commission_payouts_id_seq'::regclass);


--
-- Name: commission_receipts id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.commission_receipts ALTER COLUMN id SET DEFAULT nextval('public.commission_receipts_id_seq'::regclass);


--
-- Name: corporate_members id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.corporate_members ALTER COLUMN id SET DEFAULT nextval('public.corporate_members_id_seq'::regclass);


--
-- Name: customer_documents id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.customer_documents ALTER COLUMN id SET DEFAULT nextval('public.customer_documents_id_seq'::regclass);


--
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- Name: distributor_assignments id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.distributor_assignments ALTER COLUMN id SET DEFAULT nextval('public.distributor_assignments_id_seq'::regclass);


--
-- Name: distributor_documents id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.distributor_documents ALTER COLUMN id SET DEFAULT nextval('public.distributor_documents_id_seq'::regclass);


--
-- Name: distributor_payouts id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.distributor_payouts ALTER COLUMN id SET DEFAULT nextval('public.distributor_payouts_id_seq'::regclass);


--
-- Name: distributors id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.distributors ALTER COLUMN id SET DEFAULT nextval('public.distributors_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: family_members id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.family_members ALTER COLUMN id SET DEFAULT nextval('public.family_members_id_seq'::regclass);


--
-- Name: health_insurance_documents id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurance_documents ALTER COLUMN id SET DEFAULT nextval('public.health_insurance_documents_id_seq'::regclass);


--
-- Name: health_insurance_members id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurance_members ALTER COLUMN id SET DEFAULT nextval('public.health_insurance_members_id_seq'::regclass);


--
-- Name: health_insurance_nominees id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurance_nominees ALTER COLUMN id SET DEFAULT nextval('public.health_insurance_nominees_id_seq'::regclass);


--
-- Name: health_insurances id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurances ALTER COLUMN id SET DEFAULT nextval('public.health_insurances_id_seq'::regclass);


--
-- Name: helpdesk_tickets id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.helpdesk_tickets ALTER COLUMN id SET DEFAULT nextval('public.helpdesk_tickets_id_seq'::regclass);


--
-- Name: insurance_companies id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.insurance_companies ALTER COLUMN id SET DEFAULT nextval('public.insurance_companies_id_seq'::regclass);


--
-- Name: investments id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.investments ALTER COLUMN id SET DEFAULT nextval('public.investments_id_seq'::regclass);


--
-- Name: investor_documents id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.investor_documents ALTER COLUMN id SET DEFAULT nextval('public.investor_documents_id_seq'::regclass);


--
-- Name: investors id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.investors ALTER COLUMN id SET DEFAULT nextval('public.investors_id_seq'::regclass);


--
-- Name: invoice_items id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.invoice_items ALTER COLUMN id SET DEFAULT nextval('public.invoice_items_id_seq'::regclass);


--
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- Name: leads id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.leads ALTER COLUMN id SET DEFAULT nextval('public.leads_id_seq'::regclass);


--
-- Name: life_insurance_bank_details id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurance_bank_details ALTER COLUMN id SET DEFAULT nextval('public.life_insurance_bank_details_id_seq'::regclass);


--
-- Name: life_insurance_documents id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurance_documents ALTER COLUMN id SET DEFAULT nextval('public.life_insurance_documents_id_seq'::regclass);


--
-- Name: life_insurance_nominees id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurance_nominees ALTER COLUMN id SET DEFAULT nextval('public.life_insurance_nominees_id_seq'::regclass);


--
-- Name: life_insurances id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurances ALTER COLUMN id SET DEFAULT nextval('public.life_insurances_id_seq'::regclass);


--
-- Name: loans id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.loans ALTER COLUMN id SET DEFAULT nextval('public.loans_id_seq'::regclass);


--
-- Name: motor_insurance_documents id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.motor_insurance_documents ALTER COLUMN id SET DEFAULT nextval('public.motor_insurance_documents_id_seq'::regclass);


--
-- Name: motor_insurance_nominees id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.motor_insurance_nominees ALTER COLUMN id SET DEFAULT nextval('public.motor_insurance_nominees_id_seq'::regclass);


--
-- Name: motor_insurances id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.motor_insurances ALTER COLUMN id SET DEFAULT nextval('public.motor_insurances_id_seq'::regclass);


--
-- Name: mutual_fund_nominees id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.mutual_fund_nominees ALTER COLUMN id SET DEFAULT nextval('public.mutual_fund_nominees_id_seq'::regclass);


--
-- Name: mutual_funds id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.mutual_funds ALTER COLUMN id SET DEFAULT nextval('public.mutual_funds_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: other_insurance_documents id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.other_insurance_documents ALTER COLUMN id SET DEFAULT nextval('public.other_insurance_documents_id_seq'::regclass);


--
-- Name: other_insurance_nominees id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.other_insurance_nominees ALTER COLUMN id SET DEFAULT nextval('public.other_insurance_nominees_id_seq'::regclass);


--
-- Name: other_insurances id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.other_insurances ALTER COLUMN id SET DEFAULT nextval('public.other_insurances_id_seq'::regclass);


--
-- Name: payout_audit_logs id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.payout_audit_logs ALTER COLUMN id SET DEFAULT nextval('public.payout_audit_logs_id_seq'::regclass);


--
-- Name: payout_distributions id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.payout_distributions ALTER COLUMN id SET DEFAULT nextval('public.payout_distributions_id_seq'::regclass);


--
-- Name: payouts id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.payouts ALTER COLUMN id SET DEFAULT nextval('public.payouts_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: policies id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.policies ALTER COLUMN id SET DEFAULT nextval('public.policies_id_seq'::regclass);


--
-- Name: policy_documents id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.policy_documents ALTER COLUMN id SET DEFAULT nextval('public.policy_documents_id_seq'::regclass);


--
-- Name: reports id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.reports ALTER COLUMN id SET DEFAULT nextval('public.reports_id_seq'::regclass);


--
-- Name: role_permissions id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.role_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_permissions_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: session_activities id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.session_activities ALTER COLUMN id SET DEFAULT nextval('public.session_activities_id_seq'::regclass);


--
-- Name: solid_cache_entries id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_cache_entries ALTER COLUMN id SET DEFAULT nextval('public.solid_cache_entries_id_seq'::regclass);


--
-- Name: solid_queue_blocked_executions id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_blocked_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_blocked_executions_id_seq'::regclass);


--
-- Name: solid_queue_claimed_executions id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_claimed_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_claimed_executions_id_seq'::regclass);


--
-- Name: solid_queue_failed_executions id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_failed_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_failed_executions_id_seq'::regclass);


--
-- Name: solid_queue_jobs id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_jobs ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_jobs_id_seq'::regclass);


--
-- Name: solid_queue_pauses id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_pauses ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_pauses_id_seq'::regclass);


--
-- Name: solid_queue_processes id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_processes ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_processes_id_seq'::regclass);


--
-- Name: solid_queue_ready_executions id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_ready_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_ready_executions_id_seq'::regclass);


--
-- Name: solid_queue_recurring_executions id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_recurring_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_recurring_executions_id_seq'::regclass);


--
-- Name: solid_queue_recurring_tasks id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_recurring_tasks ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_recurring_tasks_id_seq'::regclass);


--
-- Name: solid_queue_scheduled_executions id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_scheduled_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_scheduled_executions_id_seq'::regclass);


--
-- Name: solid_queue_semaphores id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_semaphores ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_semaphores_id_seq'::regclass);


--
-- Name: sub_agent_documents id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.sub_agent_documents ALTER COLUMN id SET DEFAULT nextval('public.sub_agent_documents_id_seq'::regclass);


--
-- Name: sub_agents id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.sub_agents ALTER COLUMN id SET DEFAULT nextval('public.sub_agents_id_seq'::regclass);


--
-- Name: system_settings id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.system_settings ALTER COLUMN id SET DEFAULT nextval('public.system_settings_id_seq'::regclass);


--
-- Name: tax_services id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.tax_services ALTER COLUMN id SET DEFAULT nextval('public.tax_services_id_seq'::regclass);


--
-- Name: travel_packages id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.travel_packages ALTER COLUMN id SET DEFAULT nextval('public.travel_packages_id_seq'::regclass);


--
-- Name: user_roles id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN id SET DEFAULT nextval('public.user_roles_id_seq'::regclass);


--
-- Name: user_sessions id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.user_sessions ALTER COLUMN id SET DEFAULT nextval('public.user_sessions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
4	upload_main_document	Distributor	3	4	2026-05-15 09:36:58.557513
5	document_file	SubAgentDocument	1	5	2026-05-15 09:37:59.325459
\.


--
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.active_storage_blobs (id, key, filename, content_type, metadata, service_name, byte_size, checksum, created_at) FROM stdin;
4	00ixhy0guilgjrznm6au6x9j8bk6	Screenshot from 2026-05-03 07-05-17.png	image/png	{"identified":true}	production	53671	q07qtjx6g51/4NCVEqLL1A==	2026-05-15 09:36:58.555087
5	0xn7ticdm83mh6iqe4i117h2vv7i	logo (1).jpeg	image/jpeg	{"identified":true}	production	93663	I8dnvVcepqm3Dx2pMwh7sg==	2026-05-15 09:37:59.322308
6	acm0d0yrpo5l78kn2p62qrzpfw9g	Vijendra Photo.jpeg	image/jpeg	{"identified":true}	production	75852	Pz7tHtbrjJpk/qxfbLqHxw==	2026-05-26 00:06:22.304857
\.


--
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
\.


--
-- Data for Name: agency_brokers; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.agency_brokers (id, broker_name, broker_code, agency_code, status, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: agency_codes; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.agency_codes (id, insurance_type, company_name, agent_name, code, created_at, updated_at, broker_id) FROM stdin;
1	Health Insurance	Star Health and Allied Insurance Company Ltd	BHARATH D	BA0000424798	2026-05-11 10:45:48.612661	2026-05-11 10:45:48.612661	\N
2	Health Insurance	Star Health and Allied Insurance Company Ltd	Nanda Kishore TP	BA0000260748	2026-05-11 10:46:06.491057	2026-05-11 10:46:06.491057	\N
3	Motor and Other Insurance	Tata AIG General Insurance	Murali Krishna Kasibhatta	2771070000	2026-05-11 10:46:27.572089	2026-05-11 10:46:27.572089	\N
4	Health Insurance	Tata AIG General Insurance	Murali Krishna Kasibhatta	2771070000	2026-05-11 10:46:41.577184	2026-05-11 10:46:41.577184	\N
\.


--
-- Data for Name: ahoy_events; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.ahoy_events (id, visit_id, user_id, name, properties, "time") FROM stdin;
\.


--
-- Data for Name: ahoy_visits; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.ahoy_visits (id, visit_token, visitor_token, user_id, ip, user_agent, referrer, referring_domain, landing_page, browser, os, device_type, country, region, city, latitude, longitude, utm_source, utm_medium, utm_term, utm_content, utm_campaign, app_version, os_version, platform, started_at) FROM stdin;
\.


--
-- Data for Name: ai_report_histories; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.ai_report_histories (id, user_id, report_type, filters, ai_insights, confidence_score, generated_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: all_policy_reports; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.all_policy_reports (id, name, policy_type, report_data, created_by_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: analytics_caches; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.analytics_caches (id, cache_identifier, cache_data, last_updated, created_at, updated_at) FROM stdin;
21	main_analytics_v2	{"current_month":"2026-05-01","last_month":"2026-04-01T00:00:00.000Z","current_year":"2026-01-01","last_year":"2025-01-01T00:00:00.000Z","total_customers":19,"total_policies":19,"total_premium":"455055.66","total_affiliates":8,"total_ambassadors":4,"customer_growth":0,"policy_growth":0,"premium_growth":0,"affiliate_growth":0,"policy_distribution":{"Life Insurance":1,"Health Insurance":14,"Motor Insurance":4,"Other Insurance":0},"monthly_trends":{"Jun 2025":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Jul 2025":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Aug 2025":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Sep 2025":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Oct 2025":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Nov 2025":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Dec 2025":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Jan 2026":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Feb 2026":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Mar 2026":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Apr 2026":{"customers":0,"policies":0,"premium":"0.0","leads":0},"May 2026":{"customers":19,"policies":19,"premium":"455055.66","leads":17}},"top_affiliates":[{"id":1,"first_name":"DEVARAJ","last_name":"J","status":"active","policies_count":8},{"id":2,"first_name":"Samparka","last_name":"Association","status":"active","policies_count":7},{"id":3,"first_name":"LOKESH","last_name":"SHIVANNA","status":"active","policies_count":2},{"id":6,"first_name":"Murali Krishna","last_name":"Kasibhatta","status":"active","policies_count":2},{"id":8,"first_name":"SOWMYA","last_name":"H T","status":"active","policies_count":1}],"recent_policies":[{"type":"Life Insurance","customer":"Yogesha  MS","policy_number":"K7676680","premium":74024.0,"date":"2026-05-29T02:39:18.696Z"},{"type":"Motor Insurance","customer":"N  GOPAL","policy_number":"RRERE","premium":323.0,"date":"2026-05-27T10:38:56.557Z"},{"type":"Motor Insurance","customer":"Adithyaa Tanmaoy Kasibhatta","policy_number":"sssdsd","premium":22322.98,"date":"2026-05-27T01:13:12.623Z"},{"type":"Health Insurance","customer":"K Krishna  Prasad","policy_number":"100063248600","premium":9838.0,"date":"2026-05-20T14:05:07.274Z"},{"type":"Health Insurance","customer":"N  GOPAL","policy_number":"REQ-1779018374","premium":23000.0,"date":"2026-05-17T11:46:14.830Z"},{"type":"Life Insurance","customer":"N  GOPAL","policy_number":"REQ-1778988462","premium":2000.0,"date":"2026-05-17T03:27:42.542Z"},{"type":"Health Insurance","customer":"Eswaraiah  Sudha","policy_number":"28000000342787","premium":43056.0,"date":"2026-05-16T11:03:03.336Z"}],"recent_leads":[{"id":23,"name":"DR KRISHNA NAGARAJ","contact_number":"9980639161","email":"krishnainduvalu@yahoo.co.in","referred_by":"","product_interest":null,"current_stage":"consultation_scheduled","created_date":"2026-05-27","note":null,"created_at":"2026-05-27T16:49:42.904Z","updated_at":"2026-05-29T06:31:25.839Z","lead_id":"CUSLEAD-DR KR-ADZPN","address":"","city":"Mandya","state":"karnataka","lead_source":"walk_in","call_disposition":"follow_up","referral_amount":"0.0","transferred_amount":false,"notes":"Created from existing customer: DR KRISHNA  NAGARAJ (ID: 6)","attachments":null,"stage_updated_at":"2026-05-29T06:31:25.839Z","converted_customer_id":null,"policy_created_id":null,"product_category":"investments","product_subcategory":"mutual_fund","is_direct":true,"affiliate_id":null,"first_name":"DR KRISHNA","middle_name":"","last_name":"NAGARAJ","birth_date":"1979-05-28","gender":"male","pan_no":"ADZPN3005G","gst_no":null,"company_name":null,"marital_status":"married","height":"","weight":"","birth_place":"MANDYA","education":"MBBS","business_job":"professional","business_name":"","job_name":"","occupation":"","type_of_duty":"DOCTOR","annual_income":"2500000.0","additional_information":"","height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":true,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":22,"name":"Adithyaa Tanmaoy Kasibhatta","contact_number":"6361404087","email":"adithyaatanmayk@gmail.com","referred_by":"Murali Krishna Kasibhatta","product_interest":null,"current_stage":"converted","created_date":"2026-05-27","note":null,"created_at":"2026-05-27T01:13:12.693Z","updated_at":"2026-05-27T01:13:12.693Z","lead_id":"CUSLEAD-ADI-087-141-MTR","address":"BSK II Stage","city":"Bengaluru Urban","state":"karnataka","lead_source":"agent_referral","call_disposition":null,"referral_amount":"0.0","transferred_amount":false,"notes":"Auto-generated lead from motor insurance policy creation. Policy Number: sssdsd","attachments":null,"stage_updated_at":"2026-05-27T01:13:12.681Z","converted_customer_id":16,"policy_created_id":15,"product_category":"insurance","product_subcategory":"motor","is_direct":false,"affiliate_id":6,"first_name":"Adithyaa","middle_name":"Tanmaoy","last_name":"Kasibhatta","birth_date":"2007-10-14","gender":"male","pan_no":"QQSPK1480E","gst_no":null,"company_name":null,"marital_status":"single","height":null,"weight":null,"birth_place":null,"education":null,"business_job":null,"business_name":null,"job_name":null,"occupation":null,"type_of_duty":null,"annual_income":null,"additional_information":null,"height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":21,"name":" T SHIVANNA ","contact_number":"9743003428","email":"","referred_by":"Friend Reference","product_interest":null,"current_stage":"follow_up","created_date":"2026-05-26","note":null,"created_at":"2026-05-26T13:23:41.093Z","updated_at":"2026-05-26T13:39:15.162Z","lead_id":"CUSLEAD-TXXXX-68187","address":"No 7 ","city":"Banglore ","state":"Karnataka","lead_source":"agent_referral","call_disposition":null,"referral_amount":"0.0","transferred_amount":false,"notes":"","attachments":null,"stage_updated_at":"2026-05-26T13:39:15.162Z","converted_customer_id":null,"policy_created_id":null,"product_category":"insurance","product_subcategory":"motor","is_direct":false,"affiliate_id":3,"first_name":"T","middle_name":null,"last_name":"SHIVANNA","birth_date":null,"gender":null,"pan_no":null,"gst_no":null,"company_name":null,"marital_status":null,"height":null,"weight":null,"birth_place":null,"education":null,"business_job":null,"business_name":null,"job_name":null,"occupation":null,"type_of_duty":null,"annual_income":null,"additional_information":null,"height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":20,"name":"N  GOPAL","contact_number":"9845798137","email":"ngopalg77@gmail.com","referred_by":"Samparka Association","product_interest":null,"current_stage":"converted","created_date":"2026-05-26","note":null,"created_at":"2026-05-26T11:27:04.714Z","updated_at":"2026-05-26T11:27:04.714Z","lead_id":"CUSLEAD-NXX-137-100-MTR","address":null,"city":null,"state":null,"lead_source":"agent_referral","call_disposition":null,"referral_amount":"0.0","transferred_amount":false,"notes":"Auto-generated lead from motor insurance policy creation. Policy Number: xsdsdss","attachments":null,"stage_updated_at":"2026-05-26T11:27:04.701Z","converted_customer_id":5,"policy_created_id":14,"product_category":"insurance","product_subcategory":"motor","is_direct":false,"affiliate_id":2,"first_name":"N","middle_name":null,"last_name":"GOPAL","birth_date":"1977-07-10","gender":"male","pan_no":"ALHPG4776H","gst_no":null,"company_name":null,"marital_status":"married","height":null,"weight":null,"birth_place":null,"education":null,"business_job":null,"business_name":null,"job_name":null,"occupation":null,"type_of_duty":null,"annual_income":null,"additional_information":null,"height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":19,"name":"HANUMANTHA M","contact_number":"9538247661","email":"pradeepdjpradeep16455@gmail.com","referred_by":"VIJENDRA MP","product_interest":null,"current_stage":"converted","created_date":"2026-05-24","note":null,"created_at":"2026-05-26T00:11:49.467Z","updated_at":"2026-05-26T00:42:02.081Z","lead_id":"CUSLEAD-HANUM-AISPH","address":"S/O Marigowda, 230/2, Marchanahalli, Channapatna, Karnataka 562160","city":"Ramanagara","state":"karnataka","lead_source":"agent_referral","call_disposition":"interested","referral_amount":"0.0","transferred_amount":false,"notes":"\\n\\nUpdated: Policy created - 112233 on 2026-05-26","attachments":null,"stage_updated_at":"2026-05-26T00:42:02.070Z","converted_customer_id":22,"policy_created_id":13,"product_category":"insurance","product_subcategory":"motor","is_direct":false,"affiliate_id":8,"first_name":"HANUMANTHA","middle_name":"","last_name":"M","birth_date":"1985-06-15","gender":"male","pan_no":"AISPH0089E","gst_no":null,"company_name":null,"marital_status":"married","height":"","weight":"","birth_place":"","education":"","business_job":"","business_name":"","job_name":"","occupation":"","type_of_duty":"","annual_income":null,"additional_information":"","height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":18,"name":"Krishna Prasad","contact_number":"9150845577","email":"kp@gmail.com","referred_by":"Friend Reference","product_interest":null,"current_stage":"converted","created_date":"2026-05-18","note":null,"created_at":"2026-05-18T02:26:28.990Z","updated_at":"2026-05-20T14:01:29.520Z","lead_id":"CUSLEAD-KRISH-32790","address":"","city":"Bengaluru ","state":"Karnataka","lead_source":"agent_referral","call_disposition":null,"referral_amount":"0.0","transferred_amount":false,"notes":"Financial planning ","attachments":null,"stage_updated_at":"2026-05-20T14:01:29.520Z","converted_customer_id":19,"policy_created_id":null,"product_category":"insurance","product_subcategory":"health","is_direct":false,"affiliate_id":6,"first_name":"Krishna","middle_name":null,"last_name":"Prasad","birth_date":null,"gender":null,"pan_no":null,"gst_no":null,"company_name":null,"marital_status":null,"height":null,"weight":null,"birth_place":null,"education":null,"business_job":null,"business_name":null,"job_name":null,"occupation":null,"type_of_duty":null,"annual_income":null,"additional_information":null,"height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":17,"name":"BASAVARAJ  CHANDRASHEKAR","contact_number":"9720008888","email":"basu2736@gmail.com","referred_by":null,"product_interest":null,"current_stage":"converted","created_date":"2026-05-17","note":null,"created_at":"2026-05-17T13:22:20.550Z","updated_at":"2026-05-17T13:22:20.550Z","lead_id":"CUSLEAD-BAS-888-030-MTR","address":"CVC Farmhouse, Kushtagai Road, Bharat Gas, Bhagyanagar, Koppal","city":"Koppal","state":"karnataka","lead_source":"online","call_disposition":null,"referral_amount":"0.0","transferred_amount":false,"notes":"Auto-generated lead from motor insurance policy creation. Policy Number: REQ-1779024140","attachments":null,"stage_updated_at":"2026-05-17T13:22:20.512Z","converted_customer_id":3,"policy_created_id":12,"product_category":"insurance","product_subcategory":"motor","is_direct":true,"affiliate_id":null,"first_name":"BASAVARAJ","middle_name":null,"last_name":"CHANDRASHEKAR","birth_date":"1992-08-03","gender":"male","pan_no":"AQEPC0330M","gst_no":null,"company_name":null,"marital_status":"married","height":null,"weight":null,"birth_place":null,"education":null,"business_job":null,"business_name":null,"job_name":null,"occupation":null,"type_of_duty":null,"annual_income":null,"additional_information":null,"height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":16,"name":"Geetha Guruwale","contact_number":"6515432866","email":"","referred_by":"Friend Reference","product_interest":null,"current_stage":"one_on_one","created_date":"2026-05-17","note":null,"created_at":"2026-05-17T12:24:15.711Z","updated_at":"2026-05-25T07:15:42.286Z","lead_id":"CUSLEAD-GEETH-91656","address":"","city":"Hyderabad ","state":"telangana","lead_source":"agent_referral","call_disposition":"","referral_amount":"0.0","transferred_amount":false,"notes":"Personal Accident policy","attachments":null,"stage_updated_at":"2026-05-25T07:15:42.287Z","converted_customer_id":null,"policy_created_id":null,"product_category":"insurance","product_subcategory":"other","is_direct":false,"affiliate_id":1,"first_name":"Geetha","middle_name":"","last_name":"Guruwale","birth_date":null,"gender":"","pan_no":"","gst_no":"","company_name":"","marital_status":"","height":"","weight":"","birth_place":"","education":"","business_job":"","business_name":"","job_name":"","occupation":"","type_of_duty":"","annual_income":null,"additional_information":"","height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":15,"name":"M N Nagaveni","contact_number":"9743297766","email":"","referred_by":"Friend Reference","product_interest":null,"current_stage":"consultation_scheduled","created_date":"2026-05-17","note":null,"created_at":"2026-05-17T12:05:42.299Z","updated_at":"2026-05-17T12:06:21.931Z","lead_id":"CUSLEAD-MXXXX-27657","address":"","city":"Bengaluru ","state":"Karnataka","lead_source":"agent_referral","call_disposition":null,"referral_amount":"0.0","transferred_amount":false,"notes":"Family health Insurance ","attachments":null,"stage_updated_at":"2026-05-17T12:06:21.931Z","converted_customer_id":null,"policy_created_id":null,"product_category":"insurance","product_subcategory":"health","is_direct":false,"affiliate_id":2,"first_name":"M","middle_name":null,"last_name":"N Nagaveni","birth_date":null,"gender":null,"pan_no":null,"gst_no":null,"company_name":null,"marital_status":null,"height":null,"weight":null,"birth_place":null,"education":null,"business_job":null,"business_name":null,"job_name":null,"occupation":null,"type_of_duty":null,"annual_income":null,"additional_information":null,"height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":14,"name":"ddf  df","contact_number":"8989191919","email":null,"referred_by":"Test PRamod Bhat","product_interest":null,"current_stage":"converted","created_date":"2026-05-17","note":null,"created_at":"2026-05-17T08:44:45.516Z","updated_at":"2026-05-17T08:44:45.516Z","lead_id":"CUSLEAD-DDF-919-010-MTR-03","address":"dfd","city":"Bengaluru Rural","state":"karnataka","lead_source":"agent_referral","call_disposition":null,"referral_amount":"0.0","transferred_amount":false,"notes":"Auto-generated lead from motor insurance policy creation. Policy Number: ssddsdsdsdsds","attachments":null,"stage_updated_at":"2026-05-17T08:44:45.506Z","converted_customer_id":null,"policy_created_id":11,"product_category":"insurance","product_subcategory":"motor","is_direct":false,"affiliate_id":5,"first_name":"ddf","middle_name":null,"last_name":"df","birth_date":"2026-05-01","gender":"male","pan_no":null,"gst_no":null,"company_name":null,"marital_status":"","height":null,"weight":null,"birth_place":null,"education":null,"business_job":null,"business_name":null,"job_name":null,"occupation":null,"type_of_duty":null,"annual_income":null,"additional_information":null,"height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null}],"commission_summary":{"total_commission_due":"88933.4361","total_commission_paid":"61487.9215","affiliate_commissions":"0.0","ambassador_commissions":"4658.65"},"renewal_analytics":{"expiring_soon":3,"expiring_later":0,"expired":10,"renewal_rate":71.4},"agent_performance":{"Samparka Association":174108.78,"DEVARAJ J":161317.51,"LOKESH SHIVANNA":79526.39,"Murali Krishna Kasibhatta":32160.98,"SOWMYA H T":17942.0},"agent_customer_data":{"Samparka Association":4,"LOKESH SHIVANNA":2,"DEVARAJ J":10,"Murali Krishna Kasibhatta":2,"SOWMYA H T":1},"agent_commission":{"Murali Krishna Kasibhatta":938.3599999999999,"DEVARAJ J":6917.23,"LOKESH SHIVANNA":3181.06,"Samparka Association":7940.41,"SOWMYA H T":5023.76},"commissions_due":88933.4361,"conversion_rate":64.7,"avg_policy_value":23950,"customer_retention":31.6,"lead_conversion_funnel":{"Lead Generated":17,"Consultation Scheduled":16,"One on One":13,"Follow Up":12,"Converted":11},"lead_stage_distribution":{"Lead Generated":1,"Consultation Scheduled":3,"One on One":1,"Follow Up":1,"Follow Up Successful":0,"Follow Up Unsuccessful":0,"Not Interested":0,"Converted":11,"Lead Closed":0},"customer_location":{"Koppal":1,"Ramanagara":1,"Mandya":1,"Bengaluru ":2,"Bangalore":3,"Bengaluru Rural":1,"Mangaluru":1,"Bengaluru Urban":8},"customer_acquisition_trend":{"Jun 2025":0,"Jul 2025":0,"Aug 2025":0,"Sep 2025":0,"Oct 2025":0,"Nov 2025":0,"Dec 2025":0,"Jan 2026":0,"Feb 2026":0,"Mar 2026":0,"Apr 2026":0,"May 2026":19},"premium_revenue_trend":{"Jun 2025":0,"Jul 2025":0,"Aug 2025":0,"Sep 2025":0,"Oct 2025":0,"Nov 2025":0,"Dec 2025":0,"Jan 2026":0,"Feb 2026":0,"Mar 2026":0,"Apr 2026":0,"May 2026":455056},"active_customers":19,"converted_leads":11,"new_leads":5,"support_tickets":5,"docs_pending":0,"claims_processing":0,"client_requests_count":5}	2026-05-29 11:14:51.77923	2026-05-29 06:31:48.325532	2026-05-29 11:14:51.790101
\.


--
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.appointments (id, customer_id, customer_name, customer_email, customer_phone, meeting_agenda, notes, appointment_date, time_slot, status, created_by_id, created_at, updated_at) FROM stdin;
1	16	Adithyaa Tanmaoy Kasibhatta	adithyaatanmayk@gmail.com	6361404087	ass	sa	2026-05-25	11:00 AM	pending	2	2026-05-25 15:25:22.114972	2026-05-25 15:25:22.114972
2	2	YOGESHWARAPPA  K	yogi.slvglass4@gmail.com	9980990027	s	x	2026-05-25	03:30 PM	completed	2	2026-05-25 15:25:47.175795	2026-05-25 15:25:56.788673
3	3	BASAVARAJ  CHANDRASHEKARsdd	basu2736@gmail.com	9720008888	insurance		2026-05-28	03:30 PM	confirmed	2	2026-05-25 15:34:54.477623	2026-05-26 05:33:21.731762
4	\N	RAGHAVENDRA JOSHI			STAR HEALTH	Update on Star Advisor Program.\r\n\r\nDid not come due to other program	2026-05-28	03:00 PM	cancelled	2	2026-05-26 13:28:49.405024	2026-05-28 15:00:26.056395
\.


--
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	production	2026-05-07 10:05:15.806881	2026-05-07 12:45:21.810763
\.


--
-- Data for Name: banner_documents; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.banner_documents (id, banner_id, document_type, title, description, r2_file_key, r2_filename, r2_content_type, r2_file_size, uploaded_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: banners; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.banners (id, title, description, redirect_link, display_start_date, display_end_date, display_location, status, created_at, updated_at, display_order, r2_file_key, r2_filename, r2_content_type, r2_file_size, r2_public_url) FROM stdin;
4	tets	sd		2026-05-17	2026-06-26	dashboard	t	2026-05-17 06:20:42.782885	2026-05-17 06:20:42.782885	1	banners/20260517_062042_8d4fe9f5a4656b43_WhatsApp Image 2026-05-17 at 9.51.47 AM.jpeg	WhatsApp Image 2026-05-17 at 9.51.47 AM.jpeg	image/jpeg	492833	https://pub-5c8ca1934dba43a9bc18041c326adce0.r2.dev/banners/20260517_062042_8d4fe9f5a4656b43_WhatsApp Image 2026-05-17 at 9.51.47 AM.jpeg
\.


--
-- Data for Name: broker_codes; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.broker_codes (id, broker_id, broker_code, company_name, status, created_at, updated_at, agent_name) FROM stdin;
1	1	IP207778	\N	t	2026-05-11 10:40:44.053996	2026-05-11 10:40:44.053996	DEVARAJ J
2	2	DP3730361	\N	t	2026-05-11 10:41:48.707775	2026-05-11 10:41:48.707775	DEVARAJ J
3	3	EI00047921	\N	t	2026-05-11 10:43:02.921737	2026-05-11 10:43:02.921737	LATHA J
4	4	94181	\N	t	2026-05-11 10:44:12.804573	2026-05-11 10:44:12.804573	DEVARAJ J
5	4	BHA35393	\N	t	2026-05-11 10:45:19.624755	2026-05-11 10:45:19.624755	BHARATH D
\.


--
-- Data for Name: brokers; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.brokers (id, name, status, created_at, updated_at, insurance_company_id) FROM stdin;
1	Policy Bazaar	active	2026-05-11 10:40:09.813232	2026-05-11 10:40:09.813232	\N
2	TurtleMint	active	2026-05-11 10:41:28.812533	2026-05-11 10:41:28.812533	\N
3	RenewBuy	active	2026-05-11 10:42:06.864397	2026-05-11 10:42:06.864397	\N
4	Prudent	active	2026-05-11 10:43:56.272725	2026-05-11 10:43:56.272725	\N
\.


--
-- Data for Name: client_requests; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.client_requests (id, ticket_number, name, email, phone_number, description, status, priority, submitted_at, admin_response, resolved_at, resolved_by_id, created_at, updated_at, category, submitter_type, submitter_id, subject, request_type) FROM stdin;
1	TKT-20260515-0001	ddf df	9093939393fdfds@gmail.com	8989191919	Bebe	pending	medium	2026-05-15 14:31:18.736668	\N	\N	\N	2026-05-15 14:31:18.745681	2026-05-15 14:31:18.745681	general	Customer	9	Help Request from ddf df	\N
4	TKT-20260517-0002	Samparka Association	samparka.blr@gmail.com	8296348359	Attend IAP meet next week	pending	medium	2026-05-17 12:02:48.001408	will update reg this	\N	\N	2026-05-17 12:02:48.016889	2026-05-17 12:03:20.91096	general	SubAgent	2	Help Request from Samparka Association	\N
3	TKT-20260517-0001	DEVARAJ J	bittideva@gmail.com	6361760165	Rhrj	in_progress	medium	2026-05-17 04:42:59.438974	kyc	\N	\N	2026-05-17 04:42:59.447755	2026-05-18 03:31:54.030736	general	SubAgent	1	Help Request from DEVARAJ J	\N
5	TKT-20260526-0001	LOKESH SHIVANNA	sirifincorp@gmail.com	9902069391	Revert back to me onthe query of dr krishna 	pending	medium	2026-05-26 14:13:02.571096	Our staff will reach out to you 	\N	\N	2026-05-26 14:13:02.579981	2026-05-26 14:14:35.509998	general	SubAgent	3	Help Request from LOKESH SHIVANNA	\N
2	TKT-20260516-0001	LOKESH SHIVANNA	sirifincorp@gmail.com	9902069391	Hiw to refer a mutual fund client 	in_progress	medium	2026-05-16 11:30:47.913002	In Dr WISE App - add the Client information	\N	\N	2026-05-16 11:30:47.920204	2026-05-28 08:55:20.631998	general	SubAgent	3	Help Request from LOKESH SHIVANNA	\N
\.


--
-- Data for Name: commission_payouts; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.commission_payouts (id, policy_type, policy_id, payout_to, payout_amount, payout_date, status, created_at, updated_at, transaction_id, payment_mode, reference_number, commission_amount_received, distribution_percentage, notes, processed_by, processed_at, payout_id, lead_id, invoiced, total_commission_amount, tds_amount) FROM stdin;
179	health	49	investor	1722.24	2026-06-15	pending	2026-05-16 11:03:03.392871	2026-05-16 11:03:03.392871	\N	bank_transfer	INV_37_1778929383	\N	\N	Investor commission for health policy. Policy Number: 28000000342787	system_auto	\N	37	CUSLEAD-ESWAR-BSRPS	f	\N	\N
180	health	49	company_expense	861.12	2026-06-15	pending	2026-05-16 11:03:03.39588	2026-05-16 11:03:03.39588	\N	internal	COMP_37_1778929383	\N	\N	Company expense allocation for health policy	system_auto	\N	37	CUSLEAD-ESWAR-BSRPS	f	\N	\N
176	health	49	main_agent	5382.0	2026-05-17	paid	2026-05-16 11:03:03.381954	2026-05-17 08:54:32.61168	sdds	bank_transfer	MAIN_37_1778929383	\N	\N	sd	admin@drwise.com	2026-05-17 08:54:32.611147	37	CUSLEAD-ESWAR-BSRPS	f	\N	\N
177	health	49	affiliate	1687.8	2026-05-17	paid	2026-05-16 11:03:03.386809	2026-05-17 08:54:47.944322	sd	bank_transfer	AFF_37_1778929383	\N	\N	ssd	admin@drwise.com	2026-05-17 08:54:47.943667	37	CUSLEAD-ESWAR-BSRPS	f	\N	\N
178	health	49	ambassador	426.25	2026-05-17	paid	2026-05-16 11:03:03.389947	2026-05-17 08:55:05.083888	sd	bank_transfer	AMB_37_1778929383	\N	\N	sd	admin@drwise.com	2026-05-17 08:55:05.083237	37	CUSLEAD-ESWAR-BSRPS	f	\N	\N
195	health	52	company_expense	491.9	2026-06-19	pending	2026-05-20 14:05:07.398996	2026-05-20 14:05:07.398996	\N	internal	COMP_40_1779285907	\N	\N	Company expense allocation for health policy	system_auto	\N	40	CUSLEAD-KRISH-32790	f	\N	\N
16	health	15	main_agent	1095.14	2024-06-15	paid	2026-05-13 01:37:56.071114	2026-05-26 13:54:50.817671	20240615001	bank_transfer	MAIN_4_1778636276	\N	\N	referred by Naga CM	admin@drwise.com	2026-05-26 13:54:50.816618	4	CUSLEAD-CMX-938-280-HLT	f	\N	\N
17	health	15	affiliate	433.49	2026-05-26	paid	2026-05-13 01:37:56.172087	2026-05-26 13:55:52.895889	20240615A001	bank_transfer	AFF_4_1778636276	\N	\N		admin@drwise.com	2026-05-26 13:55:52.89537	4	CUSLEAD-CMX-938-280-HLT	f	\N	\N
18	health	15	ambassador	86.7	2026-05-26	paid	2026-05-13 01:37:56.269248	2026-05-26 13:56:12.495909	20240615B001	bank_transfer	AMB_4_1778636276	\N	\N		admin@drwise.com	2026-05-26 13:56:12.495258	4	CUSLEAD-CMX-938-280-HLT	f	\N	\N
19	health	15	investor	91.26	2026-05-26	paid	2026-05-13 01:37:56.273237	2026-05-26 13:57:20.580842	20240615I001	bank_transfer	INV_4_1778636276	\N	\N		admin@drwise.com	2026-05-26 13:57:20.579851	4	CUSLEAD-CMX-938-280-HLT	f	\N	\N
20	health	15	company_expense	91.2615	2026-05-26	paid	2026-05-13 01:37:56.278096	2026-05-26 13:57:37.057869	20240615C001	internal	COMP_4_1778636276	\N	\N		admin@drwise.com	2026-05-26 13:57:37.057362	4	CUSLEAD-CMX-938-280-HLT	f	\N	\N
196	motor	13	main_agent	7176.8	2026-05-27	paid	2026-05-27 10:29:24.992777	2026-05-28 09:12:30.197639	IN22614707389020	bank_transfer	MAIN_41_1779877764	\N	\N	9671	admin@drwise.com	2026-05-28 09:12:30.197147	41	CUSLEAD-HANUM-AISPH	f	\N	\N
181	health	2	affiliate	1153.0	2026-05-16	pending	2026-05-16 12:13:23.998909	2026-05-16 12:13:23.998909	\N	bank_transfer	AFF_MANUAL_2_1778933603	\N	5.00	Manual: health policy #89557128	admin_manual	\N	\N	CUST-20260511-PSEL8R	f	\N	\N
197	motor	13	affiliate	4994.16	2026-05-28	paid	2026-05-27 10:29:26.703987	2026-05-28 09:14:37.8518	614607299711	bank_transfer	AFF_41_1779877766	\N	\N	5K transferred to Sowmya HT from Krama a/c	admin@drwise.com	2026-05-28 09:14:37.851377	41	CUSLEAD-HANUM-AISPH	f	\N	\N
41	health	27	main_agent	266.9	2026-06-12	pending	2026-05-13 11:25:39.030955	2026-05-13 11:25:39.030955	\N	bank_transfer	MAIN_9_1778671539	\N	\N	Main agent commission for health policy. Policy Number: 90475760	system_auto	\N	9	CUST-20260513-HYC5D3	f	\N	\N
42	health	27	affiliate	84.52	2026-06-12	pending	2026-05-13 11:25:39.03494	2026-05-13 11:25:39.03494	\N	bank_transfer	AFF_9_1778671539	\N	\N	Affiliate commission for health policy. Sub-agent ID: 2	system_auto	\N	9	CUST-20260513-HYC5D3	f	\N	\N
43	health	27	ambassador	21.13	2026-06-12	pending	2026-05-13 11:25:39.03813	2026-05-13 11:25:39.03813	\N	bank_transfer	AMB_9_1778671539	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	9	CUST-20260513-HYC5D3	f	\N	\N
44	health	27	investor	88.97	2026-06-12	pending	2026-05-13 11:25:39.0414	2026-05-13 11:25:39.0414	\N	bank_transfer	INV_9_1778671539	\N	\N	Investor commission for health policy. Policy Number: 90475760	system_auto	\N	9	CUST-20260513-HYC5D3	f	\N	\N
45	health	27	company_expense	44.4838	2026-06-12	pending	2026-05-13 11:25:39.044687	2026-05-13 11:25:39.044687	\N	internal	COMP_9_1778671539	\N	\N	Company expense allocation for health policy	system_auto	\N	9	CUST-20260513-HYC5D3	f	\N	\N
51	health	29	main_agent	1000.0	2026-06-12	pending	2026-05-13 12:35:29.112068	2026-05-13 12:35:29.112068	\N	bank_transfer	MAIN_11_1778675729	\N	\N	Main agent commission for health policy. Policy Number: sd	system_auto	\N	11	CUSLEAD-BAS-888-030-HLT-01	f	\N	\N
52	health	29	affiliate	100.0	2026-06-12	pending	2026-05-13 12:35:29.115563	2026-05-13 12:35:29.115563	\N	bank_transfer	AFF_11_1778675729	\N	\N	Affiliate commission for health policy. Sub-agent ID: 1	system_auto	\N	11	CUSLEAD-BAS-888-030-HLT-01	f	\N	\N
53	health	29	ambassador	300.0	2026-06-12	pending	2026-05-13 12:35:29.118183	2026-05-13 12:35:29.118183	\N	bank_transfer	AMB_11_1778675729	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	11	CUSLEAD-BAS-888-030-HLT-01	f	\N	\N
54	health	29	investor	100.0	2026-06-12	pending	2026-05-13 12:35:29.120985	2026-05-13 12:35:29.120985	\N	bank_transfer	INV_11_1778675729	\N	\N	Investor commission for health policy. Policy Number: sd	system_auto	\N	11	CUSLEAD-BAS-888-030-HLT-01	f	\N	\N
55	health	29	company_expense	200.0	2026-06-12	pending	2026-05-13 12:35:29.123265	2026-05-13 12:35:29.123265	\N	internal	COMP_11_1778675729	\N	\N	Company expense allocation for health policy	system_auto	\N	11	CUSLEAD-BAS-888-030-HLT-01	f	\N	\N
56	health	30	main_agent	3076.2	2026-06-12	pending	2026-05-13 13:44:13.610203	2026-05-13 13:44:13.610203	\N	bank_transfer	MAIN_12_1778679853	\N	\N	Main agent commission for health policy. Policy Number: 89557128	system_auto	\N	12	CUSLEAD-YOG-027-251-HLT	f	\N	\N
57	health	30	affiliate	974.13	2026-06-12	pending	2026-05-13 13:44:13.614711	2026-05-13 13:44:13.614711	\N	bank_transfer	AFF_12_1778679853	\N	\N	Affiliate commission for health policy. Sub-agent ID: 2	system_auto	\N	12	CUSLEAD-YOG-027-251-HLT	f	\N	\N
58	health	30	ambassador	243.53	2026-06-12	pending	2026-05-13 13:44:13.618099	2026-05-13 13:44:13.618099	\N	bank_transfer	AMB_12_1778679853	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	12	CUSLEAD-YOG-027-251-HLT	f	\N	\N
59	health	30	investor	1025.4	2026-06-12	pending	2026-05-13 13:44:13.621413	2026-05-13 13:44:13.621413	\N	bank_transfer	INV_12_1778679853	\N	\N	Investor commission for health policy. Policy Number: 89557128	system_auto	\N	12	CUSLEAD-YOG-027-251-HLT	f	\N	\N
60	health	30	company_expense	512.7	2026-06-12	pending	2026-05-13 13:44:13.624507	2026-05-13 13:44:13.624507	\N	internal	COMP_12_1778679853	\N	\N	Company expense allocation for health policy	system_auto	\N	12	CUSLEAD-YOG-027-251-HLT	f	\N	\N
61	health	31	main_agent	5042.7	2026-06-12	pending	2026-05-13 13:53:04.208938	2026-05-13 13:53:04.208938	\N	bank_transfer	MAIN_13_1778680384	\N	\N	Main agent commission for health policy. Policy Number: 7000288448-00	system_auto	\N	13	CUST-20260511-DGECKX	f	\N	\N
62	health	31	affiliate	1041.43	2026-06-12	pending	2026-05-13 13:53:04.217285	2026-05-13 13:53:04.217285	\N	bank_transfer	AFF_13_1778680384	\N	\N	Affiliate commission for health policy. Sub-agent ID: 1	system_auto	\N	13	CUST-20260511-DGECKX	f	\N	\N
63	health	31	ambassador	208.29	2026-06-12	pending	2026-05-13 13:53:04.220016	2026-05-13 13:53:04.220016	\N	bank_transfer	AMB_13_1778680384	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	13	CUST-20260511-DGECKX	f	\N	\N
64	health	31	investor	1096.24	2026-06-12	pending	2026-05-13 13:53:04.223537	2026-05-13 13:53:04.223537	\N	bank_transfer	INV_13_1778680384	\N	\N	Investor commission for health policy. Policy Number: 7000288448-00	system_auto	\N	13	CUST-20260511-DGECKX	f	\N	\N
65	health	31	company_expense	1096.24	2026-06-12	pending	2026-05-13 13:53:04.227228	2026-05-13 13:53:04.227228	\N	internal	COMP_13_1778680384	\N	\N	Company expense allocation for health policy	system_auto	\N	13	CUST-20260511-DGECKX	f	\N	\N
66	health	32	main_agent	2617.08	2026-06-12	pending	2026-05-13 13:57:30.882916	2026-05-13 13:57:30.882916	\N	bank_transfer	MAIN_14_1778680650	\N	\N	Main agent commission for health policy. Policy Number: 2856 2057 2973 7501 000	system_auto	\N	14	CUST-20260512-BIVWPK	f	\N	\N
67	health	32	affiliate	828.74	2026-06-12	pending	2026-05-13 13:57:30.885239	2026-05-13 13:57:30.885239	\N	bank_transfer	AFF_14_1778680650	\N	\N	Affiliate commission for health policy. Sub-agent ID: 1	system_auto	\N	14	CUST-20260512-BIVWPK	f	\N	\N
68	health	32	ambassador	207.19	2026-06-12	pending	2026-05-13 13:57:30.887513	2026-05-13 13:57:30.887513	\N	bank_transfer	AMB_14_1778680650	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	14	CUST-20260512-BIVWPK	f	\N	\N
69	health	32	investor	872.36	2026-06-12	pending	2026-05-13 13:57:30.889866	2026-05-13 13:57:30.889866	\N	bank_transfer	INV_14_1778680650	\N	\N	Investor commission for health policy. Policy Number: 2856 2057 2973 7501 000	system_auto	\N	14	CUST-20260512-BIVWPK	f	\N	\N
70	health	32	company_expense	436.18	2026-06-12	pending	2026-05-13 13:57:30.892067	2026-05-13 13:57:30.892067	\N	internal	COMP_14_1778680650	\N	\N	Company expense allocation for health policy	system_auto	\N	14	CUST-20260512-BIVWPK	f	\N	\N
71	health	33	main_agent	4156.67	2026-06-13	pending	2026-05-14 03:16:10.511945	2026-05-14 03:16:10.511945	\N	bank_transfer	MAIN_15_1778728570	\N	\N	Main agent commission for health policy. Policy Number: 34370258202400	system_auto	\N	15	CUST-20260513-NPBJML	f	\N	\N
72	health	33	affiliate	1263.63	2026-06-13	pending	2026-05-14 03:16:10.514845	2026-05-14 03:16:10.514845	\N	bank_transfer	AFF_15_1778728570	\N	\N	Affiliate commission for health policy. Sub-agent ID: 3	system_auto	\N	15	CUST-20260513-NPBJML	f	\N	\N
73	health	33	ambassador	315.9	2026-06-13	pending	2026-05-14 03:16:10.519693	2026-05-14 03:16:10.519693	\N	bank_transfer	AMB_15_1778728570	\N	\N	Ambassador commission for health policy. Distributor ID: 2	system_auto	\N	15	CUST-20260513-NPBJML	f	\N	\N
74	health	33	investor	1330.14	2026-06-13	pending	2026-05-14 03:16:10.522739	2026-05-14 03:16:10.522739	\N	bank_transfer	INV_15_1778728570	\N	\N	Investor commission for health policy. Policy Number: 34370258202400	system_auto	\N	15	CUST-20260513-NPBJML	f	\N	\N
75	health	33	company_expense	665.0678	2026-06-13	pending	2026-05-14 03:16:10.525232	2026-05-14 03:16:10.525232	\N	internal	COMP_15_1778728570	\N	\N	Company expense allocation for health policy	system_auto	\N	15	CUST-20260513-NPBJML	f	\N	\N
182	health	49	ambassador_display	426.25	2026-05-17	paid	2026-05-17 08:55:05.118694	2026-05-17 08:55:05.118694	sd	\N	AMB_CUSLEAD-ESWAR-BSRPS_1779008105	\N	\N	sd | Ambassador commission paid to distributor: Krama Consulting	admin@drwise.com	2026-05-17 08:55:05.118137	\N	CUSLEAD-ESWAR-BSRPS	f	\N	\N
81	health	35	main_agent	3516.58	2026-06-13	pending	2026-05-14 13:20:47.299367	2026-05-14 13:20:47.299367	\N	bank_transfer	MAIN_17_1778764847	\N	\N	Main agent commission for health policy. Policy Number: 90475760	system_auto	\N	17	CUSLEAD-NXX-137-100-HLT	f	\N	\N
82	health	35	affiliate	1081.18	2026-06-13	pending	2026-05-14 13:20:47.302744	2026-05-14 13:20:47.302744	\N	bank_transfer	AFF_17_1778764847	\N	\N	Affiliate commission for health policy. Sub-agent ID: 2	system_auto	\N	17	CUSLEAD-NXX-137-100-HLT	f	\N	\N
83	health	35	ambassador	270.29	2026-06-13	pending	2026-05-14 13:20:47.305943	2026-05-14 13:20:47.305943	\N	bank_transfer	AMB_17_1778764847	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	17	CUSLEAD-NXX-137-100-HLT	f	\N	\N
84	health	35	investor	1103.24	2026-06-13	pending	2026-05-14 13:20:47.308255	2026-05-14 13:20:47.308255	\N	bank_transfer	INV_17_1778764847	\N	\N	Investor commission for health policy. Policy Number: 90475760	system_auto	\N	17	CUSLEAD-NXX-137-100-HLT	f	\N	\N
85	health	35	company_expense	551.6202	2026-06-13	pending	2026-05-14 13:20:47.311288	2026-05-14 13:20:47.311288	\N	internal	COMP_17_1778764847	\N	\N	Company expense allocation for health policy	system_auto	\N	17	CUSLEAD-NXX-137-100-HLT	f	\N	\N
86	health	36	main_agent	4227.6	2026-06-13	pending	2026-05-14 13:40:25.493119	2026-05-14 13:40:25.493119	\N	bank_transfer	MAIN_18_1778766025	\N	\N	Main agent commission for health policy. Policy Number: 2856 2057 2973 7502 000	system_auto	\N	18	CUSLEAD-G R-901-080-HLT	f	\N	\N
87	health	36	affiliate	1338.74	2026-06-13	pending	2026-05-14 13:40:25.497312	2026-05-14 13:40:25.497312	\N	bank_transfer	AFF_18_1778766025	\N	\N	Affiliate commission for health policy. Sub-agent ID: 1	system_auto	\N	18	CUSLEAD-G R-901-080-HLT	f	\N	\N
88	health	36	ambassador	267.75	2026-06-13	pending	2026-05-14 13:40:25.500184	2026-05-14 13:40:25.500184	\N	bank_transfer	AMB_18_1778766025	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	18	CUSLEAD-G R-901-080-HLT	f	\N	\N
89	health	36	investor	1409.2	2026-06-13	pending	2026-05-14 13:40:25.503688	2026-05-14 13:40:25.503688	\N	bank_transfer	INV_18_1778766025	\N	\N	Investor commission for health policy. Policy Number: 2856 2057 2973 7502 000	system_auto	\N	18	CUSLEAD-G R-901-080-HLT	f	\N	\N
90	health	36	company_expense	563.68	2026-06-13	pending	2026-05-14 13:40:25.506713	2026-05-14 13:40:25.506713	\N	internal	COMP_18_1778766025	\N	\N	Company expense allocation for health policy	system_auto	\N	18	CUSLEAD-G R-901-080-HLT	f	\N	\N
91	health	37	main_agent	2713.71	2026-06-13	pending	2026-05-14 13:55:11.492514	2026-05-14 13:55:11.492514	\N	bank_transfer	MAIN_19_1778766911	\N	\N	Main agent commission for health policy. Policy Number: 72895305	system_auto	\N	19	CUST-20260513-5P72WP	f	\N	\N
92	health	37	affiliate	859.34	2026-06-13	pending	2026-05-14 13:55:11.499009	2026-05-14 13:55:11.499009	\N	bank_transfer	AFF_19_1778766911	\N	\N	Affiliate commission for health policy. Sub-agent ID: 1	system_auto	\N	19	CUST-20260513-5P72WP	f	\N	\N
93	health	37	ambassador	171.86	2026-06-13	pending	2026-05-14 13:55:11.511405	2026-05-14 13:55:11.511405	\N	bank_transfer	AMB_19_1778766911	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	19	CUST-20260513-5P72WP	f	\N	\N
94	health	37	investor	904.57	2026-06-13	pending	2026-05-14 13:55:11.518192	2026-05-14 13:55:11.518192	\N	bank_transfer	INV_19_1778766911	\N	\N	Investor commission for health policy. Policy Number: 72895305	system_auto	\N	19	CUST-20260513-5P72WP	f	\N	\N
95	health	37	company_expense	361.8282	2026-06-13	pending	2026-05-14 13:55:11.522653	2026-05-14 13:55:11.522653	\N	internal	COMP_19_1778766911	\N	\N	Company expense allocation for health policy	system_auto	\N	19	CUST-20260513-5P72WP	f	\N	\N
97	health	38	affiliate	1813.9	2026-06-14	pending	2026-05-15 03:29:10.830875	2026-05-15 03:29:10.830875	\N	bank_transfer	AFF_20_1778815750	\N	\N	Affiliate commission for health policy. Sub-agent ID: 3	system_auto	\N	20	CUSLEAD-DR -161-280-HLT	f	\N	\N
98	health	38	ambassador	370.18	2026-06-14	pending	2026-05-15 03:29:10.869432	2026-05-15 03:29:10.869432	\N	bank_transfer	AMB_20_1778815750	\N	\N	Ambassador commission for health policy. Distributor ID: 2	system_auto	\N	20	CUSLEAD-DR -161-280-HLT	f	\N	\N
99	health	38	investor	1850.92	2026-06-14	pending	2026-05-15 03:29:10.87499	2026-05-15 03:29:10.87499	\N	bank_transfer	INV_20_1778815750	\N	\N	Investor commission for health policy. Policy Number: 34370258202501	system_auto	\N	20	CUSLEAD-DR -161-280-HLT	f	\N	\N
100	health	38	company_expense	925.46	2026-06-14	pending	2026-05-15 03:29:10.878788	2026-05-15 03:29:10.878788	\N	internal	COMP_20_1778815750	\N	\N	Company expense allocation for health policy	system_auto	\N	20	CUSLEAD-DR -161-280-HLT	f	\N	\N
201	motor	14	main_agent	2.3	2026-06-25	pending	2026-05-27 10:29:33.588414	2026-05-27 10:29:33.588414	\N	bank_transfer	MAIN_42_1779877773	\N	\N	Main agent commission for motor policy. Policy Number: xsdsdss	system_auto	\N	42	CUSLEAD-NXX-137-100-MTR	f	\N	\N
202	motor	14	affiliate	0.46	2026-06-25	pending	2026-05-27 10:29:34.716336	2026-05-27 10:29:34.716336	\N	bank_transfer	AFF_42_1779877774	\N	\N	Affiliate commission for motor policy. Sub-agent ID: 2	system_auto	\N	42	CUSLEAD-NXX-137-100-MTR	f	\N	\N
203	motor	14	ambassador	0.46	2026-06-25	pending	2026-05-27 10:29:35.914739	2026-05-27 10:29:35.914739	\N	bank_transfer	AMB_42_1779877775	\N	\N	Ambassador commission for motor policy. Distributor ID: 1	system_auto	\N	42	CUSLEAD-NXX-137-100-MTR	f	\N	\N
204	motor	14	investor	0.46	2026-06-25	pending	2026-05-27 10:29:37.042875	2026-05-27 10:29:37.042875	\N	bank_transfer	INV_42_1779877777	\N	\N	Investor commission for motor policy. Policy Number: xsdsdss	system_auto	\N	42	CUSLEAD-NXX-137-100-MTR	f	\N	\N
198	motor	13	ambassador	170.45	2026-05-28	paid	2026-05-27 10:29:27.925365	2026-05-28 09:15:03.663869	202605B001	bank_transfer	AMB_41_1779877767	\N	\N		admin@drwise.com	2026-05-28 09:15:03.663205	41	CUSLEAD-HANUM-AISPH	f	\N	\N
199	motor	13	investor	897.1	2026-05-28	paid	2026-05-27 10:29:29.076072	2026-05-28 09:15:20.015923	202605I001	bank_transfer	INV_41_1779877769	\N	\N		admin@drwise.com	2026-05-28 09:15:20.015462	41	CUSLEAD-HANUM-AISPH	f	\N	\N
200	motor	13	company_expense	538.26	2026-05-28	paid	2026-05-27 10:29:30.207181	2026-05-28 09:15:28.559284	202605C001	internal	COMP_41_1779877770	\N	\N		admin@drwise.com	2026-05-28 09:15:28.558534	41	CUSLEAD-HANUM-AISPH	f	\N	\N
96	health	38	main_agent	5899.81	2026-05-29	paid	2026-05-15 03:29:10.825928	2026-05-29 10:42:35.66947	dsd	bank_transfer	MAIN_20_1778815750	\N	\N	sd	admin@drwise.com	2026-05-29 10:42:35.668723	20	CUSLEAD-DR -161-280-HLT	f	\N	\N
183	health	50	main_agent	2300.0	2026-06-16	pending	2026-05-17 11:46:15.197558	2026-05-17 11:46:15.197558	\N	bank_transfer	MAIN_38_1779018375	\N	\N	Main agent commission for health policy. Policy Number: REQ-1779018374	system_auto	\N	38	CUSLEAD-NXX-137-100-HLT-01	f	\N	\N
184	health	50	ambassador	460.0	2026-06-16	pending	2026-05-17 11:46:15.201161	2026-05-17 11:46:15.201161	\N	bank_transfer	AMB_38_1779018375	\N	\N	Ambassador commission for health policy	system_auto	\N	38	CUSLEAD-NXX-137-100-HLT-01	f	\N	\N
185	health	50	investor	460.0	2026-06-16	pending	2026-05-17 11:46:15.208076	2026-05-17 11:46:15.208076	\N	bank_transfer	INV_38_1779018375	\N	\N	Investor commission for health policy. Policy Number: REQ-1779018374	system_auto	\N	38	CUSLEAD-NXX-137-100-HLT-01	f	\N	\N
186	health	50	company_expense	460.0	2026-06-16	pending	2026-05-17 11:46:15.211141	2026-05-17 11:46:15.211141	\N	internal	COMP_38_1779018375	\N	\N	Company expense allocation for health policy	system_auto	\N	38	CUSLEAD-NXX-137-100-HLT-01	f	\N	\N
205	motor	14	company_expense	0.46	2026-06-25	pending	2026-05-27 10:29:38.29153	2026-05-27 10:29:38.29153	\N	internal	COMP_42_1779877778	\N	\N	Company expense allocation for motor policy	system_auto	\N	42	CUSLEAD-NXX-137-100-MTR	f	\N	\N
208	motor	15	ambassador	446.46	2026-06-26	pending	2026-05-27 10:29:44.030327	2026-05-27 10:29:44.030327	\N	bank_transfer	AMB_43_1779877784	\N	\N	Ambassador commission for motor policy. Distributor ID: 1	system_auto	\N	43	CUSLEAD-ADI-087-141-MTR	f	\N	\N
209	motor	15	investor	446.46	2026-06-26	pending	2026-05-27 10:29:45.170725	2026-05-27 10:29:45.170725	\N	bank_transfer	INV_43_1779877785	\N	\N	Investor commission for motor policy. Policy Number: sssdsd	system_auto	\N	43	CUSLEAD-ADI-087-141-MTR	f	\N	\N
210	motor	15	company_expense	446.4596	2026-06-26	pending	2026-05-27 10:29:46.298923	2026-05-27 10:29:46.298923	\N	internal	COMP_43_1779877786	\N	\N	Company expense allocation for motor policy	system_auto	\N	43	CUSLEAD-ADI-087-141-MTR	f	\N	\N
211	health	2	main_agent	2912.83	2026-06-10	pending	2026-05-27 10:29:52.734721	2026-05-27 10:29:52.734721	\N	bank_transfer	MAIN_44_1779877792	\N	\N	Main agent commission for health policy. Policy Number: 89557128	system_auto	\N	44	CUST-20260511-PSEL8R	f	\N	\N
212	health	2	affiliate	1153.0	2026-06-10	pending	2026-05-27 10:29:53.869784	2026-05-27 10:29:53.869784	\N	bank_transfer	AFF_44_1779877793	\N	\N	Affiliate commission for health policy. Sub-agent ID: 2	system_auto	\N	44	CUST-20260511-PSEL8R	f	\N	\N
213	health	2	ambassador	230.6	2026-06-10	pending	2026-05-27 10:29:54.995655	2026-05-27 10:29:54.995655	\N	bank_transfer	AMB_44_1779877794	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	44	CUST-20260511-PSEL8R	f	\N	\N
214	health	2	company_expense	1213.679	2026-06-10	pending	2026-05-27 10:29:56.151125	2026-05-27 10:29:56.151125	\N	internal	COMP_44_1779877796	\N	\N	Company expense allocation for health policy	system_auto	\N	44	CUST-20260511-PSEL8R	f	\N	\N
215	health	1	main_agent	2920.37	2026-06-10	pending	2026-05-27 10:29:59.740654	2026-05-27 10:29:59.740654	\N	bank_transfer	MAIN_45_1779877799	\N	\N	Main agent commission for health policy. Policy Number: 85432300	system_auto	\N	45	CUST-20260511-UQMMSS	f	\N	\N
216	health	1	affiliate	433.49	2026-06-10	pending	2026-05-27 10:30:00.868863	2026-05-27 10:30:00.868863	\N	bank_transfer	AFF_45_1779877800	\N	\N	Affiliate commission for health policy. Sub-agent ID: 1	system_auto	\N	45	CUST-20260511-UQMMSS	f	\N	\N
217	health	1	ambassador	86.7	2026-06-10	pending	2026-05-27 10:30:01.997055	2026-05-27 10:30:01.997055	\N	bank_transfer	AMB_45_1779877801	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	45	CUST-20260511-UQMMSS	f	\N	\N
218	health	1	company_expense	456.3075	2026-06-10	pending	2026-05-27 10:30:03.123368	2026-05-27 10:30:03.123368	\N	internal	COMP_45_1779877803	\N	\N	Company expense allocation for health policy	system_auto	\N	45	CUST-20260511-UQMMSS	f	\N	\N
206	motor	15	main_agent	2232.3	2026-05-28	paid	2026-05-27 10:29:41.777165	2026-05-28 15:11:51.904984	260528002	bank_transfer	MAIN_43_1779877781	\N	\N		admin@drwise.com	2026-05-28 15:11:51.904294	43	CUSLEAD-ADI-087-141-MTR	f	\N	\N
225	life	9	affiliate	3627.18	2026-06-28	pending	2026-05-29 02:39:18.769935	2026-05-29 02:39:18.769935	\N	bank_transfer	AFF_47_1780022358	\N	\N	Affiliate commission for life policy. Sub-agent ID: 2	system_auto	\N	47	CUST-20260519-D1IE2M	f	\N	\N
226	life	9	ambassador	725.44	2026-06-28	pending	2026-05-29 02:39:18.773433	2026-05-29 02:39:18.773433	\N	bank_transfer	AMB_47_1780022358	\N	\N	Ambassador commission for life policy. Distributor ID: 1	system_auto	\N	47	CUST-20260519-D1IE2M	f	\N	\N
224	life	9	main_agent	29380.13	2026-05-29	paid	2026-05-29 02:39:18.719167	2026-05-29 10:37:25.177234	sdds	bank_transfer	MAIN_47_1780022358	\N	\N	sd	admin@drwise.com	2026-05-29 10:37:25.176537	47	CUST-20260519-D1IE2M	f	\N	\N
207	motor	15	affiliate	446.46	2026-05-29	paid	2026-05-27 10:29:42.903653	2026-05-29 10:46:05.2315	dc	bank_transfer	AFF_43_1779877782	\N	\N	sd	admin@drwise.com	2026-05-29 10:46:05.230556	43	CUSLEAD-ADI-087-141-MTR	f	\N	\N
187	health	51	main_agent	1150.0	2026-06-17	pending	2026-05-18 03:05:59.852778	2026-05-18 03:05:59.852778	\N	bank_transfer	MAIN_39_1779073559	\N	\N	Main agent commission for health policy. Policy Number: REQ-1779073559	system_auto	\N	39	CUST-20260515-97KL1W	f	\N	\N
188	health	51	ambassador	230.0	2026-06-17	pending	2026-05-18 03:05:59.855349	2026-05-18 03:05:59.855349	\N	bank_transfer	AMB_39_1779073559	\N	\N	Ambassador commission for health policy	system_auto	\N	39	CUST-20260515-97KL1W	f	\N	\N
189	health	51	investor	230.0	2026-06-17	pending	2026-05-18 03:05:59.857272	2026-05-18 03:05:59.857272	\N	bank_transfer	INV_39_1779073559	\N	\N	Investor commission for health policy. Policy Number: REQ-1779073559	system_auto	\N	39	CUST-20260515-97KL1W	f	\N	\N
190	health	51	company_expense	230.0	2026-06-17	pending	2026-05-18 03:05:59.859582	2026-05-18 03:05:59.859582	\N	internal	COMP_39_1779073559	\N	\N	Company expense allocation for health policy	system_auto	\N	39	CUST-20260515-97KL1W	f	\N	\N
220	motor	16	affiliate	6.46	2026-06-26	pending	2026-05-27 10:38:56.620798	2026-05-27 10:38:56.620798	\N	bank_transfer	AFF_46_1779878336	\N	\N	Affiliate commission for motor policy. Sub-agent ID: 2	system_auto	\N	46	\N	f	\N	\N
221	motor	16	ambassador	6.46	2026-06-26	pending	2026-05-27 10:38:56.67202	2026-05-27 10:38:56.67202	\N	bank_transfer	AMB_46_1779878336	\N	\N	Ambassador commission for motor policy. Distributor ID: 1	system_auto	\N	46	\N	f	\N	\N
222	motor	16	investor	6.46	2026-06-26	pending	2026-05-27 10:38:56.676266	2026-05-27 10:38:56.676266	\N	bank_transfer	INV_46_1779878336	\N	\N	Investor commission for motor policy. Policy Number: RRERE	system_auto	\N	46	\N	f	\N	\N
223	motor	16	company_expense	6.46	2026-06-26	pending	2026-05-27 10:38:56.680073	2026-05-27 10:38:56.680073	\N	internal	COMP_46_1779878336	\N	\N	Company expense allocation for motor policy	system_auto	\N	46	\N	f	\N	\N
219	motor	16	main_agent	32.3	2026-05-27	paid	2026-05-27 10:38:56.616503	2026-05-27 10:39:23.204873	EF	bank_transfer	MAIN_46_1779878336	\N	\N	EEE	admin@drwise.com	2026-05-27 10:39:23.204255	46	\N	f	\N	\N
227	life	9	investor	3701.2	2026-06-28	pending	2026-05-29 02:39:18.777996	2026-05-29 02:39:18.777996	\N	bank_transfer	INV_47_1780022358	\N	\N	Investor commission for life policy. Policy Number: K7676680	system_auto	\N	47	CUST-20260519-D1IE2M	f	\N	\N
228	life	9	company_expense	3701.2	2026-06-28	pending	2026-05-29 02:39:18.780898	2026-05-29 02:39:18.780898	\N	internal	COMP_47_1780022358	\N	\N	Company expense allocation for life policy	system_auto	\N	47	CUST-20260519-D1IE2M	f	\N	\N
191	health	52	main_agent	2065.98	2026-06-19	pending	2026-05-20 14:05:07.381826	2026-05-20 14:05:07.381826	\N	bank_transfer	MAIN_40_1779285907	\N	\N	Main agent commission for health policy. Policy Number: 100063248600	system_auto	\N	40	CUSLEAD-KRISH-32790	f	\N	\N
192	health	52	affiliate	482.06	2026-06-19	pending	2026-05-20 14:05:07.387122	2026-05-20 14:05:07.387122	\N	bank_transfer	AFF_40_1779285907	\N	\N	Affiliate commission for health policy. Sub-agent ID: 6	system_auto	\N	40	CUSLEAD-KRISH-32790	f	\N	\N
193	health	52	ambassador	96.41	2026-06-19	pending	2026-05-20 14:05:07.391211	2026-05-20 14:05:07.391211	\N	bank_transfer	AMB_40_1779285907	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	40	CUSLEAD-KRISH-32790	f	\N	\N
194	health	52	investor	491.9	2026-06-19	pending	2026-05-20 14:05:07.395192	2026-05-20 14:05:07.395192	\N	bank_transfer	INV_40_1779285907	\N	\N	Investor commission for health policy. Policy Number: 100063248600	system_auto	\N	40	CUSLEAD-KRISH-32790	f	\N	\N
\.


--
-- Data for Name: commission_receipts; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.commission_receipts (id, policy_type, policy_id, total_commission_received, received_date, insurance_company_name, insurance_company_reference, company_commission_percentage, payment_mode, transaction_id, notes, received_by, auto_distributed, distributed_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: corporate_members; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.corporate_members (id, customer_id, company_name, mobile, email, state, city, address, annual_income, pan_no, gst_no, additional_information, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: customer_documents; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.customer_documents (id, customer_id, document_type, created_at, updated_at, r2_file_key, r2_filename, r2_content_type, r2_file_size) FROM stdin;
\.


--
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.customers (id, customer_type, first_name, last_name, company_name, email, mobile, address, state, city, birth_date, age, gender, height, weight, education, marital_status, occupation, job_name, type_of_duty, annual_income, pan_number, gst_number, birth_place, additional_info, status, added_by, created_at, updated_at, nominee_name, nominee_relation, nominee_date_of_birth, pincode, sub_agent, middle_name, height_feet, weight_kg, business_job, business_name, additional_information, pan_no, gst_no, sub_agent_id, lead_id, deactivated, r2_profile_image_key, r2_profile_image_filename, r2_profile_image_content_type, r2_profile_image_size, r2_profile_image_public_url, policies_count) FROM stdin;
3	individual	BASAVARAJ	CHANDRASHEKAR	\N	basu2736@gmail.com	9720008888	CVC Farmhouse, Kushtagai Road, Bharat Gas, Bhagyanagar, Koppal	karnataka	Koppal	1992-08-03	33	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-05-11 12:56:05.070611	2026-05-11 12:56:05.070611	KRUTHIKA S BHOOMARADDI	spouse	1994-11-05	\N	Self		5.58	95.00	business			AQEPC0330M	\N	1	CUST-20260511-DGECKX	f	\N	\N	\N	\N	\N	2
2	individual	YOGESHWARAPPA	K		yogi.slvglass4@gmail.com	9980990027	61, 14TH CROSS, KEMPEGOWDANAGAR, BYADARAHALLI	Karnataka	Bangalore	1980-11-25	45	male	\N	\N		married			PROPRIETOR	\N	\N				t	sub_agent	2026-05-11 11:25:03.595704	2026-05-11 11:30:09.925101	SHILPA GS	spouse	1984-01-01	560091	Self		5.33	70.00	private_employee	SLV GLASS		ABZPY0767G	\N	2	CUST-20260511-PSEL8R	f	\N	\N	\N	\N	\N	2
14	individual	pramod	bhat		9dfd093939393fdfds@gmail.com	6363727272	dfd	karnataka		2026-05-14	0		\N	\N						\N	\N				t		2026-05-17 13:56:39.708955	2026-05-17 15:31:51.222847	To be updated	father	2026-05-17		Self			\N				\N	\N	1	CUST-20260517-BZUFTY	f	\N	\N	\N	\N	\N	0
11	individual	Eswaraiah	Sudha	\N	sudha.e68@gmail.com	9686405652	42, Shashwathi Nilaya, 1st A Main Cross Road, Maruthi Layout, RMV 2nd Stage, Blr 560094	karnataka	Bengaluru Urban	1967-07-21	58	female	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-05-16 10:56:46.910213	2026-05-16 10:56:46.910213	Eshwaraiah H	spouse	1956-11-25	\N	Self		5.17	82.00				BSRPS7005K	\N	1	CUSLEAD-ESWAR-BSRPS	f	\N	\N	\N	\N	\N	1
15	individual	Mani	D	\N	manikantaishan@gmail.com	9742059226	JP Nagar	Karnataka	Bengaluru 	1990-01-25	36	male	\N	\N	\N	married	\N	\N	\N	600000.0	\N	\N	\N	\N	t	agent_mobile_api_3	2026-05-18 02:50:32.871104	2026-05-18 02:50:32.871104	Indhu R	spouse	1994-05-01	560070	Self	\N	\N	\N	\N	\N	\N	BZSPM4392M	\N	3	CUST-20260518-XFOKLY	f	\N	\N	\N	\N	\N	0
4	individual	G RAVI	KIRAN		grk_sva@ymail.com	9880039901		Karnataka	Bangalore	1975-05-08	51	male	\N	\N		single			Proprietor	1000000.0	\N				t	sub_agent	2026-05-12 04:44:13.885579	2026-05-12 05:10:00.003815	G Madhusudhan	brother	1973-01-01	560004	Self			\N	self_employed	Vallabha Associates		\N	\N	1	CUST-20260512-BIVWPK	f	\N	\N	\N	\N	\N	2
7	individual	PRAMOD	SHIVAKUMAR	\N	PRAMODSHIVKUMAR79@GMAIL.COM	9945780099		karnataka	Bengaluru Urban	1979-06-20	46	male	\N	\N		married	\N	\N	Marketing	300000.0	\N	\N		\N	t	\N	2026-05-13 03:27:06.562474	2026-05-13 03:27:06.562474	Vidarbh	son	2014-10-12	\N	Self		5.17	65.00	salaried			BMRPS1515G	\N	1	CUST-20260513-5P72WP	f	\N	\N	\N	\N	\N	1
6	individual	DR KRISHNA	NAGARAJ	\N	krishnainduvalu@yahoo.co.in	9980639161		karnataka	Mandya	1979-05-28	46	male	\N	\N	MBBS	married	\N	\N	DOCTOR	2500000.0	\N	\N	MANDYA	\N	t	\N	2026-05-13 03:23:57.953796	2026-05-13 03:23:57.953796	Dr Lalitha J	spouse	1986-02-15	\N	Self		5.5	75.00	professional			ADZPN3005G	\N	3	CUST-20260513-NPBJML	f	\N	\N	\N	\N	\N	2
1	individual	CM	LINGARAJU	\N	nandininaga22@gmail.com	9008666938	62 3rd Cross Durgaparameswarinagar, Kerepalya Main Road Hosakerehalli	karnataka	Bengaluru Urban	1985-05-28	40	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-05-11 11:09:22.128051	2026-05-11 11:09:22.128051	Latha S	spouse	1995-04-24	\N	Self		5.33	55.00				AEXPL1676C	\N	1	CUST-20260511-UQMMSS	f	\N	\N	\N	\N	\N	3
22	individual	HANUMANTHA	M	\N	pradeepdjpradeep16455@gmail.com	9538247661	S/O Marigowda, 230/2, Marchanahalli, Channapatna, Karnataka 562160	karnataka	Ramanagara	1985-06-15	40	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-05-26 00:14:47.792043	2026-05-26 00:14:47.792043	PRAMODINI C	spouse	1992-12-06	\N	Self			\N				AISPH0089E	\N	8	CUSLEAD-HANUM-AISPH	f	\N	\N	\N	\N	\N	1
17	individual	GAJENDRACHARI	A	\N	gajendrachari@gmail.com	9845731819		karnataka	Bengaluru Urban	1976-02-29	50	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-05-19 03:17:12.012063	2026-05-19 03:17:12.012063	SANGEETHA	spouse	1984-02-04	\N	Self			\N	business			AFPPA8777A	\N	1	CUST-20260519-W6WKOL	f	\N	\N	\N	\N	\N	0
8	individual	GURDEEP	MANN	\N	gurdeep.mannn@gmail.com	9980698450		karnataka	Bengaluru Urban	1986-03-12	40	male	\N	\N		married	\N	\N		1000000.0	\N	\N		\N	t	\N	2026-05-13 03:33:28.293153	2026-05-13 03:33:28.293153	Mandeep Kaur	mother	1987-05-01	\N	Self	SINGH	5.83	85.00				ALAPG4528Q	\N	1	CUST-20260513-FOTT6S	f	\N	\N	\N	\N	\N	0
19	individual	K Krishna	Prasad	\N	prasadsharma5577@gmail.com	8660725693	12-1-34, 'Krishna Nivas', MT Road, New Field Street, \r\nNear Mahamaya Temple, Temple Ward, Car Street,\r\nMangalore, Karnataka 575001	karnataka	Mangaluru	2002-07-03	23	male	\N	\N		single	\N	\N		700000.0	\N	\N		\N	t	\N	2026-05-20 14:01:29.506499	2026-05-20 14:01:29.506499	VEENA BHAT	mother	1976-03-29	\N	Self		5.42	86.00	self_employed			GFVPP2999B	\N	6	CUSLEAD-KRISH-32790	f	\N	\N	\N	\N	\N	1
20	individual	N C	NIRANJAN	\N	niranjandev141@gmail.com	9945666226		karnataka	Bengaluru Rural	1995-09-08	30	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-05-25 11:38:26.132769	2026-05-25 11:38:26.132769	Rakshitha H	spouse	2003-12-19	\N	Self		5.75	74.00	business			AWDPN6661M	\N	2	CUST-20260525-JA4TGB	f	\N	\N	\N	\N	\N	0
16	individual	Adithyaa	Kasibhatta	\N	adithyaatanmayk@gmail.com	6361404087	BSK II Stage	karnataka	Bengaluru Urban	2007-10-14	18	male	\N	\N		single	\N	\N		\N	\N	\N	Secunderabad	\N	t	\N	2026-05-19 03:10:59.63744	2026-05-19 03:10:59.63744	NIVED	brother	2009-04-13	\N	Self	Tanmaoy		\N	student			QQSPK1480E	\N	6	CUST-20260519-OK6LC1	f	\N	\N	\N	\N	\N	1
21	individual	N HARISH	KUMAR	\N	sribalajicommunications15@gmail.com	9845393458		karnataka	Bengaluru Urban	1972-06-24	53	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-05-25 12:01:16.612938	2026-05-25 12:01:16.612938	S C GEETHA	spouse	1982-01-27	\N	Self		5.83	90.00	self_employed			ACRPN4891K	\N	1	CUST-20260525-HYDLAG	f	\N	\N	\N	\N	\N	0
12	individual	Tarini	Eshwaraiah	\N	tarinie04@gmail.com	9361682021	RMV Extension	Karnataka	Bengaluru 	1990-04-22	36	female	\N	\N	\N	married	\N	\N	\N	\N	\N	\N	\N	\N	t	agent_mobile_api_1	2026-05-17 12:15:08.905538	2026-05-17 12:15:08.905538	Sudha E	mother	1967-01-01	560094	Self	\N	\N	\N	\N	\N	\N	ABJPE1731A	\N	1	CUST-20260517-9DWYZQ	f	\N	\N	\N	\N	\N	0
5	individual	N	GOPAL	\N	ngopalg77@gmail.com	9845798137		karnataka	Bengaluru Urban	1977-07-10	48	male	\N	\N		married	\N	\N	Proprietor	600000.0	\N	\N		\N	t	\N	2026-05-13 01:57:36.941377	2026-05-13 01:57:36.941377	M TRIVENI	spouse	1982-04-01	\N	Self		5.92	78.00	self_employed	GT FOODS		ALHPG4776H	\N	2	CUST-20260513-HYC5D3	f	\N	\N	\N	\N	\N	6
18	individual	Yogesha	MS	\N	pragathigroup2018@gmail.com	9449202517		karnataka	Bangalore	1986-05-25	39	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-05-19 03:38:04.962832	2026-05-19 03:38:04.962832	Kaveri E	spouse	1994-02-15	\N	Self		5.5	63.00	business			ACJPY0782E	\N	2	CUST-20260519-D1IE2M	f	\N	\N	\N	\N	\N	1
\.


--
-- Data for Name: distributor_assignments; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.distributor_assignments (id, distributor_id, sub_agent_id, assigned_at, created_at, updated_at) FROM stdin;
2	1	2	2026-05-11 11:21:55.06397	2026-05-11 11:21:55.066738	2026-05-11 11:21:55.066738
3	2	3	2026-05-13 03:20:56.684339	2026-05-13 03:20:56.690816	2026-05-13 03:20:56.690816
4	1	4	2026-05-13 03:47:37.294087	2026-05-13 03:47:37.299724	2026-05-13 03:47:37.299724
5	1	1	2026-05-15 07:13:48.169008	2026-05-15 07:13:48.173318	2026-05-15 07:13:48.173318
6	3	5	2026-05-15 09:44:27.34444	2026-05-15 09:44:27.353839	2026-05-15 09:44:27.353839
8	1	7	2026-05-19 03:31:22.190801	2026-05-19 03:31:22.195463	2026-05-19 03:31:22.195463
9	1	6	2026-05-23 23:44:51.732497	2026-05-23 23:44:51.738461	2026-05-23 23:44:51.738461
10	4	8	2026-05-26 00:07:03.842115	2026-05-26 00:07:03.848724	2026-05-26 00:07:03.848724
\.


--
-- Data for Name: distributor_documents; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.distributor_documents (id, distributor_id, document_type, created_at, updated_at, r2_file_key, r2_filename, r2_content_type, r2_file_size) FROM stdin;
\.


--
-- Data for Name: distributor_payouts; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.distributor_payouts (id, distributor_id, policy_type, policy_id, payout_amount, payout_date, status, transaction_id, payment_mode, reference_number, notes, processed_by, processed_at, created_at, updated_at, invoiced) FROM stdin;
1	1	health	49	426.25	2026-05-17	paid	sd	bank_transfer	REF_CUSLEAD-ESWAR-BSRPS_1779008104	sd	admin@drwise.com	2026-05-17 08:55:04.894894	2026-05-17 08:55:05.00007	2026-05-17 08:55:05.00007	f
\.


--
-- Data for Name: distributors; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.distributors (id, first_name, middle_name, last_name, mobile, email, role_id, state_id, city_id, birth_date, gender, pan_no, gst_no, company_name, address, bank_name, account_no, ifsc_code, account_holder_name, account_type, upi_id, status, created_at, updated_at, affiliate_count, deactivated, city, state, username, password_digest, original_password, investor_id) FROM stdin;
1	Krama		Consulting	8431174477	krama.consulting@gmail.com	0	\N	\N	\N												0	2026-05-11 10:56:29.458288	2026-05-11 11:05:49.3599	0	f	Bengaluru Urban	karnataka	kramaconsulting6989	$2a$12$/aGNBALtWloM.OXJMSNUYu2pPnrM.ZiSuCSxCMxO5fQDkoB6hzSiS	SmartSwift181	1
2	SHOBHA		LOKESH	9743003428	shobhalokesh982@gmail.com	0	\N	\N	1982-06-17	Female	AEAPL6110N										0	2026-05-13 03:16:28.865472	2026-05-13 03:16:28.865472	0	f	Bengaluru Urban	karnataka	shobhalokesh2188	$2a$12$iV/u.N5ZzhzwMZwjmiFhT.wVYg67ABDqHRM6SklzNI0SsaONFbdMO	BrightBlue353	1
3	Test ambasidor		ambasidor	9898919191	909fdd3939393fdfds@gmail.com	0	\N	\N	2026-05-15		8277625962			dfd							0	2026-05-15 09:36:58.303648	2026-05-15 09:36:58.559891	0	f	Bangalore	karnataka	testambasidorambasidor7818	$2a$12$fHHtj6p2.MzF4cWXHKdm3ebB3DdNuRf1/mko1OvTueakoNmK7jIU2	SwiftBright711	1
4	M P		VIJENDRA	9845957220	vijendramarvin220@gmail.com	0	\N	\N	1982-05-01	Male	AHOPV0261B				HDFC BANK	50100766300236	HDFC0004876	VIJENDRA M P	Savings		0	2026-05-25 23:55:57.532967	2026-05-25 23:55:57.532967	0	f	Bengaluru Urban	karnataka	mpvijendra3357	$2a$12$U27IA.yxz4wIIrBn0zOhoup9kNa/sdvKIN9AgL.4kRpcy8bCGYl9q	SmartRed149	10
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.documents (id, document_type, documentable_type, documentable_id, created_at, updated_at, title, description, uploaded_by, r2_file_key, r2_filename, r2_content_type, r2_file_size) FROM stdin;
\.


--
-- Data for Name: family_members; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.family_members (id, customer_id, first_name, birth_date, age, height, weight, gender, relationship, pan_no, mobile, created_at, updated_at, middle_name, last_name, height_feet, weight_kg, additional_information) FROM stdin;
1	1	LATHA	1995-04-24	31	\N	\N	female	spouse			2026-05-11 11:09:22.140883	2026-05-11 11:09:22.140883		S		\N	
2	21	S C	1982-01-27	44	\N	\N	female	spouse			2026-05-25 12:01:16.622491	2026-05-25 12:01:16.622491		GEETHA		\N	
\.


--
-- Data for Name: health_insurance_documents; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.health_insurance_documents (id, health_insurance_id, document_type, title, description, r2_file_key, r2_filename, r2_content_type, r2_file_size, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: health_insurance_members; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.health_insurance_members (id, health_insurance_id, member_name, age, relationship, sum_insured, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: health_insurance_nominees; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.health_insurance_nominees (id, health_insurance_id, nominee_name, relationship, age, share_percentage, created_at, updated_at) FROM stdin;
1	1	LATHA S	spouse	31	100.0	2026-05-11 11:13:01.205359	2026-05-11 11:13:01.205359
2	2	Shilpa GS	spouse	42	100.0	2026-05-11 11:38:24.679901	2026-05-11 11:38:24.679901
12	27	M TRIVENI	spouse	44	100.0	2026-05-13 11:25:39.019822	2026-05-13 11:25:39.019822
14	31	KRUTHIKA S BHOOMARADDI	spouse	32	100.0	2026-05-13 13:53:04.201113	2026-05-13 13:53:04.201113
15	32	G Madhusudhan	brother	53	100.0	2026-05-13 13:57:30.874835	2026-05-13 13:57:30.874835
16	33	Dr Lalitha J	spouse	40	100.0	2026-05-14 03:16:10.502929	2026-05-14 03:16:10.502929
18	37	Vidarbh	son	12	100.0	2026-05-14 13:55:11.421619	2026-05-14 13:55:11.421619
28	49	Eshwaraiah H	spouse	70	100.0	2026-05-16 11:03:03.352368	2026-05-16 11:03:03.352368
29	52	VEENA BHAT	mother	50	100.0	2026-05-20 14:05:07.286343	2026-05-20 14:05:07.286343
\.


--
-- Data for Name: health_insurances; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.health_insurances (id, policy_id, insurance_type, claim_process, main_agent_commission_percent, main_agent_commission_amount, main_agent_tds_percent, main_agent_tds_amount, reference_by_name, broker_name, created_at, updated_at, customer_id, sub_agent_id, agency_code_id, broker_id, policy_holder, insurance_company_name, plan_name, policy_number, policy_booking_date, policy_start_date, policy_end_date, policy_term, payment_mode, sum_insured, net_premium, gst_percentage, total_premium, main_agent_commission_percentage, commission_amount, tds_percentage, tds_amount, after_tds_value, policy_type, installment_autopay_start_date, installment_autopay_end_date, notification_dates, is_customer_added, is_agent_added, is_admin_added, product_through_dr, main_agent_commission_received, main_agent_commission_transaction_id, main_agent_commission_paid_date, main_agent_commission_notes, lead_id, distributor_id, investor_id, ambassador_commission_percentage, ambassador_commission_amount, ambassador_tds_percentage, ambassador_tds_amount, ambassador_after_tds_value, sub_agent_commission_percentage, sub_agent_commission_amount, sub_agent_tds_percentage, sub_agent_tds_amount, sub_agent_after_tds_value, investor_commission_percentage, investor_commission_amount, investor_tds_percentage, investor_tds_amount, investor_after_tds_value, company_expenses_percentage, total_distribution_percentage, profit_percentage, profit_amount, policy_added_by_admin, nominee_dob, broker_code_type, insurance_company_code, main_policy_document_key, main_policy_document_filename, main_policy_document_content_type, main_policy_document_size, company_expenses_amount, is_renewed, original_policy_id, premium_frequency, status, start_date, end_date, additional_details, nominee_name, nominee_relation, sum_insured_text) FROM stdin;
49	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-16 11:03:03.336322	2026-05-17 08:54:32.506791	11	1	\N	4	Self	HDFC ERGO General Insurance	Optima Secure	28000000342787	2026-03-14	2026-05-15	2027-05-14	1	Yearly	1000000.0	43056.0	0.0	43056.0	12.5	5382.0	2.0	107.64	5274.36	New	\N	\N	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your health policy (28000000342787) is due for renewal on 14 May 2027. Please renew to continue your coverage.","date":"2027-04-14"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (28000000342787) expires in 15 days on 14 May 2027. Please renew to avoid coverage gap.","date":"2027-04-29"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (28000000342787) expires in 1 week on 14 May 2027. Immediate action required.","date":"2027-05-07"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (28000000342787) expires tomorrow on 14 May 2027. Renew now to avoid coverage gap.","date":"2027-05-13"}]	f	f	t	t	t	sdds	2026-05-17	sd	CUSLEAD-ESWAR-BSRPS	1	\N	1.0	430.56	1.0	4.31	426.25	4.0	1722.24	2.0	34.44	1687.8	4.0	1722.24	0.0	0.0	1722.24	2.0	9.0	-1.0	-430.56	t	\N	broking	\N	\N	\N	\N	\N	861.12	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
52	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-20 14:05:07.274241	2026-05-20 14:05:07.274241	19	6	\N	4	Self	ICICI Lombard	ELEVATE	100063248600	2026-05-20	2026-05-20	2027-05-19	1	Yearly	1000000.0	9838.0	0.0	9838.0	21.0	2065.98	2.0	41.32	2024.66	New	\N	\N	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your health policy (100063248600) is due for renewal on 19 May 2027. Please renew to continue your coverage.","date":"2027-04-19"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (100063248600) expires in 15 days on 19 May 2027. Please renew to avoid coverage gap.","date":"2027-05-04"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (100063248600) expires in 1 week on 19 May 2027. Immediate action required.","date":"2027-05-12"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (100063248600) expires tomorrow on 19 May 2027. Renew now to avoid coverage gap.","date":"2027-05-18"}]	f	f	t	t	f	\N	\N	\N	CUSLEAD-KRISH-32790	1	\N	1.0	98.38	2.0	1.97	96.41	5.0	491.9	2.0	9.84	482.06	5.0	491.9	0.0	0.0	491.9	5.0	11.0	-6.0	-590.28	t	\N	broking	\N	\N	\N	\N	\N	491.9	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
2	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-11 11:38:24.628897	2026-05-11 11:38:24.628897	2	2	4	\N	Self	Care Health Insurance Ltd	SUPREME	89557128	2024-09-10	2024-09-13	2025-09-12	1	Yearly	1000000.0	24273.58	18.0	28642.82	12.0	2912.83	5.0	145.64	2767.19	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260511-PSEL8R	1	\N	1.0	242.74	5.0	12.14	230.6	5.0	1213.68	5.0	60.68	1153.0	0.0	0.0	0.0	0.0	0.0	5.0	6.0	-1.0	-242.74	t	\N	broking	\N	\N	\N	\N	\N	1213.68	t	\N	\N	\N	\N	\N	\N	\N	\N	\N
1	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-11 11:13:01.193853	2026-05-14 08:12:53.692678	1	1	\N	1	Self	Care Health Insurance Ltd	SUPREME	85432300	2024-06-15	2024-06-19	2025-06-18	1	Yearly	700000.0	9126.15	18.0	10768.86	32.0	2920.37	5.0	146.02	2774.35	New	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260511-UQMMSS	1	\N	1.0	91.26	5.0	4.56	86.7	5.0	456.31	5.0	22.82	433.49	0.0	0.0	0.0	0.0	0.0	5.0	6.0	-1.0	-91.26	t	\N	broking	\N	health_insurance/1/main_policy/20260514_081253_e93f561ddbc8cc99_CARE Supreme_Policy Soft Copy_202406190217040427_Lingaraju.PDF	CARE Supreme_Policy Soft Copy_202406190217040427_Lingaraju.PDF	application/pdf	500861	456.31	t	\N			\N	\N		\N	\N	\N
27	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-13 11:25:39.006988	2026-05-16 11:38:58.484127	5	2	\N	4	Self	Care Health Insurance Ltd	SUPREME	90475760	2024-09-28	2024-10-03	2025-10-02	1	Yearly	700000.0	22249.19	18.0	26254.04	12.0	2669.9	5.0	133.5	2536.4	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260513-HYC5D3	1	\N	1.0	222.49	5.0	11.12	211.37	4.0	889.97	5.0	44.5	845.47	4.0	889.97	0.0	0.0	889.97	2.0	9.0	-1.0	-222.49	t	1982-04-01	broking	\N	\N	\N	\N	\N	444.98	t	\N	annual	active	\N	\N		TRIVENI M	spouse	\N
50	\N	Individual	\N	\N	\N	\N	\N	\N	\N	2026-05-17 11:46:14.830441	2026-05-17 11:46:14.830441	5	\N	\N	\N	N  GOPAL	To be assigned	FHO	REQ-1779018374	2026-05-17	2026-05-17	2026-06-13	0	Yearly	500000.0	23000.0	0.0	23000.0	\N	\N	\N	\N	\N	New	\N	\N	[{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (REQ-1779018374) expires in 15 days on 13 Jun 2026. Please renew to avoid coverage gap.","date":"2026-05-29"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (REQ-1779018374) expires in 1 week on 13 Jun 2026. Immediate action required.","date":"2026-06-06"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (REQ-1779018374) expires tomorrow on 13 Jun 2026. Renew now to avoid coverage gap.","date":"2026-06-12"}]	t	f	f	t	f	\N	\N	\N	CUSLEAD-NXX-137-100-HLT-01	\N	\N	2.0	460.0	\N	\N	460.0	2.0	460.0	\N	\N	460.0	2.0	460.0	\N	\N	460.0	2.0	6.0	2.0	460.0	f	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
15	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-13 01:37:55.300067	2026-05-26 13:54:50.383493	1	1	\N	1	Self	Care Health Insurance Ltd	SUPREME	85432300	2025-06-19	2025-06-19	2026-06-18	1	Yearly	700000.0	9126.15	18.0	10768.86	12.0	1095.14	5.0	54.76	1040.38	Renewal	2026-06-18	2027-06-17	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your health policy (85432300) is due for renewal on 18 Jun 2026. Please renew to continue your coverage.","date":"2026-05-19"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (85432300) expires in 15 days on 18 Jun 2026. Please renew to avoid coverage gap.","date":"2026-06-03"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (85432300) expires in 1 week on 18 Jun 2026. Immediate action required.","date":"2026-06-11"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (85432300) expires tomorrow on 18 Jun 2026. Renew now to avoid coverage gap.","date":"2026-06-17"}]	f	f	t	t	t	20240615001	2024-06-15	referred by Naga CM	CUSLEAD-CMX-938-280-HLT	1	\N	1.0	91.26	5.0	4.56	86.7	5.0	456.31	5.0	22.82	433.49	1.0	91.26	0.0	0.0	91.26	1.0	7.0	2.0	182.52	f	\N	broking	\N	health_insurance/15/main_policy/20260514_055159_7238585fc182b89b_C Lingaraju 2025-26.pdf	C Lingaraju 2025-26.pdf	application/pdf	492469	91.26	f	1	annual	active	\N	\N		LATHA S	spouse	\N
30	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-13 13:44:13.517905	2026-05-13 13:44:13.517905	2	2	\N	4	Self	Care Health Insurance Ltd	SUPREME	89557128	2025-10-01	2025-10-01	2026-09-30	1	Yearly	1000000.0	25635.0	0.0	25635.0	12.0	3076.2	5.0	153.81	2922.39	Renewal	2025-10-01	2026-10-01	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your health policy (89557128) is due for renewal on 30 Sep 2026. Please renew to continue your coverage.","date":"2026-08-31"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (89557128) expires in 15 days on 30 Sep 2026. Please renew to avoid coverage gap.","date":"2026-09-15"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (89557128) expires in 1 week on 30 Sep 2026. Immediate action required.","date":"2026-09-23"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (89557128) expires tomorrow on 30 Sep 2026. Renew now to avoid coverage gap.","date":"2026-09-29"}]	f	f	t	t	f	\N	\N	\N	CUSLEAD-YOG-027-251-HLT	1	\N	1.0	256.35	5.0	12.82	243.53	4.0	1025.4	5.0	51.27	974.13	4.0	1025.4	0.0	0.0	1025.4	2.0	9.0	-1.0	-256.35	f	\N	broking	\N	\N	\N	\N	\N	512.7	f	2	annual	active	\N	\N		SHILPA G S	spouse	\N
31	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-13 13:53:04.192699	2026-05-13 13:53:04.192699	3	1	\N	4	Self	Tata AIG General Insurance	Medicare Premier	7000288448-00	2024-09-15	2024-09-19	2025-09-18	1	Yearly	5000000.0	21924.8	18.0	25871.26	23.0	5042.7	5.0	252.14	4790.56	New	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260511-DGECKX	1	\N	1.0	219.25	5.0	10.96	208.29	5.0	1096.24	5.0	54.81	1041.43	5.0	1096.24	0.0	0.0	1096.24	5.0	11.0	-6.0	-1315.49	t	\N	broking	\N	\N	\N	\N	\N	1096.24	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
32	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-13 13:57:30.867265	2026-05-13 13:57:30.867265	4	1	\N	4	Self	HDFC ERGO General Insurance	Optima Secure	2856 2057 2973 7501 000	2024-09-13	2024-09-25	2025-09-24	1	Yearly	1000000.0	21809.0	18.0	25734.62	12.0	2617.08	5.0	130.85	2486.23	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260512-BIVWPK	1	\N	1.0	218.09	5.0	10.9	207.19	4.0	872.36	5.0	43.62	828.74	4.0	872.36	0.0	0.0	872.36	2.0	9.0	-1.0	-218.09	t	\N	broking	\N	\N	\N	\N	\N	436.18	t	\N	\N	\N	\N	\N	\N	\N	\N	\N
33	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-14 03:16:10.493327	2026-05-14 03:16:10.493327	6	3	\N	4	Self	Niva Bupa Health Insurance	REASSURE 2.0 TITANIUM+	34370258202400	2024-10-04	2024-10-13	2025-10-12	1	Yearly	2500000.0	33253.39	18.0	39239.0	12.5	4156.67	5.0	207.83	3948.84	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260513-NPBJML	2	\N	1.0	332.53	5.0	16.63	315.9	4.0	1330.14	5.0	66.51	1263.63	4.0	1330.14	0.0	0.0	1330.14	2.0	9.0	-1.0	-332.53	t	\N	broking	\N	\N	\N	\N	\N	665.07	t	\N	\N	\N	\N	\N	\N	\N	\N	\N
35	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-14 13:20:47.12683	2026-05-14 13:20:47.12683	5	2	\N	4	Self	Care Health Insurance Ltd	SUPREME	90475760	2025-10-01	2025-10-08	2026-10-07	1	Yearly	700000.0	27581.01	0.0	27581.01	12.75	3516.58	2.0	70.33	3446.25	Renewal	2025-10-08	2026-10-08	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your health policy (90475760) is due for renewal on 07 Oct 2026. Please renew to continue your coverage.","date":"2026-09-07"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (90475760) expires in 15 days on 07 Oct 2026. Please renew to avoid coverage gap.","date":"2026-09-22"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (90475760) expires in 1 week on 07 Oct 2026. Immediate action required.","date":"2026-09-30"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (90475760) expires tomorrow on 07 Oct 2026. Renew now to avoid coverage gap.","date":"2026-10-06"}]	f	f	t	t	f	\N	\N	\N	CUSLEAD-NXX-137-100-HLT	1	\N	1.0	275.81	2.0	5.52	270.29	4.0	1103.24	2.0	22.06	1081.18	4.0	1103.24	0.0	0.0	1103.24	2.0	9.0	-1.0	-275.81	f	\N	broking	\N	health_insurance/35/main_policy/20260514_132047_3123ea1754e2b9af_2025-26_Gopal N_Care Health Policy.pdf	2025-26_Gopal N_Care Health Policy.pdf	application/pdf	514226	551.62	f	27	annual	active	\N	\N		TRIVENI M	spouse	\N
36	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-14 13:40:25.371348	2026-05-14 13:40:25.371348	4	1	\N	4	Self	HDFC ERGO General Insurance	Optima Secure	2856 2057 2973 7502 000	2025-09-23	2025-09-25	2026-09-24	1	Yearly	1500000.0	28184.0	0.0	28184.0	15.0	4227.6	5.0	211.38	4016.22	Renewal	2024-09-25	2025-09-25	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your health policy (2856 2057 2973 7502 000) is due for renewal on 24 Sep 2026. Please renew to continue your coverage.","date":"2026-08-25"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (2856 2057 2973 7502 000) expires in 15 days on 24 Sep 2026. Please renew to avoid coverage gap.","date":"2026-09-09"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (2856 2057 2973 7502 000) expires in 1 week on 24 Sep 2026. Immediate action required.","date":"2026-09-17"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (2856 2057 2973 7502 000) expires tomorrow on 24 Sep 2026. Renew now to avoid coverage gap.","date":"2026-09-23"}]	f	f	t	t	f	\N	\N	\N	CUSLEAD-G R-901-080-HLT	1	\N	1.0	281.84	5.0	14.09	267.75	5.0	1409.2	5.0	70.46	1338.74	5.0	1409.2	0.0	0.0	1409.2	2.0	11.0	-3.0	-845.52	f	\N	broking	\N	health_insurance/36/main_policy/20260514_134025_9a1e1caaf4c8cd06_2025-26_HDFC ERGO_Optima Secure.pdf	2025-26_HDFC ERGO_Optima Secure.pdf	application/pdf	353164	563.68	f	32		active	\N	\N		G Madhusudhan	sibling	\N
37	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-14 13:55:11.403221	2026-05-14 13:55:11.403221	7	1	\N	4	Self	Care Health Insurance Ltd	SUPREME	72895305	2024-10-10	2024-10-18	2025-10-17	1	Yearly	1000000.0	18091.41	18.0	21347.86	15.0	2713.71	5.0	135.69	2578.02	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260513-5P72WP	1	\N	1.0	180.91	5.0	9.05	171.86	5.0	904.57	5.0	45.23	859.34	5.0	904.57	0.0	0.0	904.57	2.0	11.0	-3.0	-542.74	t	\N	broking	\N	health_insurance/37/main_policy/20260514_135511_46a1d11e86566561_2024-25.pdf	2024-25.pdf	application/pdf	491628	361.83	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
38	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-15 03:29:10.75663	2026-05-29 10:42:35.292213	6	3	\N	4	Self	Niva Bupa Health Insurance	REASSURE 2.0 TITANIUM+	34370258202501	2025-10-04	2025-10-14	2026-10-13	1	Yearly	2500000.0	46273.0	0.0	46273.0	12.75	5899.81	2.0	118.0	5781.81	Renewal	2025-10-14	2026-10-14	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your health policy (34370258202501) is due for renewal on 13 Oct 2026. Please renew to continue your coverage.","date":"2026-09-13"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (34370258202501) expires in 15 days on 13 Oct 2026. Please renew to avoid coverage gap.","date":"2026-09-28"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (34370258202501) expires in 1 week on 13 Oct 2026. Immediate action required.","date":"2026-10-06"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (34370258202501) expires tomorrow on 13 Oct 2026. Renew now to avoid coverage gap.","date":"2026-10-12"}]	f	f	t	t	t	dsd	2026-05-29	sd	CUSLEAD-DR -161-280-HLT	2	\N	1.0	462.73	20.0	92.55	370.18	4.0	1850.92	2.0	37.02	1813.9	4.0	1850.92	0.0	0.0	1850.92	2.0	9.0	-1.0	-462.73	f	\N	broking	\N	health_insurance/38/main_policy/20260515_032910_b2cf41614cf3f15f_Dr. Krishna N_2025-26.pdf	Dr. Krishna N_2025-26.pdf	application/pdf	918789	925.46	f	33	annual	active	\N	\N		Dr Lalitha J	spouse	\N
\.


--
-- Data for Name: helpdesk_tickets; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.helpdesk_tickets (id, ticket_number, subject, description, status, priority, category, submitter_type, submitter_id, assigned_to, resolution_notes, resolved_at, sub_agent_id, customer_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: insurance_companies; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.insurance_companies (id, name, status, created_at, updated_at, code, contact_person, email, mobile, address, insurance_type) FROM stdin;
1	Aditya Birla Sun Life Insurance	t	2026-05-11 07:38:42.014241	2026-05-11 07:38:42.014241	\N	\N	\N	\N	\N	life
2	Axis Max Life Insurance	t	2026-05-11 07:38:48.759809	2026-05-11 07:38:48.759809	\N	\N	\N	\N	\N	life
3	Bajaj Allianz Life Insurance	t	2026-05-11 07:38:50.2557	2026-05-11 07:38:50.2557	\N	\N	\N	\N	\N	life
4	Canara HSBC Life Insurance	t	2026-05-11 07:38:53.411714	2026-05-11 07:38:53.411714	\N	\N	\N	\N	\N	life
5	Edelweiss Life Insurance	t	2026-05-11 07:38:59.983847	2026-05-11 07:38:59.983847	\N	\N	\N	\N	\N	life
6	Go Digit Life Insurance Limited	t	2026-05-11 07:39:08.111589	2026-05-11 07:39:08.111589	\N	\N	\N	\N	\N	life
7	HDFC Life Insurance	t	2026-05-11 07:39:18.415761	2026-05-11 07:39:18.415761	\N	\N	\N	\N	\N	life
8	ICICI Prudential Life Insurance	t	2026-05-11 07:39:26.883838	2026-05-11 07:39:26.883838	\N	\N	\N	\N	\N	life
9	Kotak Life Insurance	t	2026-05-11 07:39:36.399318	2026-05-11 07:39:36.399318	\N	\N	\N	\N	\N	life
10	LIC	t	2026-05-11 07:39:40.94621	2026-05-11 07:39:40.94621	\N	\N	\N	\N	\N	life
11	Reliance Nippon Life Insurance Company	t	2026-05-11 07:39:44.354014	2026-05-11 07:39:44.354014	\N	\N	\N	\N	\N	life
12	SBI Life Insurance	t	2026-05-11 07:39:48.628421	2026-05-11 07:39:48.628421	\N	\N	\N	\N	\N	life
13	Shriram Life Insurance	t	2026-05-11 07:39:53.838485	2026-05-11 07:39:53.838485	\N	\N	\N	\N	\N	life
14	TATA AIA Life Insurance	t	2026-05-11 07:39:59.952721	2026-05-11 07:39:59.952721	\N	\N	\N	\N	\N	life
15	Agriculture Insurance Company of India	t	2026-05-11 07:40:02.766357	2026-05-11 07:40:02.766357	\N	\N	\N	\N	\N	motor_other
16	Bajaj Allianz General Insurance	t	2026-05-11 07:40:04.900297	2026-05-11 07:40:04.900297	\N	\N	\N	\N	\N	motor_other
17	Cholamandalam MS General Insurance	t	2026-05-11 07:40:09.111944	2026-05-11 07:40:09.111944	\N	\N	\N	\N	\N	motor_other
18	ECGC Limited	t	2026-05-11 07:40:13.410446	2026-05-11 07:40:13.410446	\N	\N	\N	\N	\N	motor_other
19	Future Generali India Insurance	t	2026-05-11 07:40:18.655195	2026-05-11 07:40:18.655195	\N	\N	\N	\N	\N	motor_other
20	Go Digit Insurance	t	2026-05-11 07:40:22.453472	2026-05-11 07:40:22.453472	\N	\N	\N	\N	\N	motor_other
21	HDFC ERGO General Insurance	t	2026-05-11 07:40:24.682054	2026-05-11 07:40:24.682054	\N	\N	\N	\N	\N	motor_other
22	ICICI Lombard	t	2026-05-11 07:40:28.364434	2026-05-11 07:40:28.364434	\N	\N	\N	\N	\N	motor_other
23	IFFCO TOKIO General Insurance	t	2026-05-11 07:40:30.263493	2026-05-11 07:40:30.263493	\N	\N	\N	\N	\N	motor_other
24	Kshema General Insurance Limited	t	2026-05-11 07:40:32.521417	2026-05-11 07:40:32.521417	\N	\N	\N	\N	\N	motor_other
25	Liberty General Insurance	t	2026-05-11 07:40:36.175354	2026-05-11 07:40:36.175354	\N	\N	\N	\N	\N	motor_other
26	Magma General Insurance	t	2026-05-11 07:40:42.662263	2026-05-11 07:40:42.662263	\N	\N	\N	\N	\N	motor_other
27	National Insurance Company	t	2026-05-11 07:40:54.737278	2026-05-11 07:40:54.737278	\N	\N	\N	\N	\N	motor_other
28	Navi General Insurance Limited	t	2026-05-11 07:40:56.964591	2026-05-11 07:40:56.964591	\N	\N	\N	\N	\N	motor_other
29	New India Assurance	t	2026-05-11 07:41:01.22187	2026-05-11 07:41:01.22187	\N	\N	\N	\N	\N	motor_other
30	Raheja QBE General Insurance	t	2026-05-11 07:41:02.893594	2026-05-11 07:41:02.893594	\N	\N	\N	\N	\N	motor_other
31	Reliance General Insurance	t	2026-05-11 07:41:04.291749	2026-05-11 07:41:04.291749	\N	\N	\N	\N	\N	motor_other
32	Royal Sundaram General Insurance	t	2026-05-11 07:41:05.687015	2026-05-11 07:41:05.687015	\N	\N	\N	\N	\N	motor_other
33	SBI General Insurance	t	2026-05-11 07:41:07.073402	2026-05-11 07:41:07.073402	\N	\N	\N	\N	\N	motor_other
34	Shriram General Insurance	t	2026-05-11 07:41:08.47271	2026-05-11 07:41:08.47271	\N	\N	\N	\N	\N	motor_other
35	Tata AIG General Insurance	t	2026-05-11 07:41:09.86956	2026-05-11 07:41:09.86956	\N	\N	\N	\N	\N	motor_other
36	The Oriental Insurance Company	t	2026-05-11 07:41:12.786428	2026-05-11 07:41:12.786428	\N	\N	\N	\N	\N	motor_other
37	United India Insurance Company	t	2026-05-11 07:41:17.203492	2026-05-11 07:41:17.203492	\N	\N	\N	\N	\N	motor_other
38	Universal Sompo General Insurance	t	2026-05-11 07:41:25.730389	2026-05-11 07:41:25.730389	\N	\N	\N	\N	\N	motor_other
39	Zuno General Insurance	t	2026-05-11 07:41:30.740707	2026-05-11 07:41:30.740707	\N	\N	\N	\N	\N	motor_other
40	Zurich Kotak General Insurance	t	2026-05-11 07:41:34.670467	2026-05-11 07:41:34.670467	\N	\N	\N	\N	\N	motor_other
41	Aditya Birla Health Insurance	t	2026-05-11 07:41:46.06368	2026-05-11 07:41:46.06368	\N	\N	\N	\N	\N	health
42	Bajaj Allianz General Insurance	t	2026-05-11 07:41:50.490947	2026-05-11 07:41:50.490947	\N	\N	\N	\N	\N	health
43	Care Health Insurance Ltd	t	2026-05-11 07:41:58.16113	2026-05-11 07:41:58.16113	\N	\N	\N	\N	\N	health
44	Galaxy Health Insurance Company Ltd	t	2026-05-11 07:42:06.930273	2026-05-11 07:42:06.930273	\N	\N	\N	\N	\N	health
45	HDFC ERGO General Insurance	t	2026-05-11 07:42:11.471426	2026-05-11 07:42:11.471426	\N	\N	\N	\N	\N	health
46	ICICI Lombard	t	2026-05-11 07:42:13.565995	2026-05-11 07:42:13.565995	\N	\N	\N	\N	\N	health
47	Manipal Cigna Health Insurance Company Ltd	t	2026-05-11 07:42:15.565066	2026-05-11 07:42:15.565066	\N	\N	\N	\N	\N	health
48	National Insurance Company	t	2026-05-11 07:42:18.857005	2026-05-11 07:42:18.857005	\N	\N	\N	\N	\N	health
49	New India Assurance	t	2026-05-11 07:42:24.018563	2026-05-11 07:42:24.018563	\N	\N	\N	\N	\N	health
50	Niva Bupa Health Insurance	t	2026-05-11 07:42:28.688423	2026-05-11 07:42:28.688423	\N	\N	\N	\N	\N	health
51	Reliance General Insurance	t	2026-05-11 07:42:33.913887	2026-05-11 07:42:33.913887	\N	\N	\N	\N	\N	health
52	Royal Sundaram General Insurance	t	2026-05-11 07:42:36.369448	2026-05-11 07:42:36.369448	\N	\N	\N	\N	\N	health
53	SBI General Insurance	t	2026-05-11 07:42:38.784165	2026-05-11 07:42:38.784165	\N	\N	\N	\N	\N	health
54	Star Health and Allied Insurance Company Ltd	t	2026-05-11 07:42:45.700278	2026-05-11 07:42:45.700278	\N	\N	\N	\N	\N	health
55	Tata AIG General Insurance	t	2026-05-11 07:42:48.281633	2026-05-11 07:42:48.281633	\N	\N	\N	\N	\N	health
56	The Oriental Insurance Company	t	2026-05-11 07:42:54.991918	2026-05-11 07:42:54.991918	\N	\N	\N	\N	\N	health
57	United India Insurance Company	t	2026-05-11 07:43:00.660346	2026-05-11 07:43:00.660346	\N	\N	\N	\N	\N	health
58	Zurich Kotak General Insurance	t	2026-05-11 07:43:04.084158	2026-05-11 07:43:04.084158	\N	\N	\N	\N	\N	health
\.


--
-- Data for Name: investments; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.investments (id, customer_id, investment_type, product_name, investment_amount, status, investment_date, maturity_date, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: investor_documents; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.investor_documents (id, investor_id, document_type, created_at, updated_at, r2_file_key, r2_filename, r2_content_type, r2_file_size) FROM stdin;
\.


--
-- Data for Name: investors; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.investors (id, first_name, middle_name, last_name, mobile, email, role_id, state, city, birth_date, gender, pan_no, gst_no, company_name, address, bank_name, account_no, ifsc_code, account_holder_name, account_type, upi_id, status, created_at, updated_at, password_digest, username, original_password, invested_amount, investment_percentage, main_document_key, main_document_filename, main_document_content_type, main_document_size, number_of_shares) FROM stdin;
13	ADITHYAA	TANMAOY	KASIBHATTA	6361404087	adithyaatanmayk@gmail.com	0	karnataka	Bengaluru Urban	2007-10-14	Male	QQSPK1480E				STATE BANK OF INDIA	44621414307	SBIN0018230	ADITHYAA TANMAOY KASIBHATTA	Current		0	2026-05-11 07:38:20.140197	2026-05-19 04:21:04.186992	$2a$12$Ox2gpR4krX0TCnbSWMfubOmPGhP4wdf6g2iWYUoTsrieZ0dsEclFi	adithyatanm	Ganesha@123	100000.0	100.0	\N	\N	\N	\N	1
12	Nitin	Kumar	S	9686291349	nithinkumarsrinivasa@gmail.com	0	karnataka	Bengaluru Urban	1992-07-11	Male	GYRPS1042B				KARNATAKA BANK LTD	9562500100139101	KARB0000956	NITHIN KUMAR S	Savings		0	2026-05-11 07:38:18.002691	2026-05-19 17:00:43.157193	$2a$12$gdsiTq6Uk77J5atbFjZlweAFe8DXVJlQoAJJD1.uRP8TkU2lbJAvW	nitins	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
11	Murali	Krishna	Kasibhatta	8686961074	masterlee911@gmail.com	0	karnataka	Bengaluru Urban	1971-12-11	Male	AOGPK1840J										0	2026-05-11 07:38:15.83892	2026-05-19 17:03:25.640725	$2a$12$iVvZRAfBGGgx84sfteVSN./nHWDWK9FqnNpXfPd8nT07sbyeTi0Tm	muralikasib	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
10	Vijendra	M	P	9845957220	vijendramarvin220@gmail.com	0	karnataka	Bengaluru Urban	1982-05-01	Male	AHOPV0261B				HDFC BANK	50100766300236	HDFC0004876	VIJENDRA M P	Savings		0	2026-05-11 07:38:13.651915	2026-05-19 17:05:33.654569	$2a$12$GVOE.3ACjj8KQk.Y13Jbv.PlqSKaR8e6EneBnAt3xmn5s1SILf4pe	vijendrap	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
9	Shivakumar	B	N	9743228985	kunigalshivakumara@gmail.com	0	karnataka	Bengaluru Urban	1982-07-20	Male	CDHPS8602J				CANARA BANK	6781101000772	CNRB0006781	B N SHIVAKUMARA	Savings		0	2026-05-11 07:38:11.504436	2026-05-19 17:07:33.522192	$2a$12$d7qqxP4UAYTyQT2umv9x6.dtw8DtexUkjosRYYsPyqOloHDVFwsA.	shivakumarn	Ganesha@123	100000.0	100.0	\N	\N	\N	\N	1
8	Ashok		B	9845128927	srinanjundeswaratph@gmail.com	0	karnataka	Bengaluru Urban	1983-04-01	Male	AJAPA6347D				STATE BANK OF INDIA	64130013877	SBIN0040894	ASHOK B	Savings		0	2026-05-11 07:38:09.334301	2026-05-19 17:09:14.558163	$2a$12$ycc1VxOWC4Tf9vNL74X6luykFFCfJ2I.GF..K2pm3Y4MaDOve0a.G	ashokb	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
7	Krishna		MURTHY K	9945708639	95krishnamurthy@gmail.com	0	karnataka	Bengaluru Urban	1995-07-05	Male	EPOPK0080R										0	2026-05-11 07:38:07.194447	2026-05-19 17:10:32.154886	$2a$12$fx.6MaZyARv.gPmisT0.R.ovkVvXXIy.IHNfUz9nnO.OjfYKPOMiy	krishnamurt	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
6	N C 		NIRANJAN	9945666226	niranjandev141@gmail.com	0	karnataka	Bengaluru Urban	1995-09-08	Male	AWDPN6661M				AXIS BANK	916010062549984	UTIB0001204	NIRANJAN N C	Savings		0	2026-05-11 07:38:04.989153	2026-05-19 17:12:48.089518	$2a$12$ooIEUeY0cYJP5OU9NyITKOXlBN3DJsrXLbBDmjhxThAZYHLBrmdv6	niranjannir	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
5	YOGESHWARAPPA		K	9980990027	yogi.slvglass4@gmail.com	0	karnataka	Bengaluru Urban	1980-11-25	Male	ABZPY0767G		S L V GLASS	61, 14TH CROSS, KEMPEGOWDANAGAR, BYADARAHALLI,  BENGALURU 560091							0	2026-05-11 07:38:02.850939	2026-05-19 17:15:10.505227	$2a$12$QvrOmlk2ElC3IjAvnaL8n.4x4MwGOZv92WdpPJyzlvlPErbbBm8HK	yogeshslv	Ganesha@123	25000.0	25.0	\N	\N	\N	\N	1
4	Manjunatha		R	9035722613	MANJUNATHA1105@GMAIL.COM	0	karnataka	Bengaluru Urban	1983-05-11	Male	ASAPM6418Q										0	2026-05-11 07:38:00.705507	2026-05-19 17:16:51.139043	$2a$12$OME1ylMJx4vuLT0d7OpnoOrdfvTjClWYxTOzoptbyUIH2IPofD.C.	manjunathar	Ganesha@123	100000.0	100.0	\N	\N	\N	\N	1
3	N		GOPAL	9845798137	ngopalg77@gmail.com	0	karnataka	Bengaluru Urban	1977-07-10	Male	ALHPG4776H				STATE BANK OF INDIA	64038146543	SBIN0040655	N GOPAL	Savings		0	2026-05-11 07:37:58.503701	2026-05-19 17:18:48.159382	$2a$12$u.r.iZjvLDUVucAx5YwIdej4KqZuCUXl5TjGpbH9H6.MbmjKbe2C.	gopaln	Ganesha@123	25000.0	25.0	\N	\N	\N	\N	1
2	DEVARAJ		T H	9845588357	devrajth99@gmail.com	0	karnataka	Bengaluru Urban	1985-05-20	Male	AUQPD5436M				STATE BANK OF INDIA	64063539941	SBIN0040781	DEVARAJ T H	Savings		0	2026-05-11 07:37:56.329779	2026-05-19 17:20:29.266099	$2a$12$SYw/NPVfg5zNp.Rrfq7tM.SOlVcsYbDYfZbkFUKjE912TraKVssJu	devarajth	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
1	DEVARAJ		JAYRAM	7411417470	devraaj.jayram@gmail.com	0	karnataka	Bengaluru Urban	1976-03-04	Male	AERPJ8932K			96, 1st Floor Basappa Layout Hanumanthanagar\r\n	HDFC BANK		HDFC0004876	DEVARAJ J	Savings		0	2026-05-11 07:37:54.024883	2026-05-28 09:18:00.31577	$2a$12$A9ZLeNBcmI2qbm4HqmEHveRIcn/Tne.eH6Ee2YLGliIvklh45aIpS	devarajjayr	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
\.


--
-- Data for Name: invoice_items; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.invoice_items (id, invoice_id, payout_type, payout_id, description, amount, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.invoices (id, invoice_number, payout_type, payout_id, total_amount, status, invoice_date, due_date, paid_at, recipient_name, recipient_email, recipient_address, notes, created_at, updated_at) FROM stdin;
1	INV-AFF-202605-00001	affiliate	1	1687.80	paid	2026-05-17	2026-05-17	2026-05-17 08:54:47.976103	DEVARAJ J	bittideva@gmail.com	\N	Monthly affiliate commission for 1 policies in May 2026: 28000000342787	2026-05-17 08:54:47.982374	2026-05-17 08:54:47.982374
2	INV-DIST-202605-00001	distributor	1	426.25	paid	2026-05-17	2026-05-17	2026-05-17 08:55:05.212301	Krama Consulting	krama.consulting@gmail.com	\N	Monthly distributor commission for 1 payouts in May 2026	2026-05-17 08:55:05.213421	2026-05-17 08:55:05.213421
3	INV-AMB-202605-00001	ambassador	1	426.25	paid	2026-05-17	2026-05-17	2026-05-17 08:55:05.246912	Krama Consulting	krama.consulting@gmail.com	\N	Monthly ambassador commission for 1 payouts in May 2026	2026-05-17 08:55:05.247578	2026-05-17 08:55:05.247578
4	INV-AFF-202605-00008	affiliate	8	4994.16	paid	2026-05-01	2026-05-01	2026-05-29 06:47:51.807331	SOWMYA H T	vijendramarvin220@gmail.com	\N	Backfilled affiliate commission for 1 policies in May 2026	2026-05-29 06:47:52.382808	2026-05-29 06:47:52.382808
5	INV-AMB-202605-00004	ambassador	4	170.45	paid	2026-05-01	2026-05-01	2026-05-29 06:48:04.494849	M P VIJENDRA	vijendramarvin220@gmail.com	\N	Backfilled ambassador commission for 1 payouts in May 2026	2026-05-29 06:48:06.271755	2026-05-29 06:48:06.271755
6	INV-AFF-202605-00006	affiliate	6	446.46	paid	2026-05-29	2026-05-29	2026-05-29 10:46:05.28939	Murali Krishna Kasibhatta	masterlee311@gmail.com	\N	Monthly affiliate commission for 1 policies in May 2026: sssdsd	2026-05-29 10:46:05.290255	2026-05-29 10:46:05.290255
\.


--
-- Data for Name: leads; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.leads (id, name, contact_number, email, referred_by, product_interest, current_stage, created_date, note, created_at, updated_at, lead_id, address, city, state, lead_source, call_disposition, referral_amount, transferred_amount, notes, attachments, stage_updated_at, converted_customer_id, policy_created_id, product_category, product_subcategory, is_direct, affiliate_id, first_name, middle_name, last_name, birth_date, gender, pan_no, gst_no, company_name, marital_status, height, weight, birth_place, education, business_job, business_name, job_name, occupation, type_of_duty, annual_income, additional_information, height_feet, weight_kg, business_job_type, business_job_name, duty_type, is_branch_out, ambassador_id, customer_type, parent_lead_id) FROM stdin;
1	Rr	9632850872	abcd@gmail.com	Friend Reference	\N	consultation_scheduled	2026-05-15	\N	2026-05-15 14:17:23.272929	2026-05-15 16:49:17.469209	CUSLEAD-RRXXX-45280	Bbds	Gshs	Andhra Pradesh	agent_referral	\N	0.00	f		\N	2026-05-15 16:49:17.469277	\N	\N	insurance	health	f	5	Rr	\N	Name	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
7	Eswaraiah Sudha	9686405652	sudha.e68@gmail.com		\N	converted	2026-05-01	\N	2026-05-16 10:49:54.198969	2026-05-16 10:56:46.923298	CUSLEAD-ESWAR-BSRPS	42, Shashwathi Nilaya, 1st A Main Cross Road, Maruthi Layout, RMV 2nd Stage, Blr 560094	Bengaluru Urban	karnataka	agent_referral	interested	0.00	f		\N	2026-05-16 10:56:46.923332	11	\N	insurance	health	f	1	Eswaraiah		Sudha	1967-07-21	female	BSRPS7005K	\N	\N	married	5.17	82								\N		\N	\N	\N	\N	\N	f	\N	individual	\N
9	CM  LINGARAJU	9008666938	nandininaga22@gmail.com	DEVARAJ J	\N	converted	2026-05-17	\N	2026-05-17 06:23:36.169105	2026-05-17 06:23:36.169105	CUSLEAD-CMX-938-280-MTR	62 3rd Cross Durgaparameswarinagar, Kerepalya Main Road Hosakerehalli	Bengaluru Urban	karnataka	agent_referral	\N	0.00	f	Auto-generated lead from motor insurance policy creation. Policy Number: Hdhd	\N	2026-05-17 06:23:36.131366	1	6	insurance	motor	f	1	CM	\N	LINGARAJU	1985-05-28	male	AEXPL1676C	\N	\N	married	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
8	Girish Shivanna 	9845269391	girishatshivanna@gmail.com	Friend Reference	\N	lead_generated	2026-05-16	\N	2026-05-16 11:29:33.834678	2026-05-17 06:29:20.728451	CUSLEAD-GIRIS-69468		No 7 tr nagara bengaluru 	karnataka	agent_referral		0.00	f	For mutual funds how to trigger	\N	2026-05-16 11:29:33.833938	\N	\N	insurance	other	f	3	Girish		Shivanna	\N						4.17									\N		\N	\N	\N	\N	\N	f	\N	individual	\N
15	M N Nagaveni	9743297766		Friend Reference	\N	consultation_scheduled	2026-05-17	\N	2026-05-17 12:05:42.299422	2026-05-17 12:06:21.931018	CUSLEAD-MXXXX-27657		Bengaluru 	Karnataka	agent_referral	\N	0.00	f	Family health Insurance 	\N	2026-05-17 12:06:21.931075	\N	\N	insurance	health	f	2	M	\N	N Nagaveni	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
17	BASAVARAJ  CHANDRASHEKAR	9720008888	basu2736@gmail.com	\N	\N	converted	2026-05-17	\N	2026-05-17 13:22:20.550189	2026-05-17 13:22:20.550189	CUSLEAD-BAS-888-030-MTR	CVC Farmhouse, Kushtagai Road, Bharat Gas, Bhagyanagar, Koppal	Koppal	karnataka	online	\N	0.00	f	Auto-generated lead from motor insurance policy creation. Policy Number: REQ-1779024140	\N	2026-05-17 13:22:20.512051	3	12	insurance	motor	t	\N	BASAVARAJ	\N	CHANDRASHEKAR	1992-08-03	male	AQEPC0330M	\N	\N	married	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
11	ddf  df	8989191919	9093939393fdfds@gmail.com	Test PRamod Bhat	\N	converted	2026-05-17	\N	2026-05-17 06:32:35.179317	2026-05-17 06:32:35.179317	CUSLEAD-DDF-919-010-MTR	dfd	Bengaluru Rural	karnataka	agent_referral	\N	0.00	f	Auto-generated lead from motor insurance policy creation. Policy Number: sdds2132	\N	2026-05-17 06:32:35.170993	\N	8	insurance	motor	f	5	ddf	\N	df	2026-05-01	male	\N	\N	\N		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
12	ddf  df	8989191919	\N	Test PRamod Bhat	\N	converted	2025-08-04	\N	2026-05-17 06:37:45.200222	2026-05-17 06:37:45.200222	CUSLEAD-DDF-919-010-MTR-01	dfd	Bengaluru Rural	karnataka	agent_referral	\N	0.00	f	Auto-generated lead from motor insurance policy creation. Policy Number: dss322	\N	2026-05-17 06:37:45.192645	\N	9	insurance	motor	f	5	ddf	\N	df	2026-05-01	male	\N	\N	\N		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
13	ddf  df	8989191919	\N	Test PRamod Bhat	\N	converted	2023-08-01	\N	2026-05-17 06:46:33.522824	2026-05-17 06:46:33.522824	CUSLEAD-DDF-919-010-MTR-02	dfd	Bengaluru Rural	karnataka	agent_referral	\N	0.00	f	Auto-generated lead from motor insurance policy creation. Policy Number: dsdss	\N	2026-05-17 06:46:33.512507	\N	10	insurance	motor	f	5	ddf	\N	df	2026-05-01	male	\N	\N	\N		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
14	ddf  df	8989191919	\N	Test PRamod Bhat	\N	converted	2026-05-17	\N	2026-05-17 08:44:45.516685	2026-05-17 08:44:45.516685	CUSLEAD-DDF-919-010-MTR-03	dfd	Bengaluru Rural	karnataka	agent_referral	\N	0.00	f	Auto-generated lead from motor insurance policy creation. Policy Number: ssddsdsdsdsds	\N	2026-05-17 08:44:45.506582	\N	11	insurance	motor	f	5	ddf	\N	df	2026-05-01	male	\N	\N	\N		\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
18	Krishna Prasad	9150845577	kp@gmail.com	Friend Reference	\N	converted	2026-05-18	\N	2026-05-18 02:26:28.990715	2026-05-20 14:01:29.520124	CUSLEAD-KRISH-32790		Bengaluru 	Karnataka	agent_referral	\N	0.00	f	Financial planning 	\N	2026-05-20 14:01:29.520192	19	\N	insurance	health	f	6	Krishna	\N	Prasad	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
16	Geetha Guruwale	6515432866		Friend Reference	\N	one_on_one	2026-05-17	\N	2026-05-17 12:24:15.711271	2026-05-25 07:15:42.286969	CUSLEAD-GEETH-91656		Hyderabad 	telangana	agent_referral		0.00	f	Personal Accident policy	\N	2026-05-25 07:15:42.287032	\N	\N	insurance	other	f	1	Geetha		Guruwale	\N															\N		\N	\N	\N	\N	\N	f	\N	individual	\N
19	HANUMANTHA M	9538247661	pradeepdjpradeep16455@gmail.com	VIJENDRA MP	\N	converted	2026-05-24	\N	2026-05-26 00:11:49.467249	2026-05-26 00:42:02.081352	CUSLEAD-HANUM-AISPH	S/O Marigowda, 230/2, Marchanahalli, Channapatna, Karnataka 562160	Ramanagara	karnataka	agent_referral	interested	0.00	f	\n\nUpdated: Policy created - 112233 on 2026-05-26	\N	2026-05-26 00:42:02.070582	22	13	insurance	motor	f	8	HANUMANTHA		M	1985-06-15	male	AISPH0089E	\N	\N	married										\N		\N	\N	\N	\N	\N	f	\N	individual	\N
20	N  GOPAL	9845798137	ngopalg77@gmail.com	Samparka Association	\N	converted	2026-05-26	\N	2026-05-26 11:27:04.714666	2026-05-26 11:27:04.714666	CUSLEAD-NXX-137-100-MTR	\N	\N	\N	agent_referral	\N	0.00	f	Auto-generated lead from motor insurance policy creation. Policy Number: xsdsdss	\N	2026-05-26 11:27:04.701358	5	14	insurance	motor	f	2	N	\N	GOPAL	1977-07-10	male	ALHPG4776H	\N	\N	married	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
21	 T SHIVANNA 	9743003428		Friend Reference	\N	follow_up	2026-05-26	\N	2026-05-26 13:23:41.093111	2026-05-26 13:39:15.162461	CUSLEAD-TXXXX-68187	No 7 	Banglore 	Karnataka	agent_referral	\N	0.00	f		\N	2026-05-26 13:39:15.16249	\N	\N	insurance	motor	f	3	T	\N	SHIVANNA	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
22	Adithyaa Tanmaoy Kasibhatta	6361404087	adithyaatanmayk@gmail.com	Murali Krishna Kasibhatta	\N	converted	2026-05-27	\N	2026-05-27 01:13:12.693852	2026-05-27 01:13:12.693852	CUSLEAD-ADI-087-141-MTR	BSK II Stage	Bengaluru Urban	karnataka	agent_referral	\N	0.00	f	Auto-generated lead from motor insurance policy creation. Policy Number: sssdsd	\N	2026-05-27 01:13:12.681115	16	15	insurance	motor	f	6	Adithyaa	Tanmaoy	Kasibhatta	2007-10-14	male	QQSPK1480E	\N	\N	single	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
23	DR KRISHNA NAGARAJ	9980639161	krishnainduvalu@yahoo.co.in		\N	consultation_scheduled	2026-05-27	\N	2026-05-27 16:49:42.904498	2026-05-29 06:31:25.839194	CUSLEAD-DR KR-ADZPN		Mandya	karnataka	walk_in	follow_up	0.00	f	Created from existing customer: DR KRISHNA  NAGARAJ (ID: 6)	\N	2026-05-29 06:31:25.839241	\N	\N	investments	mutual_fund	t	\N	DR KRISHNA		NAGARAJ	1979-05-28	male	ADZPN3005G	\N	\N	married			MANDYA	MBBS	professional				DOCTOR	2500000.0		\N	\N	\N	\N	\N	t	\N	individual	\N
\.


--
-- Data for Name: life_insurance_bank_details; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.life_insurance_bank_details (id, life_insurance_id, bank_name, account_type, account_number, ifsc_code, account_holder_name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: life_insurance_documents; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.life_insurance_documents (id, life_insurance_id, document_type, document_name, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: life_insurance_nominees; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.life_insurance_nominees (id, life_insurance_id, nominee_name, relationship, age, share_percentage, created_at, updated_at) FROM stdin;
5	9	Kaveri E	spouse	32	100.0	2026-05-29 02:39:18.709326	2026-05-29 02:39:18.709326
\.


--
-- Data for Name: life_insurances; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.life_insurances (id, customer_id, sub_agent_id, policy_holder, insured_name, insurance_company_name, agency_code_id, broker_id, policy_type, payment_mode, policy_number, policy_booking_date, policy_start_date, policy_end_date, risk_start_date, policy_term, premium_payment_term, plan_name, sum_insured, net_premium, first_year_gst_percentage, second_year_gst_percentage, third_year_gst_percentage, total_premium, term_rider_amount, term_rider_note, critical_illness_rider_amount, critical_illness_rider_note, accident_rider_amount, accident_rider_note, pwb_rider_amount, pwb_rider_note, other_rider_amount, other_rider_note, nominee_name, nominee_relationship, nominee_age, bank_name, account_type, account_number, ifsc_code, account_holder_name, reference_by_name, broker_name, bonus, fund, extra_note, main_agent_commission_percentage, commission_amount, tds_percentage, tds_amount, after_tds_value, installment_autopay_start_date, installment_autopay_end_date, active, created_at, updated_at, notification_dates, is_customer_added, is_agent_added, is_admin_added, distributor_id, investor_id, sub_agent_commission_percentage, sub_agent_commission_amount, distributor_commission_percentage, distributor_commission_amount, investor_commission_percentage, investor_commission_amount, main_income_percentage, main_income_amount, total_distribution_percentage, company_expenses_percentage, profit_percentage, profit_amount, sub_agent_tds_percentage, sub_agent_tds_amount, sub_agent_after_tds_value, distributor_tds_percentage, distributor_tds_amount, distributor_after_tds_value, investor_tds_percentage, investor_tds_amount, investor_after_tds_value, product_through_dr, main_agent_commission_received, main_agent_commission_transaction_id, main_agent_commission_paid_date, main_agent_commission_notes, lead_id, ambassador_commission_percentage, ambassador_commission_amount, ambassador_tds_percentage, ambassador_tds_amount, ambassador_after_tds_value, broker_code_type, policy_added_by_admin, original_policy_id, renewal_policy_id, is_renewed, insurance_company_code, main_policy_document_key, main_policy_document_filename, main_policy_document_content_type, main_policy_document_size) FROM stdin;
7	5	\N	N  GOPAL	\N	To be assigned	\N	\N	New	Yearly	REQ-1778988462	2026-05-17	2026-05-17	2046-05-17	\N	20	10	Jeevan Anand	100000.00	2000.00	0.00	0.00	0.00	2000.00	0.00	\N	0.00	\N	0.00	\N	0.00	\N	0.00	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0.00	0.00	\N	0.00	0.00	0.00	0.00	0.00	\N	\N	t	2026-05-17 03:27:42.542103	2026-05-17 03:27:42.542103	[{"type":"renewal","title":"Life Policy Renewal Reminder - 1 Month","message":"Your life policy (REQ-1778988462) is due for renewal on 17 May 2046. Please renew to continue your coverage.","date":"2046-04-17"},{"type":"renewal","title":"Life Policy Renewal Reminder - 15 Days","message":"Your life policy (REQ-1778988462) expires in 15 days on 17 May 2046. Please renew to avoid coverage gap.","date":"2046-05-02"},{"type":"renewal","title":"Life Policy Renewal Reminder - 1 Week","message":"Your life policy (REQ-1778988462) expires in 1 week on 17 May 2046. Immediate action required.","date":"2046-05-10"},{"type":"renewal","title":"Life Policy Renewal Reminder - Final Notice","message":"Your life policy (REQ-1778988462) expires tomorrow on 17 May 2046. Renew now to avoid coverage gap.","date":"2046-05-16"}]	t	f	f	1	\N	2.00	40.00	1.00	20.00	2.00	40.00	0.00	0.00	7.00	2.00	-9.00	-180.00	0.00	0.00	40.00	0.00	0.00	20.00	0.00	0.00	40.00	t	f	\N	\N	\N	CUST-20260513-HYC5D3	2.0	40.0	\N	\N	40.0	\N	f	\N	\N	f	\N	\N	\N	\N	\N
9	18	2	Self	YOGESHA MS	ICICI Prudential Life Insurance	\N	4	New	Half-Yearly	K7676680	2025-11-15	2025-11-28	2026-11-27	2025-05-28	1	1	iProtect Smart+	10000000.00	74024.00	0.00	0.00	0.00	74024.00	0.00	\N	0.00	\N	0.00	\N	0.00	\N	0.00	\N			\N								0.00	0.00		40.50	29979.72	2.00	599.59	29380.13	2025-11-28	2026-05-27	t	2026-05-29 02:39:18.696995	2026-05-29 10:37:24.489089	[{"type":"renewal","title":"Life Policy Renewal Reminder - 1 Month","message":"Your life policy (K7676680) is due for renewal on 27 Nov 2026. Please renew to continue your coverage.","date":"2026-10-28"},{"type":"renewal","title":"Life Policy Renewal Reminder - 15 Days","message":"Your life policy (K7676680) expires in 15 days on 27 Nov 2026. Please renew to avoid coverage gap.","date":"2026-11-12"},{"type":"renewal","title":"Life Policy Renewal Reminder - 1 Week","message":"Your life policy (K7676680) expires in 1 week on 27 Nov 2026. Immediate action required.","date":"2026-11-20"},{"type":"renewal","title":"Life Policy Renewal Reminder - Final Notice","message":"Your life policy (K7676680) expires tomorrow on 27 Nov 2026. Renew now to avoid coverage gap.","date":"2026-11-26"}]	f	f	t	1	\N	5.00	3701.20	1.00	740.24	5.00	3701.20	40.50	29979.72	12.00	5.00	23.50	17395.64	2.00	74.02	3627.18	0.00	0.00	740.24	0.00	0.00	3701.20	t	t	sdds	2026-05-29	sd	CUST-20260519-D1IE2M	1.0	740.24	2.0	14.8	725.44	broking	t	\N	\N	f		\N	\N	\N	\N
\.


--
-- Data for Name: loans; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.loans (id, customer_id, loan_type, loan_amount, interest_rate, loan_term, emi_amount, loan_date, status, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: motor_insurance_documents; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.motor_insurance_documents (id, motor_insurance_id, document_type, title, description, r2_file_key, r2_filename, r2_content_type, r2_file_size, created_at, updated_at, r2_url) FROM stdin;
\.


--
-- Data for Name: motor_insurance_nominees; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.motor_insurance_nominees (id, motor_insurance_id, nominee_name, relationship, age, share_percentage, created_at, updated_at) FROM stdin;
10	13	PRAMODINI C	spouse	33	100.0	2026-05-26 00:42:02.038953	2026-05-26 00:42:02.038953
11	14	M TRIVENI	spouse	44	100.0	2026-05-26 11:27:04.619211	2026-05-26 11:27:04.619211
12	15	NIVED	brother	12	100.0	2026-05-27 01:13:12.632811	2026-05-27 01:13:12.632811
13	16	M TRIVENI	spouse	44	100.0	2026-05-27 10:38:56.566896	2026-05-27 10:38:56.566896
\.


--
-- Data for Name: motor_insurances; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.motor_insurances (id, vehicle_type, class_of_vehicle, registration_number, registration_date, engine_number, chassis_number, mfy, make, model, variant, seating_capacity, discount_loading_percent, previous_policy_number, ncb, legal_liability, electrical_accessories, non_electrical_accessories, zero_depreciation, roadside_assistance, engine_protector, key_replacement, return_to_invoice, consumable_cover, personal_accident_cover, financier, vehicle_idv, cng_idv, total_idv, tp_premium, payout_od, payout_tp, payout_net, main_agent_commission_percent, main_agent_commission_amount, main_agent_tds_percent, main_agent_tds_amount, broker_name, created_at, updated_at, notification_dates, policy_end_date, policy_start_date, policy_booking_date, insurance_company_name, policy_holder, policy_type, gst_percentage, net_premium, gst_amount, after_tds_value, is_customer_added, is_agent_added, is_admin_added, reference_by_name, extra_note, customer_id, sub_agent_id, agency_code_id, broker_id, insurance_type, total_premium, policy_number, sum_insured, status, product_through_dr, main_agent_commission_received, main_agent_commission_transaction_id, main_agent_commission_paid_date, main_agent_commission_notes, lead_id, distributor_id, investor_id, sub_agent_commission_percentage, sub_agent_commission_amount, sub_agent_tds_percentage, sub_agent_tds_amount, sub_agent_after_tds_value, distributor_commission_percentage, distributor_commission_amount, distributor_tds_percentage, distributor_tds_amount, distributor_after_tds_value, investor_commission_percentage, investor_commission_amount, investor_tds_percentage, investor_tds_amount, investor_after_tds_value, ambassador_commission_percentage, ambassador_commission_amount, ambassador_tds_percentage, ambassador_tds_amount, ambassador_after_tds_value, total_distribution_percentage, company_expenses_percentage, profit_percentage, profit_amount, commission_amount, tds_percentage, tds_amount, main_agent_commission_percentage, policy_added_by_admin, payment_mode, plan_name, broker_code_type, installment_autopay_start_date, installment_autopay_end_date, nominee_name, nominee_relation, nominee_dob, insurance_company_code, company_expenses_amount, main_policy_document_key, main_policy_document_filename, main_policy_document_content_type, main_policy_document_size, main_policy_document_url, vehicle_number, vehicle_make, vehicle_model) FROM stdin;
6	New Vehicle	Private Car	Jsjdjdjd	\N	Bxnznd	Ncndnfm	\N	Bzh	Shsz		0	\N		0	\N	\N	\N	f	f	\N	\N	\N	\N	\N	\N	9588.0	\N	9588.0	0.0	\N	\N	\N	\N	500.0	\N	\N	\N	2026-05-17 06:23:36.080625	2026-05-17 06:23:36.080625	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your motor policy (Hdhd) is due for renewal on 16 May 2027. Please renew to continue your coverage.","date":"2027-04-16"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your motor policy (Hdhd) expires in 15 days on 16 May 2027. Please renew to avoid coverage gap.","date":"2027-05-01"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your motor policy (Hdhd) expires in 1 week on 16 May 2027. Immediate action required.","date":"2027-05-09"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your motor policy (Hdhd) expires tomorrow on 16 May 2027. Renew now to avoid coverage gap.","date":"2027-05-15"}]	2027-05-16	2026-05-17	2026-05-17	Agriculture Insurance Company of India	CM  LINGARAJU	New	5.00	10000.00	\N	\N	f	t	f	\N	\N	1	1	\N	\N	Comprehensive	10500.00	Hdhd	0.0	\N	f	f	\N	\N	\N	CUSLEAD-CMX-938-280-MTR	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0.00	\N	\N	\N	500.00	\N	\N	5.00	f	Annual	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N
12	Old Vehicle	Private Car	To be assigned	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	10000.0	\N	10000.0	\N	\N	\N	\N	\N	\N	\N	\N	\N	2026-05-17 13:22:20.334028	2026-05-17 13:22:20.334028	\N	2026-05-17	2026-05-17	2026-05-17	To be assigned	BASAVARAJ  CHANDRASHEKAR	\N	18.00	1000.00	\N	\N	t	f	f	\N	\N	3	\N	\N	\N	Comprehensive	1180.00	REQ-1779024140	\N	\N	f	f	\N	\N	\N	CUSLEAD-BAS-888-030-MTR	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0.00	\N	\N	\N	\N	\N	\N	\N	f	Yearly	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	To be assigned	To be assigned
14	New Vehicle	Private Car	sa22322dsadswe232332	\N			\N				\N	\N	\N	\N	\N	\N	\N	f	f	f	f	f	f	\N		231.98	\N	231.98	0.0	\N	\N	\N	\N	2.3	\N	\N	\N	2026-05-26 11:27:04.610193	2026-05-26 11:27:04.610193	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your motor policy (xsdsdss) is due for renewal on 26 May 2027. Please renew to continue your coverage.","date":"2027-04-26"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your motor policy (xsdsdss) expires in 15 days on 26 May 2027. Please renew to avoid coverage gap.","date":"2027-05-11"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your motor policy (xsdsdss) expires in 1 week on 26 May 2027. Immediate action required.","date":"2027-05-19"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your motor policy (xsdsdss) expires tomorrow on 26 May 2027. Renew now to avoid coverage gap.","date":"2027-05-25"}]	2027-05-26	2026-05-26	2026-05-26	Tata AIG General Insurance	Self	New	18.00	23.00	\N	2.30	f	f	t			5	2	3	\N	Comprehensive	27.14	xsdsdss	\N	\N	f	f	\N	\N	\N	CUSLEAD-NXX-137-100-MTR	1	\N	2.00	0.46	0.00	0.00	0.46	2.00	0.46	\N	\N	\N	2.00	0.46	0.00	0.00	0.46	2.00	0.46	0.00	0.00	0.46	8.00	2.00	0.00	0.00	2.30	0.00	0.00	10.00	t	Yearly	\N	direct	2026-05-26	2027-05-25	\N	\N	\N	\N	0.46	\N	\N	\N	\N	\N	\N	\N	\N
13	Old Vehicle	Goods Vehicle	KA05AL7275	\N	275CNG17DXXS55868	MAT556002NVD24092	2022	2022	ACE		\N	\N	\N	\N	\N	\N	\N	f	f	f	f	f	f	\N		645281.0	\N	645281.0	0.0	\N	\N	\N	\N	9688.68	\N	\N	\N	2026-05-26 00:42:02.02894	2026-05-28 09:12:29.923377	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your motor policy (112233) is due for renewal on 24 May 2027. Please renew to continue your coverage.","date":"2027-04-24"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your motor policy (112233) expires in 15 days on 24 May 2027. Please renew to avoid coverage gap.","date":"2027-05-09"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your motor policy (112233) expires in 1 week on 24 May 2027. Immediate action required.","date":"2027-05-17"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your motor policy (112233) expires tomorrow on 24 May 2027. Renew now to avoid coverage gap.","date":"2027-05-23"}]	2027-05-24	2026-05-25	2026-05-25	Liberty General Insurance	Self	Rollover	18.00	17942.00	\N	9494.91	f	f	t			22	8	\N	2	Comprehensive	21171.56	201350020126790157300000	\N	\N	f	t	IN22614707389020	2026-05-27	9671	CUSLEAD-HANUM-AISPH	4	\N	28.00	5023.76	2.00	100.48	4923.28	2.00	358.84	\N	\N	\N	5.00	897.10	0.00	0.00	897.10	1.00	179.42	2.00	3.59	175.83	36.00	5.00	13.00	2332.46	9688.68	2.00	193.77	54.00	t	Yearly	\N	broking	2026-05-25	2027-05-24	\N	\N	\N	\N	897.1	\N	\N	\N	\N	\N	\N	\N	\N
15	New Vehicle	Private Car	ssd	\N			\N				\N	\N	\N	\N	\N	\N	\N	f	f	f	f	f	f	\N		121120.98	\N	121120.98	0.0	\N	\N	\N	\N	2232.3	\N	\N	\N	2026-05-27 01:13:12.623947	2026-05-28 15:11:51.608927	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your motor policy (sssdsd) is due for renewal on 27 May 2027. Please renew to continue your coverage.","date":"2027-04-27"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your motor policy (sssdsd) expires in 15 days on 27 May 2027. Please renew to avoid coverage gap.","date":"2027-05-12"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your motor policy (sssdsd) expires in 1 week on 27 May 2027. Immediate action required.","date":"2027-05-20"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your motor policy (sssdsd) expires tomorrow on 27 May 2027. Renew now to avoid coverage gap.","date":"2027-05-26"}]	2027-05-27	2026-05-27	2026-05-27	Tata AIG General Insurance	Self	New	18.00	22322.98	\N	2232.30	f	f	t			16	6	3	\N	Comprehensive	26341.12	sssdsd	\N	\N	f	t	260528002	2026-05-28		CUSLEAD-ADI-087-141-MTR	1	\N	2.00	446.46	0.00	0.00	446.46	2.00	446.46	\N	\N	\N	2.00	446.46	0.00	0.00	446.46	2.00	446.46	0.00	0.00	446.46	8.00	2.00	0.00	0.00	2232.30	0.00	0.00	10.00	t	Yearly	\N	direct	2026-05-27	2027-05-26	\N	\N	\N	\N	446.46	\N	\N	\N	\N	\N	\N	\N	\N
16	New Vehicle	Two Wheeler	ERR323	\N			\N				\N	\N	\N	\N	\N	\N	\N	f	f	f	f	f	f	\N		2.0	1.98	3.98	0.0	\N	\N	\N	\N	32.3	\N	\N	\N	2026-05-27 10:38:56.557464	2026-05-27 10:39:22.850486	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your motor policy (RRERE) is due for renewal on 27 May 2027. Please renew to continue your coverage.","date":"2027-04-27"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your motor policy (RRERE) expires in 15 days on 27 May 2027. Please renew to avoid coverage gap.","date":"2027-05-12"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your motor policy (RRERE) expires in 1 week on 27 May 2027. Immediate action required.","date":"2027-05-20"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your motor policy (RRERE) expires tomorrow on 27 May 2027. Renew now to avoid coverage gap.","date":"2027-05-26"}]	2027-05-27	2026-05-27	2026-05-27	Tata AIG General Insurance	Self	New	18.00	323.00	\N	32.30	f	f	t			5	2	3	\N	Comprehensive	381.14	RRERE	\N	\N	t	t	EF	2026-05-27	EEE	\N	1	\N	2.00	6.46	0.00	0.00	6.46	2.00	6.46	\N	\N	\N	2.00	6.46	0.00	0.00	6.46	2.00	6.46	0.00	0.00	6.46	8.00	2.00	0.00	0.00	32.30	0.00	0.00	10.00	t	Yearly	\N	direct	2026-05-27	2027-05-26	\N	\N	\N	\N	6.46	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- Data for Name: mutual_fund_nominees; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.mutual_fund_nominees (id, mutual_fund_id, nominee_name, relationship, age, share_percentage, created_at, updated_at) FROM stdin;
1	1	ddsd	father	23	19.00	2026-05-20 01:19:57.886337	2026-05-20 01:19:57.886337
\.


--
-- Data for Name: mutual_funds; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.mutual_funds (id, customer_id, sub_agent_id, distributor_id, investment_type, amount, fund_name, folio_number, plan_name, start_date, maturity_date, bank_name, account_type, account_number, ifsc_code, account_holder_name, reference_by_name, broker_name, bonus, fund, extra_note, main_agent_commission_percentage, commission_amount, tds_percentage, tds_amount, after_tds_value, sub_agent_commission_percentage, sub_agent_commission_amount, sub_agent_tds_percentage, sub_agent_tds_amount, sub_agent_after_tds_value, distributor_commission_percentage, distributor_commission_amount, distributor_tds_percentage, distributor_tds_amount, distributor_after_tds_value, investor_commission_percentage, investor_commission_amount, company_expenses_percentage, company_expenses_amount, total_distribution_percentage, profit_percentage, profit_amount, main_policy_document_key, main_policy_document_filename, main_policy_document_content_type, main_policy_document_size, installment_autopay_start_date, installment_autopay_end_date, is_admin_added, is_customer_added, is_agent_added, active, created_at, updated_at) FROM stdin;
1	16	1	1	SIP	232000.00	dsds	2233	Growth	2026-05-20	2026-06-04								0.00	0.00		10.00	23200.00	0.00	0.00	23200.00	2.00	4640.00	0.00	0.00	4640.00	1.00	2320.00	0.00	0.00	2320.00	2.00	4640.00	0.00	0.00	5.00	5.00	11600.00	mutual_fund/1/20260520_011957_1f801d6d8d1d6d53_logo.jpeg	logo.jpeg	image/jpeg	22400	2026-05-20	2026-05-20	t	f	f	t	2026-05-20 01:19:57.872968	2026-05-20 01:19:58.606663
2	5	1	1	SIP	2000.00				\N	\N								0.00	0.00		0.00	0.00	0.00	0.00	0.00	2.00	40.00	0.00	0.00	40.00	0.00	0.00	0.00	0.00	0.00	2.00	40.00	0.00	0.00	4.00	-4.00	-80.00	\N	\N	\N	\N	2026-05-20	2026-05-20	t	f	f	t	2026-05-20 03:41:26.693977	2026-05-20 03:41:26.693977
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.notifications (id, recipient_type, recipient_id, notification_type, title, message, reference_type, reference_id, is_read, sent_at, read_at, created_at, updated_at) FROM stdin;
1	SubAgent	2	helpdesk_comment_added	New Comment on Your Support Ticket	An admin has added a comment to your support ticket: Help Request from Samparka Association	ClientRequest	4	f	2026-05-17 12:03:20.939055	\N	2026-05-17 12:03:20.938867	2026-05-17 12:03:20.938867
2	SubAgent	1	helpdesk_comment_added	New Comment on Your Support Ticket	An admin has added a comment to your support ticket: Help Request from DEVARAJ J	ClientRequest	3	f	2026-05-18 03:31:39.615763	\N	2026-05-18 03:31:39.615698	2026-05-18 03:31:39.615698
3	SubAgent	3	helpdesk_comment_added	New Comment on Your Support Ticket	An admin has added a comment to your support ticket: Help Request from LOKESH SHIVANNA	ClientRequest	5	f	2026-05-26 14:14:35.537952	\N	2026-05-26 14:14:35.537891	2026-05-26 14:14:35.537891
4	SubAgent	3	helpdesk_comment_added	New Comment on Your Support Ticket	An admin has added a comment to your support ticket: Help Request from LOKESH SHIVANNA	ClientRequest	2	f	2026-05-28 08:55:20.660303	\N	2026-05-28 08:55:20.660233	2026-05-28 08:55:20.660233
\.


--
-- Data for Name: other_insurance_documents; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.other_insurance_documents (id, other_insurance_id, document_type, title, description, r2_file_key, r2_filename, r2_content_type, r2_file_size, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: other_insurance_nominees; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.other_insurance_nominees (id, other_insurance_id, nominee_name, relationship, age, share_percentage, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: other_insurances; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.other_insurances (id, policy_id, other_policy_type, main_agent_commission_percent, main_agent_commission_amount, main_agent_tds_percent, main_agent_tds_amount, reference_by_name, broker_name, created_at, updated_at, notification_dates, policy_end_date, policy_start_date, policy_booking_date, product_through_dr, main_agent_commission_received, main_agent_commission_transaction_id, main_agent_commission_paid_date, main_agent_commission_notes, lead_id, distributor_id, investor_id, policy_holder, broker_code_type, agency_code_id, broker_id, gst_percentage, payment_mode, plan_name, policy_term, claim_process, commission_amount, tds_percentage, tds_amount, after_tds_value, sub_agent_commission_percentage, sub_agent_commission_amount, sub_agent_tds_percentage, sub_agent_tds_amount, sub_agent_after_tds_value, investor_commission_percentage, investor_commission_amount, investor_tds_percentage, investor_tds_amount, investor_after_tds_value, ambassador_commission_percentage, ambassador_commission_amount, ambassador_tds_percentage, ambassador_tds_amount, ambassador_after_tds_value, company_expenses_percentage, total_distribution_percentage, profit_percentage, profit_amount, installment_autopay_start_date, installment_autopay_end_date, main_agent_commission_percentage, policy_type, is_customer_added, is_agent_added, is_admin_added, policy_added_by_admin, is_renewed, original_policy_id, insurance_company_code, main_policy_document_key, main_policy_document_filename, main_policy_document_content_type, main_policy_document_size, company_expenses_amount, total_premium, net_premium, sum_insured, insurance_company_name, customer_id, insurance_type, sub_agent_id, policy_number) FROM stdin;
6	\N	\N	\N	\N	\N	\N	\N	\N	2026-05-17 11:43:23.047349	2026-05-17 11:43:23.047349	\N	2026-05-31	2026-05-17	2026-05-17	f	f	\N	\N	\N	CUSLEAD-NXX-137-100-OTH	\N	\N	N  GOPAL	\N	\N	\N	18.0	Yearly	Home Ins	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	New	t	f	f	f	\N	\N	\N	\N	\N	\N	\N	\N	1500.00	1500.00	10000000.00	To be assigned	5	General Insurance	\N	REQ-1779018203
7	\N	\N	\N	\N	\N	\N	\N	\N	2026-05-17 13:04:09.369584	2026-05-17 13:04:09.369584	\N	2026-05-17	2026-05-17	2026-05-17	f	f	\N	\N	\N	CUSLEAD-BAS-888-030-OTH	\N	\N	BASAVARAJ  CHANDRASHEKAR	\N	\N	\N	18.0	Yearly	Bfbf	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	New	t	f	f	f	\N	\N	\N	\N	\N	\N	\N	\N	5.00	5.00	56.00	To be assigned	3	General Insurance	\N	REQ-1779023049
8	\N	\N	\N	\N	\N	\N	\N	\N	2026-05-17 13:05:27.436159	2026-05-17 13:05:27.436159	\N	2026-05-17	2026-05-17	2026-05-17	f	f	\N	\N	\N	CUSLEAD-BAS-888-030-OTH-01	\N	\N	BASAVARAJ  CHANDRASHEKAR	\N	\N	\N	18.0	Yearly	Bxh	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	New	t	f	f	f	\N	\N	\N	\N	\N	\N	\N	\N	656.00	656.00	6565.00	To be assigned	3	General Insurance	\N	REQ-1779023127
\.


--
-- Data for Name: payout_audit_logs; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.payout_audit_logs (id, auditable_type, auditable_id, action, changes, performed_by, ip_address, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: payout_distributions; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.payout_distributions (id, commission_receipt_id, recipient_type, recipient_id, distribution_percentage, calculated_amount, paid_amount, pending_amount, status, payment_date, payment_mode, transaction_id, reference_number, payment_notes, processed_by, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: payouts; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.payouts (id, policy_type, policy_id, customer_id, total_commission_amount, status, payout_date, processed_by, processed_at, notes, reference_number, created_at, updated_at, main_agent_percentage, main_agent_commission_amount, main_agent_commission_id, affiliate_percentage, affiliate_commission_amount, affiliate_commission_id, ambassador_percentage, ambassador_commission_amount, ambassador_commission_id, investor_percentage, investor_commission_amount, investor_commission_id, company_expense_percentage, company_expense_amount, company_expense_commission_id, commission_summary, net_premium, main_agent_commission_received, main_agent_commission_transaction_id, main_agent_commission_paid_date, main_agent_commission_notes) FROM stdin;
18	health	36	4	28184.0	pending	2026-06-13	system_auto	\N	Structured payout for health policy #2856 2057 2973 7502 000	PAYOUT_HEALTH_36_1778766025	2026-05-14 13:40:25.485232	2026-05-14 13:40:25.509325	\N	4227.60	\N	\N	1338.74	\N	\N	267.75	\N	\N	1409.20	\N	\N	563.68	\N	\N	28184.0	\N	\N	\N	\N
19	health	37	7	18091.41	pending	2026-06-13	system_auto	\N	Structured payout for health policy #72895305	PAYOUT_HEALTH_37_1778766911	2026-05-14 13:55:11.462167	2026-05-14 13:55:11.526739	\N	2713.71	\N	\N	859.34	\N	\N	171.86	\N	\N	904.57	\N	\N	361.83	\N	\N	18091.41	\N	\N	\N	\N
20	health	38	6	46273.0	pending	2026-06-14	system_auto	\N	Structured payout for health policy #34370258202501\nMain agent commission paid - Transaction: dsd on 2026-05-29	PAYOUT_HEALTH_38_1778815750	2026-05-15 03:29:10.821362	2026-05-29 10:42:35.616067	\N	5899.81	\N	\N	1813.90	\N	\N	370.18	\N	\N	1850.92	\N	\N	925.46	\N	\N	46273.0	t	dsd	2026-05-29	sd
9	health	27	5	2224.19	pending	2026-06-12	system_auto	\N	Structured payout for health policy #90475760	PAYOUT_HEALTH_27_1778671539	2026-05-13 11:25:39.026727	2026-05-13 11:25:39.047877	\N	266.90	\N	\N	84.52	\N	\N	21.13	\N	\N	88.97	\N	\N	44.48	\N	\N	2224.19	\N	\N	\N	\N
11	health	29	3	10000.0	pending	2026-06-12	system_auto	\N	Structured payout for health policy #sd	PAYOUT_HEALTH_29_1778675729	2026-05-13 12:35:29.094001	2026-05-13 12:35:29.125626	\N	1000.00	\N	\N	100.00	\N	\N	300.00	\N	\N	100.00	\N	\N	200.00	\N	\N	10000.0	\N	\N	\N	\N
12	health	30	2	25635.0	pending	2026-06-12	system_auto	\N	Structured payout for health policy #89557128	PAYOUT_HEALTH_30_1778679853	2026-05-13 13:44:13.605415	2026-05-13 13:44:13.627719	\N	3076.20	\N	\N	974.13	\N	\N	243.53	\N	\N	1025.40	\N	\N	512.70	\N	\N	25635.0	\N	\N	\N	\N
13	health	31	3	21924.8	pending	2026-06-12	system_auto	\N	Structured payout for health policy #7000288448-00	PAYOUT_HEALTH_31_1778680384	2026-05-13 13:53:04.205932	2026-05-13 13:53:04.229773	\N	5042.70	\N	\N	1041.43	\N	\N	208.29	\N	\N	1096.24	\N	\N	1096.24	\N	\N	21924.8	\N	\N	\N	\N
14	health	32	4	21809.0	pending	2026-06-12	system_auto	\N	Structured payout for health policy #2856 2057 2973 7501 000	PAYOUT_HEALTH_32_1778680650	2026-05-13 13:57:30.880193	2026-05-13 13:57:30.894453	\N	2617.08	\N	\N	828.74	\N	\N	207.19	\N	\N	872.36	\N	\N	436.18	\N	\N	21809.0	\N	\N	\N	\N
15	health	33	6	33253.39	pending	2026-06-13	system_auto	\N	Structured payout for health policy #34370258202400	PAYOUT_HEALTH_33_1778728570	2026-05-14 03:16:10.508653	2026-05-14 03:16:10.527729	\N	4156.67	\N	\N	1263.63	\N	\N	315.90	\N	\N	1330.14	\N	\N	665.07	\N	\N	33253.39	\N	\N	\N	\N
38	health	50	5	23000.0	pending	2026-06-16	system_auto	\N	Structured payout for health policy #REQ-1779018374	PAYOUT_HEALTH_50_1779018375	2026-05-17 11:46:15.193384	2026-05-17 11:46:15.215667	\N	2300.00	\N	\N	\N	\N	\N	460.00	\N	\N	460.00	\N	\N	460.00	\N	\N	23000.0	\N	\N	\N	\N
17	health	35	5	27581.01	pending	2026-06-13	system_auto	\N	Structured payout for health policy #90475760	PAYOUT_HEALTH_35_1778764847	2026-05-14 13:20:47.286487	2026-05-14 13:20:47.313838	\N	3516.58	\N	\N	1081.18	\N	\N	270.29	\N	\N	1103.24	\N	\N	551.62	\N	\N	27581.01	\N	\N	\N	\N
39	health	51	9	11500.0	pending	2026-06-17	system_auto	\N	Structured payout for health policy #REQ-1779073559	PAYOUT_HEALTH_51_1779073559	2026-05-18 03:05:59.850105	2026-05-18 03:05:59.861835	\N	1150.00	\N	\N	\N	\N	\N	230.00	\N	\N	230.00	\N	\N	230.00	\N	\N	11500.0	\N	\N	\N	\N
40	health	52	19	9838.0	pending	2026-06-19	system_auto	\N	Structured payout for health policy #100063248600	PAYOUT_HEALTH_52_1779285907	2026-05-20 14:05:07.315195	2026-05-20 14:05:07.402785	\N	2065.98	\N	\N	482.06	\N	\N	96.41	\N	\N	491.90	\N	\N	491.90	\N	\N	9838.0	\N	\N	\N	\N
4	health	15	1	9126.15	pending	2026-06-12	system_auto	\N	Structured payout for health policy #85432300\nMain agent commission paid - Transaction: 20240615001 on 2024-06-15	PAYOUT_HEALTH_15_1778636275	2026-05-13 01:37:55.970395	2026-05-26 13:54:50.794624	\N	1095.14	\N	\N	433.49	\N	\N	86.70	\N	\N	91.26	\N	\N	91.26	\N	\N	9126.15	t	20240615001	2024-06-15	referred by Naga CM
42	motor	14	5	23.0	pending	2026-06-25	system_auto	\N	Structured payout for motor policy #xsdsdss	PAYOUT_MOTOR_14_1779877772	2026-05-27 10:29:33.026003	2026-05-27 10:29:39.506515	\N	2.30	\N	\N	0.46	\N	\N	0.46	\N	\N	0.46	\N	\N	0.46	\N	\N	23.0	\N	\N	\N	\N
31	life	1	9	32332.98	pending	2026-06-14	system_auto	\N	Structured payout for life policy #wq32223	PAYOUT_LIFE_1_1778844633	2026-05-15 11:30:33.484565	2026-05-15 11:30:33.501679	\N	14549.84	\N	\N	646.66	\N	\N	966.76	\N	\N	646.66	\N	\N	646.66	\N	\N	32332.98	\N	\N	\N	\N
34	life	4	10	10000.0	pending	2026-06-14	system_auto	\N	Structured payout for life policy #Udx 	PAYOUT_LIFE_4_1778854620	2026-05-15 14:17:00.108912	2026-05-15 14:17:00.12245	\N	\N	\N	\N	200.00	\N	\N	200.00	\N	\N	200.00	\N	\N	200.00	\N	\N	10000.0	\N	\N	\N	\N
44	health	2	2	24273.58	pending	2026-06-10	system_auto	\N	Structured payout for health policy #89557128	PAYOUT_HEALTH_2_1779877791	2026-05-27 10:29:52.168418	2026-05-27 10:29:57.472848	\N	2912.83	\N	\N	1153.00	\N	\N	230.60	\N	\N	\N	\N	\N	1213.68	\N	\N	24273.58	\N	\N	\N	\N
37	health	49	11	43056.0	pending	2026-06-15	system_auto	\N	Structured payout for health policy #28000000342787\nMain agent commission paid - Transaction: sdds on 2026-05-17	PAYOUT_HEALTH_49_1778929383	2026-05-16 11:03:03.378246	2026-05-17 08:54:32.586112	\N	5382.00	\N	\N	1687.80	\N	\N	426.25	\N	\N	1722.24	\N	\N	861.12	\N	\N	43056.0	t	sdds	2026-05-17	sd
45	health	1	1	9126.15	pending	2026-06-10	system_auto	\N	Structured payout for health policy #85432300	PAYOUT_HEALTH_1_1779877798	2026-05-27 10:29:59.168377	2026-05-27 10:30:04.269122	\N	2920.37	\N	\N	433.49	\N	\N	86.70	\N	\N	\N	\N	\N	456.31	\N	\N	9126.15	\N	\N	\N	\N
46	motor	16	5	323.0	pending	2026-06-26	system_auto	\N	Structured payout for motor policy #RRERE\nMain agent commission paid - Transaction: EF on 2026-05-27	PAYOUT_MOTOR_16_1779878336	2026-05-27 10:38:56.595297	2026-05-27 10:39:23.191294	\N	32.30	\N	\N	6.46	\N	\N	6.46	\N	\N	6.46	\N	\N	6.46	\N	\N	323.0	t	EF	2026-05-27	EEE
41	motor	13	22	17942.0	pending	2026-06-25	system_auto	\N	Structured payout for motor policy #201350020126790157300000\nMain agent commission paid - Transaction: IN22614707389020 on 2026-05-27	PAYOUT_MOTOR_13_1779877762	2026-05-27 10:29:23.821291	2026-05-28 09:12:30.186421	\N	7176.80	\N	\N	4994.16	\N	\N	170.45	\N	\N	897.10	\N	\N	538.26	\N	\N	17942.0	t	IN22614707389020	2026-05-27	9671
43	motor	15	16	22322.98	pending	2026-06-26	system_auto	\N	Structured payout for motor policy #sssdsd\nMain agent commission paid - Transaction: 260528002 on 2026-05-28	PAYOUT_MOTOR_15_1779877780	2026-05-27 10:29:41.207159	2026-05-28 15:11:51.886681	\N	2232.30	\N	\N	446.46	\N	\N	446.46	\N	\N	446.46	\N	\N	446.46	\N	\N	22322.98	t	260528002	2026-05-28	
47	life	9	18	74024.0	pending	2026-06-28	system_auto	\N	Structured payout for life policy #K7676680\nMain agent commission paid - Transaction: sdds on 2026-05-29	PAYOUT_LIFE_9_1780022358	2026-05-29 02:39:18.715572	2026-05-29 10:37:24.984295	\N	29380.13	\N	\N	3627.18	\N	\N	725.44	\N	\N	3701.20	\N	\N	3701.20	\N	\N	74024.0	t	sdds	2026-05-29	sd
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.permissions (id, name, module_name, action_type, description, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: policies; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.policies (id, customer_id, user_id, insurance_company_id, agency_broker_id, policy_number, policy_type, insurance_type, plan_name, payment_mode, policy_booking_date, policy_start_date, policy_end_date, policy_term_years, risk_start_date, sum_insured, net_premium, gst_percentage, total_premium, bonus, fund, note, status, created_at, updated_at, policy_holder) FROM stdin;
\.


--
-- Data for Name: policy_documents; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.policy_documents (id, policy_type, policy_id, document_type, title, description, uploaded_by, r2_file_key, r2_filename, r2_content_type, r2_file_size, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.reports (id, name, report_type, filters, report_data, status, generated_at, created_by_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.role_permissions (id, role_id, permission_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.roles (id, name, description, status, created_at, updated_at) FROM stdin;
1	super_admin	Full system access with all privileges.	t	2026-05-11 07:28:54.135721	2026-05-11 07:28:54.135721
2	sub_agent	\N	t	2026-05-11 11:05:19.526756	2026-05-11 11:05:19.526756
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.schema_migrations (version) FROM stdin;
20251116114809
20251116114816
20251116114823
20251116114829
20251116114837
20251116114846
20251116114857
20251116114906
20251116114920
20251116114930
20251116114942
20251116115020
20251116115323
20251206023244
20251207021953
20251207021959
20251207022011
20251207022023
20251207022657
20251207022703
20251207030728
20251207031308
20251207032749
20251207032756
20251208020820
20251208032858
20251208033216
20251208033314
20251210000047
20251210000515
20251210010533
20251210142045
20251210154251
20251210154344
20251211050900
20251211162531
20251211162549
20251211162613
20251211162638
20251211170000
20251212004318
20251213004822
20251213020041
20251213020459
20251215024244
20251215034230
20251215034940
20251215070425
20251215071125
20251216021955
20251216022423
20251216022745
20251216023349
20251216023457
20251216025323
20251216105459
20251216105527
20251216105917
20251216105933
20251216122404
20251217010715
20251220050644
20251220072350
20251220130647
20251220131510
20251220135204
20251220155930
20251220163223
20251220164000
20251221013208
20251221013217
20251221013226
20251221013236
20251221020620
20251222041149
20251222043945
20251223044856
20251223050649
20251223050702
20251223053221
20251224050705
20251225061741
20251225120327
20251226141714
20251226142205
20251226144604
20251227025404
20251227025921
20251227044709
20251227142226
20251227142244
20251228053428
20251228135458
20251228154545
20251229094438
20251229155842
20251230132803
20260101003809
20260101014659
20260101043849
20260101160547
20260102152536
20260103035139
20260103042523
20260103043250
20260105074724
20260106014758
20260106015013
20260110022612
20260110025235
20260110043040
20260110044344
20260112140914
20260112142642
20260112164500
20260113153107
20260113153204
20260113153225
20260113155910
20260114135128
20260114155438
20260115082229
20260115103728
20260115155330
20260116021856
20260116121300
20260116123728
20260116124205
20260116125249
20260116125302
20260117011900
20260117012304
20260117015151
20260117042226
20260117042853
20260117043931
20260117060431
20260117063353
20260117072523
20260117095122
20260117103539
20260117110232
20260117111738
20260117145030
20260118012030
20260118060311
20260118061803
20260118062057
20260118062307
20260118063227
20260118064533
20260118064748
20260118065028
20260118133559
20260120013817
20260120014756
20260120122454
20260120153958
20260120154953
20260120160543
20260121002344
20260121062438
20260122053010
20260122123911
20260123021403
20260124001232
20260124051502
20260124061011
20260124061550
20260126054849
20260126054912
20260126054957
20260126055625
20260126102943
20260126124132
20260126130837
20260126155806
20260128012149
20260128015707
20260129164211
20260130140104
20260201072012
20260202004728
20260202025046
20260202030027
20260202040231
20260202074936
20260203120117
20260203140418
20260204005352
20260204012909
20260207072855
20260208025028
20260210002958
20260210014123
20260210100948
20260213032616
20260213034805
20260213034900
20260217003246
20260217003654
20260303031139
20260305083645
20260312100850
20260313020337
20260313020629
20260313044329
20260313044416
20260313102347
20260315070711
20260315135834
20260316073755
20260317023127
20260317041007
20260317113113
20260322001729
20260322001928
20260322045517
20260324121502
20260327112210
20260327113258
20260327155233
20260328035620
20260328101306
20260331015544
20260406044200
20260412105215
20260412120413
20260413134200
20260416121749
20260416122812
20260507000001
20260507000002
20260507000003
20260508000001
20260508000002
20260510000001
20260510000002
20260510000003
20260511000001
20260511000002
20260511000003
20260511000004
20260512093854
20260515000001
20260515000002
20260516000001
20260516044545
20260516044550
20260516050000
20260516060000
20260517070000
20260517080000
20260520100000
20260520100001
20260523000001
20260525000001
20260527000001
20260527000002
\.


--
-- Data for Name: session_activities; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.session_activities (id, user_id, activity_type, occurred_at, ip_address, user_agent, session_id, created_at, updated_at) FROM stdin;
1	2	login	2026-05-11 07:37:31.810293	104.23.211.85	Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	75699c363749ec7924310d3b1a1e4626	2026-05-11 07:37:31.82358	2026-05-11 07:37:31.82358
2	2	login	2026-05-11 07:39:42.543842	172.70.135.212	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	e207e87e69a5e79e79a704d871eb6750	2026-05-11 07:39:42.56795	2026-05-11 07:39:42.56795
3	2	logout	2026-05-11 07:42:47.531181	172.68.146.154	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	9556d28f0ece1a481d308d685d0f418c	2026-05-11 07:42:47.531968	2026-05-11 07:42:47.531968
4	2	login	2026-05-11 07:44:03.878862	172.68.146.154	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	b4883b4198cbdfc11c066a19c891ba3b	2026-05-11 07:44:03.879585	2026-05-11 07:44:03.879585
5	2	logout	2026-05-11 07:51:33.180917	104.23.211.84	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	de4ea665385317ccd2190680c0187a04	2026-05-11 07:51:33.18167	2026-05-11 07:51:33.18167
6	2	login	2026-05-11 09:58:02.584771	172.68.146.154	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	3ac314d2cd475dafdc28e7d3957bc613	2026-05-11 09:58:02.585433	2026-05-11 09:58:02.585433
7	2	logout	2026-05-11 13:18:30.506326	172.69.123.140	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	0ba394a35d6914c826a3377414f05777	2026-05-11 13:18:30.542706	2026-05-11 13:18:30.542706
8	2	login	2026-05-11 13:18:56.932769	172.69.123.140	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	58f243c49650ad6882a3cf5fb4d13375	2026-05-11 13:18:56.961112	2026-05-11 13:18:56.961112
9	2	login	2026-05-12 04:23:04.183326	104.23.209.224	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	1f969aa9d5cffc08c5546056e42706a4	2026-05-12 04:23:04.205106	2026-05-12 04:23:04.205106
10	2	logout	2026-05-12 05:28:07.098801	104.23.209.183	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	9778a991a5187ee557c1ae30563f1598	2026-05-12 05:28:07.099947	2026-05-12 05:28:07.099947
11	2	login	2026-05-12 05:44:16.437989	162.158.54.197	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	bfe319f1b9919b785a54b48ca57a676f	2026-05-12 05:44:16.454288	2026-05-12 05:44:16.454288
12	2	logout	2026-05-12 06:22:11.496904	172.69.131.184	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	2aa65f82a95225ca1da6b67fd738119c	2026-05-12 06:22:11.521371	2026-05-12 06:22:11.521371
13	2	login	2026-05-12 10:41:08.363156	172.69.131.184	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	0b9a5f0f6740e2b82b8e4c3b1a496c0a	2026-05-12 10:41:08.377433	2026-05-12 10:41:08.377433
14	2	login	2026-05-12 14:36:19.034227	172.69.131.183	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	c07a7023e2fa174a6c149f7985bd9825	2026-05-12 14:36:19.047842	2026-05-12 14:36:19.047842
15	2	login	2026-05-12 17:21:09.895214	162.158.54.196	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	626f961c9b4b6e9feb9309d93442f42b	2026-05-12 17:21:09.895865	2026-05-12 17:21:09.895865
16	2	login	2026-05-13 01:00:36.370817	172.68.146.213	Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36	5f228073d23695ce03413255ac810c77	2026-05-13 01:00:36.3715	2026-05-13 01:00:36.3715
17	2	login	2026-05-13 01:17:20.478101	172.68.146.213	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	6dca018cf8c0b51fa978a1683efdec4a	2026-05-13 01:17:20.478821	2026-05-13 01:17:20.478821
18	2	login	2026-05-13 03:12:13.23024	172.69.122.134	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	a2585d1642476fbabeba066bde624bbf	2026-05-13 03:12:13.231025	2026-05-13 03:12:13.231025
19	2	logout	2026-05-13 04:38:06.7983	104.23.211.172	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	8e7e01f5fe43fcb7e34f5e5c712296e9	2026-05-13 04:38:06.799198	2026-05-13 04:38:06.799198
20	2	login	2026-05-13 10:43:21.315396	172.69.123.194	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	ceb7c2d9e767732970079f75abc2faaf	2026-05-13 10:43:21.315995	2026-05-13 10:43:21.315995
21	2	login	2026-05-13 13:34:28.609458	172.69.123.195	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	0f7c5f4097c0d67f7ea2cc9e53c526ec	2026-05-13 13:34:28.624155	2026-05-13 13:34:28.624155
22	2	logout	2026-05-13 13:59:13.567994	162.158.54.196	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	5f2f04aa25805412fbe79bc0b82bffe8	2026-05-13 13:59:13.568874	2026-05-13 13:59:13.568874
23	2	login	2026-05-14 02:36:05.087323	172.69.129.224	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	08244dd59c8532bc6906870d2890ba16	2026-05-14 02:36:05.18436	2026-05-14 02:36:05.18436
24	2	logout	2026-05-14 05:42:47.047178	172.69.131.183	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	7c6f1368404a7c330cbd47d0ea3a68c4	2026-05-14 05:42:47.048016	2026-05-14 05:42:47.048016
25	2	login	2026-05-14 05:42:56.274363	172.69.131.183	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	9e3cdf92885b3902ea36c5620b5fdb40	2026-05-14 05:42:56.275211	2026-05-14 05:42:56.275211
26	2	login	2026-05-15 03:17:33.436143	104.23.211.85	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	ee99d728810d8defb63d7d8320c648cf	2026-05-15 03:17:33.448072	2026-05-15 03:17:33.448072
27	2	logout	2026-05-15 03:59:23.636374	172.70.34.174	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	e3dee163a21c27e16759b5b9a298768d	2026-05-15 03:59:23.674585	2026-05-15 03:59:23.674585
28	2	login	2026-05-15 07:05:34.543962	162.158.54.197	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	9665be8f38a277335576c0e34be37787	2026-05-15 07:05:34.569969	2026-05-15 07:05:34.569969
29	2	login	2026-05-15 16:44:50.819193	162.158.79.191	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	ed420793a769e0bcbae2ea433a1800e3	2026-05-15 16:44:50.832818	2026-05-15 16:44:50.832818
30	3	login	2026-05-15 16:56:26.70054	104.23.209.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	e0716d92c42c7135128e1cd4729c237d	2026-05-15 16:56:26.701125	2026-05-15 16:56:26.701125
31	3	logout	2026-05-15 16:58:43.70463	104.23.209.214	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	a139ae3f0b00fb26ad38b248b2eebd14	2026-05-15 16:58:43.705301	2026-05-15 16:58:43.705301
32	2	login	2026-05-16 03:48:23.723986	172.69.123.140	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	538e0a89429bb2d8facc30c63cf72878	2026-05-16 03:48:23.73635	2026-05-16 03:48:23.73635
33	2	login	2026-05-16 06:21:51.733155	162.158.79.152	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	f30a982bdf52192b17f6701d20f1c747	2026-05-16 06:21:51.763534	2026-05-16 06:21:51.763534
34	2	login	2026-05-16 07:07:51.503374	172.69.131.183	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	72a4ddb0f657a4301946043ee74b5002	2026-05-16 07:07:51.517868	2026-05-16 07:07:51.517868
35	2	login	2026-05-16 10:26:46.60465	172.71.194.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	cdf8d5276c7563765edf5265a11dcbba	2026-05-16 10:26:46.649555	2026-05-16 10:26:46.649555
36	2	login	2026-05-16 14:14:56.509038	162.158.79.191	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	2f920eef859b143fbee9379d4f193fad	2026-05-16 14:14:56.522206	2026-05-16 14:14:56.522206
37	2	logout	2026-05-16 14:32:08.426149	172.69.123.140	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	0d350ae93fb486fbab544a43bad28da5	2026-05-16 14:32:08.440258	2026-05-16 14:32:08.440258
38	2	login	2026-05-17 02:53:07.10895	162.158.79.191	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	d0f71bc7ac33eafae81f2c68bd2be63b	2026-05-17 02:53:07.121535	2026-05-17 02:53:07.121535
39	2	logout	2026-05-17 04:49:32.849729	162.158.79.122	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	f250062c5c525c26052d36b552753543	2026-05-17 04:49:32.863376	2026-05-17 04:49:32.863376
40	2	login	2026-05-17 07:58:02.120415	172.71.194.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	ad2e0f0b9811871a78b80a379beb5ad4	2026-05-17 07:58:02.135468	2026-05-17 07:58:02.135468
41	2	login	2026-05-17 11:31:13.961321	162.158.54.196	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	fbf8876c4e72f8d93cfd28a66cc94e38	2026-05-17 11:31:13.962304	2026-05-17 11:31:13.962304
42	2	logout	2026-05-17 12:30:44.65238	172.71.194.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	8766ad3144f6791d9adbdd9ac81ed404	2026-05-17 12:30:44.653471	2026-05-17 12:30:44.653471
43	2	login	2026-05-17 13:31:30.96577	172.69.123.141	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	076d05f8d88ccae73d59216c8139fd75	2026-05-17 13:31:30.980073	2026-05-17 13:31:30.980073
44	2	login	2026-05-18 02:18:20.401119	172.69.123.140	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	fae3880f905577f18b95eff4918dd2c2	2026-05-18 02:18:20.416103	2026-05-18 02:18:20.416103
45	2	logout	2026-05-18 03:41:39.627436	104.23.209.215	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	90678b0243a5af652540294831122f4d	2026-05-18 03:41:39.628406	2026-05-18 03:41:39.628406
46	2	login	2026-05-18 08:04:33.07946	172.69.123.140	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	1daa6aaf6a356435fe8589e15f36c4cf	2026-05-18 08:04:33.081023	2026-05-18 08:04:33.081023
47	2	login	2026-05-18 11:09:33.417906	172.69.123.141	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	e2508b8a4c9676ad53e16ad44d8f1b20	2026-05-18 11:09:33.41842	2026-05-18 11:09:33.41842
48	2	login	2026-05-18 16:18:55.274772	104.23.209.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	bba4b46bf725b18b30b9c3a087ff7fb2	2026-05-18 16:18:55.288151	2026-05-18 16:18:55.288151
49	2	logout	2026-05-18 16:33:01.748964	104.23.209.92	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	28838aff01a7619f3e34d1cd0b1b71fc	2026-05-18 16:33:01.749681	2026-05-18 16:33:01.749681
50	2	login	2026-05-19 03:04:26.199657	162.158.79.192	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	8c75fc2b2774062cf07cf8c8b8dd9fd2	2026-05-19 03:04:26.200577	2026-05-19 03:04:26.200577
51	2	logout	2026-05-19 06:22:29.784017	104.23.213.117	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	d2c61cdb090a89c13155bf833f7eab1e	2026-05-19 06:22:29.784933	2026-05-19 06:22:29.784933
52	2	login	2026-05-19 16:56:50.79149	172.69.131.184	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	f074789b71a6749c5529d997cc412aed	2026-05-19 16:56:50.792161	2026-05-19 16:56:50.792161
53	2	logout	2026-05-19 17:34:01.312931	162.158.54.39	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	04fe396c94a1654888fe6a92643edd94	2026-05-19 17:34:01.313868	2026-05-19 17:34:01.313868
54	2	login	2026-05-20 03:39:24.980444	162.158.79.121	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	cbc1e1e41e95c413eb1a47d10aa51302	2026-05-20 03:39:25.083242	2026-05-20 03:39:25.083242
55	2	login	2026-05-20 13:56:33.891074	104.23.209.214	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	4d7e93214cb8437587f0da9944f39bea	2026-05-20 13:56:33.906802	2026-05-20 13:56:33.906802
56	2	login	2026-05-21 09:50:11.011066	172.69.131.184	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	1a0a71faedd83dd102f155a216ca7e20	2026-05-21 09:50:11.011711	2026-05-21 09:50:11.011711
57	2	logout	2026-05-21 13:51:41.513455	172.69.123.140	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	e12f66451eefb07ff1908cf9bfd4dfad	2026-05-21 13:51:41.535985	2026-05-21 13:51:41.535985
58	2	login	2026-05-21 14:27:11.807677	162.158.54.39	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	c0a35c63f4015223f258e887efa2765c	2026-05-21 14:27:11.808295	2026-05-21 14:27:11.808295
59	2	logout	2026-05-21 15:02:47.681634	162.158.79.191	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	3af267ec790703ab833b030931ff755a	2026-05-21 15:02:47.682446	2026-05-21 15:02:47.682446
60	2	login	2026-05-22 02:50:52.196525	172.69.123.141	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	cf0ab38ae4d22e0b53cc0423a3d53d0a	2026-05-22 02:50:52.197188	2026-05-22 02:50:52.197188
61	2	login	2026-05-23 23:14:45.174204	104.23.211.84	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	d08a06fd2a44bdae6513f28e4709fc00	2026-05-23 23:14:45.188069	2026-05-23 23:14:45.188069
62	4	login	2026-05-24 01:01:49.627909	172.69.131.184	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36 Edg/148.0.0.0	51915150ed1429b6500ffa51a4c0021b	2026-05-24 01:01:49.644012	2026-05-24 01:01:49.644012
63	2	login	2026-05-24 10:18:37.735482	172.69.123.140	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	dad5d054c683a62d4dcb7bd00edb0185	2026-05-24 10:18:37.736074	2026-05-24 10:18:37.736074
64	2	login	2026-05-25 00:59:13.504996	104.23.211.84	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	e33caf39f495beee9c1c9c5797933cd1	2026-05-25 00:59:13.505602	2026-05-25 00:59:13.505602
65	2	login	2026-05-25 15:22:30.547087	172.69.131.184	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	388b6453d6343fe6b56151a5b43520d7	2026-05-25 15:22:30.561614	2026-05-25 15:22:30.561614
66	2	login	2026-05-25 23:51:42.507442	172.71.223.122	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	e8d668b1d09ddbc5c84ce373216ec46e	2026-05-25 23:51:42.519934	2026-05-25 23:51:42.519934
67	2	logout	2026-05-26 02:14:42.392503	172.69.131.183	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	e9fa9bcca4193ac40f1a496d2942a734	2026-05-26 02:14:42.393265	2026-05-26 02:14:42.393265
68	2	login	2026-05-26 06:53:07.081734	172.69.123.140	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	472180b5ea49f2c29b28c1ff8b2ff22e	2026-05-26 06:53:07.098236	2026-05-26 06:53:07.098236
69	2	login	2026-05-26 08:56:18.727052	172.69.131.183	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	76f4e45022aee1c000d40b311854ec90	2026-05-26 08:56:18.742222	2026-05-26 08:56:18.742222
70	2	logout	2026-05-26 09:50:29.710514	172.69.131.183	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	fa333064c82b8c24064fe43237e39280	2026-05-26 09:50:29.731479	2026-05-26 09:50:29.731479
71	2	login	2026-05-26 09:57:02.105289	172.69.131.184	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	1fd707b38bf3d8ab66245581347cf88c	2026-05-26 09:57:02.105981	2026-05-26 09:57:02.105981
72	2	login	2026-05-26 13:25:27.014046	172.70.35.109	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	61e5c52c132a9fa063972e2dd3fe5556	2026-05-26 13:25:27.01467	2026-05-26 13:25:27.01467
73	2	login	2026-05-26 14:19:11.93333	172.69.131.183	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	af3b36c83b0bf8792af88b8d6605b17f	2026-05-26 14:19:11.934156	2026-05-26 14:19:11.934156
74	2	login	2026-05-27 13:20:22.966896	172.70.175.51	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	c93f1ccb546e5e8f445b601e7708b384	2026-05-27 13:20:23.004735	2026-05-27 13:20:23.004735
75	2	login	2026-05-27 16:27:10.119785	172.70.175.51	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	5cd4975b75cd81ab6a7105d7bc74b5be	2026-05-27 16:27:10.137817	2026-05-27 16:27:10.137817
76	2	login	2026-05-28 07:23:12.543168	172.69.131.183	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	d101e248fe6688e0bdc3c37627cefec2	2026-05-28 07:23:12.558701	2026-05-28 07:23:12.558701
77	2	logout	2026-05-28 15:16:18.693671	162.158.54.38	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	f418ed38167ff8522cfaa330c95973fc	2026-05-28 15:16:18.70737	2026-05-28 15:16:18.70737
78	2	login	2026-05-29 01:15:25.085487	162.158.54.39	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	11878a21519f4cae8a895f6a2066991f	2026-05-29 01:15:25.086116	2026-05-29 01:15:25.086116
79	2	login	2026-05-29 05:54:32.803303	104.23.211.84	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	432a0cb249d473a23490d14db0993c6e	2026-05-29 05:54:32.814966	2026-05-29 05:54:32.814966
80	2	login	2026-05-29 10:23:24.368056	172.69.131.183	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	4ad3538d898a465bae4f55bf47d1c4f6	2026-05-29 10:23:24.38229	2026-05-29 10:23:24.38229
81	2	logout	2026-05-29 11:57:56.74648	162.158.54.39	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	8308f43715dafab4a2d1fda611a2bfe8	2026-05-29 11:57:56.760694	2026-05-29 11:57:56.760694
\.


--
-- Data for Name: solid_cache_entries; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.solid_cache_entries (id, key, value, created_at, key_hash, byte_size) FROM stdin;
494	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32365f7633	\\x0011810c9bf2876b85da41ffffffff789c8d945d4fd35018c76fccd8c6c69c6c6040439d895e18b06f6bbbd31b0f6cb23236e636480c89cd613db0266b3bfb22cc7d04131334d1af40c2bdf19278addfc03baf4cbcf11b785ada2151716dd2a6e7fff4ff7b9ea73dcfb5f86806ccd9d8c487a8af6a1e56bb9667ba7a1c2cdab88b4db73f54f1d140b7b1162a31301b853b2e723d6714570aa996bf84b51888553a7a922c34b1a9e9e6414c8e77743fa0726e123c67c0e2c0eaeb5d1d3be7e62450752ccb24d8f988e6f67447352c93dc636021425a838165bb9ea9bbe46522e4ceb35423bfddcc280912ee70809542ae6eb9964d29a6e3d9c8ec629f0dd25dcf712d03db24a706b5bed5849bc1fa8dc061a89a9eb11788478e464e271053031b1bba67ec4fb11c4868c8c58a07121dddc0e9dadba5b3e32da51f0389979689e951524eff1d2dcf28856c1536b6ebb0d1a942aa1e2c6694c26d9666b8224d931b2b88259a298a1ced1f41c0f5fd2423967856ce2a9e7c23fd88f052cfa993983c1bb2f2558cfa6eef4f58be46d56cdde999886adac8415a04cc32c45ce0585e12c6904449e2a490f1facdd2197ce8e62e18ffaae7d62a6cc31dd8821bd41a29addc82ed6aa5065b1169b65579b2cc88a4289667f88815673017a29609eaf3cdcad309caf9fd735df666244ee4a366b12b1ce643f707c4fdfbe98f8fff2f24bb56a73695c6ba5fca76444854b59e769173e47a8fb8fe04f0d985ebeca6be8f27cf582a49122fb091333beec65de2fcbe72624ed08d5cc5394436d2518f6a7b5a0f8d19ac14fc3b34c7b3a224465de139ba2884946942f974a7989a80325f6e51b596d2ae3620d5804177c6208ee7449a2d4a2cb9d0cc1824b06254ceb7e3a5b377af4edd094073cd16ac6f95a97655d98135b245c6bf505a64a55291a41f12d28c449798159e09215f08247fffc3571f0216c28daadaf80536c93473c9e0d076a747532019cc12e257c65dcacf39d8d9d3c8f0a79a0732abfa01517403f5932540afd0a329394fa23790e9470b017dce93e72fa98ff1de156a1dd957a87070955a47c3cb6a8e9188cc09459ea505090b60319a94e3591a0ee85fbbb09382	2026-05-26 14:26:47.79523	-6487686728793729287	990
305	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d31375f7633	\\x0011814cdf376e7182da41ffffffff789c9594cb6ed3401486bb4069ae4ddba42d6a916a8a849050227becc4ce78834b4393de284e8584bab0dc78d28c148f832f94340b24362c58c1a2bc025277ac10ab8a2d88056f8058217808c68e9d5e544a6b4bb666fee3ef3f733c73aec5fb6370da4604ede91dcdf090d6b43ce2e20c9cb3511311b7d3d3d0f32eb691112a233017853baeee7a4e3f5e5f48abfe1432623056ddc2293ab1898881c96e4c8e6fe10c1d570790c118ce75ad0e6e62e40ce03450732c8b5065267273dbd8d14c8bd0f7089c8d2cad6ed7b25d8f60977e8c47617e90a516f1b6b3fd244cb8bd2eaa2fe4d72dd7b2993a713c5b274de47bc34cd3735ccb44767de1c6a2d2501e2baab2c2dcaf291b4baad2a855571535889b0c883d8d78e68e1f9c53ab8f0a9c2856582070021bc4a4bb3632b167b6525c9193100f1386eea2ba07135bd84499c2dbf9a3afd7ab4f6230b16f11c4f69332adc4540de91db77d3a2d798c966883597eb8a9ac05e3ec49474ee24521981e6f25419147823c51f7e4c9cc5deaf0ebf0cfc7989c0be9e7add987a70ca3c518ad883de93886e144f7007d2f1b52ef50eaab1fdf3f5c999af4616769b7294d7a91fb74655a8ab27800cec18d17be1d5c1997f1570c383e04b6d2402c0b455138c155270a2f8fb9b935dc4297ff4d5245928472448f03c487e45b94fcaefa9e1c93ffb905f255674fb775acb7998667b4f5a10790d8e0e205204a62b415049e2d9543971475f97cb394fe6ffe67ca92de7b4a8b0cf89099e125ae048a1510627fbf993f825fa6f62f91fccc92caacaaf5466d4361369465ff5c0df3e7055e64414902f4c172c3fccb408caaf4931a1dbc3e747d23381b1e2ccd46cf10a14dc9a5e7dfd84ef54761326809f4772ea126e3e3829398d24dbf397930bb8877a9824dbd93ac40b6c8f647e5291abda2133fba1c584f7bf2cc29f501dab9405dd7ed0b54a57b91baaef74eab794ea2b200681d2aa084ca702e6a78c39618f6d9bf96f2898b	2026-05-17 13:40:16.878087	2525257822691885156	929
227	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3137	\\x00118138513834c982da41ffffffff789c8d943b4b034114852d24668d84205a682304c442b8ce63e795b5104450b04ca14858973c482431926cb40808365682fa132c44f0818595f6fe02ff8fb8c9cc6225de6e61f69b3373ee9933993d58197aa57cdcead4fb71d43969af4ed566bda352a136e84571ab7b1c76fa8d9c21148828e5ab51b5590f9badb89cfc10c551d8ef0e7ad5fa4e7161bc520b1bad765cef251fa3d54c29b3551e7ac144b2e977b2699069e4a8a0c07530550eb27f518197421ff316d28481a048680ec6d00cf53905c390d4a2a5728c719058e8d0429e002590c895d3a18600e348a8b8e620ea83af90d02db590e11a948f84626e2131b201ebf892724a4282314828abd3e349e058e861dd42d227c0b1535ad8b48160da9720b083fadab6528a31a012096dec3afbb4028655ea3948330d1aebf9858338e1c0b1d0f5ee6f8e0cf6787b156b1fa78c80c00669bf92be278a3f5fa592be27834d79217457528602361197169a6632c91eb68b9c90e03e686c1eee4f5d1749a3f0b37d397794d01a5f12778fa9169140b056bc3fb96768181eca3e3b2f12ffd0d5b2fcea72a4a80282a5cede522f44529858df6fded2f429a058a98d4f27a546edf26f25fd008df9fdde	2026-05-17 00:57:08.433966	8572525140800636240	639
482	\\x70726f64756374696f6e3a64617368626f6172645f646174615f39396465333539385f323032362d30312d30315f323032362d31322d33315f7635	\\x0011814cf9774b6185da41ffffffff789c8d55db6edb461015d2428a6427926dd97151230952184911d4906cd99686404bd9ae51a74993f8825ef440acc8a1b4f592abee2ee5aaf986f613fb017dee077496a4642b4d9b400fe2ce0ecfcc3973e1c7b7df3c86ba918609cf4fb491112acdd76195f9868f71ceb696b9b1a8cfb466812463196a9951200b345f81ba2fe3312a83416eaac2d210993043cf97496c781daa8287989f8a508ba4912a3f16a026cd10af8fab79c830e48233839a57e01e8fff955c011ed8705e165d73197b23543ec6860d30acec37b75a3bb092818da4e03e27a80dd8c82d0a239e44f4b610e853eee1dd9dcede6e6b6f6baf3d65ade99ec73a5174bbb0bdd5e8e03e2c8f300e783cc8a996a13e358cd844264627503de08323f479c4c46ab30d8dadfd56a3d3d96f3577711796468c07335f676d39f568efb4dabbbbd882e53cbbd97d86d0de6eb5dadb9d14a13e95c01b2879658624c472ca6f726d5899d29b5956677a5edbd6aecb7a6daca5a2ce8ef51bf22a7a3b2c5b61096e3cf0f2a8632612e4b77e3c84fb918ccd504c3c857ea2945545e118637bfdf71896c84ce5c9a493f0f039fd0374d3c29ea22f55e09da2608662adc1821bc900855f4ebd165cc3fa0225d4ba0a05c0b93d95a1e2c62cc293479514b208c5afcfc9f552102bf72e2cb96632a29661daa092f0e8662482a0bbc3f40ae0051b159dcfb3572cb2c7482add80453725a7df946141a36d945e054a3c80c554257a28db0460d9d2b5d4b46d3ea8fa0a999d0766a07245cd4d893f998f3e250af0bdbd3f142cd148a3e152e502eedbbeef15257c92d1fd8ea4d0000768ae10e312f116189a3378985d778d51bc9f18eb337b2ec11d950771ab4ef3e4d18dac8ace9363124af1c1d048589d0bd28d8322dc75fd21170171ea95243cfdafdc5f27a826b3888bce63771d3632cdbc3e8652a1372bc105948f287c6f8117f847eaf74dfaa35fb8b8bddde934f79ac4c9ba5ec0b3f96033f417688632a004cf79843fc9180f679df9b68d6adaa38a79de78dbf37a855e4142771e95fc62aa26bddb0dd888fc09f795d466a0f0ecf57380972747192815341a95a16aebe2731b8c2f9072da67021bf42078c44d83f432e4fc1b65d080755792b0b4b168894d93b7aea92cee062cbb5e12f769db05b6d5ac7f2618c9e5058cfa8f697293ce97a99ece57178e9b89f6e71fb968ee7da7eb3e704e1ace3377d3f9b6e13c7737a142c4883735cdc65c3d8f50fbd98a2a92c6f8eb489d399d9203ef6e8a4a4a8856f8a22b240b3068c0bdeb9ef4fa0975851da6cfe6f57c35f538c81c4ace260df85b0367e952159925793b1db79acb28552f9d39b74a4785a1c8ea62351db23810549b5ea557f26f9f21f56af3ffe352bf28c526df642f169d53f729bd5a498dd2f9616af8f4dd0d2da1f53ef8a96b1ea160d14f593cc00f482df57b2bb5da01d3dc7fd9ff99584bd87f1fc40def9b405423da9538b02532d24b37e731acb86162e8eb454b582782baf40ee96b91b56d47a627b17f6c572875ed3121e8a14c44e0216d30e5d9e237e8d2d6c7ee4142d5bf086b31ec122d940c438d86a06aaecffc217a9738a1533d3fe5a3692dbe8c22aed39317d008946169fa11962137e19d2f7677f65a5b8d7d58a36f140da35da3cad861b0f352cf8dd4c49969136ab969824cf15b7f95fe01a8bf05fb	2026-05-26 11:29:05.883126	-4130484541935872278	1423
268	\\x70726f64756374696f6e3a64617368626f6172645f646174615f323032332d30372d30335f323032362d31322d33315f7633	\\x0011817527586b5382da41ffffffff789c8d55df4f1b47104669656363820143fa83b611284aa24ac8a690e039a95d034525254dc20fb5aa1f4eebbb397bcbdeadbbbb0775f3d6b7bef44facd4a7fe1b9dbd3b1b4cd2a6f283bdb3b333f37df3cdf8fdd9d70fa16195e5d20f5263558cda880558e181159738655bcddd78dce3c6f050917116eab951220f8da8402350c9256a8b61612ac3e200b9b4033f506962c5122c481161712a433d5656e9e23803756507787d5c2952469190825b34a20af744f2467133b09c7b0e95148120bf067ce60af0f37a8c50893f441d6062791fa3d91d6cc15af144632cd2983ca5c4802a8fee7ed16eef34db9b5b3b63cc86ee4562524db7735b9bbbdbf8149686988422e94f8036c686211fa9d49a1416f644ff00031173b9d2da85e6e66ebbdddc6e6db55ab8038b432ec2b12f21582aca291e7bab6f3e698c11fb7dadaeecc0bdca108fae0dcb633c13cbca84be6bdbea7517af8df58cb1c9b171833b4daf5989425df6fd22e32597298a3bd5017c1aabc40ee4c8d718a45a3b0a345e62e2ae6bbfc1229989f79c2705f78fe91ba093f5f00403a543ff0425b7946715e658ac42944125f39a6396f7242aa877344a803377aa4095253cc6a3f56a16b204a5afcfc8f542122256834566474352073716b582f59b992804dded675700cff9b0e43dce9fb8c83e279a4c136a2c03675e5760cea05345b70a6511422d63887e545c01b0e4e03a68c6a90a16028ddc499f5ba85e918ea9f047d3d9c74001be77f7fb92a7064b5067d4b550044ee2dd92820f73b8df111506600fed15625226dc12237b0af7f3eb8eb55af452eb7c26bfcb30af8b246cde6b1daddfa8aae43d3a24a2b4e80fac8295a9249d242cc15d160c840c0953b7ace0f37fabfd558a7a34c958f31eb25558cb39f37b18298dfea405e75039a0f4dd393123defbebf707f4459fa8b6b5d56eb79eb40893733d8767d3c926d19fa31da8900a3c1331fea812dc9fa8f2b68d7adaa58ef9fee596ef7767ba330a3ad351c92fa16ed2db4ec887e44f715f2a63fb1a4f5f1d03bc383ac8835243e36105165c5f02e192893962ce045c62937e48110bdb24be2c39ff4a1534e103a688585a4eb4afc6c53bd78c16f6112c313f4d7ab4d8422735e79f134674f92127fd71436ecafb32e3d3fbeadc6339697ffe5190c6d6bc0efbc43b6a7acfd886f76dd33b661b502560849b44b336d5cf033441be8f4ac431fe32d4a75ebbecc1db4551cd00d192af31a978886113ee5d6bd2efa5a40a374c1bd37cbe1c7bece50e65ef010df8ad817370a98bdc819ccdc6adce3895ea6733c7e6e9a83192795f1ca7039e84927ad3ad76cbc1ec2992565bff9d97f4a2351f7d933f2c7927ec313dad6646e5fd30367cfc76412bd87e57f8b16b9161c6453fe1491fff476999dfadd2ea7bdc88e045ef2742ade0e9bb42dcf0be19887a44bb12fbae4556f9d9e63c846516a596feaa68099b54924ae7895f17d9383972334a8243b74249b58714c10c542a431f698369df35bf4997ae3f6e0f5254f3b37416cb2fd085525164d052a83a0b783040ff0247746a14a762349d2550712c4c76f2431a810a2c8eff7155246c547bd2dcddd96cb76195fe9e6816dd16d5d6cd821b974661240de7a60da817a611722deefc5dfe07bc96005d	2026-05-17 05:05:05.376851	7705504534133566320	1389
354	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32315f7633	\\x0011811f1692b8c683da41ffffffff789c8d94cb6ed34014863728cdb5a54ddaa216a92648b0400dbe2576c62bb7098d9b260d4e5b0955c29ac6d366a4781cf942097904242458c02b20758f5856ace10dd8b14262c31b3076ed441550c50b5b9efff7ff9d33f29c5bc9f13c58711041e77060983e327ab64f3c9c04eb0eea21e20d46067a39c40e32232501f2b1ddf5a0e7bbe3a456cceac112321320513fc069bad041c4c4e42ca1240f7060a85f8584ef0b607d680f700f23f72a9c1a0dd7b609c5aec634af8f5dc3b2097d26c05a8cb48743dbf17c823dfa31150a57551a71de716e9c06296f34445a71b981e0c0eb331a717d07921e0ae020d7f35dcfb690430d4da6e960b74f20d371a00bc3eac052983532886f9d04ae458e65d98ac08b728565434776e8200bfbd669aa2a0b324899d0439a0f5207d842b937ef362ed5c75e210152af6c82d8715ac969c542cbf66ce77a29cabc56bcbba576d52355577799ed86daaee96ab7516faa7aa82f68c5bc5e7fbac9495295e5454e0cf1caedd30c57e26424288b9aaf2ce53629f1eb9dfab384928f68ffec3cc065dbccce7e47ddfb3b9e9305498ce2d37c49406294fe88a6ffbcf8f5799afebf5e16b75bcc9ed6de09ba398c09a986d937a765b3e549f0031afc1ba8cfa7c1f93d7c8a662f5aaecab258e1a3f0243fd990fb34f943fd239961430a75f71c3a10c33ed3f5cd3e9c3078990d2f41e425598a374614d87225a26428e5cbbd727606ca6a4d679abad66db455a6ad861b340109a220b17c59e6e98de526a00a2fc5edfc78bb71f9fef585370368a5a3abadfd1ad36d68476af3b035fd9172122f57cbb4fc8890e33941944a72dccd370a597ef8e97b00016bd10f6e38e80522742878f4fc99c799f11c48874792e6d5508f096a0e4f44065ac170f0c1c2163ea30ab6e0205d056c891dcf29cbd4bd0b49e0ae84f4155f59bda63e412737a82de8dca0aac39bd4161c5d570b9c4c65a12a725551105005acc703673292a239f707bbf865bc	2026-05-21 14:44:58.286546	507695315660009467	927
383	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32345f7633	\\x001181480d2c88ba84da41ffffffff789c8d94cb6ed34014863728cdb5a54ddaa216a92648b0400dbe2576c62bb7098d9b260d4e5b0955c29ac6d366a4781cf942097904242458c02b20758f5856ace10dd8b14262c31b3076ed441550c50b5b9efff7ff9d33f29c5bc9f13c58711041e77060983e327ab64f3c9c04eb0eea21e20d46067a39c40e32232501f2b1ddf5a0e7bbe3a456cceac112321320513fc069bad041c4c4e42ca1240f7060a85f8584ef0b607d680f700f23f72a9c1a0dd7b609c5aec634af8f5dc3b2097d26c05a8cb48743dbf17c823dfa31150a57551a71de716e9c06296f34445a71b981e0c0eb331a717d07921e0ae020d7f35dcfb690430d4da6e960b74f20d371a00bc3eac052983532886f9d04ae458e65d98ac08b728565434776e8200bfbd669aa2a0b324899d0439a0f5207d842b937ef362ed5c75e210152af6c82d8715ac969c542cbf66ce77a29cabc56bcbba576d52355577799ed86daaee96ab7516faa7aa82f68c5bc5e7fbac9495295e5454e0cf1caedd30c57e26424288b9aaf2ce53629f1eb9dfab384928f68ffec3cc065dbccce7e47ddfb3b9e9305498ce2d37c49406294fe88a6ffbcf8f5799afebf5e16b75bcc9ed6de09ba398c09a986d937a765b3e549f0031afc1ba8cfa7c1f93d7c8a662f5aaecab258e1a3f0243fd990fb34f943fd239961430a75f71c3a10c33ed3f5cd3e9c3078990d2f41e425598a374614d87225a26428e5cbbd727606ca6a4d679abad66db455a6ad861b340109a220b17c59e6e98de526a00a2fc5edfc78bb71f9fef585370368a5a3abadfd1ad36d68476af3b035fd9172122f57cbb4fc8890e33941944a72dccd370a597ef8e97b00016bd10f6e38e80522742878f4fc99c799f11c48874792e6d5508f096a0e4f44065ac170f0c1c2163ea30ab6e0205d056c891dcf29cbd4bd0b49e0ae84f4155f59bda63e412737a82de8dca0aac39bd4161c5d570b9c4c65a12a725551105005acc703673292a239f707bbf865bc	2026-05-24 12:06:00.691021	6394342634204306558	927
400	\\x70726f64756374696f6e3a64617368626f6172645f646174615f323032362d30312d30315f323032362d31322d33315f7634	\\x001181114cd8e40985da41ffffffff789c8d55db6edb461035d242b2643b926dd94951230952184911d4a06559b286404b39ae51a74993d8097ad103b12287d2364baebabb54aae61bda4fec07f4b91fd0599292ad346d023d883b7b38973367861f2fbfb9070d230d137e906a2363549a6fc1160b0c9fe0826d3b87b178c0b466a124e332d473a340166abe0e8d4026135406c3c2b406eb2364c28cfc40a689e10da8091e61712a413d9646aae2b8047569467879dc2a424611179c19d4bc023778f2afe4966033478ea5e001479bee6d9b809fe7a3b94cfc31aa0013c3861855dbedbd7607768a9714c63c8d092b0406947b74fda07dd86a3a7beda359d59aee79a25345b72bcd3da78b1dd8186312f26458945a81c6cc306653991a9d42ed980f4f30e031135bfb47e0ec755a4eb7db69ed1fe221ac8f190fe758777b23431c1db48e0e0fb1051b4576f3fbdcc351b3d53a6a76330f8d1905fe50c9d76644446c64144c2f0d9bb3f2e696ad399f97b6edcbb65e1aeb1985f363e30a998ade8e2a446387dc4d867e1175c2448afc5ae747b815cbc48cc4d45718a44a5956144e30b1d77f4f609dccd48c9c3a09771ed33f402f6bec39065285fe390a6628d636ac78b10c5104950cb5e219361028a1de5328005ed85305aa5ec2623cbb5bcd5c96a0f4f50b82be125495771dd63d331d93649836a824dcbd1a895cd0ddc3ec0ae0091b97dccff357ac679f1155da81552f2b4ebfa9c08a462b947e15ca3c84d58c257aa8d80460c3966b4bd3566a500b14323b0fcc40f535899b12bfbf187d5628c0f7f6fea160a9461a0d8f3a17f2c0eabe5f92f0495eee774485063846f31a312953dd0223730177f2eb9e318a0f526331f3e732aca922885773f7cfee5ec9aae4de3f25a2141f8e8c84ad8520bd242cc1752f187111524dfdb28407ff95fbf314d5741e71d5bde7dd849d9c337f809154e8cf5bf0122a2714bebfc297f847eaf75dfaa35fb4da6c76bbfbed7daac9425fc2a3c56073ef4fd08c644809bee031fe24137c3857e6db36ea699f3ae6fb93a6eff797fa4b127a8b5e09975037e9dd5ec8c68427bfcfa436438517cf1f033c3d3bc99d5243e371056ab62f01b7c1f80a31a70326d0a107c1636e1ce2cb10f837cac0819b9e24626963d1129b256fa1192dde0e6c787e9a0c68db85566a169f134674f92123fd314d30e97e99f1e97ef5d2f572d2fefca320cdbbe5f6bcdbee99e33ef276dd6f1df7b1b70b552a8cea26d1ec2cf4f3047590afa812718cbf8ed585db2dbbf06e5154b382788da42f240b3174e0c6a526fd414aaab0c3f4d9229fcf6688e31c50767769c0df1a385b2e7591d92297b371ab7b8c52f5b399f36a74541889bc2f96d3114b4241bde957fbe560f90249abfbff1f97f4a2149b7e93bf5872cfbd07f46a35334af78799e1d3770b5a42eb7dee67d022c292f57ece92217e406a19eeadd4eac74cf3e0e9e067aa5a42e77d2eaea0af3aa21ed1aec4a16d91917eb6394f61d38b52435f2f5ac23a15a4d235e2d77ad6568e4c4f93e0d4ae5052ed2979d023998ad047da60cab7cd77e8d2f6c7ee41f2aa7f11d662d82bb4ae64146934e4aaee052c18a1ff0aa7746a14a76234ad259071cc7576f2431a810aaccf3ec232e2265afbe2f0a0ddda733ab04ddf281a46bb4695b1c360e7a5511849c4b96917ea85698a4cf16b7f95ff01dd0905e0	2026-05-25 10:37:27.47303	-1225987541988415736	1414
497	\\x70726f64756374696f6e3a64617368626f6172645f646174615f38626337613234615f323032362d30312d30315f323032362d31322d33315f7635	\\x00118170454bef9085da41ffffffff789c8d556d4f1b4710466965c786c4060ca12a4aa25428a9a2a2336083e7a4f60c149534691220ea8b3f9cd67773f6367bb7eeee9ea99bdfd0fec4fe807eee0fe8ecddd9e0346d227fb077f6d967669e79f1c737df3c84869186093f48b591312acd37608d05868f71ceb69ec358dc675ab35092b102f5dc2890859a37a011c8648cca6058986ab03c4426ccd00f649a1882d4048fb03895a01e4b2355715c80ba3443bc3aae152ea3880bce0c6a5e853b3cf957700b70cfbaf373ef9acbc41fa10a30316c8051b5ddde6eefc36a4e369282079ca83661b3b0288c791ad36b2130a0d8a3dbbb9d766b8f5e1d4cb3d674cf139d2aba5ddcd9763ab80f2b234c429e0c8a54abd0981a466c2253a353a81df2c131063c6662b57900cef6feceaed33ce8600b96478c8733a4bbdec8ee3b4eabb9d36eb6700f568ae86688b50c71d0dc6ded365b046991dc8504fe40c94b33242156b2fc265786d5697a33cbda4ccf2bdbfa5559af8cf54cd4d9b1714d5e45afa30a09bb4f74e3815f781d339122bff1e311dc8d65628662e22b0c52a5ac2a0ac798d8ebbfc7b04c662a4f2e9d84fb4fe91ba09b15f60c03a942ff0c0533e46b1d16bd588628824a865af40ceb0b9450ef2a140017f65481aa97b0184f1f5433ca1294bebe20e86b415979b761d9339311b50cd306958407d73d1105dd1d655700cfd8a8e47e9e3fb1cc3e23a9b4034b5e969c7e5381458db6517a5528f310963295e847c506002b365d9b9ab6cd07b54021b3f3c00c542fa9b929f047f3dea789027c6fef8f044b35d2687854b99007b6ef7b25099fe4e97e47526880433497884999f216189973b89f5f778d51bc9f1a8b99fd2ec32d5538f16a6ef3f4c1b5a84aeea313124af1c1d048589b73d24dc212dcf682211721e5d42b4b78fc5fb1bf4c514d661e97dc87de066ce69af97d8ca4427f568257503926f7bd45bec03f52bf6fd1177da2a59d9d4ea7d96e524e16fa0a9ecc3b9bb13f433394210578c163fc49267834ebccb76d54d31e55ccf7c73bbedf5be82d48e8ceb3122ea16ad2db6ec8468427de17529b81c2f3974f019e9f1ee7a454d07854819aad4bc0ad33be48cae9800974e887e031370ee96508fc1b45e0c086274958da58b4c4a6c15b68268bb7092b9e9f267dda76a16d358bcf0523b9fc9051ff314d30e97e99e9e97ef5caf572d1fefca310cdbbeb76bd7beea9e33ef1b6dc6f1df7a9b705554a8cf2a6a6d99cabe731ea205f5125d2187f1da973b75376e1dd4d51cd12a215bee409c9420c1db873d5937e3fa5aeb0c3f4d9bc9e2fa688c31c5076b768c0df1a389b2e5591d9246f66e356f71885ea6733e7d5e8a83012795daca6439684826ad3abf6cac1cd73a45e6dfebf5fea17a5d8e49bfc61c93df31ed3d36a6694ee0f53c3a7ef6e68097befa39f420b0f0b96fd8c2503fc80d032dc5ba1d50f99e6c1f3fecf94b584fdf7515c435f27a21ad1aec4812d91917eb6394f60d58b5243ff5eb484752aa84b6f91be9659db76647a920427768552d79e10831eca54843ed20653be2dbe4397b63e760f12abfe45588b61afd152c928d26888aaee052c18a2ff1a27746a14a76234ad259071cc7576f2431a810a2c4fff8465c44d74eb8bd66e7b6fdbd98775fa8fa261b46b54193b0c765e1a85919a38376d41bd304d90297ee3aff23f5b1205ef	2026-05-27 01:02:09.208805	-3410260119940185397	1423
223	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d31365f7633	\\x001181d0aef6f21f82da41ffffffff789c8d943d4fdb4018c719504212070a21204125dc2ced14d9e7f7f3e40a0a061290a12c0c96892fe4a4f8ecfaa569c847e844d576efdaee6d47d4b5ea37e8d6b143d56fd0b3b1294815c583ade7fe8fffbfe739fbb9e999c92c5c0a1141236768bb09b27b7e42625c86ab21ea21120fc7367a11e010b9b932051b457a143b71124d66cc1663a54bc82dc1d2c621aed2857d445c4c4e4bfacc212ed378e3d2248b19b81af843dcc328ba34a78976e4fb8462970b5a3cc091edf9843ea7e04a81f483c00fe384e098be8c4b70f1b24abbf03b6626555889c701325bcd2de40ce3016b9228091dd243291cd67b4914fb1e0acdd6e246347242073b03f62071074ea62f6456639b24de499ad4002a975d82081455c9729820441e4ebc7e551438498615d7899199c0ca21f650bdf66aede2cb038929c1ca994f1037a9ea750aebf8b11fde2c469f355b35d7edb36e3f0be768388a22d78db2f05ebfcab77924e8f366a22fd4a7a9efe7479fce4b7a23f76cece23efaaf25337a26000084dcb32ea8bc04da1ac86d7f9eaf5dc0afcdb3bfb6ffdcb8d47879dd62772cf360ab6bb05d63d3b08ced02d2104441e180a4027ae3f8a27e51064a51ff0f0a7afbf2437c07d0d2be6574f6d6d9832df3c8d879da31ac82535780aa4974d78b6e002f884a5b9573c8370a693efcf8fd0e90f94dd6328e4c76c7b48c6ee17f1fa892cc024e5258a02902ab481c60e9d72f1a022aaf8ad758afdfbf79770716d36537f7f68dddab36344e542445e6aeda5024956f73fc356bf2ebb7955ac395fc77b343f41c113aa3311d07f7b83629c36a3621d46f1df5d874ebb3ffb3e678e9ac2670ee313ea50af69c6155835c9b9b94f526cdde76489a2d67f4a5445fbea13e4127b7a81d27bc453582dbd48e33bea92ef22a95058d6eb3062424c3d562feaf4e88fcd8f90329d84adb	2026-05-16 14:29:39.868973	3112091688672455781	885
528	\\x70726f64756374696f6e3a64617368626f6172645f646174615f65383039666134355f323032362d30312d30315f323032362d31322d33315f7635	\\x0011815dc77a421686da41ffffffff789c8d556d6f1b45108e0ab26b3bad9dc4718b88daaa286a514574761a3b9e93e09c86889496b6492310fe705adfcdd94bf76ecdee5e82e917fe00fc447e00bf82d9bbb3139742913ff876f6b967669e79b98fafbf7d004d230d137e906a2363549adf864d16187e8e4bb6560e63f18869cd4249c60a3472a340166ade82662093735406c3c2d480b5093261267e20d3c4f026d4058fb03895a0114b23d5e5519a09ce8f2bb059b88c222e3833a879156ef1e41fc1adc05debcecfbd6b2e137f8a2ac0c4b03146d5eee39d5e1b3672b2a9143ce0447507b60a8bc298a731bd2d0406147b74f371bbdfee7776badd79d69aee79a25345b7b5ce8ed3c71eac4f310979322e52ad41736e98b2994c8d4ea17ec0c78718f09889cdf63e383bfb7bbdbd6e7fbfdbc63d589b321e2eb06e2b47743afb5d6777b7bd4788f522c005a49541da0e11f476dbbd2e7649f242067face485999018eb598eb34bc3c63cc5856573a1e9a5ad7559da4b63231376716c5e9158d1db51c58a4b74e763bff07ace448afcda6f03b813cbc44cc4cc5718a44a5965149e6362afeb17b046662a512e9f847bcfe81f609015f70403a942ff040533e4ab05352f96218aa092a16a9e612381121a038502e0b53d55a0ea252cc6e3fbd58cb204a5af5f13f48da0acbc9bb0e699d994da8669834ac2fdab9e8882ee9e645700cfd9b4e47e9ebf62997d4652690756bd2c39fdb602358db659865528f310563395e8a1620380759bae4d4ddb06847aa090d9996006aa17d4e014f8c365eff34401beb7f74f044b35d23c7854b99007b6f78725099fe4e97e47526880033417884999f216189953b8975f0f8c517c941a8b593c97e1862a9c7875b77d7cff4a5425f7e11109a5f87862246c2e39192461096e7ac1848b90721a96253cfab7d85fa5a8660b8fabee03ef366ce59af9238ca4427f518233a81c92fb618daff08fd4efdbf447bf68b5d3e9f7dbdd36e564a167f074d9d982fd399a890c29c0d73cc61f65824f169df9ae8d6a3aa48af9fe79c7f7872bc31509836556c225544d7a7710b229e189f7a5d466acf0f4d5338017c787392915349e56a06eeb1270eb8ce6bee6e9800974e841f0981b87f43204fe952270e0b6274958da5ab4c8e6c15b68268bb705eb9e9f2623da78a16d358bcf0523b9fc9051ff314d30e97e99e9e97e75e67ab9687ffe5188e6dd7107de5df7d8719f7adbeeb78efbccdb862a25467953d36c2dd5f3107590afa912698cbf4cd5a9db2fbbf0fea6a86609f13ab5be902cc4d0815b973de98f52ea0a3b4c9f2debf9728e38c80165779b06fc9d81b3e95215994df27a366e0d8f51a87e36735e9d8e0a2391d7c56a3a614928a836c3eab01c5c3f45ead5f67ffba57e518acdbec95f2cb927de237ab59a19a5fbc3dcf0e9fb1b5ac2e30fd1cfa1858715cb7ec29231fe8fd032dc3ba1350e98e6c18bd14f94b584de8728aea0af12518d6857e2d896c8483fdb9c47b0e145a9a12f182d619d0aead21ba4af65d6b61d999e25c1915da1d4b547c4a0273215a18fb4c1946f8befd0a5ad8fdd83c4aa7f16d662d81bb454328a341aa26a78010b26e8bfc1199d9ac5a9184d6b09641c739d9dfc9046a0026bf30fb18cb8896e7cb1b74b5f15a7072dfa46d130da35aa8c1d063b2fcdc2484d9c9bb6a1519866c814bff657f96f418e0612	2026-05-28 14:57:33.919442	-6455888098242456190	1424
499	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3237	\\x001101c75332162086da41ffffffff04085b087b093a0e74696d657374616d706c2b079142166a3a106475726174696f6e5f6d73660c323036362e32393a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b07c820176a3b06660c323732382e30313b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07c820176a3b06660c323039352e36333b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-27 01:02:09.978143	-3451998204444592750	401
155	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d31355f7633	\\x0011813c2a3b8bd381da41ffffffff789ca594cd6ed34010c77340f970be4ad3b4552344148913228aed2424eb4b4129c2884a08a55c7ab05cefb85914af8dd7264df3008803871ea978803e0407248ebc008770e400483c036bc70e89848202f261b5f39ffdfd67ad9db9969e14d0b60b1446fa50c33e6886ed538fa451c50503a8371c6b70e6101770a42450294e679eeef96c92566bb9a741087012250ffa24cb034f8062424f934aba4f8284831924dc6fa08a630f894180cde03c5163b64db9ed4eece60d08d32c9bf23581f6624bdb716cd7f329f1f86192425bb32ab598775c9c0828e38d1d506ba5c7c484aa4a99efead480c01ae50d9f79b605ae5acb626c56b1198637c3f3638dfad649a0e5b18999dc94a550cd392e58c4b74ca155ef421365b0ee81eaa34c9f5890ff7971f3c3e6b3d49b24ca9cdb141a1341c9ffd15c29a8b5426ff01c577b836af82794a25acb1ce1b36ab8d930d3223495ebaaaf6c8654b39ce82595d26ae2c235025c0e9b4ce69547c4ac58173b73e80f0ebd9cbe7aff0f502c4b5204ddaf2ce0be5e7db95a1b377ac16931cecccb1db125d5bbd202167d2a9fffc6961f823ef4067f051760e442f08d22b4d0acb7e6b7ffceb917b78777d6e766309b579b6e2f01df5e4e6ffd17705f5aa01dbdfb7c637d5a56c74c94c5b8c0e65281c234b5bb3e32c730c378f6fe798de508f82d78ebbbaf3f0640b417b585e6c24ba07c7478bc4bf17176924242d8b8bc8f7a6054a586d40afb28ab5bc108f151f13e39e50ab1f4a1d0458d7a639252ca3cfb914e83ec76e8baed2b3b4bea033859a11eeaee0af59eb34a3dd4c7cbea96d8e1f2dd66abcbc332b451251e4bf3c1154dc35fba2479f4	2026-05-15 16:45:40.924696	-8432920770078787393	819
310	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3138	\\x001101c63505f31c83da41ffffffff04085b0c7b093a0e74696d657374616d706c2b074f7a0a6a3a106475726174696f6e5f6d73660b313639302e313a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b0735820a6a3b06660c313734352e35343b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b0760820a6a3b06660b3235302e39383b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b0778890a6a3b06660c323034362e34393b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b077a890a6a3b06660b3233382e35393b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07e6cc0a6a3b06660c313538342e37313b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b073c140b6a3b06660c313630332e31313b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-18 02:32:47.521544	1807062890916579403	614
481	\\x70726f64756374696f6e3a64617368626f6172645f63616368655f67656e	\\x001104000000000000f0bfffffffff3565303966616266	2026-05-26 11:27:05.298723	4365665205905785338	193
323	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d31385f7633	\\x001181e44bfa2cc582da41ffffffff789c9594bd6fd340188717e42671d2afa42d6a900841424828913f63e7bce0b686a6b4a5a41512ea60b9f1a539293e5bf699123220b1b033c0c88ac4c684100362460cfc078c48fc119c1dbb6d6809341922dfeff5f3f89cf7de4b99e13458f421864756dfb4436876dc1013c482b20f3b1093fec0844f3ce4433b4918504ccb0362913018665ad57c3b5a82360318630fb1746107621be14346cb8cae8d1124be9e0565cfeda30e82c1084e0bcdc07531d52ea536d24381e9b898fe32603955ba9ee7fa24c488d09b510694464f69a6bcfd99610e64c9c083ad6a71137561a58583d0b77007466a50e88401711de8b7aaac6d772b76375e9e8fef1f9838740ea2acd8361ed4784569728ac4494a5c93f77ce8a0d0e966042881ac6d11d80a41760f39b0b0faf2ea6796252a03b24f5d0cb9614e2bb4aa0bebd0ea93def82368d3636a6d66cc26ca72335e9eedb27c9d97a1a4cdb5426d3e36f4de7c5a62b462422f6db9c4f5cfc2aface8bbfa43bdad6f5456d7f5edb5b6bebb6edcd3db676d82c44bdc299b0ac5c456a3b6af978d4727b6bfee25bf5db97b7f47df3c8be7555191127c4ea88bc77bb945e93fdffdfaf0efbdfcf1a2e683c0b683f43b42df2e27d49b94fae2c7f7f717a6e622d89fb41b94a63e2b7ebc308da52c5110cec1cdd6bebdba30ae10ed58e0c504d8cd0b4a43aa2bd2296e7baef6fc847b4ed74ffa9bd4a6aa4a8d944e5b3b6d81eb94fcda788bffa3054a467064f916b27a95ddd0ee59c70e41e5e28f28098aaaa4ad20899cdc482c2cb57cb926e7230b584e4e98e9c3c710d35944e8b1b7f7d9e114c8c59380be8e35d8a9089c20c74792b59c6826856066051dd20439563fd7045c9d1b4e690bb47ac3c2517523562f86dad2587a071e4c48b72c7f42aa7b93d22d6b309e967895c6922c715c5390610394d339773c0993f1fa1bb36b859c	2026-05-18 13:29:31.910612	-7215376392406475286	891
504	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32375f7633	\\x001181abbd3150c885da41ffffffff789c8d94d14ed35018c76fccd8c626c20618d150e7a501dbd3aeedda1b8b5456c6061634315c2c87f5e08ed9dad9732acc5d796162626282266ae20b90f0025e12ef4c7c0baf4c7c084f4b3b440d6c176b76fea7bfdff79daedfa5f4e0b236e32317edc14ed30950b3e5052ec5696dce472de4d24ebf89f67bd8474e9ca4b442b29d50480332485ba59c1d2e2127a5a5cc2d9c650b1bc875b0fb24a5a7b770b8c13c8144bf27b4b99ed7c12d8cc8099c6d6c12cf73997636b1d13626cdaee7b26b4abb9628bd5ecff369e062ca6e6641f1a4ca66c2db9e1864b50cedf790552ad63deaf99ce592c0876e0b856e2ddf0a08f5bac8673535b895f50d632d5a9f8a08fda61b7477c2306bdba66d4651aee7a32e0ebabb6911885ac68114598196d9c25d947ffa7efef8d3cbd79f535ae685e7227e90d5f3ff37eb97add255c3c1b4dd8790ab418277da905218651356699c10e290e880f42bbb79004400162baa3e6905fa541e324fedd53729a5172e70fcd955c8cded87584262f0181063648d210fd6adcec5c8c9aad17858371a5b5583ab27dc1b8017c432cfb30b90950a2f9415910f3fb1282b281509c4aebbcc957bc61d9ebaa6ab087668fb5fd9748dabf998b45dc86df8904027114e0a0c2e8b4052e5a1245351c5e488debe9b3f36eed0e2c5fd5c5f32368d47866dac72f7586bcbb6b159356b869d980ab6f960415058534012a4c495165072740b4cf5fdaaf9788476fe7e1ca76c41151529392cb0282229a6df66f49f47bfbe9cd20b6b78178dce562baa2ac920a91b0cebbec5c81fcd437784ba8b26d9833ec4b0cd6d064e7bf8372d00357acabc2801455592fa25912fcbb1659c59bede2ce746b0cc2edb5ccdb636ab0d836b182be123198a44495478505601fbe285a148064ad2ce8f83f9e30f6f8e6828d2aec56f69d347cf91cb06196533c3d91e1f8c69d9688c58a5fc326a71212e7aadc761371c688136b1849fb0047761275bd1f8457e30a64fb3ddabd00d77cb917a26d067cfa4f7d1ce39691dfae7a446efbcb40efb67d3a2a0b25894cb8a24ca2a92b5b964480ec7683c9b7f03b638954a	2026-05-27 16:50:16.374404	-9172075995407740820	984
533	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32385f7633	\\x001181cd9ade061786da41ffffffff789c8d94d14ed35018c76fccd8c626c20618d150e7a501dbd3aeedda1b8b5456c6061634315c2c87f5e08ed9dad9732acc5d796162626282266ae20b90f0025e12ef4c7c0baf4c7c084f4b3b440d6c176b76fea7bfdff79daedfa5f4e0b236e32317edc14ed30950b3e5052ec5696dce472de4d24ebf89f67bd8474e9ca4b442b29d50480332485ba59c1d2e2127a5a5cc2d9c650b1bc875b0fb24a5a7b770b8c13c8144bf27b4b99ed7c12d8cc8099c6d6c12cf73997636b1d13626cdaee7b26b4abb9628bd5ecff369e062ca6e6641f1a4ca66c2db9e1864b50cedf790552ad63deaf99ce592c0876e0b856e2ddf0a08f5bac8673535b895f50d632d5a9f8a08fda61b7477c2306bdba66d4651aee7a32e0ebabb6911885ac68114598196d9c25d947ffa7efef8d3cbd79f535ae685e7227e90d5f3ff37eb97add255c3c1b4dd8790ab418277da905218651356699c10e290e880f42bbb79004400162baa3e6905fa541e324fedd53729a5172e70fcd955c8cded87584262f0181063648d210fd6adcec5c8c9aad17858371a5b5583ab27dc1b8017c432cfb30b90950a2f9415910f3fb1282b281509c4aebbcc957bc61d9ebaa6ab087668fb5fd9748dabf998b45dc86df8904027114e0a0c2e8b4052e5a1245351c5e488debe9b3f36eed0e2c5fd5c5f32368d47866dac72f7586bcbb6b159356b869d980ab6f960415058534012a4c495165072740b4cf5fdaaf9788476fe7e1ca76c41151529392cb0282229a6df66f49f47bfbe9cd20b6b78178dce562baa2ac920a91b0cebbec5c81fcd437784ba8b26d9833ec4b0cd6d064e7bf8372d00357acabc2801455592fa25912fcbb1659c59bede2ce746b0cc2edb5ccdb636ab0d836b182be123198a44495478505601fbe285a148064ad2ce8f83f9e30f6f8e6828d2aec56f69d347cf91cb06196533c3d91e1f8c69d9688c58a5fc326a71212e7aadc761371c688136b1849fb0047761275bd1f8457e30a64fb3ddabd00d77cb917a26d067cfa4f7d1ce39691dfae7a446efbcb40efb67d3a2a0b25894cb8a24ca2a92b5b964480ec7683c9b7f03b638954a	2026-05-28 15:13:39.479046	-1269971856344746695	984
266	\\x70726f64756374696f6e3a64617368626f6172645f646174615f323032352d30372d32375f323032362d31322d33315f7633	\\x001181ea559f675382da41ffffffff789c8d55df4f1b47104669656363820143fa83b611284aa24ac8a690e039a95d034525254dc20fb5aa1f4eebbb397bcbdeadbbbb0775f3d6e7aa7f5d9ffbdeffa2b377678349da547eb077767666be6fbe19bf3ffbfa2134acb25cfa416aac8a511bb1002b3cb0e212a76cabb91b8f7bdc181e2a32ce423d374ae4a1111568042ab9446d312c4c65581c209776e0072a4dac58820529222c4e65a8c7ca2a5d1c67a0aeec00af8f2b45ca281252708b4654e19e48de286e069673cfa1922210e4d780cf5c017e5e8f112af187a8034c2cef6334bb832d582b9e688c451a93a7941850e5d1dd2fdaed9d667b736b678cd9d0bd484caae9766e6b73771b9fc2d210935024fd09d0c6d830e423955a93c2c29ee81f6020622e575abbd0dcdc6db79bdbadad560b776071c84538f625044b4539c5636ff5cd278d3162bfafd5951db85719e2d1b561798c67625999d0776d5bbdeee2b5b19e313639366e70a7e9352b51a8cbbe5f64bce4324571a73a804f6395d8811cf91a83546b4781c64b4cdc75ed37582433f19ef3a4e0fe317d0374b21e9e60a074e89fa0e496f2acc21c8b558832a8645e73ccf29e4405f58e460970e64e15a8b284c778b45ecd4296a0f4f519b95e4842c46ab0c8ec6848eae0c6a256b07e331385a0bbfdec0ae0391f96bcc7f91317d9e7449369428d65e0cceb0acc1974aae856a12c42a8650cd18f8a2b00961c5c07cd3855c142a0913be9730bd52bd23115fe683afb1828c0f7ee7e5ff2d46009ea8cba168ac049bc5b52f0610ef73ba2c200eca1bd424cca845b62644fe17e7eddb1568b5e6a9dcfe47719e6759184cd7bada3f51b5595bc4787449416fd8155b03295a4938425b8cb8281902161ea96157cfe6fb5bf4a518f26196bde43b60a6b39677e0f23a5d19fb4e01c2a0794be3b2766c47b7ffefe80bee813d5b6b6daedd693166172aee7f06c3ad924fa73b4031552816722c61f5582fb1355deb6514fbbd431dfbfdcf2fdee4c774641673a2af925d44d7adb09f990fc29ee4b656c5fe3e9ab638017470779506a683cacc082eb4b205c323147cc99804b6cd20f2962619bc49725e75fa982267cc014114bcb89f6d5b878e79ad1c23e8225e6a7498f165be8a4e6fc73c2882e3fe4a43f6ec84d795f667c7a5f9d7b2c27edaf3f0ad2d89ad7619f78474def19dbf0be6d7ac76c03aa048c709368d6a6fa798026c8f7518938c65f86fad46b973d78bb28aa19205af23526150f316cc2bd6b4dfabd9454e18669639acf97638fbddca1ec3da001bf35700e2e75913b90b3d9b8d519a752fd6ce6d83c1d354632ef8be374c09350526fbad56e39983d45d26aebbff3925eb4e6a36ff28725ef843da6a7d5cca8bc1fc6868fdf2e6805dbef0a3f762d32ccb8e8273ce9e3ff282df3bb555a7d8f1b11bce8fd44a8153c7d57881bde3703518f685762dfb5c82a3fdb9c87b0cca2d4d25f152d61934a52e93cf1eb221b27476e464970e85628a9f6902298814a65e8236d30edbbe637e9d2f5c7ed418a6a7e96ce62f905ba502a8a0c5a0a5567010f06e85fe0884e8de2548ca6b3042a8e85c94e7e48235081c5f13fae8a848d6a4f9abb3b9bed36acd2df13cda2dba2daba5970e3d2288ca4e1dcb401f5c23442aec59dbfcbff00918b0055	2026-05-17 05:04:50.48956	8666340677020924209	1389
270	\\x70726f64756374696f6e3a64617368626f6172645f646174615f323032362d30312d30315f323032362d30312d33315f7633	\\x001181b2d4f56e5382da41ffffffff789c8d55e96e234510b6008d63274b9c9b8508a2450b4148c88910283512b4931091257be51008ff68b5676aec263dd3a6bbc7c1ec3320f19c3c05d533e32b2c2cf20f4f7d5d5dc75747bfb3f46a1f369d7642f128b74ea768ac5c852d113939c2056cbb5413694f582b624d600d5a25a850c45edc8c743642e3309e426b0314ca0d78a4f3cc91bcaa648253a9956aa7cd4cd46e803371ab7299245249e1d0dbdb91d93f82abc146a939d44a46b2d0fbc807c0cb78acd4191fa2893073a28f74ba5be91b4c659e929a521851d849d09e246a099799cd0dc62c80f52166b1ccfab35427c0508c75ee8a548742c673f27ae5a40472583d96fd538c642a54f308da5fb489af2a07de37face0dfca52287f10cd898043945b6a684ccb0ed595d6660abe0602a6eceb161e876616ad4e795c79150b9c73e4c75e6066acc0d46b9313e478323cc8ac3350289c592060d7b17f40fd0292a7289913631bf44251cf9d8866596ea1855d428b49699133d851a5a1d830ae0da4b0d68b24ca478fea859980c20f8ee9a546f1565c31ab0c6dc7848b516d6a1d1f068de1399a0b393e208e0a91806e167e5156f990ba2c8b661851589d9570d58b6e8cbdc6d425dc6b052b0431f0d1f00acfb647d6ad6f708ac4606856f64e1a079475d4981ef2f7a9f240af0a33f3f5122b718408b51c56219f986ed061a1e96e93e232a2cc031ba3bc4ac4e792b4cdc15ec95c71de78cece5ceeb4cbfebf0c0544e58333c387f34175510ee9f115146f6074ec3d682934e1607f02e8b0652c59453b7aee1f37f8bfd658e663cf5b8127eca3660b7e48cf730d106f9b40437d03825f7dd6559936f9b3f1ed31ffd9295c3c3a3a383af0e2827af7a034f169d4dad3f4537d03105782d53fc59677832edc8fb18d5b44b15e37c74c879b7d6ad69e82c5a25bd8caa49773bb118923ed97da1adeb1bbc7a7901f0fcfcb4344a054d870d58f57589a477269789391b09856dfa503295ae4d7c3952fe9d2268c37b4c13b1b46a68fb4c82f7aa052d6c07d619cfb31eada9d8b79ad72f0923ba782ca8ff8425351d7e53f0197e7b13b292b43f27a4b1876187bd1f9eb7c3276c2ffca11d5eb03d685262943735cdee423d4fd146e5ba098863fc6d68aec2a37a08af6f8a669110adec15a6b488316ec3ceac27792fa7aef0c3f4f1229f2f261ac7a5423d7c4c037e6fe07cba5445e1935c2ac6adc50485ca8b99634d120d26aaac8be77420b258516dbacd6e3d5aba42ead583fff64bfd628c187f5f5e0cc24bf6095d6d16a00e7f9a001fbcbea1357cf926f313d5ca43cd5bbf14591fff476885debdd05ac7c2cae879ef17ca5ac3d76f3231a73d6f886a44bb12fbbe444ef362739ec1064b72476f10ad609b2bead207c4afb76c7d3b0a3bcea233bf42a96bcfc8821de85cc51c698319ee8bdfa6435f1fbf07c9aafd5579c4895bf4a67492587464aac522110d90dfe298a4cd4aaa46d323914e53690b89c7e54b30794275221dbd90dbf426d110faf5699c1f023f279b1548cd5b427bd0aaa0310a23dffaab0e6b15503c3b32f81b6b4ef800	2026-05-17 05:05:19.840417	7274765973973710787	1324
510	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3238	\\x0011015418dfcc6e86da41ffffffff04085b0e7b093a0e74696d657374616d706c2b077bff176a3a106475726174696f6e5f6d73660c313737302e38373a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b070103186a3b06660c323231382e38343b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b072008186a3b06660c313039342e36333b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b079d08186a3b06660c313734392e38353b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07e30b186a3b06660c313538312e37383b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07f30b186a3b066609392e32323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b073c39186a3b06660c323334332e34373b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07df57186a3b06660c323231312e35383b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07a35b186a3b06660c313833302e39323b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-28 08:40:27.091336	8585746061094854253	722
336	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d31395f7633	\\x001181dd4b6bd20c83da41ffffffff789c8d94cb4edb4014863755c8054321012a40c24da5765111d9633b76c6ab81a4c48404ea00528554cbc403b114db912fa5691ea1ab56bdacbbabcabeea1275ddbe41775d55eaa66fd0b16307905a142f6ccdfcc7ff77ced1ccb9951ecec04517dbf84cef694680b58e13d8be99862b2eee60dbef0d34fcbc6fbad8889514cc27e19eaffb81374c2bc56935dcc2460aa66afb66966cec61db30edd3949cde37c380dac8245acfc295bed3333b26f646e62450f31cc726d8a584e6774d4fb31c9b7c537039413afdbee3fa816dfae467221446596a89df1135ccc28c3fe863a558683abee3d28aed05ae6e7770c8865427f07cc7c2ae525cdd406d748854b44d6fd651abaaa276bdd6406a14371f390e343bb08ec3e0bc5a7bbcce8a6285013ccb3351cc74dfc59619582739b6c44a98831943f7b112c0ccbe69616afdf5dac5b73bb527299879e1d8981966654a292ed4b1def3bbd7d39267488b5af4d6ee1eda89d6b35789acc4897cb47dfb240b4a1ce6e5392590e7a98784f0ebfcf797949c8fddff5573683eb7d9a47794d65658ed4142c8d48dae11fb921218616c7c9f18ff81e8e9a5717ec73cc193272d5524892f83d83c0d30173bdf23ceef6b1fed4be7ff36a450f3ce745737f52edd0e8cae3e660089891e8e07a224268de1394628c7941ca17cbd2b4c4f4059aaaa744355daf516a25b286ad018c4f19cc8004102e4c5b06350198849393f5fad5dbc7b79ee4f005adc535173b74ab7ebca216a1c3447072de45022902a02493f265080e578b12425d57c279085079f7f4c0099dba25574a8d00d4545adc47f15484299068c20d2a02272b428308026fd1b1f298995f82bac379fde7e085970393ee09a8b9f619b0c079fdc43e328379c82d9e86a92dcabb84387fd896e444eb7c22111c0d90df39428a6a5f7b215c89498e194bc40a2b7753b8c2e47e8c5405ebaa63ec2c737a84dddbd4145fd9bd4a63eb8ae165889c89cc4734299e37019ae2483673c9ae279f71717246718	2026-05-19 09:52:17.678331	-7118541652565841732	938
328	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3139	\\x001101f9b66b986483da41ffffffff04085b097b093a0e74696d657374616d706c2b07bfdb0b6a3a106475726174696f6e5f6d73660c313530382e33323a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b07c0e50b6a3b06660c323834332e34393b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07122b0c6a3b06660b313536352e333b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07d1320c6a3b06660c313930302e33333b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-19 03:40:47.292251	4929919455128633605	454
160	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3136	\\x0011819904f8b87782da41ffffffff789c8dd3bd4ac350140770076912abc5b17e80e22a1c736fee476e424107073fd0c12e221a429bd2146bb54d5d2a8a83a393be8183bb4fa08f210ebe81a3a09369efed289c2d70f3cbff9c937327eda3a5811394b2b49df4b2b87d7eba6a95dfac56305bef77e32ced9c45ed5ea34829778107a55a5c6b265133cdaaf90b711647bd4ebf5b4bb656e64627f5a8919e6649377f189e1682c26675e08413f94797bfad5658681425a52064685543fb3f153a6354d1c891201992b4676c9dc37df00412ddce1b445c50d8a4f2824684e6e5613b5a33884a85efe9657184a6a4f2011b7417e820c1093082449f15d312783cf190e8695d235ff84038123d6c68c47324b0e851235b818f14dbbb660acc05171bf3bb67902ff0a3fbd9d788310f04b6bcfbc3119a26940af015529d1c9bfa54de1436ea353251ca23a0b05dbd47e37515e06157efb963a25c8fe1efe0ce85b983c328ecee5d5f9a51480e0cfb7fbf061a29a6f0e57d5c8d9b521c5cac3ab8318a7812a1fe0054a38cd6	2026-05-16 00:58:00.130797	7259107503266322169	572
428	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3236	\\x0011816e17b25bc385da41ffffffff789c8d94bb4a034114864524173704c10bd806ac84c3ce7d27db79030b11248d58ac6b2e642531926c1a632368e10388be41aab43e8e9d0a4a1aedc54966528aa75b98fde63fe7e7db5dc89d9406f972314ddaf55e1ab72f5b9bd9c3d795f3f252addf8dd3a47311b57b8d02a5428256e56235ae36eb5133492be68d388da35ea7dfadd6f74bebd3935ad4485a69bd6b1e26a7997266b732c88773e6d6c4dc1a661a1e1502840cb39530f71715e66750f46621c924088a84b2ef53a840b866c005927ab494273405ce90d0d3878b925401c36ef5f369291a5033a0465274ecb288e4a00224b565a9bc06895dead8210234b6f2efb12b4f6af0b135ac7db91ab84f406129b5b16a29664422d81a024b7981af406395882c34e98e23913d329b4e690814927a1096629231a05821aeb75d16315968cfaf4e5d160d185ed99d33db9f714f0376adbbae1b5019cf0996bab794a7b4c4bb7474b3ea3e44f3cd0bace9f3b78ea281028595fd6038a3cc4f91630d7cb6d422315b61939647b3ad7c1f7c6cd270e45cd71c18568b97911b8f03f977bc5fe975bfa6	2026-05-26 00:11:59.67831	-2192069948009749153	601
511	\\x70726f64756374696f6e3a64617368626f6172645f646174615f38636464306331615f323032362d30312d30315f323032362d31322d33315f7635	\\x00118124101a0b0186da41ffffffff789c8d556d6f1b45108e0ab26b3b899dd4718388daaa286a514574ce8b5dcf49704e42444a4bdba415087f38adefe6eca57bb766772fc1f40b7f007e223f805fc1ecddd9894ba1c81f7c3bfbdcbc3cf3ccdcc737df3e80a69186093f48b591312acd37618305865fe082ad95c3583c645ab35092b1028ddc2890859ab7a019c8e40295c1b03035606d8c4c98b11fc83431bc0975c1232c4e2568c4d248757594668cb3e3126c1421a3880bce0c6a5e85db3cf947724b70d786f3f3e89acbc49fa00a30316c8451b5b3bfd36dc3addcd9440a1e70727507b60a8bc298a731bd2d0406947bb4badfeeb57bbb3b9dceac6a4df73cd1a9a2dbdaee8ed3c32eac4f300979322a4aad41736698b0a94c8d4ea17ec847c718f098898df66370767abd83bdbdee41a78d07b036613c9c63dd563347388ff7e8fe00f761bdc86f8e686588b6f3b8d3eeeeb5bb1dec10e3050bfe48c94b33262ed6b312a757865bb30ae7968d39a557b6d65567af8c8d8cd7f9b1798d61456f4715cb2db9bb18f945d40b2652e4377eebc39d5826662ca6bec22055ca12a3f002137b5dbf843532538772f624dc7b4aff00fdacb767184815fa672898a1582da879b10c5104950c55f30c1b0a94d0e82b1400afeca902552f61319edeaf662e4b50fafa1541df08aaca5b8535cf4c27a41aa60d2a09f7af4722177477945d013c639392fb79fe8af5ec33a24a3bb0ec65c5e9b715a869b45a1954a1cc4358ce58a2878a4d00d66db9b6346df507f54021b323c10c542f49df94f8c3c5e8b34201beb7f74782a51a691c3cea5cc8032bfd4149c22779b9df11151ae010cd256252a6ba0546e61ceee5d77d63141fa6c662e6cf6558514510afeeb64fef5fcbaae43e3c21a2141f8d8d848d8520fd242cc1aa178cb908a9a64159c2a37fcbfd658a6a3a8fb8ec3ef036612be7cc1f622415faf316bc86ca31851fd4f812ff48fdbe4d7ff48b9677777bbd76a74d3559e86b78b2186ceefd199ab10c29c1573cc61f6582477365be6ba39e0ea863be7fb1ebfb83a5c19284fea257c225d44d7ab71fb209e1c9ef0ba9cd48e1f9cba700cf4f8f73a7d4d0785281baed4bc06d301afb9aa70326d0a107c1636e1ce2cb10f857cac0814d4f12b1b4b4688fcd92b7d08c166f0bd63d3f4d86b4f0422b358bcf0923bafc9091fe98269874bfccf874bf7aed7a39697ffe5190e6dd71fbde5df7d4719f78dbeeb78efbd4db862a1546759368b616fa798c3ac8b7548938c65f26eadced955d78bf28aa5941bc4ed2179285183a70fb4a93fe302555d861fa6c91cf1733c4610e28bbdb34e0ef0c9c2d97bac86c9137b3716b788c52f5b399f3ea74541889bc2f96d3314b4241bd195407e5e0e6399256dbff1d97f4a2149b7e93bf5872cfbc47f46a35334af78799e1d3f70b5ac2fe87dccfa0458425ebfd8c2523fc1fa965b877526b1c32cd83e7c39fa86a09dd0fb9b886beee887a44bb1247b64546fad9e63c815b5e941afa80d112d6a92095ae10bfd6b3b672647a9a04277685926a4fc8831ecb54843ed20653be6dbe4397b63f760f9257fdb3b016c3dea07525a348a321570d2f60c118fd3738a553b33815a3692d818c63aeb3931fd20854606df61d961137d1ca17077bf45571bad0a26f140da35da3cad861b0f3d22c8c24e2dcb40d8dc23445a6f88dbfca7f0347db05e0	2026-05-28 08:55:28.476608	2262779037054788273	1424
591	\\x5f5f736f6c69645f63616368655f656e7472795f73697a655f6d6f76696e675f617665726167655f657374696d61746573	\\x3431373837	2026-05-29 11:57:23.49489	6706543775222517821	194
345	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32305f7633	\\x001181ca88b3197083da41ffffffff789c8d94cb6ed34014863728cdb5a54ddaa216a92648b0400dbe2576c62bb7098d9b260d4e5b0955c29ac6d366a4781cf942097904242458c02b20758f5856ace10dd8b14262c31b3076ed441550c50b5b9efff7ff9d33f29c5bc9f13c58711041e77060983e327ab64f3c9c04eb0eea21e20d46067a39c40e32232501f2b1ddf5a0e7bbe3a456cceac112321320513fc069bad041c4c4e42ca1240f7060a85f8584ef0b607d680f700f23f72a9c1a0dd7b609c5aec634af8f5dc3b2097d26c05a8cb48743dbf17c823dfa31150a57551a71de716e9c06296f34445a71b981e0c0eb331a717d07921e0ae020d7f35dcfb690430d4da6e960b74f20d371a00bc3eac052983532886f9d04ae458e65d98ac08b728565434776e8200bfbd669aa2a0b324899d0439a0f5207d842b937ef362ed5c75e210152af6c82d8715ac969c542cbf66ce77a29cabc56bcbba576d52355577799ed86daaee96ab7516faa7aa82f68c5bc5e7fbac9495295e5454e0cf1caedd30c57e26424288b9aaf2ce53629f1eb9dfab384928f68ffec3cc065dbccce7e47ddfb3b9e9305498ce2d37c49406294fe88a6ffbcf8f5799afebf5e16b75bcc9ed6de09ba398c09a986d937a765b3e549f0031afc1ba8cfa7c1f93d7c8a662f5aaecab258e1a3f0243fd990fb34f943fd239961430a75f71c3a10c33ed3f5cd3e9c3078990d2f41e425598a374614d87225a26428e5cbbd727606ca6a4d679abad66db455a6ad861b340109a220b17c59e6e98de526a00a2fc5edfc78bb71f9fef585370368a5a3abadfd1ad36d68476af3b035fd9172122f57cbb4fc8890e33941944a72dccd370a597ef8e97b00016bd10f6e38e80522742878f4fc99c799f11c48874792e6d5508f096a0e4f44065ac170f0c1c2163ea30ab6e0205d056c891dcf29cbd4bd0b49e0ae84f4155f59bda63e412737a82de8dca0aac39bd4161c5d570b9c4c65a12a725551105005acc703673292a239f707bbf865bc	2026-05-20 14:06:38.804434	1918383142847409599	927
424	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32355f7633	\\x0011813189e5463885da41ffffffff789c8d94cd6ed340148537284dd2a4a54ddaa216a92648b0402dfe8bed8c576e131a374d1a9cb612aa84358da7cd48f138f20f25e41190906001af80d43d6259b1863760c70a890d6fc0d8b5135540152f6c79cef1f9ee5c79eeadf4680e2cbb88a073d837ad00995d27203e4e8335177511f1fb4313bd1c601759b1920285c4eef9d00fbc515a2fe58c7009592990aa1de02c5d68236261729652d3073834d4ae42a2f779b03670fab88b9177154e8da6e738846257129adfc39e693b843e536035413a8381e3fa01c13efd980ac5ab2acd24ef383fca828c3f1c20bdb45447b0eff7189d78810b4917857090ef069eefd8c8a58606d370b1d7239069bbd08351756031ca1a9a24b04f42d702c7b2ac24f0a222b16ce4c80d5c64e3c03ecd54144101190bfa480f40e600db28ffe6ddfaa5f6d82fa640e69543103bcaaa79bd546c3abee35e2f459dd34b77b7b48e76a419da2eb35dd75a5543ebd46b0dcd88f479bd54306a4f373859aeb0bcc889115ebd7d9ae690a02ee881ba98dfa0b8af776acf526a2146fd73db212bd76276f6dbdadedfd99c22c8629c9de5370524c6e98f68facf8b5f9f27e9ffdbc8c27693d9d35b3be1560e1342a66ef5ac49cd49ea039afa1b68cf27a9853d7c8aa6af58a9288a28f149323feec67d9afca1f6914cd18d62cd3b872ec4b0c77402ab07c70c5e61a34b1079599193ae88025b9662ca2ca57cb957ce4d4159a91a4cc3d03bf596c6b4b4a83b6390200a32cb97159ede586e0c927839d9ce8fb7eb97ef5f5ff8538096db86d6dcaf329dba7ea4350e9b935f282ff34aa54ccb8f09794e612bdca6c8c5906f14b2f4f0d3f7100256e35fdb74d10b44e838f0e9c9b38e674733201b1d469a57455d26ac393a0bb3d00ec74200e6b7f01955b00dfbd90a6037d9d18cba44ddbb90846e29a22f07eaca35f5093ab9416d42f706551bdca436e1f0ba5ae4142a0b5259e459494112584b46cd7818c513ee0f535b6483	2026-05-25 23:52:03.589815	-5112128871628215544	923
340	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3230	\\x0011015c5cd0f3c783da41ffffffff04085b097b093a0e74696d657374616d706c2b07f3500d6a3a106475726174696f6e5f6d73660b313739312e393a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b078e690d6a3b066609313931313b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07eebf0d6a3b06660c313536382e30323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b073fc00d6a3b066609362e39373b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-20 06:13:07.289466	-7595484867282993172	448
387	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3235	\\x0011019815e60c9085da41ffffffff04085b147b093a0e74696d657374616d706c2b07eb9e136a3a106475726174696f6e5f6d73660b313532382e363a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b0746e5136a3b06660c323034302e38313b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07edfa136a3b06660c333330312e38323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b075aff136a3b06660c313639342e30323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b075d1e146a3b06660c323034312e32333b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b076926146a3b06660c333738332e37333b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07ea26146a3b06660b3933322e32363b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07602a146a3b06660c313936312e39313b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b072035146a3b06660c323232322e37333b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07013f146a3b06660c323032392e39383b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b070c3f146a3b066608362e323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b078c41146a3b06660c323730392e36313b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07fc69146a3b06660c323430342e31343b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b074b6a146a3b06660b3232362e38343b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07a3e0146a3b06660b323134392e343b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-25 00:59:23.786665	-2485433758477823667	1041
351	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3231	\\x00110184b1927e1e84da41ffffffff04085b077b093a0e74696d657374616d706c2b0796fe0e6a3a106475726174696f6e5f6d73660c313831332e34313a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b076a1a0f6a3b06660c323230382e32363b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-21 12:46:14.373954	2444336715856916634	347
593	\\x70726f64756374696f6e3a64617368626f6172645f646174615f35653039666162665f323032362d30312d30315f323032362d31322d33315f7635	\\x001181fc0713256e86da41ffffffff789c8d55ff4e1b4710466965631b6203c6495b944454885491906dc0e039a93d138a0a254d02895ad57f9cd67773f696bd5b77778fd4cd33b47dc33e409fa2b3776783d3b4a9fc876f67bf9b1fdf7c33f7f1e2db6da81b6998f0fc441b19a1d2fc3eac33dff06b9cb33532188b064c6b16483296a0961905b240f306d47d195fa33218e4a61aac8c900933f27c99c486d7a12a7888f9a908b5481aa9f263016ad28c707a5c80f53c641872c19941cdcb708fc7ff486e011eda705e165d73197b63543ec6860d312c77f6760e5ab096391b4bc17d4eae1ec2466e5118f124a2b785409f720fefee7577dbadce4ea733ad5ad33d8f75a2e8b6b2bbd3ece201ac8e310e783ccc4bad407d6a18b3894c8c4ea07ac487c7e8f38889f5d62134770e0fbbbbbb7bbb9d16eec3ca98f16086751a19a2d33c6c759bbbad7d42ace609ce208d14d2daeb1eecb7f73a071dec10e5390dde50c937664464aca6354e6e0c6bd3126796f519a737b6c64d6b6f8cb594d8d9b17e8b62456f87254b2eb9bb1e7a79d46b2612e4773e3d8307918ccd484c3c857ea2946546e135c6f67afb0f582133b528a34fc2a373fa07e8a5cdbd405faac0bb40c10cc56a40c58d6480c22fa5a88a6bd840a0845a4fa10078654f2528bb318bf074b39cba2c40e1eb5704bd1254957b17565c3319936c9836a8246cde8e442ee8ee697a05f08c8d0bce17d92bd6b3c7882add8425372d4ebf2d4145a3154bbf0c451ec052ca123d946c02b06acbb5a5692b40a8fa0a999d0966a0fc86044e893f9e8f3e2d14e07b7bff54b04423cd834b9d0bb86fb5df2f48f8242bf73ba242031ca179831817a96e81a1b98447d975cf18c50789b198d9731196551ec4ad3aadd3cd5b59159cc7274494e2c39191b03e17a4170705b8ebfa232e02aaa95f94f0e4df727f99a09acc222e39dbee7dd8c838f306184a85deac05afa1744ce1fb15bec03f52bf6dd11ffdc2a576bbdb6d755a549385be86b3f96033efcfd08c644009bee211fe28637c3a53e6bb36ea699f3ae679d76dcfeb2ff41724f4e6bd122ea66ed2bbbd808d094f7e5f486d860a2f5f9e033c3f3dce9c5243a37109aab62f3eb7c168ee2baef699c0263d081e71d324be0c817fa50c9a70df95442c6d2d5a64d3e42d34a5c5dd8055d74be2016dbcc04acde233c2882e2f60a43fa609269d2f533e9daf5e3b6e46da9fbfe7a4b90f9c9efbd0396d3a67ee96f36dd33977b7a04c8551dd249a8db97e1ea3f6b33555208ef197b1ba74ba4507de2f8a725a10af92f4856401064db877a3496f90902aec307d3ecfe78b29e22803149d2d1af07706ce964b5d64b6c8c574dc6a2ea354bd74e6dc2a1d158622eb8be574c4e240506ffae57ed15fbc44d26aebbfe3925e9462936fb2170bce85fb845e2da746e9fc30357cf67e414bd8fb90fb29348fb060bd5fb07888ff23b514f74e6ab523a6b9ff7cf013552de1e0432e6ea16f3ba21ed1aec4a16d91915eba394f60cd0d13435f305ac23a11a4d265e2d77ad6568e4c4f62ffc4ae5052ed0979d0239988c043da60cab3cd6fd2a5ed8fdd83e455ff2cacc5b02bb4ae64186a34e4aae6facc1fa17785133ad5f3533e9ad6e2cb28e23a3d79018d400956a61f621972132eb7daf4fddbd93f80067da36818ed1a55c60e839d977a6e241167a62da8e5a60932c5effc55fc1b417105e8	2026-05-29 15:57:28.298381	-8528069747268823026	1427
594	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32395f7633	\\x0011819d1339f86d86da41ffffffff789c8d944f4fd3601cc72f666c6363c2c69f80863a6f1ab07ddab55d77b14895320658a609e1b03cac0fec315b3bfb3c15e64e1e4c3c99a8074d8c17bc90f8063c126f26be11135f844f4b3b021a462fcdd3efd3cfe7f73cedf3bb96ec8f69531e72d0016c376c1f359aaeef509cd4e63cd4440e6df71ae8b08b3d640f927c3c9d50487dd24f9ac58c153c4276424b18759c660f36916363673f5149d67130c1388584e39c36d775dbb889113985b3890de2ba0e834fc736dac2a4d1711d764f68b3b1d2ed765d8ffa0ea6ec6516144eab6cc4bc9d5c3fada568af8bcc627e0def21ce7488ef41a78902b5966dfa84ba1de499c5dcb6bb8f480b72b5ad309a0819bd86e37776833c5b55644596553e4c335d0f75b0dfd94b2b120f242d65438a4c5f4bd57107658f3ecc9f7c3dbaf325a1a55eba0ee2fbe94ad62c166a2e75bdf31554c6d866ac738f3636f5b5709c338b69cb322c231c5ddf4b8a40ac8c9b7e6522fb8c513fbd7af33951c90f21cee836a6ad1e845c1512bcdb8294c2983e4a08b1891de1b30088002c96d5c80199a3fafaa734dc71b1eacc61802524028f0ccaae32e4bb0db33d1c39bea2af3fa9e9ebf5159dabc5dc9b8017c412cfb31b9095322f9414910fae48941694b20422d77de6ca3ce78ecf5c932b08b669eb5fd96495ab7a98b41cc86d7a90403b168e0b0c2e8b4052e581245556c5788bdebe9f3fd1efd1c2f0f5dc58d2b7f4a7baa5af720fd8d2962d7d6bc5a8ea566cca5bc6e30541618b029220c5aea480e2ad5b60aa5f33c6f6159673f1739cb1055554a478b3c0a288a4887e97d17f7ffbf3fd8cfe9f2372195b2dabaa2483b86e30a8fb36237f348e9d2bd45d30c801f420862d6ecbb75b83df340fd4f02bf3a204145589eb9744be2447965166f971ab94092cda6c74201b1e7a811cd6b828eb11f6ce687f444b876d839de065d4e4000f4ae1091e859da081f95a6e09efb30477603b5dd6f845be3f529964b357a113cc9643f5945f993e973e44bb97a435e85d92eaddcbd21aec9d4f0b82ca62492c070d4845b2361737c541db8c7af15f45ad91a7	2026-05-29 15:57:28.892642	2585407363702622422	976
374	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3234	\\x001101539e2c4e1285da41ffffffff04085b0a7b093a0e74696d657374616d706c2b07734e126a3a106475726174696f6e5f6d73660c313732352e37373a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b07284f126a3b06660b3537312e35373b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b0753e0126a3b06660c313530322e31353b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07ede8126a3b06660c323031352e31393b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07a8e9126a3b06660a3537392e363b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-24 01:03:47.395132	2877994654342782884	506
464	\\x70726f64756374696f6e3a64617368626f6172645f646174615f323032362d30312d30315f323032362d31322d33315f7635	\\x001181b9e9fb295185da41ffffffff789c8d556d6f1b4510b60ab26b27a91dd7498b1ab55551d4a28ac8719cc49e93e09c86889494b67911087f38adefe6eca57bb76677cfc1f437c04fe407f0991fc0ecddd9894ba1953ff87676ee9999679e99fbf4e6dbc7d030d230e1f989363242a5f95d5863bee1135cb0ad676e2c1a30ad5920c958865a6614c802cdebd0f0653c416530c84db76075844c9891e7cb2436bc0155c143cc4f45a845d248951f0b5093668457c7b53c641872c19941cd2b7087c7ff4aae000f6c382f8baeb98cbd312a1f63c3861856f6ba5bad1db89d818da5e03e27a87bb0915b14463c89e86d21d0a7dcc35b3bddf6fe6e7b6baf33ab5ad33d8f75a2e876a9b5d5ece23ed4c718073c1ee6a596a131338cd954264627503de0c343f479c4c4da76079a5bfbed66b7bbdfdedec55d581d331ecc7d9df57aead1d969777677b10df53cbbf97d86d069b5db9d56374568cc28f0864a5e9a1111514feb9b5e196ecfca9b5bd6e67c5ed9d6afda7a65aca5a4ce8f8d6bf42a7a3b2c5b62096e32f4f2a8132612e437ee1cc1fd48c66624a69e423f51cab2a27082b1bdfe7b02ab64a6f664d449787842ff00bdb4b1a7e84b1578a72898a158ebb0e4463240e19753af25d7b0814009b59e4201706e4f65a8b8318bf0f85125852c42f19b73727d23a82a9754e89ae99824c3b44125e1d1f548044177cfd22b80176c5c74bec85eb1c81e23aa741396ddb438fdb60c4b1aad50fa1528f100965396e8a16c1380ba2dd796a6adf8a0ea2b64761e9881ca25899b127fb2187d5628c00ff6fe996089461a0d973a1770dfeabe5f94f05956eef7448506384073891897a86e81a1398387d975cf18c50789b13ef3e712aca83c885b75b68f1f5dcbaae83c3922a2141f8e8c84b58520bd3828c22dd71f7111504dfd9284a7ff95fbeb04d5741e71d979ecde858d8c336f80a154e8cd5b7001e5430adf5fe205fe89fa7d93fee8172eb75addeef6de36d5645d2fe0f962b039fa0b3423195082e73cc29f648ccfe6ca7cd7463ded53c73c6fd2f2bc7ea15f90d05b4425bf98ba49eff60236267fc27d25b5192a3c7b7d02f0f2f83003a58646e332546d5f7c6e83f125624efb4c60931e048fb869125f869c7fa30c9a70d795442c6d2c5a62b3e4ad6b4a8bbb0175d74be2016dbbc04acdfa6784115d5ec0487f4c939b74be4af974bebe70dc8cb43fffc84973ef3b3df78173dc749ebb9bce774de7c4dd840a15467593683616fa7988dacf56549138c65fc7eacce9961c78bf282a6941bc4ad21792051834e1ce9526bd4142aab0c3f4f9229faf661e079943c9d9a4017f67e06cb9d445668bbc998e5bcd6594aa97ce9c5ba5a3c250647db19c8e581c08ea4dbfd22ff937cf90b4bafdff71492f4ab1e9b7d98b45e7d47d4aaf5652a3747e9c19eebd5fd012da1f829fb9e6110a16fd94c543fc88d452bf7752ab1d30cdfd97839fa96a09fb1f82b8e67d1d887a44bb1287b645467ae9e63c82db6e9818fa7ad112d6892095ae10bf16595b39323d8dfd23bb4249b54784a04732118187b4c194679bdfa44bdb1fbb070955ff22acc5b03768a164186a340455737de68fd07b83533a35f2533e9ad6e2cb28e23a3d79018d401956671f61197213ae7cb9bbb3d7de6aeec33a7da36818ed1a55c60e839d97466e241167a64da8e5a62932c56ffc55fa07382505c2	2026-05-26 06:53:47.936877	-5718463762700479890	1413
535	\\x70726f64756374696f6e3a64617368626f6172645f646174615f62643564343663395f323032362d30312d30315f323032362d31322d33315f7635	\\x00118150368dde3d86da41ffffffff789c8d556d6f1b45108e0ab26b3b899dd4718388daaa286a5145747612a79e93e09c84889496b6492b10fe705adfcdd94bf76ecdee5e82e917fe00fc447e00bf82d9bbb3139742913ff876f6b967669e79b98f6fbe7d004d230d137e906a2363549a6fc2060b0cbfc0055b2b87b178c8b466a12463051ab951200b356f413390c9052a8361616ac0da189930633f9069627813ea8247589c4ad088a591eaea28cd1867c725d8285c4611179c19d4bc0ab779f28fe096e0ae75e7e7de3597893f41156062d808a36a776fe7a00db772b289143ce0447507b60a8bc298a731bd2d0406147bb4bad7eeb57b9d9d6e7796b5a67b9ee854d16dadb3e3f4f000d62798843c1915a9d6a039334cd854a646a7503fe4a3630c78ccc446fb31383b8f77f73b7bddc7dd36eec3da84f1708e755b39a2b3eff43addddf63e21d68b00e7905606693b4470b0db3ee86297242f64f0474a5e9a3189b19ee538bd32dc9aa538b76ccc35bdb2b5ae4a7b656c64c2ce8fcd6b122b7a3baa587189ee62e4175e2f984891dff8ad0f77629998b198fa0a835429ab8cc20b4cec75fd12d6c84c25cae59370ef29fd03f4b3e29e612055e89fa160867cb5a0e6c5324411543254cd336c285042a3af5000bcb2a70a54bd84c5787abf9a5196a0f4f52b82be119495b70a6b9e994ea86d9836a824dcbfee8928e8ee28bb0278c62625f7f3fc15cbec33924a3bb0ec65c9e9b715a869b4cd32a8429987b09ca9440f151b00acdb746d6ada3620d40385ccce043350bda406a7c01f2e7a9f250af0bdbd3f122cd548f3e051e5421ed8de1f94247c92a7fb1d49a1010ed15c222665ca5b6064cee15e7edd3746f1616a2c66fe5c86155538f1ea6efbf4feb5a84aeec313124af1d1d848d85870d24fc212ac7ac1988b90721a94253cfab7d85fa6a8a6738fcbee036f13b672cdfc214652a13f2fc16ba81c93fb418d2ff18fd4efdbf447bf68b9d3e9f5dadd36e564a1afe1c9a2b339fb333463195280af788c3fca048fe69df9ae8d6a3aa08af9fe45c7f7074b832509fd4556c225544d7ab71fb209e189f785d466a4f0fce55380e7a7c7392915349e54a06eeb1270eb8ce6bee6e9800974e841f0981b87f43204fe95227060d393242c6d2d5a64b3e02d3493c5db8275cf4f93216dbcd0b69ac5e782915c7ec8a8ff98269874bfccf474bf7aed7ab9687ffe5188e6dd71fbde5df7d4719f78dbeeb78efbd4db862a25467953d36c2dd4f3187590afa912698cbf4cd4b9db2bbbf0fea6a86609f13ab5be902cc4d081db573de90f53ea0a3b4c9f2deaf9628638cc0165779b06fc9d81b3e95215994df266366e0d8f51a87e36735e9d8e0a2391d7c56a3a664928a83683eaa01cdc3c47ead5f67ffba57e518a4dbfc95f2cb967de237ab59a19a5fbc3ccf0e9fb1b5ac2de87e867d0c2c392653f63c908ff476819ee9dd01a874cf3e0f9f027ca5ac2c18728aea1af13518d6857e2c896c8483fdb9c2770cb8b52435f305ac23a15d4a52ba4af65d6b61d999e26c1895da1d4b527c4a0c73215a18fb4c1946f8befd0a5ad8fdd83c4aa7f16d662d81bb454328a341aa26a78010bc6e8bfc1299d9ac5a9184d6b09641c739d9dfc9046a0026bb30fb18cb88956bed8dfa5af8a73002dfa46d130da35aa8c1d063b2fcdc2484d9c9bb6a15198a6c814bff157f96ffe960609	2026-05-29 02:13:34.20855	1605984047799203678	1424
363	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32325f7633	\\x001181c8e57293f483da41ffffffff789c8d94cb6ed34014863728cdb5a54ddaa216a92648b0400dbe2576c62bb7098d9b260d4e5b0955c29ac6d366a4781cf942097904242458c02b20758f5856ace10dd8b14262c31b3076ed441550c50b5b9efff7ff9d33f29c5bc9f13c58711041e77060983e327ab64f3c9c04eb0eea21e20d46067a39c40e32232501f2b1ddf5a0e7bbe3a456cceac112321320513fc069bad041c4c4e42ca1240f7060a85f8584ef0b607d680f700f23f72a9c1a0dd7b609c5aec634af8f5dc3b2097d26c05a8cb48743dbf17c823dfa31150a57551a71de716e9c06296f34445a71b981e0c0eb331a717d07921e0ae020d7f35dcfb690430d4da6e960b74f20d371a00bc3eac052983532886f9d04ae458e65d98ac08b728565434776e8200bfbd669aa2a0b324899d0439a0f5207d842b937ef362ed5c75e210152af6c82d8715ac969c542cbf66ce77a29cabc56bcbba576d52355577799ed86daaee96ab7516faa7aa82f68c5bc5e7fbac9495295e5454e0cf1caedd30c57e26424288b9aaf2ce53629f1eb9dfab384928f68ffec3cc065dbccce7e47ddfb3b9e9305498ce2d37c49406294fe88a6ffbcf8f5799afebf5e16b75bcc9ed6de09ba398c09a986d937a765b3e549f0031afc1ba8cfa7c1f93d7c8a662f5aaecab258e1a3f0243fd990fb34f943fd239961430a75f71c3a10c33ed3f5cd3e9c3078990d2f41e425598a374614d87225a26428e5cbbd727606ca6a4d679abad66db455a6ad861b340109a220b17c59e6e98de526a00a2fc5edfc78bb71f9fef585370368a5a3abadfd1ad36d68476af3b035fd9172122f57cbb4fc8890e33941944a72dccd370a597ef8e97b00016bd10f6e38e80522742878f4fc99c799f11c48874792e6d5508f096a0e4f44065ac170f0c1c2163ea30ab6e0205d056c891dcf29cbd4bd0b49e0ae84f4155f59bda63e412737a82de8dca0aac39bd4161c5d570b9c4c65a12a725551105005acc703673292a239f707bbf865bc	2026-05-22 03:47:33.798405	-7243172349780379515	927
358	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3232	\\x001101897b73594c84da41ffffffff04085b087b093a0e74696d657374616d706c2b0793c40f6a3a106475726174696f6e5f6d73660c313339322e37323a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b0777ca0f6a3b06660c313933322e37363b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07d5d10f6a3b06660c313530332e32333b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-22 02:50:59.495859	-7360975985040348908	401
369	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32335f7633	\\x0011816049c0ed8e84da41ffffffff789c8d94cb6ed34014863728cdb5a54ddaa216a92648b0400dbe2576c62bb7098d9b260d4e5b0955c29ac6d366a4781cf942097904242458c02b20758f5856ace10dd8b14262c31b3076ed441550c50b5b9efff7ff9d33f29c5bc9f13c58711041e77060983e327ab64f3c9c04eb0eea21e20d46067a39c40e32232501f2b1ddf5a0e7bbe3a456cceac112321320513fc069bad041c4c4e42ca1240f7060a85f8584ef0b607d680f700f23f72a9c1a0dd7b609c5aec634af8f5dc3b2097d26c05a8cb48743dbf17c823dfa31150a57551a71de716e9c06296f34445a71b981e0c0eb331a717d07921e0ae020d7f35dcfb690430d4da6e960b74f20d371a00bc3eac052983532886f9d04ae458e65d98ac08b728565434776e8200bfbd669aa2a0b324899d0439a0f5207d842b937ef362ed5c75e210152af6c82d8715ac969c542cbf66ce77a29cabc56bcbba576d52355577799ed86daaee96ab7516faa7aa82f68c5bc5e7fbac9495295e5454e0cf1caedd30c57e26424288b9aaf2ce53629f1eb9dfab384928f68ffec3cc065dbccce7e47ddfb3b9e9305498ce2d37c49406294fe88a6ffbcf8f5799afebf5e16b75bcc9ed6de09ba398c09a986d937a765b3e549f0031afc1ba8cfa7c1f93d7c8a662f5aaecab258e1a3f0243fd990fb34f943fd239961430a75f71c3a10c33ed3f5cd3e9c3078990d2f41e425598a374614d87225a26428e5cbbd727606ca6a4d679abad66db455a6ad861b340109a220b17c59e6e98de526a00a2fc5edfc78bb71f9fef585370368a5a3abadfd1ad36d68476af3b035fd9172122f57cbb4fc8890e33941944a72dccd370a597ef8e97b00016bd10f6e38e80522742878f4fc99c799f11c48874792e6d5508f096a0e4f44065ac170f0c1c2163ea30ab6e0205d056c891dcf29cbd4bd0b49e0ae84f4155f59bda63e412737a82de8dca0aac39bd4161c5d570b9c4c65a12a725551105005acc703673292a239f707bbf865bc	2026-05-23 23:41:51.006185	-6522873222930103940	927
367	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3233	\\x001101b1d0b1bee684da41ffffffff04085b087b093a0e74696d657374616d706c2b079f36126a3a106475726174696f6e5f6d73660c313632342e32373a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b073f3b126a3b06660c313433392e39333b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b076a3b126a3b066609372e36313b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-23 23:22:07.606379	8381921440239734887	398
478	\\x70726f64756374696f6e3a64617368626f6172645f646174615f305f323032362d30312d30315f323032362d31322d33315f7635	\\x001181decf8d9f6085da41ffffffff789c8d556d6f1b45108e0ab26b27ad1dc749831ab55551d4a28ac8719c17cf49704e42444a4adbbc08843f9cd67773f692bd5bb3bbe760fa1be027f203f8cc0f60f6eeecc4a1d0ca1f7c3b3bf7cccc33cfcc7d7af7dd33a81b6998f0fc441b19a1d27c1596996ff808676c2b991b8b7a4c6b16483296a09a1905b240f31ad47d198f50190c72d37d581c201366e0f932890daf4345f010f35301aa913452e5c739a84a33c0ebe3721e320cb9e0cca0e66578c0e37f2537078f6d382f8baeb98cbd212a1f63c3fa189677da1bcd2d58cac08652709f13d44358cb2d0a239e44f4b610e853eee1fdadf6ce76736b63676f52b5a67b1eeb44d1ed7c73a3d1c65da80d310e78dccf4b2d417d6218b2b14c8c4ea0b2cffb87e8f38889e5cd3d686cecb61aedf66e6b731bb76171c87830f575566aa9c7de566b6f7b1b5b50cbb39bde67087bcd566bafd94e11ea130abcbe9257664044d4d2fac6d786a5497953cbf294cf6bdbca755baf8dd594d4e9b17e835e456f87254b2cc18dfa5e1e75c44482fccee0081e4532360331f614fa8952961585238cedf5df23582433b527a34ec29313fa07e8a48d3d455faac03b45c10cc55a81793792010abf947acdbb86f5044aa876140a80737b2a41d98d5984c74fcb2964010adf9c93eba5a0aa5c52a16bc643920cd3069584a737231104dd1da45700afd8b0e07c91bd62913d4654e9062cb86971fa5d09e6355aa174cb50e4012ca42cd143c92600355bae2d4d5bf141c557c8ec3c3003e52b123725fe7c36faa450801fecfd816089461a0d973a1770dfeabe5b90f05956eef7448506d84773851817a96e81a1398327d975c718c57b89b13ed3e722dc537910b7e26c1e3fbd9155c1797e444429de1f1809cb33413a715080fbae3fe022a09aba45092ffe2bf7b709aaf134e282f3cc5d85b58c33af87a154e84d5b7001a5430adf9de773fc13f5fb3afdd12f5c6836dbedcd9d4daac9ba5ec0cbd96053f457680632a004cf79843fc9180fa6cabc6da39e76a9639e376a7a5e77ae3b27a1338b4a7e317593deed046c48fe84fb466ad35778f6f604e0f5f161064a0d8d8625a8d8bef8dc06e3f3c49cf699c0063d081e71d320be0c39ff46193460d595442c6d2c5a6293e4ad6b4a8bbb0635d74be21e6dbbc04acdfa6784115d5ec0487f4c939b74be4af974bebe70dc8cb43fffc849731f391df7b173dc705ebaebce770de7c45d87321546759368d666fa7988dacf56548138c65f87eacc69171d78bf28ca6941bc42d21792051834e0c1b526bd5e42aab0c3f4f92c9f6f261efb9943d159a701bf3570b65cea22b345de4dc7adea324ad54b67ceadd0516128b2be584e072c0e04f5a65bee16fdbb67485addfcffb8a417a5d8f8dbecc58273eabea057cba9513a3f4e0c0fdf2f6809ad0fc14f5cf3087316fd94c57dfc88d452bf5ba955f799e6feebdecf54b584dd0f41dcf0be09443da25d897ddb2223bd74731ec1921b2686be5eb484752248a5f7885f8bacad1c991ec7fe915da1a4da2342d0039988c043da60cab3cd6fd0a5ed8fdd8384aa7f11d662d8255a2819861a0d41555d9ff903f42e714ca77a7eca47d35a7c19455ca7272fa01128c1e2e4232c436ec27b5f6e6fedb4361abbb042df281a46bb4695b1c360e7a59e1b49c499691daab9698c4cf13b7f15ff0126a6060f	2026-05-26 11:17:38.221499	-8050382658065991170	1415
556	\\x70726f64756374696f6e3a64617368626f6172645f646174615f34643433306132655f323032362d30312d30315f323032362d31322d33315f7635	\\x0011812759ad105086da41ffffffff789c8d55e16e1b45108e0ab26b3b899dd4710b444d5514a5a852643b8953cf49704e42444a4adb241508ff38adefe6eca57bb766772fc1f4198037e401780a66efce4e1c0a45fee1dbd9b96f66bef966eee3bbefb6a06ea461c2f3136d64844af307b0c67cc32f71ced6c8dc5834605ab34092b104b5cc2890059a37a0eecbf81295c12037d56065844c9891e7cb2436bc0e55c143cc4f45a845d248951f0b50936684d3e302ace521c3900bce0c6a5e86fb3cfe47720bb061c3795974cd65ec8d51f9181b36c4b0dcd9ddde6fc1bd0c6c2c05f739416dc07a6e5118f124a2b785409f720f9777bb3bed5667bbd39956ade99ec73a51745bd9d96e76711f56c718073c1ee6a556a03e358cd944264627503de0c323f479c444a3f50c9adbadf66e67affb6ca7d3c20eac8c190f66ce4e632d7569ef35bbedce4e6b0ff76035cf70e692a3ec76f7f70869bf4328f5290fde50c92b33223656d32227d7867bd31a6796b519a9d7b6c6756faf8db594d9d9b17e8363456f8725cb2ec15d0ebd3cea251309f23b9f3e8787918ccd484c3c857ea294a546e125c6f67aeb0f582133f528e34fc2a353fa07e8a5dd3d435faac03b43c10cc56a40c58d6480c22fa55e15d7b0814009b59e420170614f2528bb318bf0e47139852c40e1eb0b727d2ba82a7719565c3319936e9836a8243cbe198920e8ee30bd0278c1c605e78bec158bec31a24a3761d14d8bd3ef4a50d168d5d22f439107b098b2440f259b00acda726d69da2a10aabe4266878219285f91c229f127f3d1a785027c6fef0f054b34d240b8d4b980fb56fcfd82844fb272bf232a34c0019a2bc4b848750b0ccd393ccaae7bc6283e488cf5993d176149e541dcaad33a797c23ab82f3e49888527c383212d6e682f4e2a000cbae3fe222a09afa45094fff2df7d709aac92ce2a2b3e53e80f58c336f80a154e8cd5af0064a4714be5fe10bfc23f5db26fdd12f5c6cb7bbdd56a7453559d737f07c3ed80cfd059a910c28c10b1ee18f32c6c399326fdba8a77dea98e75db63dafbfd05f90d09b4725bf98ba49eff60236267fc27d25b5192a3c7f7d0af0f2e42803a58646e312546d5f7c6e83d1e0575ced33814d7a103ce2a6497c1972fe953268c2035712b1b4b668934d93b7ae292dee3aacba5e120f68e505566ad63f238ce8f20246fa639adca4f365caa7f3d51bc7cd48fbf3f79c34f7a1d373379c93a6f3dcdd74be6d3aa7ee2694a930aa9b44b33ed7cf23d47eb6a70ac431fe3256e74eb7e8c0fb45514e0be25592be902cc0a009f7af35e90d1252851da6cfe7f97c35f538c81c8ace260df8ad81b3e55217992df26e3a6e359751aa5e3a736e958e0a4391f5c5723a627120a837fd72bfe8df3d47d26aebbfe3925e9462936fb2170bce99fb945e2da746e9fc30357cf67e414bd8fd10fcd4358fb060d1cf583cc4ff915aea772bb5da01d3dc7f39f889aa96b0ff21881bde3781a847b42b71685b64a4976ece63b8e78689a14f182d619d0852e912f16b91b59523d393d83fb62b94547b4c087a24131178481b4c79b6f94dbab4fdb17b9050f5cfc25a0c7b8b164a86a146435035d767fe08bdb738a1533d3fe5a3692dbe8c22aed39317d008946065fa25962137e152abdddc696defed4383be51348c768d2a6387c1ce4b3d37928833d326d472d30499e277fe2afe0d372e061a	2026-05-29 07:24:06.771704	-24054342219910978	1426
537	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3239	\\x00118166486dbec586da41ffffffff789c8dd3bd4ac35014077007691b538a9b3a29e2a470ccb91fb9b9c9e0e4a0082ec5c5218434a591d66a9a16a183938f20f826aee213f8000a82bba3838bc6e4a69b70b6c0cdef9ec3b9ffb3dc3adf9c5b7e274f47c9248f4657c3bde6e9d7fa85bfda9b66519e8e2fc3d1a4df46a51150fa9d388a07493848f36ef1479447e1643ccde2e4687ba33ce985fd74982759f1f177daf01b87ddb9152c15b7de15b7068dbecdb406ce82663768fda702ab46673f256aa3640e20559dec6e948aa187e07944f550294b83e444f201a690e30a702551bd61a5504b0da8898a0ba3846020a9a3583b30ca631e6897a89e87f5001d0714b5c3efebba43c6810ba2bacf4a654ba64121116d4debc12b018a3a8cfd4ad90239bdd47b85562457402df4690c3a20a975d8ac8a9f0b4a11c9f1ac4e2c79a1e29979239402047535725348824b254f0b22a9f9799d9924b81a1875062f37755499024eed6ee7d6285e4481531777f0b8580b0e8caad24ad9a8196116bfc50890ea	2026-05-29 02:13:35.179081	-8016969246444872464	566
560	\\x70726f64756374696f6e3a64617368626f6172645f646174615f39636635656361345f323032362d30312d30315f323032362d31322d33315f7635	\\x001181306e797b5b86da41ffffffff789c8d55ff6e1b45108e0ab26b3b899dc4710b446d5514b5a852643b8e8de72438272122a5a56dd20a84ff38adefe6eca57bb766772fc1f4198037e401780a66efce4e5c0aadfc876f67bf9b1fdf7c33f7f1cd370fa06ea461c2f3136d64844af3dbb0cd7cc32f70c9d6c8602c1a31ad5920c958825a6614c802cd1b50f7657c81ca60909b6ab0314126ccc4f365121b5e87aae021e6a722d42269a4ca8f05a84933c1f97105b6f39061c8056706352fc32d1eff2bb915b86bc3795974cd65ec4d51f9181b36c6b0dcedecf55ab095399b4ac17d4eaeeec24e6e5118f124a2b785409f720fd73bfdfd76abbbd7edceabd674cf639d28baadecef35fbd883cd29c6018fc779a915a8cf0d53369389d109540ff9f8187d1e31b1ddfa129a7bfd8376afdf6b765b78001b53c68305d6696488834ea7d7ee755b0784d8cc135c401a29a4d5e9f70eda9d6eaf8b5da23ca7c11b2b79692644c6665ae3eccab0352f7161d95e707a656b5cb5f6ca584b895d1cebd72856f47658b2e492bb8bb19747bd6022417ee3d3c7702792b1998899a7d04f94b2cc28bcc0d85e3ff81336c84c2dcae89370ef09fd030cd2e69ea12f55e09da160866235a0e2463240e1975254c5356c2450426da05000bcb4a71294dd9845787abf9cba2c40e19b97047d2da82a771d365c339b926c9836a824dcbf1e895cd0dd517a05f0944d0bce17d92bd6b3c7882add8455372d4ebf294145a315cbb00c451ec06aca123d946c02b069cbb5a5692b40a8fa0a999d0966a07c4902a7c41f2e479f170af083bd3f122cd148f3e052e702ee5bed0f0b123ec9cafd9ea8d00087682e11e322d52d3034e7702fbb1e18a3f8283116b3782ec29aca83b855a7757aff5a5605e7e10911a5f87862246c2f0519c44101d65d7fc24540350d8b121efd57ee2f1254b345c455e7817b1b7632cebc118652a1b768c12b281d53f86185aff08fd4efbbf447bf70b5ddeef75bdd16d564a1afe0f172b085f7a7682632a0045ff2087f92311e2d94f9b68d7a3aa48e79de45dbf3862bc315098365af848ba99bf4ee206053c293dfe7529bb1c2f3174f009e9d1e674ea9a1d1b40455db179fdb6034f71557fb4c60931e048fb869125f86c0bf51064db8ed4a2296b6162db279f2169ad2e2eec0a6eb25f188365e60a566f1196144971730d21fd30493ce57299fced7af1c3723edaf3f72d2dc3bcec0bdeb9c369dc7eeaef35dd379e2ee42990aa3ba49343b4bfd3c46ed676baa401ce3af5375eef48b0ebc5b14e5b4205e25e90bc9020c9a70eb4a93de282155d861fa7c99cfe773c46106283abb34e06f0d9c2d97bac86c9137d371abb98c52f5d29973ab7454188aac2f96d3098b0341bd19968745ffe63992565bff1f97f4a2149b7d9bbd5870cedc47f46a39354ae7c7b9e1b3770b5a42e77deee7d03cc28af57ec6e2317e406a29eeadd46a874c73ffd9e867aa5a42ef7d2eaea1af3ba21ed1aec4b16d91915eba394f60cb0d13435f305ac23a11a4d235e2d77ad6568e4ccf62ffc4ae5052ed0979d0139988c043da60cab3cd6fd2a5ed8fdd83e455ff22acc5b0d7685dc930d468c855cdf5993f41ef35cee854cf4ff9685a8b2fa388ebf4e405340225d8987f8865c84db8d66a37f75b7b073d68d0378a86d1ae5165ec30d879a9e746127166da855a6e9a2153fcc6dfc57f0082c005f1	2026-05-29 10:38:57.979667	4476806376399974554	1427
\.


--
-- Data for Name: solid_queue_blocked_executions; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.solid_queue_blocked_executions (id, job_id, queue_name, priority, concurrency_key, expires_at, created_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_claimed_executions; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.solid_queue_claimed_executions (id, job_id, process_id, created_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_failed_executions; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.solid_queue_failed_executions (id, job_id, error, created_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_jobs; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.solid_queue_jobs (id, queue_name, class_name, arguments, priority, active_job_id, scheduled_at, finished_at, concurrency_key, created_at, updated_at) FROM stdin;
1	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"b9ed872f-7ad7-40fe-bce3-8f8bfdc126ef","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://drwise-admin/ActiveStorage::Blob/3"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-05-15T05:10:37.426099662Z","scheduled_at":"2026-05-15T05:10:37.425729011Z"}	0	b9ed872f-7ad7-40fe-bce3-8f8bfdc126ef	2026-05-15 05:10:37.425729	\N	\N	2026-05-15 05:10:38.110961	2026-05-15 05:10:38.110961
2	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"aaa7ed28-356a-4bdc-9a12-f9c10a06bcee","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://drwise-admin/ActiveStorage::Blob/4"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-05-15T09:36:59.475652021Z","scheduled_at":"2026-05-15T09:36:59.475207774Z"}	0	aaa7ed28-356a-4bdc-9a12-f9c10a06bcee	2026-05-15 09:36:59.475207	\N	\N	2026-05-15 09:36:59.690551	2026-05-15 09:36:59.690551
3	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"97fcf0de-b5e6-4cb0-9bea-108b826bcd23","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://drwise-admin/ActiveStorage::Blob/5"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-05-15T09:38:00.212020186Z","scheduled_at":"2026-05-15T09:38:00.211638390Z"}	0	97fcf0de-b5e6-4cb0-9bea-108b826bcd23	2026-05-15 09:38:00.211638	\N	\N	2026-05-15 09:38:00.478674	2026-05-15 09:38:00.478674
4	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"690e5e97-d395-4333-b668-00ec5b96b547","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://drwise-admin/ActiveStorage::Blob/6"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-05-26T00:06:23.049630527Z","scheduled_at":"2026-05-26T00:06:23.049276767Z"}	0	690e5e97-d395-4333-b668-00ec5b96b547	2026-05-26 00:06:23.049276	\N	\N	2026-05-26 00:06:23.38099	2026-05-26 00:06:23.38099
5	default	ActiveStorage::PurgeJob	{"job_class":"ActiveStorage::PurgeJob","job_id":"ea9bcd8d-f3b2-4363-abb6-52e343ea8b34","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://drwise-admin/ActiveStorage::Blob/6"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-05-26T00:06:54.676843405Z","scheduled_at":"2026-05-26T00:06:54.676551337Z"}	0	ea9bcd8d-f3b2-4363-abb6-52e343ea8b34	2026-05-26 00:06:54.676551	\N	\N	2026-05-26 00:06:55.317125	2026-05-26 00:06:55.317125
\.


--
-- Data for Name: solid_queue_pauses; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.solid_queue_pauses (id, queue_name, created_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_processes; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.solid_queue_processes (id, kind, last_heartbeat_at, supervisor_id, pid, hostname, metadata, created_at, name) FROM stdin;
\.


--
-- Data for Name: solid_queue_ready_executions; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.solid_queue_ready_executions (id, job_id, queue_name, priority, created_at) FROM stdin;
1	1	default	0	2026-05-15 05:10:38.203094
2	2	default	0	2026-05-15 09:36:59.782912
3	3	default	0	2026-05-15 09:38:00.516163
4	4	default	0	2026-05-26 00:06:23.430402
5	5	default	0	2026-05-26 00:06:55.574805
\.


--
-- Data for Name: solid_queue_recurring_executions; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.solid_queue_recurring_executions (id, job_id, task_key, run_at, created_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_recurring_tasks; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.solid_queue_recurring_tasks (id, key, schedule, command, class_name, arguments, queue_name, priority, static, description, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_scheduled_executions; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.solid_queue_scheduled_executions (id, job_id, queue_name, priority, scheduled_at, created_at) FROM stdin;
\.


--
-- Data for Name: solid_queue_semaphores; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.solid_queue_semaphores (id, key, value, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sub_agent_documents; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.sub_agent_documents (id, sub_agent_id, document_type, created_at, updated_at, r2_file_key, r2_filename, r2_content_type, r2_file_size) FROM stdin;
1	5	Profile Image	2026-05-15 09:37:59.304598	2026-05-15 09:37:59.328534	sub_agent_documents/5/20260515_093758_92493003e8ec1372_logo (1).jpeg	logo (1).jpeg	image/jpeg	93663
\.


--
-- Data for Name: sub_agents; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.sub_agents (id, first_name, middle_name, last_name, mobile, email, role_id, state_id, city_id, birth_date, gender, pan_no, gst_no, company_name, address, bank_name, account_no, ifsc_code, account_holder_name, account_type, upi_id, status, created_at, updated_at, password_digest, distributor_id, plain_password, original_password, password_reset_at, deactivated, city, state) FROM stdin;
2	Samparka		Association	8296348359	samparka.blr@gmail.com	2	439	20134	\N												0	2026-05-11 11:21:29.600006	2026-05-11 11:21:55.056451	$2a$12$DY/C4KOvrjVHfE7TCF7YXuKdJ4AYzG0I3vV9GKykh7ADNhSZ76ECG	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
3	LOKESH		SHIVANNA	9902069391	sirifincorp@gmail.com	2	504	6379	1973-06-27	Male	AVMPS7760C		SPOORTHY VENTURES		STATE BANK OF INDIA	64079368397	SBIN0070242	LOKESH S	Savings		0	2026-05-13 03:19:42.414149	2026-05-13 03:20:56.662408	$2a$12$A2iqu48GvdKHRGoHunsqCeayQF6mSjkogY0TmwfEEGuHbKmr6y4IO	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
4	SUDARSHAN	R	RAO	9880708186	sudarshanrrao@gmail.com	2	504	6379	1977-09-15	Male					HDFC BANK	50100173705850	HDFC0000286	SUDARSHAN RAO	Savings		0	2026-05-13 03:47:12.324472	2026-05-13 03:47:37.276947	$2a$12$owu8jRqXRGZQ0fxBoFvQ0.O0SUU5MmEN72EXP3CRBwTb1hcN3bfaC	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
1	DEVARAJ		J	6361760165	bittideva@gmail.com	2	439	20134	1976-03-04	Male	AERPJ8932K		KRAMA								0	2026-05-11 11:05:19.546733	2026-05-15 07:13:48.144086	$2a$12$6cSESFYyI.myac1rTFpOIOpBLcYN8vxGKA2YE7f5C8W.6xTdwBWZi	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
5	Test PRamod		Bhat	9191909393	90939dd39393fdfds@gmail.com	2	930	4416	\N	Male				dfd							0	2026-05-15 09:37:34.361553	2026-05-15 09:44:27.329231	$2a$12$nsVnd70hRrhiTXFISZ8S0uzWmPQr9hDoHLRtKxMWimhX0eN1yfqPi	\N	\N	admin@123	\N	f	Bangalore	karnataka
7	RAVIKUMAR		J	9008829849	ravikumarjblr@gmail.com	2	665	10248	1977-03-14	Male	AJQPR6146M		NANDUS SOLUTIONS		Union Bank of India	520101001517933	UBIN0907464		Savings	RAVIKUMAR J	0	2026-05-19 03:30:30.904353	2026-05-19 03:30:30.904353	$2a$12$NlodDhcPGPJJxmOH5D3NaOvI/yRSlC2j4q1JKp0zdOyItn5L0wjIu	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
6	Murali Krishna		Kasibhatta	8686961074	masterlee311@gmail.com	2	665	10248	1971-12-11	Male	AOGPK1840J										0	2026-05-18 02:23:51.962112	2026-05-23 23:44:51.707073	$2a$12$9AuOVdySCiXcnd0uSUacnuzAMINxPGL8bA4P/XqxTwwOSSK7B7Apu	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
8	SOWMYA		H T	9620455292	vijendramarvin220@gmail.com	2	724	67499	1990-04-29	Female					CANARA BANK	000005994		SOWMYA H T	Savings		0	2026-05-26 00:05:41.930884	2026-05-26 00:05:41.930884	$2a$12$9oV4HkwJB9ScsqjMUwO.L.l8k7ZTvQ/.eCem1bjjvVm1S4co5ZqmO	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
\.


--
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.system_settings (id, key, value, description, setting_type, created_at, updated_at, default_main_agent_commission, default_affiliate_commission, default_ambassador_commission, default_company_expenses, terms_and_conditions, investment_amount, company_name, company_phone, company_email, company_address) FROM stdin;
2	company_website	www.dr-wise.in	Company website URL	string	2026-05-21 10:36:13.104838	2026-05-21 10:36:13.104838	\N	\N	\N	\N	\N	0.00	\N	\N	\N	\N
3	support_hours	Monday to Saturday: 10:00 AM - 6:00 PM	Customer support hours	string	2026-05-21 10:36:13.12485	2026-05-24 12:01:44.148237	\N	\N	\N	\N	\N	0.00	\N	\N	\N	\N
1	system_config	system configuration	System configuration settings	configuration	2026-05-20 02:26:20.769897	2026-05-25 23:59:07.191563	\N	\N	\N	\N	\N	0.00	Dr WISE Consulting Services LLP	+918431174477	info@dr-wise.in	402-B-1, Basement Floor, 'Sundara Arcade', ITI HBCS Layout, Mysore Road, Bengaluru-  560 039
\.


--
-- Data for Name: tax_services; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.tax_services (id, customer_id, service_type, financial_year, filing_date, amount, status, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: travel_packages; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.travel_packages (id, customer_id, travel_type, destination, travel_date, return_date, package_amount, status, notes, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.user_roles (id, name, description, status, display_order, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.user_sessions (id, user_id, session_id, ip_address, user_agent, started_at, ended_at, duration, status, location, device_type, browser, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: drwisedb01_user
--

COPY public.users (id, first_name, last_name, email, mobile, pan_number, gst_number, date_of_birth, gender, height, weight, education, marital_status, occupation, job_name, type_of_duty, annual_income, birth_place, address, state, city, user_type, role, status, additional_info, created_at, updated_at, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, role_id, user_role_id, plain_password, original_password, sidebar_permissions, role_name, password_reset_at, crud_permissions) FROM stdin;
2	Admin	User	admin@drwise.com	9999999999	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	admin	\N	t	\N	2026-05-11 07:37:18.6308	2026-05-11 07:37:18.6308	$2a$12$g16KQMmL1EBvGII2fTLefeQfI1ADAIQ6N8TjyuEV9UyZ103QxYKaW	\N	\N	\N	1	\N	\N	\N	\N	super_admin	\N	\N
3	Krama	Consulting	krama.consulting@gmail.com	8431174477	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	ambassador	\N	t	\N	2026-05-11 10:56:29.909145	2026-05-11 10:56:29.909145	$2a$12$3nPR6OOTEI39e6Fyc0MBKe4sMODBHaH6jfdTBil.QcSGyzFbfa3bq	\N	\N	\N	\N	\N	\N	Ganesha@123	\N	\N	\N	\N
4	DEVARAJ	J	bittideva@gmail.com	+918792051175	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sub_agent	\N	t	\N	2026-05-11 11:05:19.774874	2026-05-11 11:05:19.774874	$2a$12$mtrz9vLoiPN.YLV962yTKO9FnGXqDsQ99rit2nFHuqF5EnUZ2rMmq	\N	\N	\N	2	\N	\N	\N	\N	\N	\N	\N
5	CM	LINGARAJU	nandininaga22@gmail.com	9008666938	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-11 11:09:22.366055	2026-05-11 11:09:22.366055	$2a$12$QF5i1XEnrtb1XNaEgiquw.7l2SYV8iIIiM/vJyKgGE6iom9aR5vJe	\N	\N	\N	\N	\N	\N	CMXX@1985	\N	\N	\N	\N
6	Samparka	Association	samparka.blr@gmail.com	+918296348359	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sub_agent	\N	t	\N	2026-05-11 11:21:29.821466	2026-05-11 11:21:29.821466	$2a$12$VY4mgewqwo74xd6iDHRON..uvqyLUq6SeH8kzriTesO6yJ6XQVewi	\N	\N	\N	2	\N	\N	\N	\N	\N	\N	\N
7	YOGESHWARAPPA	K	yogi.slvglass4@gmail.com	9980990027	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-11 11:25:03.819656	2026-05-11 11:25:03.819656	$2a$12$cS4rTngJ/.TQAuD/t6pGlOOjdNWZ0yIq8SvbdZgCtP3pwBdJhUyt.	\N	\N	\N	\N	\N	\N	YOGE@1980	\N	\N	\N	\N
8	BASAVARAJ	CHANDRASHEKAR	basu2736@gmail.com	9720008888	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-11 12:56:05.383943	2026-05-11 12:56:05.383943	$2a$12$graN.v2HbzJOnYRH6zcTheppYkB4ygpHxzJLeLHM96qTi/vWX/Tqy	\N	\N	\N	\N	\N	\N	BASA@1992	\N	\N	\N	\N
9	G RAVI	KIRAN	grk_sva@ymail.com	9880039901	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-12 04:44:14.11607	2026-05-12 04:44:14.11607	$2a$12$uq.DPeBGPj2I5gteFiXaAOfry3vnlGcahSPXRTvLMU5.uzkYstN3W	\N	\N	\N	\N	\N	\N	G RA@1975	\N	\N	\N	\N
10	N	GOPAL	ngopalg77@gmail.com	9845798137	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-13 01:57:37.174768	2026-05-13 01:57:37.174768	$2a$12$An/AA9HhH87w8UGPPfCRhuwvArh/dCBz5TUFOKerTCXDwBliUJL0e	\N	\N	\N	\N	\N	\N	NXXX@1977	\N	\N	\N	\N
11	SHOBHA	LOKESH	shobhalokesh982@gmail.com	9743003428	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	ambassador	\N	t	\N	2026-05-13 03:16:29.479996	2026-05-13 03:16:29.479996	$2a$12$N6/1u4vLYsVZaaT9pZMxPuHzSeecQWaAeOFGGBtIh8u3jSy377dJO	\N	\N	\N	\N	\N	\N	Ganesha@123	\N	\N	\N	\N
12	LOKESH	SHIVANNA	sirifincorp@gmail.com	+919902069391	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sub_agent	\N	t	\N	2026-05-13 03:19:42.644473	2026-05-13 03:19:42.644473	$2a$12$9Up13Cb/x9.JGFRwurlbvuplNo.8w/yVVbFY3BglqwHZQxUifzxDC	\N	\N	\N	2	\N	\N	\N	\N	\N	\N	\N
13	DR KRISHNA	NAGARAJ	krishnainduvalu@yahoo.co.in	9980639161	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-13 03:23:58.224999	2026-05-13 03:23:58.224999	$2a$12$PaOCMs7hkE9tm8zPYr/N0uF7bIa3WReQY/3dpO/bch6vBIVv03lVG	\N	\N	\N	\N	\N	\N	DR K@1979	\N	\N	\N	\N
14	PRAMOD	SHIVAKUMAR	pramodshivkumar79@gmail.com	9945780099	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-13 03:27:06.791285	2026-05-13 03:27:06.791285	$2a$12$E2bWuLffUbEg1JCnQNuzt.QGdg.D93RO7tV1GpogJ7jNDVtc1V46u	\N	\N	\N	\N	\N	\N	PRAM@1979	\N	\N	\N	\N
15	GURDEEP	MANN	gurdeep.mannn@gmail.com	9980698450	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-13 03:33:28.533638	2026-05-13 03:33:28.533638	$2a$12$2075OWuelZ92NZaJKDFfUe2t0TqT4LHY7YMtextRRqRg6iBSluw..	\N	\N	\N	\N	\N	\N	GURD@1986	\N	\N	\N	\N
16	SUDARSHAN	RAO	sudarshanrrao@gmail.com	+919880708186	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sub_agent	\N	t	\N	2026-05-13 03:47:12.556912	2026-05-13 03:47:12.556912	$2a$12$cAMSxaMMIp7ud.52gKyqPOnCQj/shJETRpbWvOoZQ9D1M2Uwok7xC	\N	\N	\N	2	\N	\N	\N	\N	\N	\N	\N
17	Test ambasidor	ambasidor	909fdd3939393fdfds@gmail.com	9898919191	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	ambassador	\N	t	\N	2026-05-15 09:37:00.028173	2026-05-15 09:37:00.028173	$2a$12$IqTn7IHKc/dI4Hp36y/EkOhP8shUktCmu51dLXkJ3YI25sbjGF2c2	\N	\N	\N	\N	\N	\N	Ganesha@123	\N	\N	\N	\N
18	Test PRamod	Bhat	90939dd39393fdfds@gmail.com	+919191909393	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sub_agent	\N	t	\N	2026-05-15 09:37:34.590899	2026-05-15 09:37:34.590899	$2a$12$iDD8esi/FZ6uCSs4UDVZFO117WaY6ZfywWvbBtdQeGgArZLGHRdSy	\N	\N	\N	2	\N	\N	\N	\N	\N	\N	\N
19	ddf	df	9093939393fdfds@gmail.com	8989191919	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-15 09:46:41.28768	2026-05-15 09:46:41.28768	$2a$12$AjxlJZmUF75GiQbWg2P0U.KYM.rb3yD.8EvtmrvxntULExo8k9R5e	\N	\N	\N	\N	\N	\N	DDFX@2026	\N	\N	\N	\N
20	Dhjd	Dh d	dhdj@gmail.com	9632850872	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-15 14:14:52.703323	2026-05-15 14:14:52.703323	$2a$12$FwZgXlb.Fp6ZnlhyroN0cuEnVCC7JcGI/PdsqyIygjVb7NWtIuc0O	\N	\N	\N	2	\N	\N	\N	\N	customer	\N	\N
21	Eswaraiah	Sudha	sudha.e68@gmail.com	9686405652	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-16 10:56:47.144528	2026-05-16 10:56:47.144528	$2a$12$aToRVlA6Qudmd.ziqCT8hucileCuV3BsPCtd8zRMzI74Own5RIZ0W	\N	\N	\N	\N	\N	\N	ESWA@1967	\N	\N	\N	\N
22	Tarini	Eshwaraiah	tarinie04@gmail.com	9361682021	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-17 12:15:09.136579	2026-05-17 12:15:09.136579	$2a$12$O4BWlBkYigG1znUoUSUP6O07xCszQxP1QG4q.Zwr/RVJmjoKU57ce	\N	\N	\N	2	\N	\N	\N	\N	customer	\N	\N
23	Hrhr	Hdud	hdh@gmail.com	6363185653	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-17 13:25:29.043112	2026-05-17 13:25:29.043112	$2a$12$cAfNzk07r3GO31Ja.a2LSuEL30k2pM.Lft5sBN4cLtFNC7hTW5ysy	\N	\N	\N	2	\N	\N	\N	\N	customer	\N	\N
24	pramod	bhat	9dfd093939393fdfds@gmail.com	6363727272	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-17 13:56:39.950424	2026-05-17 13:56:39.950424	$2a$12$tOfhatCNobEiBSrhy1vbdeftFKWAXs7NZPBBipGXmv/XNdV1qu2x2	\N	\N	\N	\N	\N	\N	PRAM@2026	\N	\N	\N	\N
25	Murali	Kasibhatta	masterlee311@gmail.com	8686961074	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sub_agent	\N	t	\N	2026-05-18 02:23:52.193154	2026-05-18 02:23:52.193154	$2a$12$rfiMauGefStckYLSum09CeB4iCkMr6jtrrjskmzzD2Ng3j4zdFhsO	\N	\N	\N	2	\N	\N	\N	\N	\N	\N	\N
26	Mani	D	manikantaishan@gmail.com	9742059226	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-18 02:50:33.098445	2026-05-18 02:50:33.098445	$2a$12$xMdgeSYycYaFs6zE7/cQlOKTiCBv3G0CMEmRKLweo1fE8FdoCPShy	\N	\N	\N	2	\N	\N	\N	\N	customer	\N	\N
27	Adithyaa	Kasibhatta	adithyaatanmayk@gmail.com	6361404087	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-19 03:10:59.861186	2026-05-19 03:10:59.861186	$2a$12$3P0XM4ZvfrsYkxBTpc5sMuvOo2DeqNOAXJpW5pH334JcotzLLVTLO	\N	\N	\N	\N	\N	\N	ADIT@2007	\N	\N	\N	\N
28	GAJENDRACHARI	A	gajendrachari@gmail.com	9845731819	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-19 03:17:12.257671	2026-05-19 03:17:12.257671	$2a$12$YCzupHejSKTlPGnEBlD.uehjwgNxNS1if09FffPWddZuYJaYKIGJ2	\N	\N	\N	\N	\N	\N	GAJE@1976	\N	\N	\N	\N
29	RAVIKUMAR	J	ravikumarjblr@gmail.com	9008829849	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sub_agent	\N	t	\N	2026-05-19 03:30:31.151087	2026-05-19 03:30:31.151087	$2a$12$8JKLzhTgUfnwEZxjgVpHYOwGa1HxZscEEA.lX77SQ4nJoCsgWue9O	\N	\N	\N	2	\N	\N	\N	\N	\N	\N	\N
30	Yogesha	MS	pragathigroup2018@gmail.com	9449202517	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-19 03:38:05.306909	2026-05-19 03:38:05.306909	$2a$12$J/tpBt/hrd0qSwjTuVSPGuM.yxNkC1PWjbT2Be0MRgOkaQZruCKxK	\N	\N	\N	\N	\N	\N	YOGE@1986	\N	\N	\N	\N
31	K Krishna	Prasad	prasadsharma5577@gmail.com	8660725693	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-20 14:01:29.744452	2026-05-20 14:01:29.744452	$2a$12$..H2vjR5PT.K/XHuuW.wuO1KoPjJfu4FlvX.p9KSTDyWeB3IPq8DW	\N	\N	\N	\N	\N	\N	K KR@2002	\N	\N	\N	\N
32	N C	NIRANJAN	niranjandev141@gmail.com	9945666226	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-25 11:38:26.39499	2026-05-25 11:38:26.39499	$2a$12$8PA.kSu3C7oFzS4zlcC41uZosU.aVxNTdG757upCK6j3iSCDimNIG	\N	\N	\N	\N	\N	\N	N CX@1995	\N	\N	\N	\N
33	N HARISH	KUMAR	sribalajicommunications15@gmail.com	9845393458	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-25 12:01:16.84688	2026-05-25 12:01:16.84688	$2a$12$2HsBMvtRKx3CP3jGr4Di7OWIbZQUf5SHTmFtPt0avj0bQ3Me41a.y	\N	\N	\N	\N	\N	\N	N HA@1972	\N	\N	\N	\N
34	M P	VIJENDRA	vijendramarvin220@gmail.com	9845957220	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	ambassador	\N	t	\N	2026-05-25 23:55:58.002387	2026-05-25 23:55:58.002387	$2a$12$i9S/yiijLkyKeY9YFzEMg.kxleYgJ3y2jPYhNYTLF1ecpJzXwOXd6	\N	\N	\N	\N	\N	\N	Ganesha@123	\N	\N	\N	\N
35	HANUMANTHA	M	pradeepdjpradeep16455@gmail.com	9538247661	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-05-26 00:14:48.032474	2026-05-26 00:14:48.032474	$2a$12$A4LjpOS3cKSENfb.leRBueu./bh5mqpGzaHEqsbuJqoJ3lBYTi3HK	\N	\N	\N	\N	\N	\N	HANU@1985	\N	\N	\N	\N
\.


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 6, true);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 6, true);


--
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 1, false);


--
-- Name: agency_brokers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.agency_brokers_id_seq', 1, false);


--
-- Name: agency_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.agency_codes_id_seq', 4, true);


--
-- Name: ahoy_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.ahoy_events_id_seq', 1, false);


--
-- Name: ahoy_visits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.ahoy_visits_id_seq', 1, false);


--
-- Name: ai_report_histories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.ai_report_histories_id_seq', 1, false);


--
-- Name: all_policy_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.all_policy_reports_id_seq', 1, false);


--
-- Name: analytics_caches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.analytics_caches_id_seq', 21, true);


--
-- Name: appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.appointments_id_seq', 4, true);


--
-- Name: banner_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.banner_documents_id_seq', 1, false);


--
-- Name: banners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.banners_id_seq', 4, true);


--
-- Name: broker_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.broker_codes_id_seq', 5, true);


--
-- Name: brokers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.brokers_id_seq', 4, true);


--
-- Name: client_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.client_requests_id_seq', 5, true);


--
-- Name: commission_payouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.commission_payouts_id_seq', 228, true);


--
-- Name: commission_receipts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.commission_receipts_id_seq', 1, false);


--
-- Name: corporate_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.corporate_members_id_seq', 1, false);


--
-- Name: customer_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.customer_documents_id_seq', 1, true);


--
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.customers_id_seq', 22, true);


--
-- Name: distributor_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.distributor_assignments_id_seq', 10, true);


--
-- Name: distributor_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.distributor_documents_id_seq', 1, false);


--
-- Name: distributor_payouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.distributor_payouts_id_seq', 1, true);


--
-- Name: distributors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.distributors_id_seq', 4, true);


--
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.documents_id_seq', 1, false);


--
-- Name: family_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.family_members_id_seq', 2, true);


--
-- Name: health_insurance_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.health_insurance_documents_id_seq', 8, true);


--
-- Name: health_insurance_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.health_insurance_members_id_seq', 1, false);


--
-- Name: health_insurance_nominees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.health_insurance_nominees_id_seq', 29, true);


--
-- Name: health_insurances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.health_insurances_id_seq', 52, true);


--
-- Name: helpdesk_tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.helpdesk_tickets_id_seq', 1, false);


--
-- Name: insurance_companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.insurance_companies_id_seq', 58, true);


--
-- Name: investments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.investments_id_seq', 1, false);


--
-- Name: investor_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.investor_documents_id_seq', 1, false);


--
-- Name: investors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.investors_id_seq', 13, true);


--
-- Name: invoice_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.invoice_items_id_seq', 1, false);


--
-- Name: invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.invoices_id_seq', 6, true);


--
-- Name: leads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.leads_id_seq', 23, true);


--
-- Name: life_insurance_bank_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.life_insurance_bank_details_id_seq', 1, false);


--
-- Name: life_insurance_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.life_insurance_documents_id_seq', 1, false);


--
-- Name: life_insurance_nominees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.life_insurance_nominees_id_seq', 5, true);


--
-- Name: life_insurances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.life_insurances_id_seq', 9, true);


--
-- Name: loans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.loans_id_seq', 1, false);


--
-- Name: motor_insurance_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.motor_insurance_documents_id_seq', 12, true);


--
-- Name: motor_insurance_nominees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.motor_insurance_nominees_id_seq', 13, true);


--
-- Name: motor_insurances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.motor_insurances_id_seq', 16, true);


--
-- Name: mutual_fund_nominees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.mutual_fund_nominees_id_seq', 1, true);


--
-- Name: mutual_funds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.mutual_funds_id_seq', 2, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.notifications_id_seq', 4, true);


--
-- Name: other_insurance_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.other_insurance_documents_id_seq', 3, true);


--
-- Name: other_insurance_nominees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.other_insurance_nominees_id_seq', 3, true);


--
-- Name: other_insurances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.other_insurances_id_seq', 8, true);


--
-- Name: payout_audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.payout_audit_logs_id_seq', 1, false);


--
-- Name: payout_distributions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.payout_distributions_id_seq', 1, false);


--
-- Name: payouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.payouts_id_seq', 47, true);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.permissions_id_seq', 1, false);


--
-- Name: policies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.policies_id_seq', 1, false);


--
-- Name: policy_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.policy_documents_id_seq', 2, true);


--
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.reports_id_seq', 1, false);


--
-- Name: role_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.role_permissions_id_seq', 1, false);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.roles_id_seq', 2, true);


--
-- Name: session_activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.session_activities_id_seq', 81, true);


--
-- Name: solid_cache_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.solid_cache_entries_id_seq', 597, true);


--
-- Name: solid_queue_blocked_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.solid_queue_blocked_executions_id_seq', 1, false);


--
-- Name: solid_queue_claimed_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.solid_queue_claimed_executions_id_seq', 1, false);


--
-- Name: solid_queue_failed_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.solid_queue_failed_executions_id_seq', 1, false);


--
-- Name: solid_queue_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.solid_queue_jobs_id_seq', 5, true);


--
-- Name: solid_queue_pauses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.solid_queue_pauses_id_seq', 1, false);


--
-- Name: solid_queue_processes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.solid_queue_processes_id_seq', 1, false);


--
-- Name: solid_queue_ready_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.solid_queue_ready_executions_id_seq', 5, true);


--
-- Name: solid_queue_recurring_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.solid_queue_recurring_executions_id_seq', 1, false);


--
-- Name: solid_queue_recurring_tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.solid_queue_recurring_tasks_id_seq', 1, false);


--
-- Name: solid_queue_scheduled_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.solid_queue_scheduled_executions_id_seq', 1, false);


--
-- Name: solid_queue_semaphores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.solid_queue_semaphores_id_seq', 1, false);


--
-- Name: sub_agent_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.sub_agent_documents_id_seq', 2, true);


--
-- Name: sub_agents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.sub_agents_id_seq', 8, true);


--
-- Name: system_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.system_settings_id_seq', 3, true);


--
-- Name: tax_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.tax_services_id_seq', 1, false);


--
-- Name: travel_packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.travel_packages_id_seq', 1, false);


--
-- Name: user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.user_roles_id_seq', 1, false);


--
-- Name: user_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.user_sessions_id_seq', 1, false);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: drwisedb01_user
--

SELECT pg_catalog.setval('public.users_id_seq', 35, true);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- Name: agency_brokers agency_brokers_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.agency_brokers
    ADD CONSTRAINT agency_brokers_pkey PRIMARY KEY (id);


--
-- Name: agency_codes agency_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.agency_codes
    ADD CONSTRAINT agency_codes_pkey PRIMARY KEY (id);


--
-- Name: ahoy_events ahoy_events_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.ahoy_events
    ADD CONSTRAINT ahoy_events_pkey PRIMARY KEY (id);


--
-- Name: ahoy_visits ahoy_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.ahoy_visits
    ADD CONSTRAINT ahoy_visits_pkey PRIMARY KEY (id);


--
-- Name: ai_report_histories ai_report_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.ai_report_histories
    ADD CONSTRAINT ai_report_histories_pkey PRIMARY KEY (id);


--
-- Name: all_policy_reports all_policy_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.all_policy_reports
    ADD CONSTRAINT all_policy_reports_pkey PRIMARY KEY (id);


--
-- Name: analytics_caches analytics_caches_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.analytics_caches
    ADD CONSTRAINT analytics_caches_pkey PRIMARY KEY (id);


--
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: banner_documents banner_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.banner_documents
    ADD CONSTRAINT banner_documents_pkey PRIMARY KEY (id);


--
-- Name: banners banners_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.banners
    ADD CONSTRAINT banners_pkey PRIMARY KEY (id);


--
-- Name: broker_codes broker_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.broker_codes
    ADD CONSTRAINT broker_codes_pkey PRIMARY KEY (id);


--
-- Name: brokers brokers_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.brokers
    ADD CONSTRAINT brokers_pkey PRIMARY KEY (id);


--
-- Name: client_requests client_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.client_requests
    ADD CONSTRAINT client_requests_pkey PRIMARY KEY (id);


--
-- Name: commission_payouts commission_payouts_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.commission_payouts
    ADD CONSTRAINT commission_payouts_pkey PRIMARY KEY (id);


--
-- Name: commission_receipts commission_receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.commission_receipts
    ADD CONSTRAINT commission_receipts_pkey PRIMARY KEY (id);


--
-- Name: corporate_members corporate_members_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.corporate_members
    ADD CONSTRAINT corporate_members_pkey PRIMARY KEY (id);


--
-- Name: customer_documents customer_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.customer_documents
    ADD CONSTRAINT customer_documents_pkey PRIMARY KEY (id);


--
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- Name: distributor_assignments distributor_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.distributor_assignments
    ADD CONSTRAINT distributor_assignments_pkey PRIMARY KEY (id);


--
-- Name: distributor_documents distributor_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.distributor_documents
    ADD CONSTRAINT distributor_documents_pkey PRIMARY KEY (id);


--
-- Name: distributor_payouts distributor_payouts_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.distributor_payouts
    ADD CONSTRAINT distributor_payouts_pkey PRIMARY KEY (id);


--
-- Name: distributors distributors_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.distributors
    ADD CONSTRAINT distributors_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: family_members family_members_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.family_members
    ADD CONSTRAINT family_members_pkey PRIMARY KEY (id);


--
-- Name: health_insurance_documents health_insurance_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurance_documents
    ADD CONSTRAINT health_insurance_documents_pkey PRIMARY KEY (id);


--
-- Name: health_insurance_members health_insurance_members_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurance_members
    ADD CONSTRAINT health_insurance_members_pkey PRIMARY KEY (id);


--
-- Name: health_insurance_nominees health_insurance_nominees_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurance_nominees
    ADD CONSTRAINT health_insurance_nominees_pkey PRIMARY KEY (id);


--
-- Name: health_insurances health_insurances_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT health_insurances_pkey PRIMARY KEY (id);


--
-- Name: helpdesk_tickets helpdesk_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.helpdesk_tickets
    ADD CONSTRAINT helpdesk_tickets_pkey PRIMARY KEY (id);


--
-- Name: insurance_companies insurance_companies_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.insurance_companies
    ADD CONSTRAINT insurance_companies_pkey PRIMARY KEY (id);


--
-- Name: investments investments_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.investments
    ADD CONSTRAINT investments_pkey PRIMARY KEY (id);


--
-- Name: investor_documents investor_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.investor_documents
    ADD CONSTRAINT investor_documents_pkey PRIMARY KEY (id);


--
-- Name: investors investors_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.investors
    ADD CONSTRAINT investors_pkey PRIMARY KEY (id);


--
-- Name: invoice_items invoice_items_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT invoice_items_pkey PRIMARY KEY (id);


--
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- Name: leads leads_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_pkey PRIMARY KEY (id);


--
-- Name: life_insurance_bank_details life_insurance_bank_details_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurance_bank_details
    ADD CONSTRAINT life_insurance_bank_details_pkey PRIMARY KEY (id);


--
-- Name: life_insurance_documents life_insurance_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurance_documents
    ADD CONSTRAINT life_insurance_documents_pkey PRIMARY KEY (id);


--
-- Name: life_insurance_nominees life_insurance_nominees_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurance_nominees
    ADD CONSTRAINT life_insurance_nominees_pkey PRIMARY KEY (id);


--
-- Name: life_insurances life_insurances_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurances
    ADD CONSTRAINT life_insurances_pkey PRIMARY KEY (id);


--
-- Name: loans loans_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_pkey PRIMARY KEY (id);


--
-- Name: motor_insurance_documents motor_insurance_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.motor_insurance_documents
    ADD CONSTRAINT motor_insurance_documents_pkey PRIMARY KEY (id);


--
-- Name: motor_insurance_nominees motor_insurance_nominees_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.motor_insurance_nominees
    ADD CONSTRAINT motor_insurance_nominees_pkey PRIMARY KEY (id);


--
-- Name: motor_insurances motor_insurances_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.motor_insurances
    ADD CONSTRAINT motor_insurances_pkey PRIMARY KEY (id);


--
-- Name: mutual_fund_nominees mutual_fund_nominees_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.mutual_fund_nominees
    ADD CONSTRAINT mutual_fund_nominees_pkey PRIMARY KEY (id);


--
-- Name: mutual_funds mutual_funds_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.mutual_funds
    ADD CONSTRAINT mutual_funds_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: other_insurance_documents other_insurance_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.other_insurance_documents
    ADD CONSTRAINT other_insurance_documents_pkey PRIMARY KEY (id);


--
-- Name: other_insurance_nominees other_insurance_nominees_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.other_insurance_nominees
    ADD CONSTRAINT other_insurance_nominees_pkey PRIMARY KEY (id);


--
-- Name: other_insurances other_insurances_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.other_insurances
    ADD CONSTRAINT other_insurances_pkey PRIMARY KEY (id);


--
-- Name: payout_audit_logs payout_audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.payout_audit_logs
    ADD CONSTRAINT payout_audit_logs_pkey PRIMARY KEY (id);


--
-- Name: payout_distributions payout_distributions_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.payout_distributions
    ADD CONSTRAINT payout_distributions_pkey PRIMARY KEY (id);


--
-- Name: payouts payouts_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.payouts
    ADD CONSTRAINT payouts_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: policies policies_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT policies_pkey PRIMARY KEY (id);


--
-- Name: policy_documents policy_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.policy_documents
    ADD CONSTRAINT policy_documents_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: session_activities session_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.session_activities
    ADD CONSTRAINT session_activities_pkey PRIMARY KEY (id);


--
-- Name: solid_cache_entries solid_cache_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_cache_entries
    ADD CONSTRAINT solid_cache_entries_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_blocked_executions solid_queue_blocked_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_blocked_executions
    ADD CONSTRAINT solid_queue_blocked_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_claimed_executions solid_queue_claimed_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_claimed_executions
    ADD CONSTRAINT solid_queue_claimed_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_failed_executions solid_queue_failed_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_failed_executions
    ADD CONSTRAINT solid_queue_failed_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_jobs solid_queue_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_jobs
    ADD CONSTRAINT solid_queue_jobs_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_pauses solid_queue_pauses_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_pauses
    ADD CONSTRAINT solid_queue_pauses_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_processes solid_queue_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_processes
    ADD CONSTRAINT solid_queue_processes_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_ready_executions solid_queue_ready_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_ready_executions
    ADD CONSTRAINT solid_queue_ready_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_recurring_executions solid_queue_recurring_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_recurring_executions
    ADD CONSTRAINT solid_queue_recurring_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_recurring_tasks solid_queue_recurring_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_recurring_tasks
    ADD CONSTRAINT solid_queue_recurring_tasks_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_scheduled_executions solid_queue_scheduled_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_scheduled_executions
    ADD CONSTRAINT solid_queue_scheduled_executions_pkey PRIMARY KEY (id);


--
-- Name: solid_queue_semaphores solid_queue_semaphores_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_semaphores
    ADD CONSTRAINT solid_queue_semaphores_pkey PRIMARY KEY (id);


--
-- Name: sub_agent_documents sub_agent_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.sub_agent_documents
    ADD CONSTRAINT sub_agent_documents_pkey PRIMARY KEY (id);


--
-- Name: sub_agents sub_agents_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.sub_agents
    ADD CONSTRAINT sub_agents_pkey PRIMARY KEY (id);


--
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- Name: tax_services tax_services_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.tax_services
    ADD CONSTRAINT tax_services_pkey PRIMARY KEY (id);


--
-- Name: travel_packages travel_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.travel_packages
    ADD CONSTRAINT travel_packages_pkey PRIMARY KEY (id);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_commission_payouts_payout_to_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_commission_payouts_payout_to_status ON public.commission_payouts USING btree (payout_to, status);


--
-- Name: idx_commission_payouts_policy; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_commission_payouts_policy ON public.commission_payouts USING btree (policy_type, policy_id);


--
-- Name: idx_commission_payouts_policy_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_commission_payouts_policy_status ON public.commission_payouts USING btree (policy_type, policy_id, status);


--
-- Name: idx_commission_payouts_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_commission_payouts_status ON public.commission_payouts USING btree (status);


--
-- Name: idx_dashboard_stats_view_calculated_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX idx_dashboard_stats_view_calculated_at ON public.dashboard_stats_view USING btree (calculated_at);


--
-- Name: idx_health_insurances_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_health_insurances_created_at ON public.health_insurances USING btree (created_at);


--
-- Name: idx_insurance_companies_code; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_insurance_companies_code ON public.insurance_companies USING btree (code);


--
-- Name: idx_insurance_companies_code_gin; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_insurance_companies_code_gin ON public.insurance_companies USING gin (code public.gin_trgm_ops);


--
-- Name: idx_insurance_companies_contact_gin; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_insurance_companies_contact_gin ON public.insurance_companies USING gin (contact_person public.gin_trgm_ops);


--
-- Name: idx_insurance_companies_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_insurance_companies_created_at ON public.insurance_companies USING btree (created_at);


--
-- Name: idx_insurance_companies_name; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_insurance_companies_name ON public.insurance_companies USING btree (name);


--
-- Name: idx_insurance_companies_name_gin; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_insurance_companies_name_gin ON public.insurance_companies USING gin (name public.gin_trgm_ops);


--
-- Name: idx_insurance_companies_name_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_insurance_companies_name_id ON public.insurance_companies USING btree (name, id);


--
-- Name: idx_insurance_companies_search_composite; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_insurance_companies_search_composite ON public.insurance_companies USING btree (name, code, contact_person);


--
-- Name: idx_insurance_companies_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_insurance_companies_status ON public.insurance_companies USING btree (status);


--
-- Name: idx_insurance_companies_updated_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_insurance_companies_updated_at ON public.insurance_companies USING btree (updated_at);


--
-- Name: idx_life_insurances_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_life_insurances_created_at ON public.life_insurances USING btree (created_at);


--
-- Name: idx_motor_insurances_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_motor_insurances_created_at ON public.motor_insurances USING btree (created_at);


--
-- Name: idx_on_product_through_dr_total_premium_6bf60d17b1; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_on_product_through_dr_total_premium_6bf60d17b1 ON public.health_insurances USING btree (product_through_dr, total_premium);


--
-- Name: idx_other_insurances_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_other_insurances_created_at ON public.other_insurances USING btree (created_at);


--
-- Name: idx_payouts_policy; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_payouts_policy ON public.payouts USING btree (policy_type, policy_id);


--
-- Name: idx_role_permissions_permission; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_role_permissions_permission ON public.role_permissions USING btree (permission_id);


--
-- Name: idx_role_permissions_role; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_role_permissions_role ON public.role_permissions USING btree (role_id);


--
-- Name: idx_role_permissions_unique; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX idx_role_permissions_unique ON public.role_permissions USING btree (role_id, permission_id);


--
-- Name: idx_users_role_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX idx_users_role_id ON public.users USING btree (role_id);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- Name: index_agency_codes_on_broker_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_agency_codes_on_broker_id ON public.agency_codes USING btree (broker_id);


--
-- Name: index_ahoy_events_on_name_and_time; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_ahoy_events_on_name_and_time ON public.ahoy_events USING btree (name, "time");


--
-- Name: index_ahoy_events_on_properties; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_ahoy_events_on_properties ON public.ahoy_events USING gin (properties jsonb_path_ops);


--
-- Name: index_ahoy_events_on_user_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_ahoy_events_on_user_id ON public.ahoy_events USING btree (user_id);


--
-- Name: index_ahoy_events_on_visit_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_ahoy_events_on_visit_id ON public.ahoy_events USING btree (visit_id);


--
-- Name: index_ahoy_visits_on_user_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_ahoy_visits_on_user_id ON public.ahoy_visits USING btree (user_id);


--
-- Name: index_ahoy_visits_on_visit_token; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_ahoy_visits_on_visit_token ON public.ahoy_visits USING btree (visit_token);


--
-- Name: index_ahoy_visits_on_visitor_token_and_started_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_ahoy_visits_on_visitor_token_and_started_at ON public.ahoy_visits USING btree (visitor_token, started_at);


--
-- Name: index_ai_report_histories_on_confidence_score; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_ai_report_histories_on_confidence_score ON public.ai_report_histories USING btree (confidence_score);


--
-- Name: index_ai_report_histories_on_generated_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_ai_report_histories_on_generated_at ON public.ai_report_histories USING btree (generated_at);


--
-- Name: index_ai_report_histories_on_report_type; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_ai_report_histories_on_report_type ON public.ai_report_histories USING btree (report_type);


--
-- Name: index_ai_report_histories_on_user_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_ai_report_histories_on_user_id ON public.ai_report_histories USING btree (user_id);


--
-- Name: index_ai_report_histories_on_user_id_and_report_type; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_ai_report_histories_on_user_id_and_report_type ON public.ai_report_histories USING btree (user_id, report_type);


--
-- Name: index_analytics_caches_on_cache_identifier; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_analytics_caches_on_cache_identifier ON public.analytics_caches USING btree (cache_identifier);


--
-- Name: index_appointments_on_appointment_date; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_appointments_on_appointment_date ON public.appointments USING btree (appointment_date);


--
-- Name: index_appointments_on_created_by_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_appointments_on_created_by_id ON public.appointments USING btree (created_by_id);


--
-- Name: index_appointments_on_customer_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_appointments_on_customer_id ON public.appointments USING btree (customer_id);


--
-- Name: index_appointments_on_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_appointments_on_status ON public.appointments USING btree (status);


--
-- Name: index_banner_documents_on_banner_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_banner_documents_on_banner_id ON public.banner_documents USING btree (banner_id);


--
-- Name: index_banners_on_display_order; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_banners_on_display_order ON public.banners USING btree (display_order);


--
-- Name: index_broker_codes_on_broker_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_broker_codes_on_broker_id ON public.broker_codes USING btree (broker_id);


--
-- Name: index_brokers_on_insurance_company_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_brokers_on_insurance_company_id ON public.brokers USING btree (insurance_company_id);


--
-- Name: index_brokers_on_name; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_brokers_on_name ON public.brokers USING btree (name);


--
-- Name: index_brokers_on_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_brokers_on_status ON public.brokers USING btree (status);


--
-- Name: index_client_requests_on_email; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_client_requests_on_email ON public.client_requests USING btree (email);


--
-- Name: index_client_requests_on_resolved_by_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_client_requests_on_resolved_by_id ON public.client_requests USING btree (resolved_by_id);


--
-- Name: index_client_requests_on_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_client_requests_on_status ON public.client_requests USING btree (status);


--
-- Name: index_client_requests_on_submitted_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_client_requests_on_submitted_at ON public.client_requests USING btree (submitted_at);


--
-- Name: index_client_requests_on_submitter_type_and_submitter_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_client_requests_on_submitter_type_and_submitter_id ON public.client_requests USING btree (submitter_type, submitter_id);


--
-- Name: index_client_requests_on_ticket_number; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_client_requests_on_ticket_number ON public.client_requests USING btree (ticket_number);


--
-- Name: index_commission_payouts_on_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_commission_payouts_on_created_at ON public.commission_payouts USING btree (created_at);


--
-- Name: index_commission_payouts_on_lead_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_commission_payouts_on_lead_id ON public.commission_payouts USING btree (lead_id);


--
-- Name: index_commission_payouts_on_payout_date; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_commission_payouts_on_payout_date ON public.commission_payouts USING btree (payout_date);


--
-- Name: index_commission_payouts_on_payout_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_commission_payouts_on_payout_id ON public.commission_payouts USING btree (payout_id);


--
-- Name: index_commission_payouts_on_payout_to_and_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_commission_payouts_on_payout_to_and_status ON public.commission_payouts USING btree (payout_to, status);


--
-- Name: index_commission_payouts_on_policy_type_and_policy_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_commission_payouts_on_policy_type_and_policy_id ON public.commission_payouts USING btree (policy_type, policy_id);


--
-- Name: index_commission_payouts_on_status_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_commission_payouts_on_status_and_created_at ON public.commission_payouts USING btree (status, created_at);


--
-- Name: index_commission_receipts_on_auto_distributed; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_commission_receipts_on_auto_distributed ON public.commission_receipts USING btree (auto_distributed);


--
-- Name: index_commission_receipts_on_policy_type_and_policy_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_commission_receipts_on_policy_type_and_policy_id ON public.commission_receipts USING btree (policy_type, policy_id);


--
-- Name: index_commission_receipts_on_received_date; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_commission_receipts_on_received_date ON public.commission_receipts USING btree (received_date);


--
-- Name: index_corporate_members_on_customer_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_corporate_members_on_customer_id ON public.corporate_members USING btree (customer_id);


--
-- Name: index_customer_documents_on_customer_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_customer_documents_on_customer_id ON public.customer_documents USING btree (customer_id);


--
-- Name: index_customers_on_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_customers_on_created_at ON public.customers USING btree (created_at);


--
-- Name: index_customers_on_customer_type; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_customers_on_customer_type ON public.customers USING btree (customer_type);


--
-- Name: index_customers_on_customer_type_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_customers_on_customer_type_and_created_at ON public.customers USING btree (customer_type, created_at);


--
-- Name: index_customers_on_customer_type_and_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_customers_on_customer_type_and_status ON public.customers USING btree (customer_type, status);


--
-- Name: index_customers_on_email; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_customers_on_email ON public.customers USING btree (email);


--
-- Name: index_customers_on_lead_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_customers_on_lead_id ON public.customers USING btree (lead_id);


--
-- Name: index_customers_on_mobile; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_customers_on_mobile ON public.customers USING btree (mobile);


--
-- Name: index_customers_on_pan_number; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_customers_on_pan_number ON public.customers USING btree (pan_number);


--
-- Name: index_customers_on_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_customers_on_status ON public.customers USING btree (status);


--
-- Name: index_customers_on_status_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_customers_on_status_and_created_at ON public.customers USING btree (status, created_at);


--
-- Name: index_customers_on_sub_agent_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_customers_on_sub_agent_id ON public.customers USING btree (sub_agent_id);


--
-- Name: index_distributor_assignments_on_distributor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_distributor_assignments_on_distributor_id ON public.distributor_assignments USING btree (distributor_id);


--
-- Name: index_distributor_assignments_on_sub_agent_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_distributor_assignments_on_sub_agent_id ON public.distributor_assignments USING btree (sub_agent_id);


--
-- Name: index_distributor_documents_on_distributor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_distributor_documents_on_distributor_id ON public.distributor_documents USING btree (distributor_id);


--
-- Name: index_distributor_payouts_on_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_distributor_payouts_on_created_at ON public.distributor_payouts USING btree (created_at);


--
-- Name: index_distributor_payouts_on_distributor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_distributor_payouts_on_distributor_id ON public.distributor_payouts USING btree (distributor_id);


--
-- Name: index_distributor_payouts_on_distributor_id_and_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_distributor_payouts_on_distributor_id_and_status ON public.distributor_payouts USING btree (distributor_id, status);


--
-- Name: index_distributor_payouts_on_policy_type_and_policy_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_distributor_payouts_on_policy_type_and_policy_id ON public.distributor_payouts USING btree (policy_type, policy_id);


--
-- Name: index_distributor_payouts_on_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_distributor_payouts_on_status ON public.distributor_payouts USING btree (status);


--
-- Name: index_distributor_payouts_on_status_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_distributor_payouts_on_status_and_created_at ON public.distributor_payouts USING btree (status, created_at);


--
-- Name: index_distributors_on_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_distributors_on_created_at ON public.distributors USING btree (created_at);


--
-- Name: index_distributors_on_email; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_distributors_on_email ON public.distributors USING btree (email);


--
-- Name: index_distributors_on_investor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_distributors_on_investor_id ON public.distributors USING btree (investor_id);


--
-- Name: index_distributors_on_mobile; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_distributors_on_mobile ON public.distributors USING btree (mobile);


--
-- Name: index_distributors_on_role_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_distributors_on_role_id ON public.distributors USING btree (role_id);


--
-- Name: index_distributors_on_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_distributors_on_status ON public.distributors USING btree (status);


--
-- Name: index_documents_on_documentable; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_documents_on_documentable ON public.documents USING btree (documentable_type, documentable_id);


--
-- Name: index_family_members_on_customer_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_family_members_on_customer_id ON public.family_members USING btree (customer_id);


--
-- Name: index_health_insurance_documents_on_health_insurance_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurance_documents_on_health_insurance_id ON public.health_insurance_documents USING btree (health_insurance_id);


--
-- Name: index_health_insurance_members_on_health_insurance_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurance_members_on_health_insurance_id ON public.health_insurance_members USING btree (health_insurance_id);


--
-- Name: index_health_insurance_nominees_on_health_insurance_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurance_nominees_on_health_insurance_id ON public.health_insurance_nominees USING btree (health_insurance_id);


--
-- Name: index_health_insurances_on_agency_code_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurances_on_agency_code_id ON public.health_insurances USING btree (agency_code_id);


--
-- Name: index_health_insurances_on_broker_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurances_on_broker_id ON public.health_insurances USING btree (broker_id);


--
-- Name: index_health_insurances_on_customer_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurances_on_customer_id ON public.health_insurances USING btree (customer_id);


--
-- Name: index_health_insurances_on_customer_id_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurances_on_customer_id_and_created_at ON public.health_insurances USING btree (customer_id, created_at);


--
-- Name: index_health_insurances_on_distributor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurances_on_distributor_id ON public.health_insurances USING btree (distributor_id);


--
-- Name: index_health_insurances_on_insurance_company_code; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurances_on_insurance_company_code ON public.health_insurances USING btree (insurance_company_code);


--
-- Name: index_health_insurances_on_investor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurances_on_investor_id ON public.health_insurances USING btree (investor_id);


--
-- Name: index_health_insurances_on_lead_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_health_insurances_on_lead_id ON public.health_insurances USING btree (lead_id);


--
-- Name: index_health_insurances_on_policy_end_date; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurances_on_policy_end_date ON public.health_insurances USING btree (policy_end_date);


--
-- Name: index_health_insurances_on_policy_end_date_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurances_on_policy_end_date_and_created_at ON public.health_insurances USING btree (policy_end_date, created_at);


--
-- Name: index_health_insurances_on_policy_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurances_on_policy_id ON public.health_insurances USING btree (policy_id);


--
-- Name: index_health_insurances_on_policy_type; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurances_on_policy_type ON public.health_insurances USING btree (policy_type);


--
-- Name: index_health_insurances_on_product_through_dr; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurances_on_product_through_dr ON public.health_insurances USING btree (product_through_dr);


--
-- Name: index_health_insurances_on_product_through_dr_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurances_on_product_through_dr_and_created_at ON public.health_insurances USING btree (product_through_dr, created_at);


--
-- Name: index_health_insurances_on_product_through_dr_and_sum_insured; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurances_on_product_through_dr_and_sum_insured ON public.health_insurances USING btree (product_through_dr, sum_insured);


--
-- Name: index_health_insurances_on_sub_agent_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_health_insurances_on_sub_agent_id ON public.health_insurances USING btree (sub_agent_id);


--
-- Name: index_helpdesk_tickets_on_customer_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_helpdesk_tickets_on_customer_id ON public.helpdesk_tickets USING btree (customer_id);


--
-- Name: index_helpdesk_tickets_on_sub_agent_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_helpdesk_tickets_on_sub_agent_id ON public.helpdesk_tickets USING btree (sub_agent_id);


--
-- Name: index_helpdesk_tickets_on_ticket_number; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_helpdesk_tickets_on_ticket_number ON public.helpdesk_tickets USING btree (ticket_number);


--
-- Name: index_investments_on_customer_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_investments_on_customer_id ON public.investments USING btree (customer_id);


--
-- Name: index_investor_documents_on_investor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_investor_documents_on_investor_id ON public.investor_documents USING btree (investor_id);


--
-- Name: index_investors_on_email; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_investors_on_email ON public.investors USING btree (email);


--
-- Name: index_investors_on_mobile; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_investors_on_mobile ON public.investors USING btree (mobile);


--
-- Name: index_investors_on_role_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_investors_on_role_id ON public.investors USING btree (role_id);


--
-- Name: index_investors_on_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_investors_on_status ON public.investors USING btree (status);


--
-- Name: index_invoice_items_on_invoice_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_invoice_items_on_invoice_id ON public.invoice_items USING btree (invoice_id);


--
-- Name: index_invoices_on_invoice_date; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_invoices_on_invoice_date ON public.invoices USING btree (invoice_date);


--
-- Name: index_invoices_on_invoice_number; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_invoices_on_invoice_number ON public.invoices USING btree (invoice_number);


--
-- Name: index_invoices_on_payout_type_and_payout_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_invoices_on_payout_type_and_payout_id ON public.invoices USING btree (payout_type, payout_id);


--
-- Name: index_invoices_on_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_invoices_on_status ON public.invoices USING btree (status);


--
-- Name: index_leads_on_affiliate_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_affiliate_id ON public.leads USING btree (affiliate_id);


--
-- Name: index_leads_on_ambassador_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_ambassador_id ON public.leads USING btree (ambassador_id);


--
-- Name: index_leads_on_company_name; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_company_name ON public.leads USING btree (company_name);


--
-- Name: index_leads_on_contact_number; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_contact_number ON public.leads USING btree (contact_number);


--
-- Name: index_leads_on_converted_customer_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_converted_customer_id ON public.leads USING btree (converted_customer_id);


--
-- Name: index_leads_on_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_created_at ON public.leads USING btree (created_at);


--
-- Name: index_leads_on_current_stage; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_current_stage ON public.leads USING btree (current_stage);


--
-- Name: index_leads_on_current_stage_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_current_stage_and_created_at ON public.leads USING btree (current_stage, created_at);


--
-- Name: index_leads_on_email; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_email ON public.leads USING btree (email);


--
-- Name: index_leads_on_first_name_and_last_name; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_first_name_and_last_name ON public.leads USING btree (first_name, last_name);


--
-- Name: index_leads_on_is_direct; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_is_direct ON public.leads USING btree (is_direct);


--
-- Name: index_leads_on_lead_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_leads_on_lead_id ON public.leads USING btree (lead_id);


--
-- Name: index_leads_on_lead_source; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_lead_source ON public.leads USING btree (lead_source);


--
-- Name: index_leads_on_parent_lead_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_parent_lead_id ON public.leads USING btree (parent_lead_id);


--
-- Name: index_leads_on_policy_created_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_policy_created_id ON public.leads USING btree (policy_created_id);


--
-- Name: index_leads_on_product_category; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_product_category ON public.leads USING btree (product_category);


--
-- Name: index_leads_on_product_category_and_product_subcategory; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_product_category_and_product_subcategory ON public.leads USING btree (product_category, product_subcategory);


--
-- Name: index_leads_on_product_subcategory; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_leads_on_product_subcategory ON public.leads USING btree (product_subcategory);


--
-- Name: index_life_insurance_bank_details_on_life_insurance_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurance_bank_details_on_life_insurance_id ON public.life_insurance_bank_details USING btree (life_insurance_id);


--
-- Name: index_life_insurance_documents_on_life_insurance_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurance_documents_on_life_insurance_id ON public.life_insurance_documents USING btree (life_insurance_id);


--
-- Name: index_life_insurance_nominees_on_life_insurance_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurance_nominees_on_life_insurance_id ON public.life_insurance_nominees USING btree (life_insurance_id);


--
-- Name: index_life_insurances_on_agency_code_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_agency_code_id ON public.life_insurances USING btree (agency_code_id);


--
-- Name: index_life_insurances_on_broker_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_broker_id ON public.life_insurances USING btree (broker_id);


--
-- Name: index_life_insurances_on_customer_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_customer_id ON public.life_insurances USING btree (customer_id);


--
-- Name: index_life_insurances_on_customer_id_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_customer_id_and_created_at ON public.life_insurances USING btree (customer_id, created_at);


--
-- Name: index_life_insurances_on_distributor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_distributor_id ON public.life_insurances USING btree (distributor_id);


--
-- Name: index_life_insurances_on_insurance_company_code; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_insurance_company_code ON public.life_insurances USING btree (insurance_company_code);


--
-- Name: index_life_insurances_on_insurance_company_name; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_insurance_company_name ON public.life_insurances USING btree (insurance_company_name);


--
-- Name: index_life_insurances_on_investor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_investor_id ON public.life_insurances USING btree (investor_id);


--
-- Name: index_life_insurances_on_is_renewed; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_is_renewed ON public.life_insurances USING btree (is_renewed);


--
-- Name: index_life_insurances_on_lead_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_life_insurances_on_lead_id ON public.life_insurances USING btree (lead_id);


--
-- Name: index_life_insurances_on_original_policy_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_original_policy_id ON public.life_insurances USING btree (original_policy_id);


--
-- Name: index_life_insurances_on_policy_end_date; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_policy_end_date ON public.life_insurances USING btree (policy_end_date);


--
-- Name: index_life_insurances_on_policy_end_date_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_policy_end_date_and_created_at ON public.life_insurances USING btree (policy_end_date, created_at);


--
-- Name: index_life_insurances_on_policy_number; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_life_insurances_on_policy_number ON public.life_insurances USING btree (policy_number);


--
-- Name: index_life_insurances_on_policy_start_date; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_policy_start_date ON public.life_insurances USING btree (policy_start_date);


--
-- Name: index_life_insurances_on_policy_start_date_and_policy_end_date; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_policy_start_date_and_policy_end_date ON public.life_insurances USING btree (policy_start_date, policy_end_date);


--
-- Name: index_life_insurances_on_policy_type; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_policy_type ON public.life_insurances USING btree (policy_type);


--
-- Name: index_life_insurances_on_product_through_dr; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_product_through_dr ON public.life_insurances USING btree (product_through_dr);


--
-- Name: index_life_insurances_on_product_through_dr_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_product_through_dr_and_created_at ON public.life_insurances USING btree (product_through_dr, created_at);


--
-- Name: index_life_insurances_on_product_through_dr_and_sum_insured; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_product_through_dr_and_sum_insured ON public.life_insurances USING btree (product_through_dr, sum_insured);


--
-- Name: index_life_insurances_on_product_through_dr_and_total_premium; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_product_through_dr_and_total_premium ON public.life_insurances USING btree (product_through_dr, total_premium);


--
-- Name: index_life_insurances_on_renewal_policy_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_renewal_policy_id ON public.life_insurances USING btree (renewal_policy_id);


--
-- Name: index_life_insurances_on_sub_agent_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_life_insurances_on_sub_agent_id ON public.life_insurances USING btree (sub_agent_id);


--
-- Name: index_loans_on_customer_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_loans_on_customer_id ON public.loans USING btree (customer_id);


--
-- Name: index_motor_insurance_documents_on_motor_insurance_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_motor_insurance_documents_on_motor_insurance_id ON public.motor_insurance_documents USING btree (motor_insurance_id);


--
-- Name: index_motor_insurance_nominees_on_motor_insurance_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_motor_insurance_nominees_on_motor_insurance_id ON public.motor_insurance_nominees USING btree (motor_insurance_id);


--
-- Name: index_motor_insurances_on_agency_code_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_motor_insurances_on_agency_code_id ON public.motor_insurances USING btree (agency_code_id);


--
-- Name: index_motor_insurances_on_broker_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_motor_insurances_on_broker_id ON public.motor_insurances USING btree (broker_id);


--
-- Name: index_motor_insurances_on_customer_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_motor_insurances_on_customer_id ON public.motor_insurances USING btree (customer_id);


--
-- Name: index_motor_insurances_on_customer_id_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_motor_insurances_on_customer_id_and_created_at ON public.motor_insurances USING btree (customer_id, created_at);


--
-- Name: index_motor_insurances_on_distributor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_motor_insurances_on_distributor_id ON public.motor_insurances USING btree (distributor_id);


--
-- Name: index_motor_insurances_on_insurance_company_code; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_motor_insurances_on_insurance_company_code ON public.motor_insurances USING btree (insurance_company_code);


--
-- Name: index_motor_insurances_on_investor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_motor_insurances_on_investor_id ON public.motor_insurances USING btree (investor_id);


--
-- Name: index_motor_insurances_on_lead_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_motor_insurances_on_lead_id ON public.motor_insurances USING btree (lead_id);


--
-- Name: index_motor_insurances_on_policy_end_date; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_motor_insurances_on_policy_end_date ON public.motor_insurances USING btree (policy_end_date);


--
-- Name: index_motor_insurances_on_policy_end_date_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_motor_insurances_on_policy_end_date_and_created_at ON public.motor_insurances USING btree (policy_end_date, created_at);


--
-- Name: index_motor_insurances_on_policy_number; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_motor_insurances_on_policy_number ON public.motor_insurances USING btree (policy_number);


--
-- Name: index_motor_insurances_on_policy_type; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_motor_insurances_on_policy_type ON public.motor_insurances USING btree (policy_type);


--
-- Name: index_motor_insurances_on_sub_agent_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_motor_insurances_on_sub_agent_id ON public.motor_insurances USING btree (sub_agent_id);


--
-- Name: index_mutual_fund_nominees_on_mutual_fund_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_mutual_fund_nominees_on_mutual_fund_id ON public.mutual_fund_nominees USING btree (mutual_fund_id);


--
-- Name: index_mutual_funds_on_customer_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_mutual_funds_on_customer_id ON public.mutual_funds USING btree (customer_id);


--
-- Name: index_mutual_funds_on_distributor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_mutual_funds_on_distributor_id ON public.mutual_funds USING btree (distributor_id);


--
-- Name: index_mutual_funds_on_sub_agent_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_mutual_funds_on_sub_agent_id ON public.mutual_funds USING btree (sub_agent_id);


--
-- Name: index_notifications_on_is_read; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_notifications_on_is_read ON public.notifications USING btree (is_read);


--
-- Name: index_notifications_on_recipient_type_and_recipient_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_notifications_on_recipient_type_and_recipient_id ON public.notifications USING btree (recipient_type, recipient_id);


--
-- Name: index_notifications_on_reference_type_and_reference_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_notifications_on_reference_type_and_reference_id ON public.notifications USING btree (reference_type, reference_id);


--
-- Name: index_notifications_on_sent_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_notifications_on_sent_at ON public.notifications USING btree (sent_at);


--
-- Name: index_other_insurance_documents_on_other_insurance_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_other_insurance_documents_on_other_insurance_id ON public.other_insurance_documents USING btree (other_insurance_id);


--
-- Name: index_other_insurance_nominees_on_other_insurance_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_other_insurance_nominees_on_other_insurance_id ON public.other_insurance_nominees USING btree (other_insurance_id);


--
-- Name: index_other_insurances_on_customer_id_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_other_insurances_on_customer_id_and_created_at ON public.other_insurances USING btree (customer_id, created_at);


--
-- Name: index_other_insurances_on_distributor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_other_insurances_on_distributor_id ON public.other_insurances USING btree (distributor_id);


--
-- Name: index_other_insurances_on_insurance_company_code; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_other_insurances_on_insurance_company_code ON public.other_insurances USING btree (insurance_company_code);


--
-- Name: index_other_insurances_on_investor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_other_insurances_on_investor_id ON public.other_insurances USING btree (investor_id);


--
-- Name: index_other_insurances_on_lead_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_other_insurances_on_lead_id ON public.other_insurances USING btree (lead_id);


--
-- Name: index_other_insurances_on_policy_end_date; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_other_insurances_on_policy_end_date ON public.other_insurances USING btree (policy_end_date);


--
-- Name: index_other_insurances_on_policy_end_date_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_other_insurances_on_policy_end_date_and_created_at ON public.other_insurances USING btree (policy_end_date, created_at);


--
-- Name: index_other_insurances_on_policy_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_other_insurances_on_policy_id ON public.other_insurances USING btree (policy_id);


--
-- Name: index_payout_audit_logs_on_auditable_type_and_auditable_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_payout_audit_logs_on_auditable_type_and_auditable_id ON public.payout_audit_logs USING btree (auditable_type, auditable_id);


--
-- Name: index_payout_audit_logs_on_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_payout_audit_logs_on_created_at ON public.payout_audit_logs USING btree (created_at);


--
-- Name: index_payout_audit_logs_on_performed_by; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_payout_audit_logs_on_performed_by ON public.payout_audit_logs USING btree (performed_by);


--
-- Name: index_payout_distributions_on_commission_receipt_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_payout_distributions_on_commission_receipt_id ON public.payout_distributions USING btree (commission_receipt_id);


--
-- Name: index_payout_distributions_on_payment_date; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_payout_distributions_on_payment_date ON public.payout_distributions USING btree (payment_date);


--
-- Name: index_payout_distributions_on_recipient_type_and_recipient_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_payout_distributions_on_recipient_type_and_recipient_id ON public.payout_distributions USING btree (recipient_type, recipient_id);


--
-- Name: index_payout_distributions_on_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_payout_distributions_on_status ON public.payout_distributions USING btree (status);


--
-- Name: index_payouts_on_affiliate_commission_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_payouts_on_affiliate_commission_id ON public.payouts USING btree (affiliate_commission_id);


--
-- Name: index_payouts_on_ambassador_commission_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_payouts_on_ambassador_commission_id ON public.payouts USING btree (ambassador_commission_id);


--
-- Name: index_payouts_on_company_expense_commission_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_payouts_on_company_expense_commission_id ON public.payouts USING btree (company_expense_commission_id);


--
-- Name: index_payouts_on_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_payouts_on_created_at ON public.payouts USING btree (created_at);


--
-- Name: index_payouts_on_investor_commission_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_payouts_on_investor_commission_id ON public.payouts USING btree (investor_commission_id);


--
-- Name: index_payouts_on_main_agent_commission_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_payouts_on_main_agent_commission_id ON public.payouts USING btree (main_agent_commission_id);


--
-- Name: index_payouts_on_policy_type_and_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_payouts_on_policy_type_and_id ON public.payouts USING btree (policy_type, policy_id);


--
-- Name: index_payouts_on_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_payouts_on_status ON public.payouts USING btree (status);


--
-- Name: index_permissions_on_action_type; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_permissions_on_action_type ON public.permissions USING btree (action_type);


--
-- Name: index_permissions_on_module_name; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_permissions_on_module_name ON public.permissions USING btree (module_name);


--
-- Name: index_permissions_on_module_name_and_action_type; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_permissions_on_module_name_and_action_type ON public.permissions USING btree (module_name, action_type);


--
-- Name: index_policies_on_agency_broker_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_policies_on_agency_broker_id ON public.policies USING btree (agency_broker_id);


--
-- Name: index_policies_on_customer_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_policies_on_customer_id ON public.policies USING btree (customer_id);


--
-- Name: index_policies_on_customer_id_and_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_policies_on_customer_id_and_created_at ON public.policies USING btree (customer_id, created_at);


--
-- Name: index_policies_on_insurance_company_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_policies_on_insurance_company_id ON public.policies USING btree (insurance_company_id);


--
-- Name: index_policies_on_insurance_type; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_policies_on_insurance_type ON public.policies USING btree (insurance_type);


--
-- Name: index_policies_on_policy_end_date; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_policies_on_policy_end_date ON public.policies USING btree (policy_end_date);


--
-- Name: index_policies_on_policy_start_date; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_policies_on_policy_start_date ON public.policies USING btree (policy_start_date);


--
-- Name: index_policies_on_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_policies_on_status ON public.policies USING btree (status);


--
-- Name: index_policies_on_user_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_policies_on_user_id ON public.policies USING btree (user_id);


--
-- Name: index_policy_documents_on_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_policy_documents_on_created_at ON public.policy_documents USING btree (created_at);


--
-- Name: index_policy_documents_on_document_type; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_policy_documents_on_document_type ON public.policy_documents USING btree (document_type);


--
-- Name: index_policy_documents_on_policy_type_and_policy_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_policy_documents_on_policy_type_and_policy_id ON public.policy_documents USING btree (policy_type, policy_id);


--
-- Name: index_role_permissions_on_permission_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_role_permissions_on_permission_id ON public.role_permissions USING btree (permission_id);


--
-- Name: index_role_permissions_on_role_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_role_permissions_on_role_id ON public.role_permissions USING btree (role_id);


--
-- Name: index_roles_on_name; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_roles_on_name ON public.roles USING btree (name);


--
-- Name: index_roles_on_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_roles_on_status ON public.roles USING btree (status);


--
-- Name: index_session_activities_on_user_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_session_activities_on_user_id ON public.session_activities USING btree (user_id);


--
-- Name: index_solid_cache_entries_on_byte_size; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_cache_entries_on_byte_size ON public.solid_cache_entries USING btree (byte_size);


--
-- Name: index_solid_cache_entries_on_key_hash; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_solid_cache_entries_on_key_hash ON public.solid_cache_entries USING btree (key_hash);


--
-- Name: index_solid_cache_entries_on_key_hash_and_byte_size; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_cache_entries_on_key_hash_and_byte_size ON public.solid_cache_entries USING btree (key_hash, byte_size);


--
-- Name: index_solid_queue_blocked_executions_for_maintenance; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_blocked_executions_for_maintenance ON public.solid_queue_blocked_executions USING btree (expires_at, concurrency_key);


--
-- Name: index_solid_queue_blocked_executions_for_release; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_blocked_executions_for_release ON public.solid_queue_blocked_executions USING btree (concurrency_key, priority, job_id);


--
-- Name: index_solid_queue_blocked_executions_on_job_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_solid_queue_blocked_executions_on_job_id ON public.solid_queue_blocked_executions USING btree (job_id);


--
-- Name: index_solid_queue_claimed_executions_on_job_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_solid_queue_claimed_executions_on_job_id ON public.solid_queue_claimed_executions USING btree (job_id);


--
-- Name: index_solid_queue_claimed_executions_on_process_id_and_job_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_claimed_executions_on_process_id_and_job_id ON public.solid_queue_claimed_executions USING btree (process_id, job_id);


--
-- Name: index_solid_queue_dispatch_all; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_dispatch_all ON public.solid_queue_scheduled_executions USING btree (scheduled_at, priority, job_id);


--
-- Name: index_solid_queue_failed_executions_on_job_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_solid_queue_failed_executions_on_job_id ON public.solid_queue_failed_executions USING btree (job_id);


--
-- Name: index_solid_queue_jobs_for_alerting; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_jobs_for_alerting ON public.solid_queue_jobs USING btree (scheduled_at, finished_at);


--
-- Name: index_solid_queue_jobs_for_filtering; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_jobs_for_filtering ON public.solid_queue_jobs USING btree (queue_name, finished_at);


--
-- Name: index_solid_queue_jobs_on_active_job_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_jobs_on_active_job_id ON public.solid_queue_jobs USING btree (active_job_id);


--
-- Name: index_solid_queue_jobs_on_class_name; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_jobs_on_class_name ON public.solid_queue_jobs USING btree (class_name);


--
-- Name: index_solid_queue_jobs_on_finished_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_jobs_on_finished_at ON public.solid_queue_jobs USING btree (finished_at);


--
-- Name: index_solid_queue_pauses_on_queue_name; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_solid_queue_pauses_on_queue_name ON public.solid_queue_pauses USING btree (queue_name);


--
-- Name: index_solid_queue_poll_all; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_poll_all ON public.solid_queue_ready_executions USING btree (priority, job_id);


--
-- Name: index_solid_queue_poll_by_queue; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_poll_by_queue ON public.solid_queue_ready_executions USING btree (queue_name, priority, job_id);


--
-- Name: index_solid_queue_processes_on_last_heartbeat_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_processes_on_last_heartbeat_at ON public.solid_queue_processes USING btree (last_heartbeat_at);


--
-- Name: index_solid_queue_processes_on_name_and_supervisor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_solid_queue_processes_on_name_and_supervisor_id ON public.solid_queue_processes USING btree (name, supervisor_id);


--
-- Name: index_solid_queue_processes_on_supervisor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_processes_on_supervisor_id ON public.solid_queue_processes USING btree (supervisor_id);


--
-- Name: index_solid_queue_ready_executions_on_job_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_solid_queue_ready_executions_on_job_id ON public.solid_queue_ready_executions USING btree (job_id);


--
-- Name: index_solid_queue_recurring_executions_on_job_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_solid_queue_recurring_executions_on_job_id ON public.solid_queue_recurring_executions USING btree (job_id);


--
-- Name: index_solid_queue_recurring_executions_on_task_key_and_run_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_solid_queue_recurring_executions_on_task_key_and_run_at ON public.solid_queue_recurring_executions USING btree (task_key, run_at);


--
-- Name: index_solid_queue_recurring_tasks_on_key; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_solid_queue_recurring_tasks_on_key ON public.solid_queue_recurring_tasks USING btree (key);


--
-- Name: index_solid_queue_recurring_tasks_on_static; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_recurring_tasks_on_static ON public.solid_queue_recurring_tasks USING btree (static);


--
-- Name: index_solid_queue_scheduled_executions_on_job_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_solid_queue_scheduled_executions_on_job_id ON public.solid_queue_scheduled_executions USING btree (job_id);


--
-- Name: index_solid_queue_semaphores_on_expires_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_semaphores_on_expires_at ON public.solid_queue_semaphores USING btree (expires_at);


--
-- Name: index_solid_queue_semaphores_on_key; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_solid_queue_semaphores_on_key ON public.solid_queue_semaphores USING btree (key);


--
-- Name: index_solid_queue_semaphores_on_key_and_value; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_solid_queue_semaphores_on_key_and_value ON public.solid_queue_semaphores USING btree (key, value);


--
-- Name: index_sub_agent_documents_on_document_type; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_sub_agent_documents_on_document_type ON public.sub_agent_documents USING btree (document_type);


--
-- Name: index_sub_agent_documents_on_sub_agent_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_sub_agent_documents_on_sub_agent_id ON public.sub_agent_documents USING btree (sub_agent_id);


--
-- Name: index_sub_agent_documents_on_sub_agent_id_and_document_type; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_sub_agent_documents_on_sub_agent_id_and_document_type ON public.sub_agent_documents USING btree (sub_agent_id, document_type);


--
-- Name: index_sub_agents_on_created_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_sub_agents_on_created_at ON public.sub_agents USING btree (created_at);


--
-- Name: index_sub_agents_on_distributor_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_sub_agents_on_distributor_id ON public.sub_agents USING btree (distributor_id);


--
-- Name: index_sub_agents_on_email; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_sub_agents_on_email ON public.sub_agents USING btree (email);


--
-- Name: index_sub_agents_on_mobile; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_sub_agents_on_mobile ON public.sub_agents USING btree (mobile);


--
-- Name: index_sub_agents_on_role_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_sub_agents_on_role_id ON public.sub_agents USING btree (role_id);


--
-- Name: index_sub_agents_on_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_sub_agents_on_status ON public.sub_agents USING btree (status);


--
-- Name: index_system_settings_on_key; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_system_settings_on_key ON public.system_settings USING btree (key);


--
-- Name: index_tax_services_on_customer_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_tax_services_on_customer_id ON public.tax_services USING btree (customer_id);


--
-- Name: index_travel_packages_on_customer_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_travel_packages_on_customer_id ON public.travel_packages USING btree (customer_id);


--
-- Name: index_user_roles_on_display_order; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_user_roles_on_display_order ON public.user_roles USING btree (display_order);


--
-- Name: index_user_roles_on_name; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_user_roles_on_name ON public.user_roles USING btree (name);


--
-- Name: index_user_roles_on_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_user_roles_on_status ON public.user_roles USING btree (status);


--
-- Name: index_user_sessions_on_ip_address; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_user_sessions_on_ip_address ON public.user_sessions USING btree (ip_address);


--
-- Name: index_user_sessions_on_session_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_user_sessions_on_session_id ON public.user_sessions USING btree (session_id);


--
-- Name: index_user_sessions_on_started_at; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_user_sessions_on_started_at ON public.user_sessions USING btree (started_at);


--
-- Name: index_user_sessions_on_status; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_user_sessions_on_status ON public.user_sessions USING btree (status);


--
-- Name: index_user_sessions_on_user_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_user_sessions_on_user_id ON public.user_sessions USING btree (user_id);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_role_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_users_on_role_id ON public.users USING btree (role_id);


--
-- Name: index_users_on_user_role_id; Type: INDEX; Schema: public; Owner: drwisedb01_user
--

CREATE INDEX index_users_on_user_role_id ON public.users USING btree (user_role_id);


--
-- Name: customers fk_rails_008db845d0; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT fk_rails_008db845d0 FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- Name: client_requests fk_rails_01555c239d; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.client_requests
    ADD CONSTRAINT fk_rails_01555c239d FOREIGN KEY (resolved_by_id) REFERENCES public.users(id);


--
-- Name: health_insurance_nominees fk_rails_0e6e5acb42; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurance_nominees
    ADD CONSTRAINT fk_rails_0e6e5acb42 FOREIGN KEY (health_insurance_id) REFERENCES public.health_insurances(id);


--
-- Name: motor_insurances fk_rails_1137d0b877; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.motor_insurances
    ADD CONSTRAINT fk_rails_1137d0b877 FOREIGN KEY (broker_id) REFERENCES public.brokers(id);


--
-- Name: tax_services fk_rails_1a1cf777a6; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.tax_services
    ADD CONSTRAINT fk_rails_1a1cf777a6 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: broker_codes fk_rails_215550e107; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.broker_codes
    ADD CONSTRAINT fk_rails_215550e107 FOREIGN KEY (broker_id) REFERENCES public.brokers(id);


--
-- Name: session_activities fk_rails_216a79c3b1; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.session_activities
    ADD CONSTRAINT fk_rails_216a79c3b1 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: policies fk_rails_21e14e2e1d; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT fk_rails_21e14e2e1d FOREIGN KEY (agency_broker_id) REFERENCES public.agency_brokers(id);


--
-- Name: invoice_items fk_rails_25bf3d2c5e; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT fk_rails_25bf3d2c5e FOREIGN KEY (invoice_id) REFERENCES public.invoices(id);


--
-- Name: motor_insurances fk_rails_284d5e7121; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.motor_insurances
    ADD CONSTRAINT fk_rails_284d5e7121 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- Name: other_insurance_nominees fk_rails_2da340b9f8; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.other_insurance_nominees
    ADD CONSTRAINT fk_rails_2da340b9f8 FOREIGN KEY (other_insurance_id) REFERENCES public.other_insurances(id);


--
-- Name: policies fk_rails_2f51f55afa; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT fk_rails_2f51f55afa FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: solid_queue_recurring_executions fk_rails_318a5533ed; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_recurring_executions
    ADD CONSTRAINT fk_rails_318a5533ed FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: health_insurances fk_rails_3212ef8977; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT fk_rails_3212ef8977 FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- Name: health_insurance_members fk_rails_33b646c0a8; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurance_members
    ADD CONSTRAINT fk_rails_33b646c0a8 FOREIGN KEY (health_insurance_id) REFERENCES public.health_insurances(id);


--
-- Name: health_insurances fk_rails_341cbe5017; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT fk_rails_341cbe5017 FOREIGN KEY (investor_id) REFERENCES public.investors(id);


--
-- Name: other_insurance_documents fk_rails_3814dd1ef3; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.other_insurance_documents
    ADD CONSTRAINT fk_rails_3814dd1ef3 FOREIGN KEY (other_insurance_id) REFERENCES public.other_insurances(id);


--
-- Name: motor_insurance_documents fk_rails_3942837366; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.motor_insurance_documents
    ADD CONSTRAINT fk_rails_3942837366 FOREIGN KEY (motor_insurance_id) REFERENCES public.motor_insurances(id);


--
-- Name: solid_queue_failed_executions fk_rails_39bbc7a631; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_failed_executions
    ADD CONSTRAINT fk_rails_39bbc7a631 FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: distributor_documents fk_rails_3c32118d69; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.distributor_documents
    ADD CONSTRAINT fk_rails_3c32118d69 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- Name: life_insurances fk_rails_417a996493; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurances
    ADD CONSTRAINT fk_rails_417a996493 FOREIGN KEY (agency_code_id) REFERENCES public.agency_codes(id);


--
-- Name: role_permissions fk_rails_439e640a3f; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT fk_rails_439e640a3f FOREIGN KEY (permission_id) REFERENCES public.permissions(id);


--
-- Name: mutual_funds fk_rails_44f95263a3; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.mutual_funds
    ADD CONSTRAINT fk_rails_44f95263a3 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: brokers fk_rails_456e15ca6a; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.brokers
    ADD CONSTRAINT fk_rails_456e15ca6a FOREIGN KEY (insurance_company_id) REFERENCES public.insurance_companies(id);


--
-- Name: life_insurances fk_rails_47498cf3e6; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurances
    ADD CONSTRAINT fk_rails_47498cf3e6 FOREIGN KEY (broker_id) REFERENCES public.brokers(id);


--
-- Name: solid_queue_blocked_executions fk_rails_4cd34e2228; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_blocked_executions
    ADD CONSTRAINT fk_rails_4cd34e2228 FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: policies fk_rails_4f6a17c362; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT fk_rails_4f6a17c362 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: motor_insurances fk_rails_532422c87b; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.motor_insurances
    ADD CONSTRAINT fk_rails_532422c87b FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- Name: sub_agents fk_rails_5638372c18; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.sub_agents
    ADD CONSTRAINT fk_rails_5638372c18 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- Name: motor_insurances fk_rails_58959b2958; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.motor_insurances
    ADD CONSTRAINT fk_rails_58959b2958 FOREIGN KEY (investor_id) REFERENCES public.investors(id);


--
-- Name: policies fk_rails_5cb4dca12a; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT fk_rails_5cb4dca12a FOREIGN KEY (insurance_company_id) REFERENCES public.insurance_companies(id);


--
-- Name: role_permissions fk_rails_60126080bd; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT fk_rails_60126080bd FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: users fk_rails_642f17018b; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_642f17018b FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- Name: family_members fk_rails_66b694a28b; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.family_members
    ADD CONSTRAINT fk_rails_66b694a28b FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: life_insurance_bank_details fk_rails_6ba08ad855; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurance_bank_details
    ADD CONSTRAINT fk_rails_6ba08ad855 FOREIGN KEY (life_insurance_id) REFERENCES public.life_insurances(id);


--
-- Name: life_insurance_nominees fk_rails_6ba3896177; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurance_nominees
    ADD CONSTRAINT fk_rails_6ba3896177 FOREIGN KEY (life_insurance_id) REFERENCES public.life_insurances(id);


--
-- Name: travel_packages fk_rails_7250d92cb6; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.travel_packages
    ADD CONSTRAINT fk_rails_7250d92cb6 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: commission_payouts fk_rails_76f645ffa9; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.commission_payouts
    ADD CONSTRAINT fk_rails_76f645ffa9 FOREIGN KEY (payout_id) REFERENCES public.payouts(id);


--
-- Name: distributor_assignments fk_rails_7be9b91081; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.distributor_assignments
    ADD CONSTRAINT fk_rails_7be9b91081 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- Name: solid_queue_ready_executions fk_rails_81fcbd66af; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_ready_executions
    ADD CONSTRAINT fk_rails_81fcbd66af FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: health_insurances fk_rails_87aeeb6937; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT fk_rails_87aeeb6937 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: appointments fk_rails_882571afb2; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_rails_882571afb2 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: other_insurances fk_rails_8e74cde379; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.other_insurances
    ADD CONSTRAINT fk_rails_8e74cde379 FOREIGN KEY (policy_id) REFERENCES public.policies(id);


--
-- Name: mutual_fund_nominees fk_rails_8f42299122; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.mutual_fund_nominees
    ADD CONSTRAINT fk_rails_8f42299122 FOREIGN KEY (mutual_fund_id) REFERENCES public.mutual_funds(id);


--
-- Name: motor_insurances fk_rails_97d4be159d; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.motor_insurances
    ADD CONSTRAINT fk_rails_97d4be159d FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: solid_queue_claimed_executions fk_rails_9cfe4d4944; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_claimed_executions
    ADD CONSTRAINT fk_rails_9cfe4d4944 FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: life_insurances fk_rails_9f14af9e98; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurances
    ADD CONSTRAINT fk_rails_9f14af9e98 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: user_sessions fk_rails_9fa262d742; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT fk_rails_9fa262d742 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: distributor_assignments fk_rails_a3ef0851ec; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.distributor_assignments
    ADD CONSTRAINT fk_rails_a3ef0851ec FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- Name: agency_codes fk_rails_a59373839c; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.agency_codes
    ADD CONSTRAINT fk_rails_a59373839c FOREIGN KEY (broker_id) REFERENCES public.brokers(id);


--
-- Name: helpdesk_tickets fk_rails_ac69f5f95d; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.helpdesk_tickets
    ADD CONSTRAINT fk_rails_ac69f5f95d FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- Name: health_insurances fk_rails_ad2281368f; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT fk_rails_ad2281368f FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- Name: health_insurances fk_rails_ade27562ab; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT fk_rails_ade27562ab FOREIGN KEY (policy_id) REFERENCES public.policies(id);


--
-- Name: leads fk_rails_b0973b0601; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT fk_rails_b0973b0601 FOREIGN KEY (ambassador_id) REFERENCES public.distributors(id);


--
-- Name: payout_distributions fk_rails_b0a2f7e932; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.payout_distributions
    ADD CONSTRAINT fk_rails_b0a2f7e932 FOREIGN KEY (commission_receipt_id) REFERENCES public.commission_receipts(id);


--
-- Name: corporate_members fk_rails_b43ddda53b; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.corporate_members
    ADD CONSTRAINT fk_rails_b43ddda53b FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: helpdesk_tickets fk_rails_b5418b7db0; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.helpdesk_tickets
    ADD CONSTRAINT fk_rails_b5418b7db0 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: banner_documents fk_rails_ba0255e49a; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.banner_documents
    ADD CONSTRAINT fk_rails_ba0255e49a FOREIGN KEY (banner_id) REFERENCES public.banners(id);


--
-- Name: loans fk_rails_ba3831bab8; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT fk_rails_ba3831bab8 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: motor_insurance_nominees fk_rails_bb9aae8592; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.motor_insurance_nominees
    ADD CONSTRAINT fk_rails_bb9aae8592 FOREIGN KEY (motor_insurance_id) REFERENCES public.motor_insurances(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: solid_queue_scheduled_executions fk_rails_c4316f352d; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.solid_queue_scheduled_executions
    ADD CONSTRAINT fk_rails_c4316f352d FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- Name: investments fk_rails_c8d1342f80; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.investments
    ADD CONSTRAINT fk_rails_c8d1342f80 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: ai_report_histories fk_rails_cfaca47ac5; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.ai_report_histories
    ADD CONSTRAINT fk_rails_cfaca47ac5 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: other_insurances fk_rails_d306e08494; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.other_insurances
    ADD CONSTRAINT fk_rails_d306e08494 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- Name: other_insurances fk_rails_d8deac0a99; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.other_insurances
    ADD CONSTRAINT fk_rails_d8deac0a99 FOREIGN KEY (investor_id) REFERENCES public.investors(id);


--
-- Name: appointments fk_rails_dc29d99253; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_rails_dc29d99253 FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- Name: life_insurances fk_rails_e165c4ce34; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurances
    ADD CONSTRAINT fk_rails_e165c4ce34 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- Name: life_insurances fk_rails_e3b9a67e5b; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurances
    ADD CONSTRAINT fk_rails_e3b9a67e5b FOREIGN KEY (investor_id) REFERENCES public.investors(id);


--
-- Name: health_insurances fk_rails_e565a0ca90; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT fk_rails_e565a0ca90 FOREIGN KEY (broker_id) REFERENCES public.brokers(id);


--
-- Name: health_insurance_documents fk_rails_e78edd3464; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurance_documents
    ADD CONSTRAINT fk_rails_e78edd3464 FOREIGN KEY (health_insurance_id) REFERENCES public.health_insurances(id);


--
-- Name: mutual_funds fk_rails_ec7a2f6153; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.mutual_funds
    ADD CONSTRAINT fk_rails_ec7a2f6153 FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- Name: distributor_payouts fk_rails_f01b58b380; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.distributor_payouts
    ADD CONSTRAINT fk_rails_f01b58b380 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- Name: health_insurances fk_rails_f1c7cc2f76; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT fk_rails_f1c7cc2f76 FOREIGN KEY (agency_code_id) REFERENCES public.agency_codes(id);


--
-- Name: customer_documents fk_rails_f20817c66a; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.customer_documents
    ADD CONSTRAINT fk_rails_f20817c66a FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- Name: motor_insurances fk_rails_f384cbb9a4; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.motor_insurances
    ADD CONSTRAINT fk_rails_f384cbb9a4 FOREIGN KEY (agency_code_id) REFERENCES public.agency_codes(id);


--
-- Name: sub_agent_documents fk_rails_f4389f7b34; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.sub_agent_documents
    ADD CONSTRAINT fk_rails_f4389f7b34 FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- Name: investor_documents fk_rails_f77eb37bb8; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.investor_documents
    ADD CONSTRAINT fk_rails_f77eb37bb8 FOREIGN KEY (investor_id) REFERENCES public.investors(id);


--
-- Name: life_insurances fk_rails_f9ebb4eb0d; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurances
    ADD CONSTRAINT fk_rails_f9ebb4eb0d FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- Name: mutual_funds fk_rails_fa6b5a2241; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.mutual_funds
    ADD CONSTRAINT fk_rails_fa6b5a2241 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- Name: users fk_rails_fa83e8f093; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_fa83e8f093 FOREIGN KEY (user_role_id) REFERENCES public.user_roles(id);


--
-- Name: life_insurance_documents fk_rails_fe30481887; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.life_insurance_documents
    ADD CONSTRAINT fk_rails_fe30481887 FOREIGN KEY (life_insurance_id) REFERENCES public.life_insurances(id);


--
-- Name: health_insurances health_insurances_original_policy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: drwisedb01_user
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT health_insurances_original_policy_id_fkey FOREIGN KEY (original_policy_id) REFERENCES public.health_insurances(id);


--
-- Name: dashboard_stats_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: drwisedb01_user
--

REFRESH MATERIALIZED VIEW public.dashboard_stats_view;


--
-- PostgreSQL database dump complete
--

\unrestrict GIhzTnVexQFIc3dACSQGxZIT1k94jR3BAvNUKQZPebVZNWHtdbOs7zzlPS2fyK3

