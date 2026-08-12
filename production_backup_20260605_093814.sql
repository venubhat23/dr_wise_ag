--
-- PostgreSQL database dump
--

\restrict 4vPRe6fbNg09O2GWJVhWWPaMnOlorlPY3yIfTfLXOJB8fLMSsPbGbKJrKsqEWIe

-- Dumped from database version 18.3 (Debian 18.3-1.pgdg12+1)
-- Dumped by pg_dump version 18.3 (Ubuntu 18.3-1.pgdg24.04+1)

-- Started on 2026-06-05 09:38:14 IST

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
-- TOC entry 2 (class 3079 OID 19555)
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- TOC entry 4811 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- TOC entry 402 (class 1255 OID 19417)
-- Name: refresh_dashboard_stats_view(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.refresh_dashboard_stats_view() RETURNS void
    LANGUAGE plpgsql
    AS $$
      BEGIN
        REFRESH MATERIALIZED VIEW CONCURRENTLY dashboard_stats_view;
      END;
      $$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 245 (class 1259 OID 18128)
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- TOC entry 244 (class 1259 OID 18127)
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4812 (class 0 OID 0)
-- Dependencies: 244
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- TOC entry 243 (class 1259 OID 18112)
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 242 (class 1259 OID 18111)
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4813 (class 0 OID 0)
-- Dependencies: 242
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- TOC entry 247 (class 1259 OID 18150)
-- Name: active_storage_variant_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_variant_records (
    id bigint NOT NULL,
    blob_id bigint NOT NULL,
    variation_digest character varying NOT NULL
);


--
-- TOC entry 246 (class 1259 OID 18149)
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_variant_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4814 (class 0 OID 0)
-- Dependencies: 246
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_variant_records_id_seq OWNED BY public.active_storage_variant_records.id;


--
-- TOC entry 231 (class 1259 OID 17972)
-- Name: agency_brokers; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 230 (class 1259 OID 17971)
-- Name: agency_brokers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.agency_brokers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4815 (class 0 OID 0)
-- Dependencies: 230
-- Name: agency_brokers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.agency_brokers_id_seq OWNED BY public.agency_brokers.id;


--
-- TOC entry 257 (class 1259 OID 18249)
-- Name: agency_codes; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 256 (class 1259 OID 18248)
-- Name: agency_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.agency_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4816 (class 0 OID 0)
-- Dependencies: 256
-- Name: agency_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.agency_codes_id_seq OWNED BY public.agency_codes.id;


--
-- TOC entry 333 (class 1259 OID 19331)
-- Name: ahoy_events; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ahoy_events (
    id bigint NOT NULL,
    visit_id bigint,
    user_id bigint,
    name character varying,
    properties jsonb,
    "time" timestamp(6) without time zone
);


--
-- TOC entry 332 (class 1259 OID 19330)
-- Name: ahoy_events_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ahoy_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4817 (class 0 OID 0)
-- Dependencies: 332
-- Name: ahoy_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ahoy_events_id_seq OWNED BY public.ahoy_events.id;


--
-- TOC entry 331 (class 1259 OID 19318)
-- Name: ahoy_visits; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 330 (class 1259 OID 19317)
-- Name: ahoy_visits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ahoy_visits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4818 (class 0 OID 0)
-- Dependencies: 330
-- Name: ahoy_visits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ahoy_visits_id_seq OWNED BY public.ahoy_visits.id;


--
-- TOC entry 321 (class 1259 OID 19216)
-- Name: ai_report_histories; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 320 (class 1259 OID 19215)
-- Name: ai_report_histories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ai_report_histories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4819 (class 0 OID 0)
-- Dependencies: 320
-- Name: ai_report_histories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ai_report_histories_id_seq OWNED BY public.ai_report_histories.id;


--
-- TOC entry 327 (class 1259 OID 19280)
-- Name: all_policy_reports; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 326 (class 1259 OID 19279)
-- Name: all_policy_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.all_policy_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4820 (class 0 OID 0)
-- Dependencies: 326
-- Name: all_policy_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.all_policy_reports_id_seq OWNED BY public.all_policy_reports.id;


--
-- TOC entry 323 (class 1259 OID 19255)
-- Name: analytics_caches; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.analytics_caches (
    id bigint NOT NULL,
    cache_identifier character varying,
    cache_data text,
    last_updated timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- TOC entry 322 (class 1259 OID 19254)
-- Name: analytics_caches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.analytics_caches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4821 (class 0 OID 0)
-- Dependencies: 322
-- Name: analytics_caches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.analytics_caches_id_seq OWNED BY public.analytics_caches.id;


--
-- TOC entry 388 (class 1259 OID 20842)
-- Name: appointments; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 387 (class 1259 OID 20841)
-- Name: appointments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.appointments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4822 (class 0 OID 0)
-- Dependencies: 387
-- Name: appointments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.appointments_id_seq OWNED BY public.appointments.id;


--
-- TOC entry 221 (class 1259 OID 17906)
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- TOC entry 352 (class 1259 OID 19683)
-- Name: banner_documents; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 351 (class 1259 OID 19682)
-- Name: banner_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.banner_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4823 (class 0 OID 0)
-- Dependencies: 351
-- Name: banner_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.banner_documents_id_seq OWNED BY public.banner_documents.id;


--
-- TOC entry 273 (class 1259 OID 18585)
-- Name: banners; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 272 (class 1259 OID 18584)
-- Name: banners_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.banners_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4824 (class 0 OID 0)
-- Dependencies: 272
-- Name: banners_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.banners_id_seq OWNED BY public.banners.id;


--
-- TOC entry 319 (class 1259 OID 19191)
-- Name: broker_codes; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 318 (class 1259 OID 19190)
-- Name: broker_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.broker_codes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4825 (class 0 OID 0)
-- Dependencies: 318
-- Name: broker_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.broker_codes_id_seq OWNED BY public.broker_codes.id;


--
-- TOC entry 259 (class 1259 OID 18261)
-- Name: brokers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.brokers (
    id bigint NOT NULL,
    name character varying NOT NULL,
    status character varying DEFAULT 'active'::character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    insurance_company_id bigint
);


--
-- TOC entry 258 (class 1259 OID 18260)
-- Name: brokers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.brokers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4826 (class 0 OID 0)
-- Dependencies: 258
-- Name: brokers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.brokers_id_seq OWNED BY public.brokers.id;


--
-- TOC entry 265 (class 1259 OID 18463)
-- Name: client_requests; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 264 (class 1259 OID 18462)
-- Name: client_requests_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.client_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4827 (class 0 OID 0)
-- Dependencies: 264
-- Name: client_requests_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.client_requests_id_seq OWNED BY public.client_requests.id;


--
-- TOC entry 390 (class 1259 OID 20911)
-- Name: client_services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.client_services (
    id bigint NOT NULL,
    service_type character varying NOT NULL,
    service_category character varying NOT NULL,
    customer_id bigint NOT NULL,
    sub_agent_id bigint,
    distributor_id bigint,
    amount numeric(15,2) DEFAULT 0.0,
    status character varying DEFAULT 'pending'::character varying,
    reference_number character varying,
    start_date date,
    notes text,
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
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- TOC entry 389 (class 1259 OID 20910)
-- Name: client_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.client_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4828 (class 0 OID 0)
-- Dependencies: 389
-- Name: client_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.client_services_id_seq OWNED BY public.client_services.id;


--
-- TOC entry 293 (class 1259 OID 18828)
-- Name: commission_payouts; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 292 (class 1259 OID 18827)
-- Name: commission_payouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.commission_payouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4829 (class 0 OID 0)
-- Dependencies: 292
-- Name: commission_payouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.commission_payouts_id_seq OWNED BY public.commission_payouts.id;


--
-- TOC entry 295 (class 1259 OID 18840)
-- Name: commission_receipts; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 294 (class 1259 OID 18839)
-- Name: commission_receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.commission_receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4830 (class 0 OID 0)
-- Dependencies: 294
-- Name: commission_receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.commission_receipts_id_seq OWNED BY public.commission_receipts.id;


--
-- TOC entry 249 (class 1259 OID 18172)
-- Name: corporate_members; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 248 (class 1259 OID 18171)
-- Name: corporate_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.corporate_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4831 (class 0 OID 0)
-- Dependencies: 248
-- Name: corporate_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.corporate_members_id_seq OWNED BY public.corporate_members.id;


--
-- TOC entry 317 (class 1259 OID 19164)
-- Name: customer_documents; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 316 (class 1259 OID 19163)
-- Name: customer_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customer_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4832 (class 0 OID 0)
-- Dependencies: 316
-- Name: customer_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customer_documents_id_seq OWNED BY public.customer_documents.id;


--
-- TOC entry 225 (class 1259 OID 17929)
-- Name: customers; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 224 (class 1259 OID 17928)
-- Name: customers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.customers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4833 (class 0 OID 0)
-- Dependencies: 224
-- Name: customers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.customers_id_seq OWNED BY public.customers.id;


--
-- TOC entry 277 (class 1259 OID 18656)
-- Name: distributors; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 235 (class 1259 OID 18043)
-- Name: health_insurances; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 241 (class 1259 OID 18100)
-- Name: leads; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 263 (class 1259 OID 18392)
-- Name: life_insurances; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 237 (class 1259 OID 18062)
-- Name: motor_insurances; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 253 (class 1259 OID 18206)
-- Name: sub_agents; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 336 (class 1259 OID 19418)
-- Name: dashboard_stats_view; Type: MATERIALIZED VIEW; Schema: public; Owner: -
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


--
-- TOC entry 301 (class 1259 OID 18920)
-- Name: distributor_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.distributor_assignments (
    id bigint NOT NULL,
    distributor_id bigint NOT NULL,
    sub_agent_id bigint NOT NULL,
    assigned_at timestamp(6) without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- TOC entry 300 (class 1259 OID 18919)
-- Name: distributor_assignments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.distributor_assignments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4834 (class 0 OID 0)
-- Dependencies: 300
-- Name: distributor_assignments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.distributor_assignments_id_seq OWNED BY public.distributor_assignments.id;


--
-- TOC entry 279 (class 1259 OID 18678)
-- Name: distributor_documents; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 278 (class 1259 OID 18677)
-- Name: distributor_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.distributor_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4835 (class 0 OID 0)
-- Dependencies: 278
-- Name: distributor_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.distributor_documents_id_seq OWNED BY public.distributor_documents.id;


--
-- TOC entry 311 (class 1259 OID 19063)
-- Name: distributor_payouts; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 310 (class 1259 OID 19062)
-- Name: distributor_payouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.distributor_payouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4836 (class 0 OID 0)
-- Dependencies: 310
-- Name: distributor_payouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.distributor_payouts_id_seq OWNED BY public.distributor_payouts.id;


--
-- TOC entry 276 (class 1259 OID 18655)
-- Name: distributors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.distributors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4837 (class 0 OID 0)
-- Dependencies: 276
-- Name: distributors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.distributors_id_seq OWNED BY public.distributors.id;


--
-- TOC entry 251 (class 1259 OID 18191)
-- Name: documents; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 250 (class 1259 OID 18190)
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4838 (class 0 OID 0)
-- Dependencies: 250
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- TOC entry 227 (class 1259 OID 17941)
-- Name: family_members; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 226 (class 1259 OID 17940)
-- Name: family_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.family_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4839 (class 0 OID 0)
-- Dependencies: 226
-- Name: family_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.family_members_id_seq OWNED BY public.family_members.id;


--
-- TOC entry 356 (class 1259 OID 19742)
-- Name: health_insurance_documents; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 355 (class 1259 OID 19741)
-- Name: health_insurance_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.health_insurance_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4840 (class 0 OID 0)
-- Dependencies: 355
-- Name: health_insurance_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.health_insurance_documents_id_seq OWNED BY public.health_insurance_documents.id;


--
-- TOC entry 261 (class 1259 OID 18301)
-- Name: health_insurance_members; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 260 (class 1259 OID 18300)
-- Name: health_insurance_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.health_insurance_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4841 (class 0 OID 0)
-- Dependencies: 260
-- Name: health_insurance_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.health_insurance_members_id_seq OWNED BY public.health_insurance_members.id;


--
-- TOC entry 342 (class 1259 OID 19495)
-- Name: health_insurance_nominees; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 341 (class 1259 OID 19494)
-- Name: health_insurance_nominees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.health_insurance_nominees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4842 (class 0 OID 0)
-- Dependencies: 341
-- Name: health_insurance_nominees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.health_insurance_nominees_id_seq OWNED BY public.health_insurance_nominees.id;


--
-- TOC entry 234 (class 1259 OID 18042)
-- Name: health_insurances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.health_insurances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4843 (class 0 OID 0)
-- Dependencies: 234
-- Name: health_insurances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.health_insurances_id_seq OWNED BY public.health_insurances.id;


--
-- TOC entry 338 (class 1259 OID 19444)
-- Name: helpdesk_tickets; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 337 (class 1259 OID 19443)
-- Name: helpdesk_tickets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.helpdesk_tickets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4844 (class 0 OID 0)
-- Dependencies: 337
-- Name: helpdesk_tickets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.helpdesk_tickets_id_seq OWNED BY public.helpdesk_tickets.id;


--
-- TOC entry 229 (class 1259 OID 17960)
-- Name: insurance_companies; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 228 (class 1259 OID 17959)
-- Name: insurance_companies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.insurance_companies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4845 (class 0 OID 0)
-- Dependencies: 228
-- Name: insurance_companies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.insurance_companies_id_seq OWNED BY public.insurance_companies.id;


--
-- TOC entry 303 (class 1259 OID 18987)
-- Name: investments; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 302 (class 1259 OID 18986)
-- Name: investments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.investments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4846 (class 0 OID 0)
-- Dependencies: 302
-- Name: investments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.investments_id_seq OWNED BY public.investments.id;


--
-- TOC entry 285 (class 1259 OID 18733)
-- Name: investor_documents; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 284 (class 1259 OID 18732)
-- Name: investor_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.investor_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4847 (class 0 OID 0)
-- Dependencies: 284
-- Name: investor_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.investor_documents_id_seq OWNED BY public.investor_documents.id;


--
-- TOC entry 283 (class 1259 OID 18711)
-- Name: investors; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 282 (class 1259 OID 18710)
-- Name: investors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.investors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4848 (class 0 OID 0)
-- Dependencies: 282
-- Name: investors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.investors_id_seq OWNED BY public.investors.id;


--
-- TOC entry 340 (class 1259 OID 19476)
-- Name: invoice_items; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 339 (class 1259 OID 19475)
-- Name: invoice_items_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoice_items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4849 (class 0 OID 0)
-- Dependencies: 339
-- Name: invoice_items_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoice_items_id_seq OWNED BY public.invoice_items.id;


--
-- TOC entry 315 (class 1259 OID 19138)
-- Name: invoices; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 314 (class 1259 OID 19137)
-- Name: invoices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invoices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4850 (class 0 OID 0)
-- Dependencies: 314
-- Name: invoices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invoices_id_seq OWNED BY public.invoices.id;


--
-- TOC entry 240 (class 1259 OID 18099)
-- Name: leads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.leads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4851 (class 0 OID 0)
-- Dependencies: 240
-- Name: leads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.leads_id_seq OWNED BY public.leads.id;


--
-- TOC entry 289 (class 1259 OID 18790)
-- Name: life_insurance_bank_details; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 288 (class 1259 OID 18789)
-- Name: life_insurance_bank_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.life_insurance_bank_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4852 (class 0 OID 0)
-- Dependencies: 288
-- Name: life_insurance_bank_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.life_insurance_bank_details_id_seq OWNED BY public.life_insurance_bank_details.id;


--
-- TOC entry 291 (class 1259 OID 18809)
-- Name: life_insurance_documents; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.life_insurance_documents (
    id bigint NOT NULL,
    life_insurance_id bigint NOT NULL,
    document_type character varying,
    document_name character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- TOC entry 290 (class 1259 OID 18808)
-- Name: life_insurance_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.life_insurance_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4853 (class 0 OID 0)
-- Dependencies: 290
-- Name: life_insurance_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.life_insurance_documents_id_seq OWNED BY public.life_insurance_documents.id;


--
-- TOC entry 287 (class 1259 OID 18771)
-- Name: life_insurance_nominees; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 286 (class 1259 OID 18770)
-- Name: life_insurance_nominees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.life_insurance_nominees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4854 (class 0 OID 0)
-- Dependencies: 286
-- Name: life_insurance_nominees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.life_insurance_nominees_id_seq OWNED BY public.life_insurance_nominees.id;


--
-- TOC entry 262 (class 1259 OID 18391)
-- Name: life_insurances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.life_insurances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4855 (class 0 OID 0)
-- Dependencies: 262
-- Name: life_insurances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.life_insurances_id_seq OWNED BY public.life_insurances.id;


--
-- TOC entry 305 (class 1259 OID 19006)
-- Name: loans; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 304 (class 1259 OID 19005)
-- Name: loans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.loans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4856 (class 0 OID 0)
-- Dependencies: 304
-- Name: loans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.loans_id_seq OWNED BY public.loans.id;


--
-- TOC entry 350 (class 1259 OID 19664)
-- Name: motor_insurance_documents; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 349 (class 1259 OID 19663)
-- Name: motor_insurance_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.motor_insurance_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4857 (class 0 OID 0)
-- Dependencies: 349
-- Name: motor_insurance_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.motor_insurance_documents_id_seq OWNED BY public.motor_insurance_documents.id;


--
-- TOC entry 346 (class 1259 OID 19533)
-- Name: motor_insurance_nominees; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 345 (class 1259 OID 19532)
-- Name: motor_insurance_nominees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.motor_insurance_nominees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4858 (class 0 OID 0)
-- Dependencies: 345
-- Name: motor_insurance_nominees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.motor_insurance_nominees_id_seq OWNED BY public.motor_insurance_nominees.id;


--
-- TOC entry 236 (class 1259 OID 18061)
-- Name: motor_insurances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.motor_insurances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4859 (class 0 OID 0)
-- Dependencies: 236
-- Name: motor_insurances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.motor_insurances_id_seq OWNED BY public.motor_insurances.id;


--
-- TOC entry 386 (class 1259 OID 20818)
-- Name: mutual_fund_nominees; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 385 (class 1259 OID 20817)
-- Name: mutual_fund_nominees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mutual_fund_nominees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4860 (class 0 OID 0)
-- Dependencies: 385
-- Name: mutual_fund_nominees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mutual_fund_nominees_id_seq OWNED BY public.mutual_fund_nominees.id;


--
-- TOC entry 384 (class 1259 OID 20757)
-- Name: mutual_funds; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 383 (class 1259 OID 20756)
-- Name: mutual_funds_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mutual_funds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4861 (class 0 OID 0)
-- Dependencies: 383
-- Name: mutual_funds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mutual_funds_id_seq OWNED BY public.mutual_funds.id;


--
-- TOC entry 358 (class 1259 OID 19761)
-- Name: notifications; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 357 (class 1259 OID 19760)
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4862 (class 0 OID 0)
-- Dependencies: 357
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- TOC entry 354 (class 1259 OID 19702)
-- Name: other_insurance_documents; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 353 (class 1259 OID 19701)
-- Name: other_insurance_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.other_insurance_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4863 (class 0 OID 0)
-- Dependencies: 353
-- Name: other_insurance_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.other_insurance_documents_id_seq OWNED BY public.other_insurance_documents.id;


--
-- TOC entry 344 (class 1259 OID 19514)
-- Name: other_insurance_nominees; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 343 (class 1259 OID 19513)
-- Name: other_insurance_nominees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.other_insurance_nominees_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4864 (class 0 OID 0)
-- Dependencies: 343
-- Name: other_insurance_nominees_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.other_insurance_nominees_id_seq OWNED BY public.other_insurance_nominees.id;


--
-- TOC entry 239 (class 1259 OID 18081)
-- Name: other_insurances; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 238 (class 1259 OID 18080)
-- Name: other_insurances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.other_insurances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4865 (class 0 OID 0)
-- Dependencies: 238
-- Name: other_insurances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.other_insurances_id_seq OWNED BY public.other_insurances.id;


--
-- TOC entry 299 (class 1259 OID 18882)
-- Name: payout_audit_logs; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 298 (class 1259 OID 18881)
-- Name: payout_audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payout_audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4866 (class 0 OID 0)
-- Dependencies: 298
-- Name: payout_audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payout_audit_logs_id_seq OWNED BY public.payout_audit_logs.id;


--
-- TOC entry 297 (class 1259 OID 18857)
-- Name: payout_distributions; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 296 (class 1259 OID 18856)
-- Name: payout_distributions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payout_distributions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4867 (class 0 OID 0)
-- Dependencies: 296
-- Name: payout_distributions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payout_distributions_id_seq OWNED BY public.payout_distributions.id;


--
-- TOC entry 313 (class 1259 OID 19086)
-- Name: payouts; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 312 (class 1259 OID 19085)
-- Name: payouts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payouts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4868 (class 0 OID 0)
-- Dependencies: 312
-- Name: payouts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payouts_id_seq OWNED BY public.payouts.id;


--
-- TOC entry 269 (class 1259 OID 18533)
-- Name: permissions; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 268 (class 1259 OID 18532)
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4869 (class 0 OID 0)
-- Dependencies: 268
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- TOC entry 233 (class 1259 OID 17984)
-- Name: policies; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 232 (class 1259 OID 17983)
-- Name: policies_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.policies_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4870 (class 0 OID 0)
-- Dependencies: 232
-- Name: policies_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.policies_id_seq OWNED BY public.policies.id;


--
-- TOC entry 348 (class 1259 OID 19645)
-- Name: policy_documents; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 347 (class 1259 OID 19644)
-- Name: policy_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.policy_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4871 (class 0 OID 0)
-- Dependencies: 347
-- Name: policy_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.policy_documents_id_seq OWNED BY public.policy_documents.id;


--
-- TOC entry 325 (class 1259 OID 19268)
-- Name: reports; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 324 (class 1259 OID 19267)
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4872 (class 0 OID 0)
-- Dependencies: 324
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reports_id_seq OWNED BY public.reports.id;


--
-- TOC entry 271 (class 1259 OID 18551)
-- Name: role_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_permissions (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    permission_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- TOC entry 270 (class 1259 OID 18550)
-- Name: role_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.role_permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4873 (class 0 OID 0)
-- Dependencies: 270
-- Name: role_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.role_permissions_id_seq OWNED BY public.role_permissions.id;


--
-- TOC entry 267 (class 1259 OID 18516)
-- Name: roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    status boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- TOC entry 266 (class 1259 OID 18515)
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4874 (class 0 OID 0)
-- Dependencies: 266
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- TOC entry 220 (class 1259 OID 17898)
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- TOC entry 335 (class 1259 OID 19345)
-- Name: session_activities; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 334 (class 1259 OID 19344)
-- Name: session_activities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.session_activities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4875 (class 0 OID 0)
-- Dependencies: 334
-- Name: session_activities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.session_activities_id_seq OWNED BY public.session_activities.id;


--
-- TOC entry 360 (class 1259 OID 19785)
-- Name: solid_cache_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_cache_entries (
    id bigint NOT NULL,
    key bytea NOT NULL,
    value bytea NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    key_hash bigint NOT NULL,
    byte_size integer NOT NULL
);


--
-- TOC entry 359 (class 1259 OID 19784)
-- Name: solid_cache_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_cache_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4876 (class 0 OID 0)
-- Dependencies: 359
-- Name: solid_cache_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_cache_entries_id_seq OWNED BY public.solid_cache_entries.id;


--
-- TOC entry 364 (class 1259 OID 20542)
-- Name: solid_queue_blocked_executions; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 363 (class 1259 OID 20541)
-- Name: solid_queue_blocked_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_blocked_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4877 (class 0 OID 0)
-- Dependencies: 363
-- Name: solid_queue_blocked_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_blocked_executions_id_seq OWNED BY public.solid_queue_blocked_executions.id;


--
-- TOC entry 366 (class 1259 OID 20562)
-- Name: solid_queue_claimed_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_claimed_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    process_id bigint,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- TOC entry 365 (class 1259 OID 20561)
-- Name: solid_queue_claimed_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_claimed_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4878 (class 0 OID 0)
-- Dependencies: 365
-- Name: solid_queue_claimed_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_claimed_executions_id_seq OWNED BY public.solid_queue_claimed_executions.id;


--
-- TOC entry 368 (class 1259 OID 20574)
-- Name: solid_queue_failed_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_failed_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    error text,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- TOC entry 367 (class 1259 OID 20573)
-- Name: solid_queue_failed_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_failed_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4879 (class 0 OID 0)
-- Dependencies: 367
-- Name: solid_queue_failed_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_failed_executions_id_seq OWNED BY public.solid_queue_failed_executions.id;


--
-- TOC entry 362 (class 1259 OID 20521)
-- Name: solid_queue_jobs; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 361 (class 1259 OID 20520)
-- Name: solid_queue_jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4880 (class 0 OID 0)
-- Dependencies: 361
-- Name: solid_queue_jobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_jobs_id_seq OWNED BY public.solid_queue_jobs.id;


--
-- TOC entry 370 (class 1259 OID 20587)
-- Name: solid_queue_pauses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_pauses (
    id bigint NOT NULL,
    queue_name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- TOC entry 369 (class 1259 OID 20586)
-- Name: solid_queue_pauses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_pauses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4881 (class 0 OID 0)
-- Dependencies: 369
-- Name: solid_queue_pauses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_pauses_id_seq OWNED BY public.solid_queue_pauses.id;


--
-- TOC entry 372 (class 1259 OID 20600)
-- Name: solid_queue_processes; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 371 (class 1259 OID 20599)
-- Name: solid_queue_processes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_processes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4882 (class 0 OID 0)
-- Dependencies: 371
-- Name: solid_queue_processes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_processes_id_seq OWNED BY public.solid_queue_processes.id;


--
-- TOC entry 374 (class 1259 OID 20618)
-- Name: solid_queue_ready_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_ready_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    queue_name character varying NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- TOC entry 373 (class 1259 OID 20617)
-- Name: solid_queue_ready_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_ready_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4883 (class 0 OID 0)
-- Dependencies: 373
-- Name: solid_queue_ready_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_ready_executions_id_seq OWNED BY public.solid_queue_ready_executions.id;


--
-- TOC entry 376 (class 1259 OID 20636)
-- Name: solid_queue_recurring_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_recurring_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    task_key character varying NOT NULL,
    run_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- TOC entry 375 (class 1259 OID 20635)
-- Name: solid_queue_recurring_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_recurring_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4884 (class 0 OID 0)
-- Dependencies: 375
-- Name: solid_queue_recurring_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_recurring_executions_id_seq OWNED BY public.solid_queue_recurring_executions.id;


--
-- TOC entry 378 (class 1259 OID 20652)
-- Name: solid_queue_recurring_tasks; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 377 (class 1259 OID 20651)
-- Name: solid_queue_recurring_tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_recurring_tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4885 (class 0 OID 0)
-- Dependencies: 377
-- Name: solid_queue_recurring_tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_recurring_tasks_id_seq OWNED BY public.solid_queue_recurring_tasks.id;


--
-- TOC entry 380 (class 1259 OID 20671)
-- Name: solid_queue_scheduled_executions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_scheduled_executions (
    id bigint NOT NULL,
    job_id bigint NOT NULL,
    queue_name character varying NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    scheduled_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL
);


--
-- TOC entry 379 (class 1259 OID 20670)
-- Name: solid_queue_scheduled_executions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_scheduled_executions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4886 (class 0 OID 0)
-- Dependencies: 379
-- Name: solid_queue_scheduled_executions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_scheduled_executions_id_seq OWNED BY public.solid_queue_scheduled_executions.id;


--
-- TOC entry 382 (class 1259 OID 20689)
-- Name: solid_queue_semaphores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.solid_queue_semaphores (
    id bigint NOT NULL,
    key character varying NOT NULL,
    value integer DEFAULT 1 NOT NULL,
    expires_at timestamp(6) without time zone NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- TOC entry 381 (class 1259 OID 20688)
-- Name: solid_queue_semaphores_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.solid_queue_semaphores_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4887 (class 0 OID 0)
-- Dependencies: 381
-- Name: solid_queue_semaphores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.solid_queue_semaphores_id_seq OWNED BY public.solid_queue_semaphores.id;


--
-- TOC entry 255 (class 1259 OID 18228)
-- Name: sub_agent_documents; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 254 (class 1259 OID 18227)
-- Name: sub_agent_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sub_agent_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4888 (class 0 OID 0)
-- Dependencies: 254
-- Name: sub_agent_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sub_agent_documents_id_seq OWNED BY public.sub_agent_documents.id;


--
-- TOC entry 252 (class 1259 OID 18205)
-- Name: sub_agents_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sub_agents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4889 (class 0 OID 0)
-- Dependencies: 252
-- Name: sub_agents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sub_agents_id_seq OWNED BY public.sub_agents.id;


--
-- TOC entry 281 (class 1259 OID 18697)
-- Name: system_settings; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 280 (class 1259 OID 18696)
-- Name: system_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.system_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4890 (class 0 OID 0)
-- Dependencies: 280
-- Name: system_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.system_settings_id_seq OWNED BY public.system_settings.id;


--
-- TOC entry 307 (class 1259 OID 19025)
-- Name: tax_services; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 306 (class 1259 OID 19024)
-- Name: tax_services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.tax_services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4891 (class 0 OID 0)
-- Dependencies: 306
-- Name: tax_services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.tax_services_id_seq OWNED BY public.tax_services.id;


--
-- TOC entry 309 (class 1259 OID 19044)
-- Name: travel_packages; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 308 (class 1259 OID 19043)
-- Name: travel_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.travel_packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4892 (class 0 OID 0)
-- Dependencies: 308
-- Name: travel_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.travel_packages_id_seq OWNED BY public.travel_packages.id;


--
-- TOC entry 275 (class 1259 OID 18599)
-- Name: user_roles; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 274 (class 1259 OID 18598)
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4893 (class 0 OID 0)
-- Dependencies: 274
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_roles_id_seq OWNED BY public.user_roles.id;


--
-- TOC entry 329 (class 1259 OID 19292)
-- Name: user_sessions; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 328 (class 1259 OID 19291)
-- Name: user_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_sessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4894 (class 0 OID 0)
-- Dependencies: 328
-- Name: user_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_sessions_id_seq OWNED BY public.user_sessions.id;


--
-- TOC entry 223 (class 1259 OID 17917)
-- Name: users; Type: TABLE; Schema: public; Owner: -
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


--
-- TOC entry 4895 (class 0 OID 0)
-- Dependencies: 223
-- Name: COLUMN users.password_reset_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.password_reset_at IS 'When password was last reset';


--
-- TOC entry 222 (class 1259 OID 17916)
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4896 (class 0 OID 0)
-- Dependencies: 222
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- TOC entry 3743 (class 2604 OID 18131)
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- TOC entry 3742 (class 2604 OID 18115)
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- TOC entry 3744 (class 2604 OID 18153)
-- Name: active_storage_variant_records id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records ALTER COLUMN id SET DEFAULT nextval('public.active_storage_variant_records_id_seq'::regclass);


--
-- TOC entry 3709 (class 2604 OID 17975)
-- Name: agency_brokers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agency_brokers ALTER COLUMN id SET DEFAULT nextval('public.agency_brokers_id_seq'::regclass);


--
-- TOC entry 3751 (class 2604 OID 18252)
-- Name: agency_codes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agency_codes ALTER COLUMN id SET DEFAULT nextval('public.agency_codes_id_seq'::regclass);


--
-- TOC entry 3840 (class 2604 OID 19334)
-- Name: ahoy_events id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_events ALTER COLUMN id SET DEFAULT nextval('public.ahoy_events_id_seq'::regclass);


--
-- TOC entry 3839 (class 2604 OID 19321)
-- Name: ahoy_visits id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_visits ALTER COLUMN id SET DEFAULT nextval('public.ahoy_visits_id_seq'::regclass);


--
-- TOC entry 3833 (class 2604 OID 19219)
-- Name: ai_report_histories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_report_histories ALTER COLUMN id SET DEFAULT nextval('public.ai_report_histories_id_seq'::regclass);


--
-- TOC entry 3836 (class 2604 OID 19283)
-- Name: all_policy_reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.all_policy_reports ALTER COLUMN id SET DEFAULT nextval('public.all_policy_reports_id_seq'::regclass);


--
-- TOC entry 3834 (class 2604 OID 19258)
-- Name: analytics_caches id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.analytics_caches ALTER COLUMN id SET DEFAULT nextval('public.analytics_caches_id_seq'::regclass);


--
-- TOC entry 3902 (class 2604 OID 20845)
-- Name: appointments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments ALTER COLUMN id SET DEFAULT nextval('public.appointments_id_seq'::regclass);


--
-- TOC entry 3849 (class 2604 OID 19686)
-- Name: banner_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.banner_documents ALTER COLUMN id SET DEFAULT nextval('public.banner_documents_id_seq'::regclass);


--
-- TOC entry 3793 (class 2604 OID 18588)
-- Name: banners id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.banners ALTER COLUMN id SET DEFAULT nextval('public.banners_id_seq'::regclass);


--
-- TOC entry 3832 (class 2604 OID 19194)
-- Name: broker_codes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broker_codes ALTER COLUMN id SET DEFAULT nextval('public.broker_codes_id_seq'::regclass);


--
-- TOC entry 3752 (class 2604 OID 18264)
-- Name: brokers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brokers ALTER COLUMN id SET DEFAULT nextval('public.brokers_id_seq'::regclass);


--
-- TOC entry 3786 (class 2604 OID 18466)
-- Name: client_requests id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_requests ALTER COLUMN id SET DEFAULT nextval('public.client_requests_id_seq'::regclass);


--
-- TOC entry 3904 (class 2604 OID 20914)
-- Name: client_services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_services ALTER COLUMN id SET DEFAULT nextval('public.client_services_id_seq'::regclass);


--
-- TOC entry 3811 (class 2604 OID 18831)
-- Name: commission_payouts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commission_payouts ALTER COLUMN id SET DEFAULT nextval('public.commission_payouts_id_seq'::regclass);


--
-- TOC entry 3813 (class 2604 OID 18843)
-- Name: commission_receipts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commission_receipts ALTER COLUMN id SET DEFAULT nextval('public.commission_receipts_id_seq'::regclass);


--
-- TOC entry 3745 (class 2604 OID 18175)
-- Name: corporate_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.corporate_members ALTER COLUMN id SET DEFAULT nextval('public.corporate_members_id_seq'::regclass);


--
-- TOC entry 3831 (class 2604 OID 19167)
-- Name: customer_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_documents ALTER COLUMN id SET DEFAULT nextval('public.customer_documents_id_seq'::regclass);


--
-- TOC entry 3703 (class 2604 OID 17932)
-- Name: customers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers ALTER COLUMN id SET DEFAULT nextval('public.customers_id_seq'::regclass);


--
-- TOC entry 3820 (class 2604 OID 18923)
-- Name: distributor_assignments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_assignments ALTER COLUMN id SET DEFAULT nextval('public.distributor_assignments_id_seq'::regclass);


--
-- TOC entry 3802 (class 2604 OID 18681)
-- Name: distributor_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_documents ALTER COLUMN id SET DEFAULT nextval('public.distributor_documents_id_seq'::regclass);


--
-- TOC entry 3825 (class 2604 OID 19066)
-- Name: distributor_payouts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_payouts ALTER COLUMN id SET DEFAULT nextval('public.distributor_payouts_id_seq'::regclass);


--
-- TOC entry 3798 (class 2604 OID 18659)
-- Name: distributors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributors ALTER COLUMN id SET DEFAULT nextval('public.distributors_id_seq'::regclass);


--
-- TOC entry 3746 (class 2604 OID 18194)
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- TOC entry 3707 (class 2604 OID 17944)
-- Name: family_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.family_members ALTER COLUMN id SET DEFAULT nextval('public.family_members_id_seq'::regclass);


--
-- TOC entry 3851 (class 2604 OID 19745)
-- Name: health_insurance_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurance_documents ALTER COLUMN id SET DEFAULT nextval('public.health_insurance_documents_id_seq'::regclass);


--
-- TOC entry 3754 (class 2604 OID 18304)
-- Name: health_insurance_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurance_members ALTER COLUMN id SET DEFAULT nextval('public.health_insurance_members_id_seq'::regclass);


--
-- TOC entry 3844 (class 2604 OID 19498)
-- Name: health_insurance_nominees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurance_nominees ALTER COLUMN id SET DEFAULT nextval('public.health_insurance_nominees_id_seq'::regclass);


--
-- TOC entry 3711 (class 2604 OID 18046)
-- Name: health_insurances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurances ALTER COLUMN id SET DEFAULT nextval('public.health_insurances_id_seq'::regclass);


--
-- TOC entry 3842 (class 2604 OID 19447)
-- Name: helpdesk_tickets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.helpdesk_tickets ALTER COLUMN id SET DEFAULT nextval('public.helpdesk_tickets_id_seq'::regclass);


--
-- TOC entry 3708 (class 2604 OID 17963)
-- Name: insurance_companies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insurance_companies ALTER COLUMN id SET DEFAULT nextval('public.insurance_companies_id_seq'::regclass);


--
-- TOC entry 3821 (class 2604 OID 18990)
-- Name: investments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investments ALTER COLUMN id SET DEFAULT nextval('public.investments_id_seq'::regclass);


--
-- TOC entry 3807 (class 2604 OID 18736)
-- Name: investor_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investor_documents ALTER COLUMN id SET DEFAULT nextval('public.investor_documents_id_seq'::regclass);


--
-- TOC entry 3805 (class 2604 OID 18714)
-- Name: investors id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investors ALTER COLUMN id SET DEFAULT nextval('public.investors_id_seq'::regclass);


--
-- TOC entry 3843 (class 2604 OID 19479)
-- Name: invoice_items id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_items ALTER COLUMN id SET DEFAULT nextval('public.invoice_items_id_seq'::regclass);


--
-- TOC entry 3829 (class 2604 OID 19141)
-- Name: invoices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices ALTER COLUMN id SET DEFAULT nextval('public.invoices_id_seq'::regclass);


--
-- TOC entry 3736 (class 2604 OID 18103)
-- Name: leads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leads ALTER COLUMN id SET DEFAULT nextval('public.leads_id_seq'::regclass);


--
-- TOC entry 3809 (class 2604 OID 18793)
-- Name: life_insurance_bank_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurance_bank_details ALTER COLUMN id SET DEFAULT nextval('public.life_insurance_bank_details_id_seq'::regclass);


--
-- TOC entry 3810 (class 2604 OID 18812)
-- Name: life_insurance_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurance_documents ALTER COLUMN id SET DEFAULT nextval('public.life_insurance_documents_id_seq'::regclass);


--
-- TOC entry 3808 (class 2604 OID 18774)
-- Name: life_insurance_nominees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurance_nominees ALTER COLUMN id SET DEFAULT nextval('public.life_insurance_nominees_id_seq'::regclass);


--
-- TOC entry 3755 (class 2604 OID 18395)
-- Name: life_insurances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurances ALTER COLUMN id SET DEFAULT nextval('public.life_insurances_id_seq'::regclass);


--
-- TOC entry 3822 (class 2604 OID 19009)
-- Name: loans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loans ALTER COLUMN id SET DEFAULT nextval('public.loans_id_seq'::regclass);


--
-- TOC entry 3848 (class 2604 OID 19667)
-- Name: motor_insurance_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_insurance_documents ALTER COLUMN id SET DEFAULT nextval('public.motor_insurance_documents_id_seq'::regclass);


--
-- TOC entry 3846 (class 2604 OID 19536)
-- Name: motor_insurance_nominees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_insurance_nominees ALTER COLUMN id SET DEFAULT nextval('public.motor_insurance_nominees_id_seq'::regclass);


--
-- TOC entry 3719 (class 2604 OID 18065)
-- Name: motor_insurances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_insurances ALTER COLUMN id SET DEFAULT nextval('public.motor_insurances_id_seq'::regclass);


--
-- TOC entry 3901 (class 2604 OID 20821)
-- Name: mutual_fund_nominees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mutual_fund_nominees ALTER COLUMN id SET DEFAULT nextval('public.mutual_fund_nominees_id_seq'::regclass);


--
-- TOC entry 3872 (class 2604 OID 20760)
-- Name: mutual_funds id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mutual_funds ALTER COLUMN id SET DEFAULT nextval('public.mutual_funds_id_seq'::regclass);


--
-- TOC entry 3852 (class 2604 OID 19764)
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- TOC entry 3850 (class 2604 OID 19705)
-- Name: other_insurance_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.other_insurance_documents ALTER COLUMN id SET DEFAULT nextval('public.other_insurance_documents_id_seq'::regclass);


--
-- TOC entry 3845 (class 2604 OID 19517)
-- Name: other_insurance_nominees id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.other_insurance_nominees ALTER COLUMN id SET DEFAULT nextval('public.other_insurance_nominees_id_seq'::regclass);


--
-- TOC entry 3727 (class 2604 OID 18084)
-- Name: other_insurances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.other_insurances ALTER COLUMN id SET DEFAULT nextval('public.other_insurances_id_seq'::regclass);


--
-- TOC entry 3819 (class 2604 OID 18885)
-- Name: payout_audit_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payout_audit_logs ALTER COLUMN id SET DEFAULT nextval('public.payout_audit_logs_id_seq'::regclass);


--
-- TOC entry 3815 (class 2604 OID 18860)
-- Name: payout_distributions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payout_distributions ALTER COLUMN id SET DEFAULT nextval('public.payout_distributions_id_seq'::regclass);


--
-- TOC entry 3828 (class 2604 OID 19089)
-- Name: payouts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payouts ALTER COLUMN id SET DEFAULT nextval('public.payouts_id_seq'::regclass);


--
-- TOC entry 3791 (class 2604 OID 18536)
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- TOC entry 3710 (class 2604 OID 17987)
-- Name: policies id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policies ALTER COLUMN id SET DEFAULT nextval('public.policies_id_seq'::regclass);


--
-- TOC entry 3847 (class 2604 OID 19648)
-- Name: policy_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policy_documents ALTER COLUMN id SET DEFAULT nextval('public.policy_documents_id_seq'::regclass);


--
-- TOC entry 3835 (class 2604 OID 19271)
-- Name: reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports ALTER COLUMN id SET DEFAULT nextval('public.reports_id_seq'::regclass);


--
-- TOC entry 3792 (class 2604 OID 18554)
-- Name: role_permissions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions ALTER COLUMN id SET DEFAULT nextval('public.role_permissions_id_seq'::regclass);


--
-- TOC entry 3789 (class 2604 OID 18519)
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- TOC entry 3841 (class 2604 OID 19348)
-- Name: session_activities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_activities ALTER COLUMN id SET DEFAULT nextval('public.session_activities_id_seq'::regclass);


--
-- TOC entry 3853 (class 2604 OID 19788)
-- Name: solid_cache_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_cache_entries ALTER COLUMN id SET DEFAULT nextval('public.solid_cache_entries_id_seq'::regclass);


--
-- TOC entry 3856 (class 2604 OID 20545)
-- Name: solid_queue_blocked_executions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_blocked_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_blocked_executions_id_seq'::regclass);


--
-- TOC entry 3858 (class 2604 OID 20565)
-- Name: solid_queue_claimed_executions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_claimed_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_claimed_executions_id_seq'::regclass);


--
-- TOC entry 3859 (class 2604 OID 20577)
-- Name: solid_queue_failed_executions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_failed_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_failed_executions_id_seq'::regclass);


--
-- TOC entry 3854 (class 2604 OID 20524)
-- Name: solid_queue_jobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_jobs ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_jobs_id_seq'::regclass);


--
-- TOC entry 3860 (class 2604 OID 20590)
-- Name: solid_queue_pauses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_pauses ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_pauses_id_seq'::regclass);


--
-- TOC entry 3861 (class 2604 OID 20603)
-- Name: solid_queue_processes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_processes ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_processes_id_seq'::regclass);


--
-- TOC entry 3862 (class 2604 OID 20621)
-- Name: solid_queue_ready_executions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_ready_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_ready_executions_id_seq'::regclass);


--
-- TOC entry 3864 (class 2604 OID 20639)
-- Name: solid_queue_recurring_executions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_recurring_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_recurring_executions_id_seq'::regclass);


--
-- TOC entry 3865 (class 2604 OID 20655)
-- Name: solid_queue_recurring_tasks id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_recurring_tasks ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_recurring_tasks_id_seq'::regclass);


--
-- TOC entry 3868 (class 2604 OID 20674)
-- Name: solid_queue_scheduled_executions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_scheduled_executions ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_scheduled_executions_id_seq'::regclass);


--
-- TOC entry 3870 (class 2604 OID 20692)
-- Name: solid_queue_semaphores id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_semaphores ALTER COLUMN id SET DEFAULT nextval('public.solid_queue_semaphores_id_seq'::regclass);


--
-- TOC entry 3750 (class 2604 OID 18231)
-- Name: sub_agent_documents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_agent_documents ALTER COLUMN id SET DEFAULT nextval('public.sub_agent_documents_id_seq'::regclass);


--
-- TOC entry 3747 (class 2604 OID 18209)
-- Name: sub_agents id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_agents ALTER COLUMN id SET DEFAULT nextval('public.sub_agents_id_seq'::regclass);


--
-- TOC entry 3803 (class 2604 OID 18700)
-- Name: system_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_settings ALTER COLUMN id SET DEFAULT nextval('public.system_settings_id_seq'::regclass);


--
-- TOC entry 3823 (class 2604 OID 19028)
-- Name: tax_services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_services ALTER COLUMN id SET DEFAULT nextval('public.tax_services_id_seq'::regclass);


--
-- TOC entry 3824 (class 2604 OID 19047)
-- Name: travel_packages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.travel_packages ALTER COLUMN id SET DEFAULT nextval('public.travel_packages_id_seq'::regclass);


--
-- TOC entry 3795 (class 2604 OID 18602)
-- Name: user_roles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles ALTER COLUMN id SET DEFAULT nextval('public.user_roles_id_seq'::regclass);


--
-- TOC entry 3837 (class 2604 OID 19295)
-- Name: user_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions ALTER COLUMN id SET DEFAULT nextval('public.user_sessions_id_seq'::regclass);


--
-- TOC entry 3701 (class 2604 OID 17920)
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- TOC entry 4660 (class 0 OID 18128)
-- Dependencies: 245
-- Data for Name: active_storage_attachments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.active_storage_attachments (id, name, record_type, record_id, blob_id, created_at) FROM stdin;
7	document_file	SubAgentDocument	3	7	2026-06-02 14:52:37.614234
\.


--
-- TOC entry 4658 (class 0 OID 18112)
-- Dependencies: 243
-- Data for Name: active_storage_blobs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.active_storage_blobs (id, key, filename, content_type, metadata, service_name, byte_size, checksum, created_at) FROM stdin;
4	00ixhy0guilgjrznm6au6x9j8bk6	Screenshot from 2026-05-03 07-05-17.png	image/png	{"identified":true}	production	53671	q07qtjx6g51/4NCVEqLL1A==	2026-05-15 09:36:58.555087
5	0xn7ticdm83mh6iqe4i117h2vv7i	logo (1).jpeg	image/jpeg	{"identified":true}	production	93663	I8dnvVcepqm3Dx2pMwh7sg==	2026-05-15 09:37:59.322308
6	acm0d0yrpo5l78kn2p62qrzpfw9g	Vijendra Photo.jpeg	image/jpeg	{"identified":true}	production	75852	Pz7tHtbrjJpk/qxfbLqHxw==	2026-05-26 00:06:22.304857
7	3eeywzi7i2w1o03fskntvqasbp96	PAN.jpg	image/jpeg	{"identified":true}	production	84864	SJc6sDm4AwZFlCHZzfrgwQ==	2026-06-02 14:52:37.611036
\.


--
-- TOC entry 4662 (class 0 OID 18150)
-- Dependencies: 247
-- Data for Name: active_storage_variant_records; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.active_storage_variant_records (id, blob_id, variation_digest) FROM stdin;
\.


--
-- TOC entry 4646 (class 0 OID 17972)
-- Dependencies: 231
-- Data for Name: agency_brokers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.agency_brokers (id, broker_name, broker_code, agency_code, status, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4672 (class 0 OID 18249)
-- Dependencies: 257
-- Data for Name: agency_codes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.agency_codes (id, insurance_type, company_name, agent_name, code, created_at, updated_at, broker_id) FROM stdin;
1	Health Insurance	Star Health and Allied Insurance Company Ltd	BHARATH D	BA0000424798	2026-05-11 10:45:48.612661	2026-05-11 10:45:48.612661	\N
2	Health Insurance	Star Health and Allied Insurance Company Ltd	Nanda Kishore TP	BA0000260748	2026-05-11 10:46:06.491057	2026-05-11 10:46:06.491057	\N
3	Motor and Other Insurance	Tata AIG General Insurance	Murali Krishna Kasibhatta	2771070000	2026-05-11 10:46:27.572089	2026-05-11 10:46:27.572089	\N
4	Health Insurance	Tata AIG General Insurance	Murali Krishna Kasibhatta	2771070000	2026-05-11 10:46:41.577184	2026-05-11 10:46:41.577184	\N
\.


--
-- TOC entry 4748 (class 0 OID 19331)
-- Dependencies: 333
-- Data for Name: ahoy_events; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ahoy_events (id, visit_id, user_id, name, properties, "time") FROM stdin;
\.


--
-- TOC entry 4746 (class 0 OID 19318)
-- Dependencies: 331
-- Data for Name: ahoy_visits; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ahoy_visits (id, visit_token, visitor_token, user_id, ip, user_agent, referrer, referring_domain, landing_page, browser, os, device_type, country, region, city, latitude, longitude, utm_source, utm_medium, utm_term, utm_content, utm_campaign, app_version, os_version, platform, started_at) FROM stdin;
\.


--
-- TOC entry 4736 (class 0 OID 19216)
-- Dependencies: 321
-- Data for Name: ai_report_histories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ai_report_histories (id, user_id, report_type, filters, ai_insights, confidence_score, generated_at, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4742 (class 0 OID 19280)
-- Dependencies: 327
-- Data for Name: all_policy_reports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.all_policy_reports (id, name, policy_type, report_data, created_by_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4738 (class 0 OID 19255)
-- Dependencies: 323
-- Data for Name: analytics_caches; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.analytics_caches (id, cache_identifier, cache_data, last_updated, created_at, updated_at) FROM stdin;
22	main_analytics_v2	{"current_month":"2026-06-01","last_month":"2026-05-01T00:00:00.000Z","current_year":"2026-01-01","last_year":"2025-01-01T00:00:00.000Z","total_customers":19,"total_policies":15,"total_premium":"389330.68","total_affiliates":8,"total_ambassadors":4,"customer_growth":-100.0,"policy_growth":-300.0,"premium_growth":-100.0,"affiliate_growth":-100.0,"policy_distribution":{"Life Insurance":1,"Health Insurance":13,"Motor Insurance":1,"Other Insurance":0},"monthly_trends":{"Jul 2025":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Aug 2025":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Sep 2025":{"customers":0,"policies":1,"premium":"28184.0","leads":0},"Oct 2025":{"customers":0,"policies":3,"premium":"99489.01","leads":0},"Nov 2025":{"customers":0,"policies":1,"premium":"74024.0","leads":0},"Dec 2025":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Jan 2026":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Feb 2026":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Mar 2026":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Apr 2026":{"customers":0,"policies":0,"premium":"0.0","leads":0},"May 2026":{"customers":19,"policies":2,"premium":"27780.0","leads":8},"Jun 2026":{"customers":0,"policies":0,"premium":"0.0","leads":0}},"top_affiliates":[{"id":1,"first_name":"DEVARAJ","last_name":"J","status":"active","policies_count":6},{"id":2,"first_name":"Samparka","last_name":"Association","status":"active","policies_count":5},{"id":3,"first_name":"LOKESH","last_name":"SHIVANNA","status":"active","policies_count":2},{"id":6,"first_name":"Murali Krishna","last_name":"Kasibhatta","status":"active","policies_count":1},{"id":8,"first_name":"SOWMYA","last_name":"H T","status":"active","policies_count":1}],"recent_policies":[{"type":"Life Insurance","customer":"Yogesha  MS","policy_number":"K7676680","premium":74024.0,"date":"2026-05-29T02:39:18.696Z"},{"type":"Motor Insurance","customer":"HANUMANTHA  M","policy_number":"201350020126790157300000","premium":17942.0,"date":"2026-05-26T00:42:02.028Z"},{"type":"Health Insurance","customer":"K Krishna  Prasad","policy_number":"100063248600","premium":9838.0,"date":"2026-05-20T14:05:07.274Z"},{"type":"Health Insurance","customer":"DR KRISHNA  NAGARAJ","policy_number":"34370258202501","premium":46273.0,"date":"2026-05-15T03:29:10.756Z"},{"type":"Health Insurance","customer":"PRAMOD  SHIVAKUMAR","policy_number":"72895305","premium":18091.41,"date":"2026-05-14T13:55:11.403Z"}],"recent_leads":[{"id":23,"name":"DR KRISHNA NAGARAJ","contact_number":"9980639161","email":"krishnainduvalu@yahoo.co.in","referred_by":"","product_interest":null,"current_stage":"consultation_scheduled","created_date":"2026-05-27","note":null,"created_at":"2026-05-27T16:49:42.904Z","updated_at":"2026-05-29T06:31:25.839Z","lead_id":"CUSLEAD-DR KR-ADZPN","address":"","city":"Mandya","state":"karnataka","lead_source":"walk_in","call_disposition":"follow_up","referral_amount":"0.0","transferred_amount":false,"notes":"Created from existing customer: DR KRISHNA  NAGARAJ (ID: 6)","attachments":null,"stage_updated_at":"2026-05-29T06:31:25.839Z","converted_customer_id":null,"policy_created_id":null,"product_category":"investments","product_subcategory":"mutual_fund","is_direct":true,"affiliate_id":null,"first_name":"DR KRISHNA","middle_name":"","last_name":"NAGARAJ","birth_date":"1979-05-28","gender":"male","pan_no":"ADZPN3005G","gst_no":null,"company_name":null,"marital_status":"married","height":"","weight":"","birth_place":"MANDYA","education":"MBBS","business_job":"professional","business_name":"","job_name":"","occupation":"","type_of_duty":"DOCTOR","annual_income":"2500000.0","additional_information":"","height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":true,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":21,"name":" T SHIVANNA ","contact_number":"9743003428","email":"","referred_by":"Friend Reference","product_interest":null,"current_stage":"follow_up","created_date":"2026-05-26","note":null,"created_at":"2026-05-26T13:23:41.093Z","updated_at":"2026-05-26T13:39:15.162Z","lead_id":"CUSLEAD-TXXXX-68187","address":"No 7 ","city":"Banglore ","state":"Karnataka","lead_source":"agent_referral","call_disposition":null,"referral_amount":"0.0","transferred_amount":false,"notes":"","attachments":null,"stage_updated_at":"2026-05-26T13:39:15.162Z","converted_customer_id":null,"policy_created_id":null,"product_category":"insurance","product_subcategory":"motor","is_direct":false,"affiliate_id":3,"first_name":"T","middle_name":null,"last_name":"SHIVANNA","birth_date":null,"gender":null,"pan_no":null,"gst_no":null,"company_name":null,"marital_status":null,"height":null,"weight":null,"birth_place":null,"education":null,"business_job":null,"business_name":null,"job_name":null,"occupation":null,"type_of_duty":null,"annual_income":null,"additional_information":null,"height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":19,"name":"HANUMANTHA M","contact_number":"9538247661","email":"pradeepdjpradeep16455@gmail.com","referred_by":"VIJENDRA MP","product_interest":null,"current_stage":"converted","created_date":"2026-05-24","note":null,"created_at":"2026-05-26T00:11:49.467Z","updated_at":"2026-05-26T00:42:02.081Z","lead_id":"CUSLEAD-HANUM-AISPH","address":"S/O Marigowda, 230/2, Marchanahalli, Channapatna, Karnataka 562160","city":"Ramanagara","state":"karnataka","lead_source":"agent_referral","call_disposition":"interested","referral_amount":"0.0","transferred_amount":false,"notes":"\\n\\nUpdated: Policy created - 112233 on 2026-05-26","attachments":null,"stage_updated_at":"2026-05-26T00:42:02.070Z","converted_customer_id":22,"policy_created_id":13,"product_category":"insurance","product_subcategory":"motor","is_direct":false,"affiliate_id":8,"first_name":"HANUMANTHA","middle_name":"","last_name":"M","birth_date":"1985-06-15","gender":"male","pan_no":"AISPH0089E","gst_no":null,"company_name":null,"marital_status":"married","height":"","weight":"","birth_place":"","education":"","business_job":"","business_name":"","job_name":"","occupation":"","type_of_duty":"","annual_income":null,"additional_information":"","height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":18,"name":"Krishna Prasad","contact_number":"9150845577","email":"kp@gmail.com","referred_by":"Friend Reference","product_interest":null,"current_stage":"converted","created_date":"2026-05-18","note":null,"created_at":"2026-05-18T02:26:28.990Z","updated_at":"2026-05-20T14:01:29.520Z","lead_id":"CUSLEAD-KRISH-32790","address":"","city":"Bengaluru ","state":"Karnataka","lead_source":"agent_referral","call_disposition":null,"referral_amount":"0.0","transferred_amount":false,"notes":"Financial planning ","attachments":null,"stage_updated_at":"2026-05-20T14:01:29.520Z","converted_customer_id":19,"policy_created_id":null,"product_category":"insurance","product_subcategory":"health","is_direct":false,"affiliate_id":6,"first_name":"Krishna","middle_name":null,"last_name":"Prasad","birth_date":null,"gender":null,"pan_no":null,"gst_no":null,"company_name":null,"marital_status":null,"height":null,"weight":null,"birth_place":null,"education":null,"business_job":null,"business_name":null,"job_name":null,"occupation":null,"type_of_duty":null,"annual_income":null,"additional_information":null,"height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":16,"name":"Geetha Guruwale","contact_number":"6515432866","email":"","referred_by":"Friend Reference","product_interest":null,"current_stage":"one_on_one","created_date":"2026-05-17","note":null,"created_at":"2026-05-17T12:24:15.711Z","updated_at":"2026-05-25T07:15:42.286Z","lead_id":"CUSLEAD-GEETH-91656","address":"","city":"Hyderabad ","state":"telangana","lead_source":"agent_referral","call_disposition":"","referral_amount":"0.0","transferred_amount":false,"notes":"Personal Accident policy","attachments":null,"stage_updated_at":"2026-05-25T07:15:42.287Z","converted_customer_id":null,"policy_created_id":null,"product_category":"insurance","product_subcategory":"other","is_direct":false,"affiliate_id":1,"first_name":"Geetha","middle_name":"","last_name":"Guruwale","birth_date":null,"gender":"","pan_no":"","gst_no":"","company_name":"","marital_status":"","height":"","weight":"","birth_place":"","education":"","business_job":"","business_name":"","job_name":"","occupation":"","type_of_duty":"","annual_income":null,"additional_information":"","height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":15,"name":"M N Nagaveni","contact_number":"9743297766","email":"","referred_by":"Friend Reference","product_interest":null,"current_stage":"consultation_scheduled","created_date":"2026-05-17","note":null,"created_at":"2026-05-17T12:05:42.299Z","updated_at":"2026-05-17T12:06:21.931Z","lead_id":"CUSLEAD-MXXXX-27657","address":"","city":"Bengaluru ","state":"Karnataka","lead_source":"agent_referral","call_disposition":null,"referral_amount":"0.0","transferred_amount":false,"notes":"Family health Insurance ","attachments":null,"stage_updated_at":"2026-05-17T12:06:21.931Z","converted_customer_id":null,"policy_created_id":null,"product_category":"insurance","product_subcategory":"health","is_direct":false,"affiliate_id":2,"first_name":"M","middle_name":null,"last_name":"N Nagaveni","birth_date":null,"gender":null,"pan_no":null,"gst_no":null,"company_name":null,"marital_status":null,"height":null,"weight":null,"birth_place":null,"education":null,"business_job":null,"business_name":null,"job_name":null,"occupation":null,"type_of_duty":null,"annual_income":null,"additional_information":null,"height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":8,"name":"Girish Shivanna ","contact_number":"9845269391","email":"girishatshivanna@gmail.com","referred_by":"Friend Reference","product_interest":null,"current_stage":"lead_generated","created_date":"2026-05-16","note":null,"created_at":"2026-05-16T11:29:33.834Z","updated_at":"2026-05-17T06:29:20.728Z","lead_id":"CUSLEAD-GIRIS-69468","address":"","city":"No 7 tr nagara bengaluru ","state":"karnataka","lead_source":"agent_referral","call_disposition":"","referral_amount":"0.0","transferred_amount":false,"notes":"For mutual funds how to trigger","attachments":null,"stage_updated_at":"2026-05-16T11:29:33.833Z","converted_customer_id":null,"policy_created_id":null,"product_category":"insurance","product_subcategory":"other","is_direct":false,"affiliate_id":3,"first_name":"Girish","middle_name":"","last_name":"Shivanna","birth_date":null,"gender":"","pan_no":"","gst_no":"","company_name":"","marital_status":"","height":"4.17","weight":"","birth_place":"","education":"","business_job":"","business_name":"","job_name":"","occupation":"","type_of_duty":"","annual_income":null,"additional_information":"","height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":7,"name":"Eswaraiah Sudha","contact_number":"9686405652","email":"sudha.e68@gmail.com","referred_by":"","product_interest":null,"current_stage":"converted","created_date":"2026-05-01","note":null,"created_at":"2026-05-16T10:49:54.198Z","updated_at":"2026-05-16T10:56:46.923Z","lead_id":"CUSLEAD-ESWAR-BSRPS","address":"42, Shashwathi Nilaya, 1st A Main Cross Road, Maruthi Layout, RMV 2nd Stage, Blr 560094","city":"Bengaluru Urban","state":"karnataka","lead_source":"agent_referral","call_disposition":"interested","referral_amount":"0.0","transferred_amount":false,"notes":"","attachments":null,"stage_updated_at":"2026-05-16T10:56:46.923Z","converted_customer_id":11,"policy_created_id":null,"product_category":"insurance","product_subcategory":"health","is_direct":false,"affiliate_id":1,"first_name":"Eswaraiah","middle_name":"","last_name":"Sudha","birth_date":"1967-07-21","gender":"female","pan_no":"BSRPS7005K","gst_no":null,"company_name":null,"marital_status":"married","height":"5.17","weight":"82","birth_place":"","education":"","business_job":"","business_name":"","job_name":"","occupation":"","type_of_duty":"","annual_income":null,"additional_information":"","height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null}],"commission_summary":{"total_commission_due":"81300.7165","total_commission_paid":"50854.5615","affiliate_commissions":"0.0","ambassador_commissions":"3745.27"},"renewal_analytics":{"expiring_soon":1,"expiring_later":0,"expired":10,"renewal_rate":71.4},"agent_performance":{"Samparka Association":173762.78,"DEVARAJ J":108261.51,"LOKESH SHIVANNA":79526.39,"SOWMYA H T":17942.0,"Murali Krishna Kasibhatta":9838.0},"agent_customer_data":{"Samparka Association":4,"LOKESH SHIVANNA":2,"DEVARAJ J":10,"Murali Krishna Kasibhatta":2,"SOWMYA H T":1},"agent_commission":{"Murali Krishna Kasibhatta":491.9,"DEVARAJ J":5194.99,"LOKESH SHIVANNA":3181.06,"Samparka Association":7933.49,"SOWMYA H T":5023.76},"commissions_due":81300.7165,"conversion_rate":37.5,"avg_policy_value":25955,"customer_retention":26.3,"lead_conversion_funnel":{"Lead Generated":8,"Consultation Scheduled":7,"One on One":5,"Follow Up":4,"Converted":3},"lead_stage_distribution":{"Lead Generated":1,"Consultation Scheduled":2,"One on One":1,"Follow Up":1,"Follow Up Successful":0,"Follow Up Unsuccessful":0,"Not Interested":0,"Converted":3,"Lead Closed":0},"customer_location":{"Koppal":1,"Ramanagara":1,"Mandya":1,"Bengaluru ":2,"Bangalore":3,"Bengaluru Rural":1,"Mangaluru":1,"Bengaluru Urban":8},"customer_acquisition_trend":{"Jul 2025":0,"Aug 2025":0,"Sep 2025":0,"Oct 2025":0,"Nov 2025":0,"Dec 2025":0,"Jan 2026":0,"Feb 2026":0,"Mar 2026":0,"Apr 2026":0,"May 2026":19,"Jun 2026":0},"premium_revenue_trend":{"Jul 2025":0,"Aug 2025":0,"Sep 2025":28184,"Oct 2025":99489,"Nov 2025":74024,"Dec 2025":0,"Jan 2026":0,"Feb 2026":0,"Mar 2026":0,"Apr 2026":0,"May 2026":27780,"Jun 2026":0},"active_customers":19,"converted_leads":3,"new_leads":2,"support_tickets":5,"docs_pending":0,"claims_processing":0,"client_requests_count":5,"total_investors":13,"investor_status_distribution":{"Active":13,"Inactive":0},"top_investors_by_ambassadors":{"DEVARAJ JAYRAM":3,"Vijendra P":1,"ADITHYAA KASIBHATTA":0,"DEVARAJ T H":0,"Murali Kasibhatta":0,"Krishna MURTHY K":0,"Shivakumar N":0,"Nitin S":0,"N GOPAL":0,"YOGESHWARAPPA K":0},"top_investors_by_commission":{}}	2026-06-02 04:26:42.304739	2026-05-30 11:12:22.704969	2026-06-02 04:26:42.322498
24	main_analytics_v3	{"current_month":"2026-06-01","last_month":"2026-05-01T00:00:00.000Z","current_year":"2026-01-01","last_year":"2025-01-01T00:00:00.000Z","total_customers":19,"total_policies":15,"total_premium":"389330.68","total_affiliates":8,"total_ambassadors":4,"customer_growth":-100.0,"policy_growth":-300.0,"premium_growth":-100.0,"affiliate_growth":-100.0,"policy_distribution":{"Life Insurance":1,"Health Insurance":13,"Motor Insurance":1,"Other Insurance":0},"monthly_trends":{"Jul 2025":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Aug 2025":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Sep 2025":{"customers":0,"policies":1,"premium":"28184.0","leads":0},"Oct 2025":{"customers":0,"policies":3,"premium":"99489.01","leads":0},"Nov 2025":{"customers":0,"policies":1,"premium":"74024.0","leads":0},"Dec 2025":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Jan 2026":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Feb 2026":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Mar 2026":{"customers":0,"policies":0,"premium":"0.0","leads":0},"Apr 2026":{"customers":0,"policies":0,"premium":"0.0","leads":0},"May 2026":{"customers":19,"policies":2,"premium":"27780.0","leads":8},"Jun 2026":{"customers":0,"policies":0,"premium":"0.0","leads":0}},"top_affiliates":[{"id":1,"first_name":"DEVARAJ","last_name":"J","status":"active","policies_count":6},{"id":2,"first_name":"Samparka","last_name":"Association","status":"active","policies_count":5},{"id":3,"first_name":"LOKESH","last_name":"SHIVANNA","status":"active","policies_count":2},{"id":6,"first_name":"Murali Krishna","last_name":"Kasibhatta","status":"active","policies_count":1},{"id":8,"first_name":"SOWMYA","last_name":"H T","status":"active","policies_count":1}],"recent_policies":[{"type":"Life Insurance","customer":"Yogesha  MS","policy_number":"K7676680","premium":74024.0,"date":"2026-05-29T02:39:18.696Z"},{"type":"Motor Insurance","customer":"HANUMANTHA  M","policy_number":"201350020126790157300000","premium":17942.0,"date":"2026-05-26T00:42:02.028Z"},{"type":"Health Insurance","customer":"K Krishna  Prasad","policy_number":"100063248600","premium":9838.0,"date":"2026-05-20T14:05:07.274Z"},{"type":"Health Insurance","customer":"DR KRISHNA  NAGARAJ","policy_number":"34370258202501","premium":46273.0,"date":"2026-05-15T03:29:10.756Z"},{"type":"Health Insurance","customer":"PRAMOD  SHIVAKUMAR","policy_number":"72895305","premium":18091.41,"date":"2026-05-14T13:55:11.403Z"}],"recent_leads":[{"id":23,"name":"DR KRISHNA NAGARAJ","contact_number":"9980639161","email":"krishnainduvalu@yahoo.co.in","referred_by":"","product_interest":null,"current_stage":"consultation_scheduled","created_date":"2026-05-27","note":null,"created_at":"2026-05-27T16:49:42.904Z","updated_at":"2026-05-29T06:31:25.839Z","lead_id":"CUSLEAD-DR KR-ADZPN","address":"","city":"Mandya","state":"karnataka","lead_source":"walk_in","call_disposition":"follow_up","referral_amount":"0.0","transferred_amount":false,"notes":"Created from existing customer: DR KRISHNA  NAGARAJ (ID: 6)","attachments":null,"stage_updated_at":"2026-05-29T06:31:25.839Z","converted_customer_id":null,"policy_created_id":null,"product_category":"investments","product_subcategory":"mutual_fund","is_direct":true,"affiliate_id":null,"first_name":"DR KRISHNA","middle_name":"","last_name":"NAGARAJ","birth_date":"1979-05-28","gender":"male","pan_no":"ADZPN3005G","gst_no":null,"company_name":null,"marital_status":"married","height":"","weight":"","birth_place":"MANDYA","education":"MBBS","business_job":"professional","business_name":"","job_name":"","occupation":"","type_of_duty":"DOCTOR","annual_income":"2500000.0","additional_information":"","height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":true,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":21,"name":" T SHIVANNA ","contact_number":"9743003428","email":"","referred_by":"Friend Reference","product_interest":null,"current_stage":"follow_up","created_date":"2026-05-26","note":null,"created_at":"2026-05-26T13:23:41.093Z","updated_at":"2026-05-26T13:39:15.162Z","lead_id":"CUSLEAD-TXXXX-68187","address":"No 7 ","city":"Banglore ","state":"Karnataka","lead_source":"agent_referral","call_disposition":null,"referral_amount":"0.0","transferred_amount":false,"notes":"","attachments":null,"stage_updated_at":"2026-05-26T13:39:15.162Z","converted_customer_id":null,"policy_created_id":null,"product_category":"insurance","product_subcategory":"motor","is_direct":false,"affiliate_id":3,"first_name":"T","middle_name":null,"last_name":"SHIVANNA","birth_date":null,"gender":null,"pan_no":null,"gst_no":null,"company_name":null,"marital_status":null,"height":null,"weight":null,"birth_place":null,"education":null,"business_job":null,"business_name":null,"job_name":null,"occupation":null,"type_of_duty":null,"annual_income":null,"additional_information":null,"height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":19,"name":"HANUMANTHA M","contact_number":"9538247661","email":"pradeepdjpradeep16455@gmail.com","referred_by":"VIJENDRA MP","product_interest":null,"current_stage":"converted","created_date":"2026-05-24","note":null,"created_at":"2026-05-26T00:11:49.467Z","updated_at":"2026-05-26T00:42:02.081Z","lead_id":"CUSLEAD-HANUM-AISPH","address":"S/O Marigowda, 230/2, Marchanahalli, Channapatna, Karnataka 562160","city":"Ramanagara","state":"karnataka","lead_source":"agent_referral","call_disposition":"interested","referral_amount":"0.0","transferred_amount":false,"notes":"\\n\\nUpdated: Policy created - 112233 on 2026-05-26","attachments":null,"stage_updated_at":"2026-05-26T00:42:02.070Z","converted_customer_id":22,"policy_created_id":13,"product_category":"insurance","product_subcategory":"motor","is_direct":false,"affiliate_id":8,"first_name":"HANUMANTHA","middle_name":"","last_name":"M","birth_date":"1985-06-15","gender":"male","pan_no":"AISPH0089E","gst_no":null,"company_name":null,"marital_status":"married","height":"","weight":"","birth_place":"","education":"","business_job":"","business_name":"","job_name":"","occupation":"","type_of_duty":"","annual_income":null,"additional_information":"","height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":18,"name":"Krishna Prasad","contact_number":"9150845577","email":"kp@gmail.com","referred_by":"Friend Reference","product_interest":null,"current_stage":"converted","created_date":"2026-05-18","note":null,"created_at":"2026-05-18T02:26:28.990Z","updated_at":"2026-05-20T14:01:29.520Z","lead_id":"CUSLEAD-KRISH-32790","address":"","city":"Bengaluru ","state":"Karnataka","lead_source":"agent_referral","call_disposition":null,"referral_amount":"0.0","transferred_amount":false,"notes":"Financial planning ","attachments":null,"stage_updated_at":"2026-05-20T14:01:29.520Z","converted_customer_id":19,"policy_created_id":null,"product_category":"insurance","product_subcategory":"health","is_direct":false,"affiliate_id":6,"first_name":"Krishna","middle_name":null,"last_name":"Prasad","birth_date":null,"gender":null,"pan_no":null,"gst_no":null,"company_name":null,"marital_status":null,"height":null,"weight":null,"birth_place":null,"education":null,"business_job":null,"business_name":null,"job_name":null,"occupation":null,"type_of_duty":null,"annual_income":null,"additional_information":null,"height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":16,"name":"Geetha Guruwale","contact_number":"6515432866","email":"","referred_by":"Friend Reference","product_interest":null,"current_stage":"one_on_one","created_date":"2026-05-17","note":null,"created_at":"2026-05-17T12:24:15.711Z","updated_at":"2026-05-25T07:15:42.286Z","lead_id":"CUSLEAD-GEETH-91656","address":"","city":"Hyderabad ","state":"telangana","lead_source":"agent_referral","call_disposition":"","referral_amount":"0.0","transferred_amount":false,"notes":"Personal Accident policy","attachments":null,"stage_updated_at":"2026-05-25T07:15:42.287Z","converted_customer_id":null,"policy_created_id":null,"product_category":"insurance","product_subcategory":"other","is_direct":false,"affiliate_id":1,"first_name":"Geetha","middle_name":"","last_name":"Guruwale","birth_date":null,"gender":"","pan_no":"","gst_no":"","company_name":"","marital_status":"","height":"","weight":"","birth_place":"","education":"","business_job":"","business_name":"","job_name":"","occupation":"","type_of_duty":"","annual_income":null,"additional_information":"","height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":15,"name":"M N Nagaveni","contact_number":"9743297766","email":"","referred_by":"Friend Reference","product_interest":null,"current_stage":"consultation_scheduled","created_date":"2026-05-17","note":null,"created_at":"2026-05-17T12:05:42.299Z","updated_at":"2026-05-17T12:06:21.931Z","lead_id":"CUSLEAD-MXXXX-27657","address":"","city":"Bengaluru ","state":"Karnataka","lead_source":"agent_referral","call_disposition":null,"referral_amount":"0.0","transferred_amount":false,"notes":"Family health Insurance ","attachments":null,"stage_updated_at":"2026-05-17T12:06:21.931Z","converted_customer_id":null,"policy_created_id":null,"product_category":"insurance","product_subcategory":"health","is_direct":false,"affiliate_id":2,"first_name":"M","middle_name":null,"last_name":"N Nagaveni","birth_date":null,"gender":null,"pan_no":null,"gst_no":null,"company_name":null,"marital_status":null,"height":null,"weight":null,"birth_place":null,"education":null,"business_job":null,"business_name":null,"job_name":null,"occupation":null,"type_of_duty":null,"annual_income":null,"additional_information":null,"height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":8,"name":"Girish Shivanna ","contact_number":"9845269391","email":"girishatshivanna@gmail.com","referred_by":"Friend Reference","product_interest":null,"current_stage":"lead_generated","created_date":"2026-05-16","note":null,"created_at":"2026-05-16T11:29:33.834Z","updated_at":"2026-05-17T06:29:20.728Z","lead_id":"CUSLEAD-GIRIS-69468","address":"","city":"No 7 tr nagara bengaluru ","state":"karnataka","lead_source":"agent_referral","call_disposition":"","referral_amount":"0.0","transferred_amount":false,"notes":"For mutual funds how to trigger","attachments":null,"stage_updated_at":"2026-05-16T11:29:33.833Z","converted_customer_id":null,"policy_created_id":null,"product_category":"insurance","product_subcategory":"other","is_direct":false,"affiliate_id":3,"first_name":"Girish","middle_name":"","last_name":"Shivanna","birth_date":null,"gender":"","pan_no":"","gst_no":"","company_name":"","marital_status":"","height":"4.17","weight":"","birth_place":"","education":"","business_job":"","business_name":"","job_name":"","occupation":"","type_of_duty":"","annual_income":null,"additional_information":"","height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null},{"id":7,"name":"Eswaraiah Sudha","contact_number":"9686405652","email":"sudha.e68@gmail.com","referred_by":"","product_interest":null,"current_stage":"converted","created_date":"2026-05-01","note":null,"created_at":"2026-05-16T10:49:54.198Z","updated_at":"2026-05-16T10:56:46.923Z","lead_id":"CUSLEAD-ESWAR-BSRPS","address":"42, Shashwathi Nilaya, 1st A Main Cross Road, Maruthi Layout, RMV 2nd Stage, Blr 560094","city":"Bengaluru Urban","state":"karnataka","lead_source":"agent_referral","call_disposition":"interested","referral_amount":"0.0","transferred_amount":false,"notes":"","attachments":null,"stage_updated_at":"2026-05-16T10:56:46.923Z","converted_customer_id":11,"policy_created_id":null,"product_category":"insurance","product_subcategory":"health","is_direct":false,"affiliate_id":1,"first_name":"Eswaraiah","middle_name":"","last_name":"Sudha","birth_date":"1967-07-21","gender":"female","pan_no":"BSRPS7005K","gst_no":null,"company_name":null,"marital_status":"married","height":"5.17","weight":"82","birth_place":"","education":"","business_job":"","business_name":"","job_name":"","occupation":"","type_of_duty":"","annual_income":null,"additional_information":"","height_feet":null,"weight_kg":null,"business_job_type":null,"business_job_name":null,"duty_type":null,"is_branch_out":false,"ambassador_id":null,"customer_type":"individual","parent_lead_id":null}],"commission_summary":{"total_commission_due":"81300.7165","total_commission_paid":"50854.5615","affiliate_commissions":"0.0","ambassador_commissions":"3745.27"},"renewal_analytics":{"expiring_soon":1,"expiring_later":0,"expired":10,"renewal_rate":71.4},"agent_performance":{"Samparka Association":173762.78,"DEVARAJ J":108261.51,"LOKESH SHIVANNA":79526.39,"SOWMYA H T":17942.0,"Murali Krishna Kasibhatta":9838.0},"agent_customer_data":{"Samparka Association":4,"LOKESH SHIVANNA":2,"DEVARAJ J":10,"Murali Krishna Kasibhatta":2,"SOWMYA H T":1},"agent_commission":{"Murali Krishna Kasibhatta":491.9,"DEVARAJ J":5194.99,"LOKESH SHIVANNA":3181.06,"Samparka Association":7933.49,"SOWMYA H T":5023.76},"commissions_due":81300.7165,"conversion_rate":37.5,"avg_policy_value":25955,"customer_retention":26.3,"lead_conversion_funnel":{"Lead Generated":8,"Consultation Scheduled":7,"One on One":5,"Follow Up":4,"Converted":3},"lead_stage_distribution":{"Lead Generated":1,"Consultation Scheduled":2,"One on One":1,"Follow Up":1,"Follow Up Successful":0,"Follow Up Unsuccessful":0,"Not Interested":0,"Converted":3,"Lead Closed":0},"customer_location":{"Koppal":1,"Ramanagara":1,"Mandya":1,"Bengaluru ":2,"Bangalore":3,"Bengaluru Rural":1,"Mangaluru":1,"Bengaluru Urban":8},"customer_acquisition_trend":{"Jul 2025":0,"Aug 2025":0,"Sep 2025":0,"Oct 2025":0,"Nov 2025":0,"Dec 2025":0,"Jan 2026":0,"Feb 2026":0,"Mar 2026":0,"Apr 2026":0,"May 2026":19,"Jun 2026":0},"premium_revenue_trend":{"Jul 2025":0,"Aug 2025":0,"Sep 2025":28184,"Oct 2025":99489,"Nov 2025":74024,"Dec 2025":0,"Jan 2026":0,"Feb 2026":0,"Mar 2026":0,"Apr 2026":0,"May 2026":27780,"Jun 2026":0},"active_customers":19,"converted_leads":3,"new_leads":2,"support_tickets":5,"docs_pending":0,"claims_processing":0,"client_requests_count":5,"total_investors":13,"investor_status_distribution":{"Active":13,"Inactive":0},"top_investors_by_ambassadors":{"DEVARAJ JAYRAM":3,"Vijendra P":1,"ADITHYAA KASIBHATTA":0,"DEVARAJ T H":0,"Murali Kasibhatta":0,"Krishna MURTHY K":0,"Shivakumar N":0,"Nitin S":0,"N GOPAL":0,"YOGESHWARAPPA K":0},"top_investors_by_commission":{}}	2026-06-02 07:20:41.696396	2026-06-02 04:47:57.419497	2026-06-02 07:20:41.720245
\.


--
-- TOC entry 4803 (class 0 OID 20842)
-- Dependencies: 388
-- Data for Name: appointments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.appointments (id, customer_id, customer_name, customer_email, customer_phone, meeting_agenda, notes, appointment_date, time_slot, status, created_by_id, created_at, updated_at) FROM stdin;
1	16	Adithyaa Tanmaoy Kasibhatta	adithyaatanmayk@gmail.com	6361404087	ass	sa	2026-05-25	11:00 AM	pending	2	2026-05-25 15:25:22.114972	2026-05-25 15:25:22.114972
2	2	YOGESHWARAPPA  K	yogi.slvglass4@gmail.com	9980990027	s	x	2026-05-25	03:30 PM	completed	2	2026-05-25 15:25:47.175795	2026-05-25 15:25:56.788673
3	3	BASAVARAJ  CHANDRASHEKARsdd	basu2736@gmail.com	9720008888	insurance		2026-05-28	03:30 PM	confirmed	2	2026-05-25 15:34:54.477623	2026-05-26 05:33:21.731762
4	\N	RAGHAVENDRA JOSHI			STAR HEALTH	Update on Star Advisor Program.\r\n\r\nDid not come due to other program	2026-05-28	03:00 PM	cancelled	2	2026-05-26 13:28:49.405024	2026-05-28 15:00:26.056395
\.


--
-- TOC entry 4636 (class 0 OID 17906)
-- Dependencies: 221
-- Data for Name: ar_internal_metadata; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
environment	production	2026-05-07 10:05:15.806881	2026-05-07 12:45:21.810763
\.


--
-- TOC entry 4767 (class 0 OID 19683)
-- Dependencies: 352
-- Data for Name: banner_documents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.banner_documents (id, banner_id, document_type, title, description, r2_file_key, r2_filename, r2_content_type, r2_file_size, uploaded_by, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4688 (class 0 OID 18585)
-- Dependencies: 273
-- Data for Name: banners; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.banners (id, title, description, redirect_link, display_start_date, display_end_date, display_location, status, created_at, updated_at, display_order, r2_file_key, r2_filename, r2_content_type, r2_file_size, r2_public_url) FROM stdin;
4	tets	sd		2026-05-17	2026-06-26	dashboard	t	2026-05-17 06:20:42.782885	2026-05-17 06:20:42.782885	1	banners/20260517_062042_8d4fe9f5a4656b43_WhatsApp Image 2026-05-17 at 9.51.47 AM.jpeg	WhatsApp Image 2026-05-17 at 9.51.47 AM.jpeg	image/jpeg	492833	https://pub-5c8ca1934dba43a9bc18041c326adce0.r2.dev/banners/20260517_062042_8d4fe9f5a4656b43_WhatsApp Image 2026-05-17 at 9.51.47 AM.jpeg
\.


--
-- TOC entry 4734 (class 0 OID 19191)
-- Dependencies: 319
-- Data for Name: broker_codes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.broker_codes (id, broker_id, broker_code, company_name, status, created_at, updated_at, agent_name) FROM stdin;
1	1	IP207778	\N	t	2026-05-11 10:40:44.053996	2026-05-11 10:40:44.053996	DEVARAJ J
2	2	DP3730361	\N	t	2026-05-11 10:41:48.707775	2026-05-11 10:41:48.707775	DEVARAJ J
3	3	EI00047921	\N	t	2026-05-11 10:43:02.921737	2026-05-11 10:43:02.921737	LATHA J
4	4	94181	\N	t	2026-05-11 10:44:12.804573	2026-05-11 10:44:12.804573	DEVARAJ J
5	4	BHA35393	\N	t	2026-05-11 10:45:19.624755	2026-05-11 10:45:19.624755	BHARATH D
\.


--
-- TOC entry 4674 (class 0 OID 18261)
-- Dependencies: 259
-- Data for Name: brokers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.brokers (id, name, status, created_at, updated_at, insurance_company_id) FROM stdin;
1	Policy Bazaar	active	2026-05-11 10:40:09.813232	2026-05-11 10:40:09.813232	\N
2	TurtleMint	active	2026-05-11 10:41:28.812533	2026-05-11 10:41:28.812533	\N
3	RenewBuy	active	2026-05-11 10:42:06.864397	2026-05-11 10:42:06.864397	\N
4	Prudent	active	2026-05-11 10:43:56.272725	2026-05-11 10:43:56.272725	\N
\.


--
-- TOC entry 4680 (class 0 OID 18463)
-- Dependencies: 265
-- Data for Name: client_requests; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_requests (id, ticket_number, name, email, phone_number, description, status, priority, submitted_at, admin_response, resolved_at, resolved_by_id, created_at, updated_at, category, submitter_type, submitter_id, subject, request_type) FROM stdin;
4	TKT-20260517-0002	Samparka Association	samparka.blr@gmail.com	8296348359	Attend IAP meet next week	pending	medium	2026-05-17 12:02:48.001408	will update reg this	\N	\N	2026-05-17 12:02:48.016889	2026-05-17 12:03:20.91096	general	SubAgent	2	Help Request from Samparka Association	\N
3	TKT-20260517-0001	DEVARAJ J	bittideva@gmail.com	6361760165	Rhrj	in_progress	medium	2026-05-17 04:42:59.438974	kyc	\N	\N	2026-05-17 04:42:59.447755	2026-05-18 03:31:54.030736	general	SubAgent	1	Help Request from DEVARAJ J	\N
5	TKT-20260526-0001	LOKESH SHIVANNA	sirifincorp@gmail.com	9902069391	Revert back to me onthe query of dr krishna 	pending	medium	2026-05-26 14:13:02.571096	Our staff will reach out to you 	\N	\N	2026-05-26 14:13:02.579981	2026-05-26 14:14:35.509998	general	SubAgent	3	Help Request from LOKESH SHIVANNA	\N
2	TKT-20260516-0001	LOKESH SHIVANNA	sirifincorp@gmail.com	9902069391	Hiw to refer a mutual fund client 	in_progress	medium	2026-05-16 11:30:47.913002	In Dr WISE App - add the Client information	\N	\N	2026-05-16 11:30:47.920204	2026-05-28 08:55:20.631998	general	SubAgent	3	Help Request from LOKESH SHIVANNA	\N
1	TKT-20260515-0001	ddf df	9093939393fdfds@gmail.com	8989191919	Bebe	closed	medium	2026-05-15 14:31:18.736668	\N	2026-06-02 22:07:34.570904	\N	2026-05-15 14:31:18.745681	2026-06-02 22:07:34.57081	general	Customer	9	Help Request from ddf df	\N
\.


--
-- TOC entry 4805 (class 0 OID 20911)
-- Dependencies: 390
-- Data for Name: client_services; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.client_services (id, service_type, service_category, customer_id, sub_agent_id, distributor_id, amount, status, reference_number, start_date, notes, main_agent_commission_percentage, commission_amount, tds_percentage, tds_amount, after_tds_value, sub_agent_commission_percentage, sub_agent_commission_amount, sub_agent_tds_percentage, sub_agent_tds_amount, sub_agent_after_tds_value, distributor_commission_percentage, distributor_commission_amount, distributor_tds_percentage, distributor_tds_amount, distributor_after_tds_value, investor_commission_percentage, investor_commission_amount, company_expenses_percentage, company_expenses_amount, total_distribution_percentage, profit_percentage, profit_amount, created_at, updated_at) FROM stdin;
1	investments_fd	investments	3	1	1	33.98	pending		\N		10.00	3.40	0.00	0.00	3.40	2.00	0.68	0.00	0.00	0.68	0.00	0.00	0.00	0.00	0.00	2.00	0.68	0.00	0.00	4.00	6.00	2.04	2026-06-01 10:07:03.413375	2026-06-01 10:07:03.413375
\.


--
-- TOC entry 4708 (class 0 OID 18828)
-- Dependencies: 293
-- Data for Name: commission_payouts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.commission_payouts (id, policy_type, policy_id, payout_to, payout_amount, payout_date, status, created_at, updated_at, transaction_id, payment_mode, reference_number, commission_amount_received, distribution_percentage, notes, processed_by, processed_at, payout_id, lead_id, invoiced, total_commission_amount, tds_amount) FROM stdin;
195	health	52	company_expense	491.9	2026-06-19	pending	2026-05-20 14:05:07.398996	2026-05-20 14:05:07.398996	\N	internal	COMP_40_1779285907	\N	\N	Company expense allocation for health policy	system_auto	\N	40	CUSLEAD-KRISH-32790	f	\N	\N
16	health	15	main_agent	1095.14	2024-06-15	paid	2026-05-13 01:37:56.071114	2026-05-26 13:54:50.817671	20240615001	bank_transfer	MAIN_4_1778636276	\N	\N	referred by Naga CM	admin@drwise.com	2026-05-26 13:54:50.816618	4	CUSLEAD-CMX-938-280-HLT	f	\N	\N
17	health	15	affiliate	433.49	2026-05-26	paid	2026-05-13 01:37:56.172087	2026-05-26 13:55:52.895889	20240615A001	bank_transfer	AFF_4_1778636276	\N	\N		admin@drwise.com	2026-05-26 13:55:52.89537	4	CUSLEAD-CMX-938-280-HLT	f	\N	\N
18	health	15	ambassador	86.7	2026-05-26	paid	2026-05-13 01:37:56.269248	2026-05-26 13:56:12.495909	20240615B001	bank_transfer	AMB_4_1778636276	\N	\N		admin@drwise.com	2026-05-26 13:56:12.495258	4	CUSLEAD-CMX-938-280-HLT	f	\N	\N
19	health	15	investor	91.26	2026-05-26	paid	2026-05-13 01:37:56.273237	2026-05-26 13:57:20.580842	20240615I001	bank_transfer	INV_4_1778636276	\N	\N		admin@drwise.com	2026-05-26 13:57:20.579851	4	CUSLEAD-CMX-938-280-HLT	f	\N	\N
20	health	15	company_expense	91.2615	2026-05-26	paid	2026-05-13 01:37:56.278096	2026-05-26 13:57:37.057869	20240615C001	internal	COMP_4_1778636276	\N	\N		admin@drwise.com	2026-05-26 13:57:37.057362	4	CUSLEAD-CMX-938-280-HLT	f	\N	\N
196	motor	13	main_agent	7176.8	2026-05-27	paid	2026-05-27 10:29:24.992777	2026-05-28 09:12:30.197639	IN22614707389020	bank_transfer	MAIN_41_1779877764	\N	\N	9671	admin@drwise.com	2026-05-28 09:12:30.197147	41	CUSLEAD-HANUM-AISPH	f	\N	\N
232	motor	17	investor	35.1	2026-07-02	pending	2026-06-02 13:52:21.864092	2026-06-02 13:52:21.864092	\N	bank_transfer	INV_48_1780408341	\N	\N	Investor commission for motor policy. Policy Number: D268395947	system_auto	\N	48	\N	f	\N	\N
233	motor	17	company_expense	70.2	2026-07-02	pending	2026-06-02 13:52:21.869361	2026-06-02 13:52:21.869361	\N	internal	COMP_48_1780408341	\N	\N	Company expense allocation for motor policy	system_auto	\N	48	\N	f	\N	\N
230	motor	17	affiliate	34.4	2026-06-02	paid	2026-06-02 13:52:21.856818	2026-06-02 13:55:02.993117	260529A001	bank_transfer	AFF_48_1780408341	\N	\N		admin@drwise.com	2026-06-02 13:55:02.992146	48	\N	f	\N	\N
231	motor	17	ambassador	6.88	2026-06-02	paid	2026-06-02 13:52:21.860681	2026-06-02 13:55:14.636221	260529B001	bank_transfer	AMB_48_1780408341	\N	\N		admin@drwise.com	2026-06-02 13:55:14.63569	48	\N	f	\N	\N
229	motor	17	main_agent	322.92	2026-05-29	paid	2026-06-02 13:52:21.851908	2026-06-02 13:57:25.291132	IN22614909224291	bank_transfer	MAIN_48_1780408341	\N	\N		admin@drwise.com	2026-06-02 13:57:25.290708	48	\N	f	\N	\N
251	health	56	main_agent	7491.83	2026-07-03	pending	2026-06-03 00:54:55.244415	2026-06-03 00:54:55.244415	\N	bank_transfer	MAIN_53_1780448095	\N	\N	Main agent commission for health policy. Policy Number: 7030003418	system_auto	\N	53	CUST-20260603-IY2TG5	f	\N	\N
252	health	56	affiliate	1547.23	2026-07-03	pending	2026-06-03 00:54:55.247986	2026-06-03 00:54:55.247986	\N	bank_transfer	AFF_53_1780448095	\N	\N	Affiliate commission for health policy. Sub-agent ID: 13	system_auto	\N	53	CUST-20260603-IY2TG5	f	\N	\N
253	health	56	ambassador	309.44	2026-07-03	pending	2026-06-03 00:54:55.272266	2026-06-03 00:54:55.272266	\N	bank_transfer	AMB_53_1780448095	\N	\N	Ambassador commission for health policy	system_auto	\N	53	CUST-20260603-IY2TG5	f	\N	\N
254	health	56	investor	1628.66	2026-07-03	pending	2026-06-03 00:54:55.278908	2026-06-03 00:54:55.278908	\N	bank_transfer	INV_53_1780448095	\N	\N	Investor commission for health policy. Policy Number: 7030003418	system_auto	\N	53	CUST-20260603-IY2TG5	f	\N	\N
255	health	56	company_expense	1628.6585	2026-07-03	pending	2026-06-03 00:54:55.283765	2026-06-03 00:54:55.283765	\N	internal	COMP_53_1780448095	\N	\N	Company expense allocation for health policy	system_auto	\N	53	CUST-20260603-IY2TG5	f	\N	\N
256	health	57	main_agent	2701.09	2026-07-03	pending	2026-06-03 01:06:38.249978	2026-06-03 01:06:38.249978	\N	bank_transfer	MAIN_54_1780448798	\N	\N	Main agent commission for health policy. Policy Number: 9740808135	system_auto	\N	54	CUST-20260603-AX520H	f	\N	\N
257	health	57	affiliate	1368.55	2026-07-03	pending	2026-06-03 01:06:38.255001	2026-06-03 01:06:38.255001	\N	bank_transfer	AFF_54_1780448798	\N	\N	Affiliate commission for health policy. Sub-agent ID: 1	system_auto	\N	54	CUST-20260603-AX520H	f	\N	\N
258	health	57	ambassador	342.14	2026-07-03	pending	2026-06-03 01:06:38.257107	2026-06-03 01:06:38.257107	\N	bank_transfer	AMB_54_1780448798	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	54	CUST-20260603-AX520H	f	\N	\N
259	health	57	company_expense	720.2906	2026-07-03	pending	2026-06-03 01:06:38.261387	2026-06-03 01:06:38.261387	\N	internal	COMP_54_1780448798	\N	\N	Company expense allocation for health policy	system_auto	\N	54	CUST-20260603-AX520H	f	\N	\N
285	health	64	main_agent	3555.45	2026-07-03	pending	2026-06-03 05:01:33.210837	2026-06-03 05:01:33.210837	\N	bank_transfer	MAIN_61_1780462893	\N	\N	Main agent commission for health policy. Policy Number: IDV002280092	system_auto	\N	61	CUST-20260603-OODTIX	f	\N	\N
286	health	64	affiliate	1125.89	2026-07-03	pending	2026-06-03 05:01:33.214732	2026-06-03 05:01:33.214732	\N	bank_transfer	AFF_61_1780462893	\N	\N	Affiliate commission for health policy. Sub-agent ID: 1	system_auto	\N	61	CUST-20260603-OODTIX	f	\N	\N
287	health	64	ambassador	225.18	2026-07-03	pending	2026-06-03 05:01:33.2195	2026-06-03 05:01:33.2195	\N	bank_transfer	AMB_61_1780462893	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	61	CUST-20260603-OODTIX	f	\N	\N
288	health	64	investor	1185.15	2026-07-03	pending	2026-06-03 05:01:33.222597	2026-06-03 05:01:33.222597	\N	bank_transfer	INV_61_1780462893	\N	\N	Investor commission for health policy. Policy Number: IDV002280092	system_auto	\N	61	CUST-20260603-OODTIX	f	\N	\N
289	health	64	company_expense	474.06	2026-07-03	pending	2026-06-03 05:01:33.226465	2026-06-03 05:01:33.226465	\N	internal	COMP_61_1780462893	\N	\N	Company expense allocation for health policy	system_auto	\N	61	CUST-20260603-OODTIX	f	\N	\N
290	health	65	main_agent	4536.0	2026-07-03	pending	2026-06-03 05:10:07.079755	2026-06-03 05:10:07.079755	\N	bank_transfer	MAIN_62_1780463407	\N	\N	Main agent commission for health policy. Policy Number: 7045112500083174	system_auto	\N	62	CUST-20260603-1Q9QHT	f	\N	\N
291	health	65	affiliate	1077.3	2026-07-03	pending	2026-06-03 05:10:07.083034	2026-06-03 05:10:07.083034	\N	bank_transfer	AFF_62_1780463407	\N	\N	Affiliate commission for health policy. Sub-agent ID: 2	system_auto	\N	62	CUST-20260603-1Q9QHT	f	\N	\N
292	health	65	ambassador	215.46	2026-07-03	pending	2026-06-03 05:10:07.085609	2026-06-03 05:10:07.085609	\N	bank_transfer	AMB_62_1780463407	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	62	CUST-20260603-1Q9QHT	f	\N	\N
293	health	65	investor	1134.0	2026-07-03	pending	2026-06-03 05:10:07.088598	2026-06-03 05:10:07.088598	\N	bank_transfer	INV_62_1780463407	\N	\N	Investor commission for health policy. Policy Number: 7045112500083174	system_auto	\N	62	CUST-20260603-1Q9QHT	f	\N	\N
294	health	65	company_expense	1134.0	2026-07-03	pending	2026-06-03 05:10:07.091948	2026-06-03 05:10:07.091948	\N	internal	COMP_62_1780463407	\N	\N	Company expense allocation for health policy	system_auto	\N	62	CUST-20260603-1Q9QHT	f	\N	\N
310	motor	20	main_agent	177.3	2026-07-03	pending	2026-06-03 18:26:58.026716	2026-06-03 18:26:58.026716	\N	bank_transfer	MAIN_66_1780511218	\N	\N	Main agent commission for motor policy. Policy Number: 6107213023 00 00	system_auto	\N	66	\N	f	\N	\N
311	motor	20	affiliate	57.92	2026-07-03	pending	2026-06-03 18:26:58.031765	2026-06-03 18:26:58.031765	\N	bank_transfer	AFF_66_1780511218	\N	\N	Affiliate commission for motor policy. Sub-agent ID: 8	system_auto	\N	66	\N	f	\N	\N
312	motor	20	ambassador	11.58	2026-07-03	pending	2026-06-03 18:26:58.036226	2026-06-03 18:26:58.036226	\N	bank_transfer	AMB_66_1780511218	\N	\N	Ambassador commission for motor policy. Distributor ID: 4	system_auto	\N	66	\N	f	\N	\N
181	health	2	affiliate	1153.0	2026-05-16	pending	2026-05-16 12:13:23.998909	2026-05-16 12:13:23.998909	\N	bank_transfer	AFF_MANUAL_2_1778933603	\N	5.00	Manual: health policy #89557128	admin_manual	\N	\N	CUST-20260511-PSEL8R	f	\N	\N
234	motor	18	main_agent	344.35	2026-07-02	pending	2026-06-02 16:49:57.687652	2026-06-02 16:49:57.687652	\N	bank_transfer	MAIN_49_1780418997	\N	\N	Main agent commission for motor policy. Policy Number: D268909373	system_auto	\N	49	\N	f	\N	\N
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
235	motor	18	affiliate	100.52	2026-07-02	pending	2026-06-02 16:49:57.691243	2026-06-02 16:49:57.691243	\N	bank_transfer	AFF_49_1780418997	\N	\N	Affiliate commission for motor policy. Sub-agent ID: 11	system_auto	\N	49	\N	f	\N	\N
236	motor	18	ambassador	7.18	2026-07-02	pending	2026-06-02 16:49:57.69449	2026-06-02 16:49:57.69449	\N	bank_transfer	AMB_49_1780418997	\N	\N	Ambassador commission for motor policy. Distributor ID: 1	system_auto	\N	49	\N	f	\N	\N
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
237	motor	18	investor	36.63	2026-07-02	pending	2026-06-02 16:49:57.697813	2026-06-02 16:49:57.697813	\N	bank_transfer	INV_49_1780418997	\N	\N	Investor commission for motor policy. Policy Number: D268909373	system_auto	\N	49	\N	f	\N	\N
97	health	38	affiliate	1813.9	2026-06-14	pending	2026-05-15 03:29:10.830875	2026-05-15 03:29:10.830875	\N	bank_transfer	AFF_20_1778815750	\N	\N	Affiliate commission for health policy. Sub-agent ID: 3	system_auto	\N	20	CUSLEAD-DR -161-280-HLT	f	\N	\N
98	health	38	ambassador	370.18	2026-06-14	pending	2026-05-15 03:29:10.869432	2026-05-15 03:29:10.869432	\N	bank_transfer	AMB_20_1778815750	\N	\N	Ambassador commission for health policy. Distributor ID: 2	system_auto	\N	20	CUSLEAD-DR -161-280-HLT	f	\N	\N
99	health	38	investor	1850.92	2026-06-14	pending	2026-05-15 03:29:10.87499	2026-05-15 03:29:10.87499	\N	bank_transfer	INV_20_1778815750	\N	\N	Investor commission for health policy. Policy Number: 34370258202501	system_auto	\N	20	CUSLEAD-DR -161-280-HLT	f	\N	\N
100	health	38	company_expense	925.46	2026-06-14	pending	2026-05-15 03:29:10.878788	2026-05-15 03:29:10.878788	\N	internal	COMP_20_1778815750	\N	\N	Company expense allocation for health policy	system_auto	\N	20	CUSLEAD-DR -161-280-HLT	f	\N	\N
238	motor	18	company_expense	36.633	2026-07-02	pending	2026-06-02 16:49:57.701149	2026-06-02 16:49:57.701149	\N	internal	COMP_49_1780418997	\N	\N	Company expense allocation for motor policy	system_auto	\N	49	\N	f	\N	\N
260	health	58	main_agent	8148.61	2026-07-03	pending	2026-06-03 01:15:34.768751	2026-06-03 01:15:34.768751	\N	bank_transfer	MAIN_55_1780449334	\N	\N	Main agent commission for health policy. Policy Number: 4225i/ELVT/372710990/00/000	system_auto	\N	55	CUST-20260603-XQBHCE	f	\N	\N
261	health	58	affiliate	1682.87	2026-07-03	pending	2026-06-03 01:15:34.772015	2026-06-03 01:15:34.772015	\N	bank_transfer	AFF_55_1780449334	\N	\N	Affiliate commission for health policy. Sub-agent ID: 1	system_auto	\N	55	CUST-20260603-XQBHCE	f	\N	\N
262	health	58	ambassador	336.58	2026-07-03	pending	2026-06-03 01:15:34.774557	2026-06-03 01:15:34.774557	\N	bank_transfer	AMB_55_1780449334	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	55	CUST-20260603-XQBHCE	f	\N	\N
263	health	58	company_expense	1771.437	2026-07-03	pending	2026-06-03 01:15:34.777098	2026-06-03 01:15:34.777098	\N	internal	COMP_55_1780449334	\N	\N	Company expense allocation for health policy	system_auto	\N	55	CUST-20260603-XQBHCE	f	\N	\N
264	health	59	main_agent	2653.75	2026-07-03	pending	2026-06-03 01:32:22.381055	2026-06-03 01:32:22.381055	\N	bank_transfer	MAIN_56_1780450342	\N	\N	Main agent commission for health policy. Policy Number: 34560831202400	system_auto	\N	56	CUST-20260603-2EJKUR	f	\N	\N
265	health	59	affiliate	1008.42	2026-07-03	pending	2026-06-03 01:32:22.383717	2026-06-03 01:32:22.383717	\N	bank_transfer	AFF_56_1780450342	\N	\N	Affiliate commission for health policy. Sub-agent ID: 3	system_auto	\N	56	CUST-20260603-2EJKUR	f	\N	\N
198	motor	13	ambassador	170.45	2026-05-28	paid	2026-05-27 10:29:27.925365	2026-05-28 09:15:03.663869	202605B001	bank_transfer	AMB_41_1779877767	\N	\N		admin@drwise.com	2026-05-28 09:15:03.663205	41	CUSLEAD-HANUM-AISPH	f	\N	\N
199	motor	13	investor	897.1	2026-05-28	paid	2026-05-27 10:29:29.076072	2026-05-28 09:15:20.015923	202605I001	bank_transfer	INV_41_1779877769	\N	\N		admin@drwise.com	2026-05-28 09:15:20.015462	41	CUSLEAD-HANUM-AISPH	f	\N	\N
200	motor	13	company_expense	538.26	2026-05-28	paid	2026-05-27 10:29:30.207181	2026-05-28 09:15:28.559284	202605C001	internal	COMP_41_1779877770	\N	\N		admin@drwise.com	2026-05-28 09:15:28.558534	41	CUSLEAD-HANUM-AISPH	f	\N	\N
96	health	38	main_agent	5899.81	2026-05-29	paid	2026-05-15 03:29:10.825928	2026-05-29 10:42:35.66947	dsd	bank_transfer	MAIN_20_1778815750	\N	\N	sd	admin@drwise.com	2026-05-29 10:42:35.668723	20	CUSLEAD-DR -161-280-HLT	f	\N	\N
239	health	53	main_agent	3265.77	2026-07-02	pending	2026-06-02 23:38:56.788247	2026-06-02 23:38:56.788247	\N	bank_transfer	MAIN_50_1780443536	\N	\N	Main agent commission for health policy. Policy Number: 34428150202400	system_auto	\N	50	CUST-20260513-FOTT6S	f	\N	\N
240	health	53	affiliate	674.45	2026-07-02	pending	2026-06-02 23:38:56.791572	2026-06-02 23:38:56.791572	\N	bank_transfer	AFF_50_1780443536	\N	\N	Affiliate commission for health policy. Sub-agent ID: 1	system_auto	\N	50	CUST-20260513-FOTT6S	f	\N	\N
241	health	53	ambassador	134.89	2026-07-02	pending	2026-06-02 23:38:56.794648	2026-06-02 23:38:56.794648	\N	bank_transfer	AMB_50_1780443536	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	50	CUST-20260513-FOTT6S	f	\N	\N
242	health	53	company_expense	709.95	2026-07-02	pending	2026-06-02 23:38:56.797672	2026-06-02 23:38:56.797672	\N	internal	COMP_50_1780443536	\N	\N	Company expense allocation for health policy	system_auto	\N	50	CUST-20260513-FOTT6S	f	\N	\N
266	health	59	ambassador	201.68	2026-07-03	pending	2026-06-03 01:32:22.386893	2026-06-03 01:32:22.386893	\N	bank_transfer	AMB_56_1780450342	\N	\N	Ambassador commission for health policy. Distributor ID: 2	system_auto	\N	56	CUST-20260603-2EJKUR	f	\N	\N
267	health	59	company_expense	849.2	2026-07-03	pending	2026-06-03 01:32:22.390928	2026-06-03 01:32:22.390928	\N	internal	COMP_56_1780450342	\N	\N	Company expense allocation for health policy	system_auto	\N	56	CUST-20260603-2EJKUR	f	\N	\N
268	health	60	main_agent	6003.25	2026-07-03	pending	2026-06-03 01:37:14.642826	2026-06-03 01:37:14.642826	\N	bank_transfer	MAIN_57_1780450634	\N	\N	Main agent commission for health policy. Policy Number: 34551958202400	system_auto	\N	57	CUSLEAD-HAR-566-270-HLT	f	\N	\N
269	health	60	affiliate	1824.99	2026-07-03	pending	2026-06-03 01:37:14.645347	2026-06-03 01:37:14.645347	\N	bank_transfer	AFF_57_1780450634	\N	\N	Affiliate commission for health policy. Sub-agent ID: 3	system_auto	\N	57	CUSLEAD-HAR-566-270-HLT	f	\N	\N
270	health	60	ambassador	456.25	2026-07-03	pending	2026-06-03 01:37:14.648439	2026-06-03 01:37:14.648439	\N	bank_transfer	AMB_57_1780450634	\N	\N	Ambassador commission for health policy. Distributor ID: 2	system_auto	\N	57	CUSLEAD-HAR-566-270-HLT	f	\N	\N
271	health	60	company_expense	1921.04	2026-07-03	pending	2026-06-03 01:37:14.650926	2026-06-03 01:37:14.650926	\N	internal	COMP_57_1780450634	\N	\N	Company expense allocation for health policy	system_auto	\N	57	CUSLEAD-HAR-566-270-HLT	f	\N	\N
276	health	62	main_agent	4900.33	2026-07-03	pending	2026-06-03 02:27:49.559096	2026-06-03 02:27:49.559096	\N	bank_transfer	MAIN_59_1780453669	\N	\N	Main agent commission for health policy. Policy Number: PROPRM050120013	system_auto	\N	59	CUST-20260603-1HJN1I	f	\N	\N
277	health	62	affiliate	2116.05	2026-07-03	pending	2026-06-03 02:27:49.561918	2026-06-03 02:27:49.561918	\N	bank_transfer	AFF_59_1780453669	\N	\N	Affiliate commission for health policy. Sub-agent ID: 15	system_auto	\N	59	CUST-20260603-1HJN1I	f	\N	\N
278	health	62	ambassador	423.21	2026-07-03	pending	2026-06-03 02:27:49.564408	2026-06-03 02:27:49.564408	\N	bank_transfer	AMB_59_1780453669	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	59	CUST-20260603-1HJN1I	f	\N	\N
279	health	62	company_expense	890.9694	2026-07-03	pending	2026-06-03 02:27:49.566866	2026-06-03 02:27:49.566866	\N	internal	COMP_59_1780453669	\N	\N	Company expense allocation for health policy	system_auto	\N	59	CUST-20260603-1HJN1I	f	\N	\N
295	health	66	main_agent	4829.4	2026-07-03	pending	2026-06-03 05:23:25.296483	2026-06-03 05:23:25.296483	\N	bank_transfer	MAIN_63_1780464205	\N	\N	Main agent commission for health policy. Policy Number: 2851112500070677,	system_auto	\N	63	CUST-20260603-8DZK0V	f	\N	\N
296	health	66	affiliate	1146.98	2026-07-03	pending	2026-06-03 05:23:25.29989	2026-06-03 05:23:25.29989	\N	bank_transfer	AFF_63_1780464205	\N	\N	Affiliate commission for health policy. Sub-agent ID: 1	system_auto	\N	63	CUST-20260603-8DZK0V	f	\N	\N
211	health	2	main_agent	2912.83	2026-06-10	pending	2026-05-27 10:29:52.734721	2026-05-27 10:29:52.734721	\N	bank_transfer	MAIN_44_1779877792	\N	\N	Main agent commission for health policy. Policy Number: 89557128	system_auto	\N	44	CUST-20260511-PSEL8R	f	\N	\N
212	health	2	affiliate	1153.0	2026-06-10	pending	2026-05-27 10:29:53.869784	2026-05-27 10:29:53.869784	\N	bank_transfer	AFF_44_1779877793	\N	\N	Affiliate commission for health policy. Sub-agent ID: 2	system_auto	\N	44	CUST-20260511-PSEL8R	f	\N	\N
213	health	2	ambassador	230.6	2026-06-10	pending	2026-05-27 10:29:54.995655	2026-05-27 10:29:54.995655	\N	bank_transfer	AMB_44_1779877794	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	44	CUST-20260511-PSEL8R	f	\N	\N
214	health	2	company_expense	1213.679	2026-06-10	pending	2026-05-27 10:29:56.151125	2026-05-27 10:29:56.151125	\N	internal	COMP_44_1779877796	\N	\N	Company expense allocation for health policy	system_auto	\N	44	CUST-20260511-PSEL8R	f	\N	\N
215	health	1	main_agent	2920.37	2026-06-10	pending	2026-05-27 10:29:59.740654	2026-05-27 10:29:59.740654	\N	bank_transfer	MAIN_45_1779877799	\N	\N	Main agent commission for health policy. Policy Number: 85432300	system_auto	\N	45	CUST-20260511-UQMMSS	f	\N	\N
216	health	1	affiliate	433.49	2026-06-10	pending	2026-05-27 10:30:00.868863	2026-05-27 10:30:00.868863	\N	bank_transfer	AFF_45_1779877800	\N	\N	Affiliate commission for health policy. Sub-agent ID: 1	system_auto	\N	45	CUST-20260511-UQMMSS	f	\N	\N
217	health	1	ambassador	86.7	2026-06-10	pending	2026-05-27 10:30:01.997055	2026-05-27 10:30:01.997055	\N	bank_transfer	AMB_45_1779877801	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	45	CUST-20260511-UQMMSS	f	\N	\N
218	health	1	company_expense	456.3075	2026-06-10	pending	2026-05-27 10:30:03.123368	2026-05-27 10:30:03.123368	\N	internal	COMP_45_1779877803	\N	\N	Company expense allocation for health policy	system_auto	\N	45	CUST-20260511-UQMMSS	f	\N	\N
297	health	66	ambassador	229.4	2026-07-03	pending	2026-06-03 05:23:25.302468	2026-06-03 05:23:25.302468	\N	bank_transfer	AMB_63_1780464205	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	63	CUST-20260603-8DZK0V	f	\N	\N
298	health	66	investor	1207.35	2026-07-03	pending	2026-06-03 05:23:25.305646	2026-06-03 05:23:25.305646	\N	bank_transfer	INV_63_1780464205	\N	\N	Investor commission for health policy. Policy Number: 2851112500070677,	system_auto	\N	63	CUST-20260603-8DZK0V	f	\N	\N
299	health	66	company_expense	1207.35	2026-07-03	pending	2026-06-03 05:23:25.308183	2026-06-03 05:23:25.308183	\N	internal	COMP_63_1780464205	\N	\N	Company expense allocation for health policy	system_auto	\N	63	CUST-20260603-8DZK0V	f	\N	\N
313	motor	20	investor	59.1	2026-07-03	pending	2026-06-03 18:26:58.039736	2026-06-03 18:26:58.039736	\N	bank_transfer	INV_66_1780511218	\N	\N	Investor commission for motor policy. Policy Number: 6107213023 00 00	system_auto	\N	66	\N	f	\N	\N
314	motor	20	company_expense	23.64	2026-07-03	pending	2026-06-03 18:26:58.044119	2026-06-03 18:26:58.044119	\N	internal	COMP_66_1780511218	\N	\N	Company expense allocation for motor policy	system_auto	\N	66	\N	f	\N	\N
225	life	9	affiliate	3627.18	2026-06-28	pending	2026-05-29 02:39:18.769935	2026-05-29 02:39:18.769935	\N	bank_transfer	AFF_47_1780022358	\N	\N	Affiliate commission for life policy. Sub-agent ID: 2	system_auto	\N	47	CUST-20260519-D1IE2M	f	\N	\N
226	life	9	ambassador	725.44	2026-06-28	pending	2026-05-29 02:39:18.773433	2026-05-29 02:39:18.773433	\N	bank_transfer	AMB_47_1780022358	\N	\N	Ambassador commission for life policy. Distributor ID: 1	system_auto	\N	47	CUST-20260519-D1IE2M	f	\N	\N
224	life	9	main_agent	29380.13	2026-05-29	paid	2026-05-29 02:39:18.719167	2026-05-29 10:37:25.177234	sdds	bank_transfer	MAIN_47_1780022358	\N	\N	sd	admin@drwise.com	2026-05-29 10:37:25.176537	47	CUST-20260519-D1IE2M	f	\N	\N
187	health	51	main_agent	1150.0	2026-06-17	pending	2026-05-18 03:05:59.852778	2026-05-18 03:05:59.852778	\N	bank_transfer	MAIN_39_1779073559	\N	\N	Main agent commission for health policy. Policy Number: REQ-1779073559	system_auto	\N	39	CUST-20260515-97KL1W	f	\N	\N
188	health	51	ambassador	230.0	2026-06-17	pending	2026-05-18 03:05:59.855349	2026-05-18 03:05:59.855349	\N	bank_transfer	AMB_39_1779073559	\N	\N	Ambassador commission for health policy	system_auto	\N	39	CUST-20260515-97KL1W	f	\N	\N
189	health	51	investor	230.0	2026-06-17	pending	2026-05-18 03:05:59.857272	2026-05-18 03:05:59.857272	\N	bank_transfer	INV_39_1779073559	\N	\N	Investor commission for health policy. Policy Number: REQ-1779073559	system_auto	\N	39	CUST-20260515-97KL1W	f	\N	\N
190	health	51	company_expense	230.0	2026-06-17	pending	2026-05-18 03:05:59.859582	2026-05-18 03:05:59.859582	\N	internal	COMP_39_1779073559	\N	\N	Company expense allocation for health policy	system_auto	\N	39	CUST-20260515-97KL1W	f	\N	\N
243	health	54	main_agent	2346.92	2026-07-02	pending	2026-06-02 23:47:42.298325	2026-06-02 23:47:42.298325	\N	bank_transfer	MAIN_51_1780444062	\N	\N	Main agent commission for health policy. Policy Number: 4225i/P-ELVT/363000758/00/000	system_auto	\N	51	CUST-20260602-8TQAHL	f	\N	\N
244	health	54	affiliate	891.83	2026-07-02	pending	2026-06-02 23:47:42.301551	2026-06-02 23:47:42.301551	\N	bank_transfer	AFF_51_1780444062	\N	\N	Affiliate commission for health policy. Sub-agent ID: 4	system_auto	\N	51	CUST-20260602-8TQAHL	f	\N	\N
245	health	54	ambassador	222.96	2026-07-02	pending	2026-06-02 23:47:42.304044	2026-06-02 23:47:42.304044	\N	bank_transfer	AMB_51_1780444062	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	51	CUST-20260602-8TQAHL	f	\N	\N
246	health	54	company_expense	704.0766	2026-07-02	pending	2026-06-02 23:47:42.306705	2026-06-02 23:47:42.306705	\N	internal	COMP_51_1780444062	\N	\N	Company expense allocation for health policy	system_auto	\N	51	CUST-20260602-8TQAHL	f	\N	\N
272	health	61	main_agent	1317.88	2026-07-03	pending	2026-06-03 01:51:00.960436	2026-06-03 01:51:00.960436	\N	bank_transfer	MAIN_58_1780451460	\N	\N	Main agent commission for health policy. Policy Number: 95514336	system_auto	\N	58	CUST-20260603-TKTGK1	f	\N	\N
273	health	61	affiliate	417.33	2026-07-03	pending	2026-06-03 01:51:00.962734	2026-06-03 01:51:00.962734	\N	bank_transfer	AFF_58_1780451460	\N	\N	Affiliate commission for health policy. Sub-agent ID: 14	system_auto	\N	58	CUST-20260603-TKTGK1	f	\N	\N
227	life	9	investor	3701.2	2026-06-28	pending	2026-05-29 02:39:18.777996	2026-05-29 02:39:18.777996	\N	bank_transfer	INV_47_1780022358	\N	\N	Investor commission for life policy. Policy Number: K7676680	system_auto	\N	47	CUST-20260519-D1IE2M	f	\N	\N
228	life	9	company_expense	3701.2	2026-06-28	pending	2026-05-29 02:39:18.780898	2026-05-29 02:39:18.780898	\N	internal	COMP_47_1780022358	\N	\N	Company expense allocation for life policy	system_auto	\N	47	CUST-20260519-D1IE2M	f	\N	\N
274	health	61	ambassador	104.33	2026-07-03	pending	2026-06-03 01:51:00.965549	2026-06-03 01:51:00.965549	\N	bank_transfer	AMB_58_1780451460	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	58	CUST-20260603-TKTGK1	f	\N	\N
275	health	61	company_expense	439.2944	2026-07-03	pending	2026-06-03 01:51:00.968279	2026-06-03 01:51:00.968279	\N	internal	COMP_58_1780451460	\N	\N	Company expense allocation for health policy	system_auto	\N	58	CUST-20260603-TKTGK1	f	\N	\N
300	health	67	main_agent	1202.16	2026-07-03	pending	2026-06-03 14:01:25.872143	2026-06-03 14:01:25.872143	\N	bank_transfer	MAIN_64_1780495285	\N	\N	Main agent commission for health policy. Policy Number: 7330061278	system_auto	\N	64	CUST-20260603-LMCP9O	f	\N	\N
301	health	67	affiliate	380.68	2026-07-03	pending	2026-06-03 14:01:25.87513	2026-06-03 14:01:25.87513	\N	bank_transfer	AFF_64_1780495285	\N	\N	Affiliate commission for health policy. Sub-agent ID: 10	system_auto	\N	64	CUST-20260603-LMCP9O	f	\N	\N
302	health	67	ambassador	76.13	2026-07-03	pending	2026-06-03 14:01:25.877236	2026-06-03 14:01:25.877236	\N	bank_transfer	AMB_64_1780495285	\N	\N	Ambassador commission for health policy. Distributor ID: 7	system_auto	\N	64	CUST-20260603-LMCP9O	f	\N	\N
303	health	67	investor	400.72	2026-07-03	pending	2026-06-03 14:01:25.879339	2026-06-03 14:01:25.879339	\N	bank_transfer	INV_64_1780495285	\N	\N	Investor commission for health policy. Policy Number: 7330061278	system_auto	\N	64	CUST-20260603-LMCP9O	f	\N	\N
304	health	67	company_expense	160.2878	2026-07-03	pending	2026-06-03 14:01:25.881395	2026-06-03 14:01:25.881395	\N	internal	COMP_64_1780495285	\N	\N	Company expense allocation for health policy	system_auto	\N	64	CUST-20260603-LMCP9O	f	\N	\N
247	health	55	main_agent	1582.16	2026-07-03	pending	2026-06-03 00:35:54.172229	2026-06-03 00:35:54.172229	\N	bank_transfer	MAIN_52_1780446954	\N	\N	Main agent commission for health policy. Policy Number: 7090009658	system_auto	\N	52	CUST-20260603-UF53XU	f	\N	\N
248	health	55	affiliate	601.23	2026-07-03	pending	2026-06-03 00:35:54.175878	2026-06-03 00:35:54.175878	\N	bank_transfer	AFF_52_1780446954	\N	\N	Affiliate commission for health policy. Sub-agent ID: 1	system_auto	\N	52	CUST-20260603-UF53XU	f	\N	\N
249	health	55	ambassador	200.41	2026-07-03	pending	2026-06-03 00:35:54.178659	2026-06-03 00:35:54.178659	\N	bank_transfer	AMB_52_1780446954	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	52	CUST-20260603-UF53XU	f	\N	\N
250	health	55	company_expense	421.9104	2026-07-03	pending	2026-06-03 00:35:54.181405	2026-06-03 00:35:54.181405	\N	internal	COMP_52_1780446954	\N	\N	Company expense allocation for health policy	system_auto	\N	52	CUST-20260603-UF53XU	f	\N	\N
280	health	63	main_agent	11041.84	2026-07-03	pending	2026-06-03 03:31:38.479623	2026-06-03 03:31:38.479623	\N	bank_transfer	MAIN_60_1780457498	\N	\N	Main agent commission for health policy. Policy Number: SARVAH050041079	system_auto	\N	60	CUST-20260603-FPVLYO	f	\N	\N
281	health	63	affiliate	2280.38	2026-07-03	pending	2026-06-03 03:31:38.48332	2026-06-03 03:31:38.48332	\N	bank_transfer	AFF_60_1780457498	\N	\N	Affiliate commission for health policy. Sub-agent ID: 1	system_auto	\N	60	CUST-20260603-FPVLYO	f	\N	\N
282	health	63	ambassador	456.08	2026-07-03	pending	2026-06-03 03:31:38.487262	2026-06-03 03:31:38.487262	\N	bank_transfer	AMB_60_1780457498	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	60	CUST-20260603-FPVLYO	f	\N	\N
283	health	63	investor	2400.4	2026-07-03	pending	2026-06-03 03:31:38.490477	2026-06-03 03:31:38.490477	\N	bank_transfer	INV_60_1780457498	\N	\N	Investor commission for health policy. Policy Number: SARVAH050041079	system_auto	\N	60	CUST-20260603-FPVLYO	f	\N	\N
284	health	63	company_expense	2400.4	2026-07-03	pending	2026-06-03 03:31:38.495585	2026-06-03 03:31:38.495585	\N	internal	COMP_60_1780457498	\N	\N	Company expense allocation for health policy	system_auto	\N	60	CUST-20260603-FPVLYO	f	\N	\N
305	motor	19	main_agent	7883.52	2026-07-03	pending	2026-06-03 17:54:50.503143	2026-06-03 17:54:50.503143	\N	bank_transfer	MAIN_65_1780509290	\N	\N	Main agent commission for motor policy. Policy Number: 0907003126P102573254	system_auto	\N	65	\N	f	\N	\N
306	motor	19	affiliate	4989.61	2026-07-03	pending	2026-06-03 17:54:50.50782	2026-06-03 17:54:50.50782	\N	bank_transfer	AFF_65_1780509290	\N	\N	Affiliate commission for motor policy. Sub-agent ID: 7	system_auto	\N	65	\N	f	\N	\N
307	motor	19	ambassador	160.96	2026-07-03	pending	2026-06-03 17:54:50.512302	2026-06-03 17:54:50.512302	\N	bank_transfer	AMB_65_1780509290	\N	\N	Ambassador commission for motor policy. Distributor ID: 1	system_auto	\N	65	\N	f	\N	\N
308	motor	19	investor	821.2	2026-07-03	pending	2026-06-03 17:54:50.518354	2026-06-03 17:54:50.518354	\N	bank_transfer	INV_65_1780509290	\N	\N	Investor commission for motor policy. Policy Number: 0907003126P102573254	system_auto	\N	65	\N	f	\N	\N
309	motor	19	company_expense	821.2	2026-07-03	pending	2026-06-03 17:54:50.522906	2026-06-03 17:54:50.522906	\N	internal	COMP_65_1780509290	\N	\N	Company expense allocation for motor policy	system_auto	\N	65	\N	f	\N	\N
191	health	52	main_agent	2065.98	2026-06-19	pending	2026-05-20 14:05:07.381826	2026-05-20 14:05:07.381826	\N	bank_transfer	MAIN_40_1779285907	\N	\N	Main agent commission for health policy. Policy Number: 100063248600	system_auto	\N	40	CUSLEAD-KRISH-32790	f	\N	\N
192	health	52	affiliate	482.06	2026-06-19	pending	2026-05-20 14:05:07.387122	2026-05-20 14:05:07.387122	\N	bank_transfer	AFF_40_1779285907	\N	\N	Affiliate commission for health policy. Sub-agent ID: 6	system_auto	\N	40	CUSLEAD-KRISH-32790	f	\N	\N
193	health	52	ambassador	96.41	2026-06-19	pending	2026-05-20 14:05:07.391211	2026-05-20 14:05:07.391211	\N	bank_transfer	AMB_40_1779285907	\N	\N	Ambassador commission for health policy. Distributor ID: 1	system_auto	\N	40	CUSLEAD-KRISH-32790	f	\N	\N
194	health	52	investor	491.9	2026-06-19	pending	2026-05-20 14:05:07.395192	2026-05-20 14:05:07.395192	\N	bank_transfer	INV_40_1779285907	\N	\N	Investor commission for health policy. Policy Number: 100063248600	system_auto	\N	40	CUSLEAD-KRISH-32790	f	\N	\N
\.


--
-- TOC entry 4710 (class 0 OID 18840)
-- Dependencies: 295
-- Data for Name: commission_receipts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.commission_receipts (id, policy_type, policy_id, total_commission_received, received_date, insurance_company_name, insurance_company_reference, company_commission_percentage, payment_mode, transaction_id, notes, received_by, auto_distributed, distributed_at, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4664 (class 0 OID 18172)
-- Dependencies: 249
-- Data for Name: corporate_members; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.corporate_members (id, customer_id, company_name, mobile, email, state, city, address, annual_income, pan_no, gst_no, additional_information, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4732 (class 0 OID 19164)
-- Dependencies: 317
-- Data for Name: customer_documents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customer_documents (id, customer_id, document_type, created_at, updated_at, r2_file_key, r2_filename, r2_content_type, r2_file_size) FROM stdin;
\.


--
-- TOC entry 4640 (class 0 OID 17929)
-- Dependencies: 225
-- Data for Name: customers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.customers (id, customer_type, first_name, last_name, company_name, email, mobile, address, state, city, birth_date, age, gender, height, weight, education, marital_status, occupation, job_name, type_of_duty, annual_income, pan_number, gst_number, birth_place, additional_info, status, added_by, created_at, updated_at, nominee_name, nominee_relation, nominee_date_of_birth, pincode, sub_agent, middle_name, height_feet, weight_kg, business_job, business_name, additional_information, pan_no, gst_no, sub_agent_id, lead_id, deactivated, r2_profile_image_key, r2_profile_image_filename, r2_profile_image_content_type, r2_profile_image_size, r2_profile_image_public_url, policies_count) FROM stdin;
16	individual	Adithyaa	Kasibhatta	\N	adithyaatanmayk@gmail.com	6361404087	BSK II Stage	karnataka	Bengaluru Urban	2007-10-14	18	male	\N	\N		single	\N	\N		\N	\N	\N	Secunderabad	\N	t	\N	2026-05-19 03:10:59.63744	2026-05-19 03:10:59.63744	NIVED	brother	2009-04-13	\N	Self	Tanmaoy		\N	student			QQSPK1480E	\N	6	CUST-20260519-OK6LC1	f	\N	\N	\N	\N	\N	1
18	individual	Yogesha	MS		pragathigroup2018@gmail.com	9449202517		karnataka	Bangalore	1986-05-25	40	male	\N	\N		married				\N	\N				t	sub_agent	2026-05-19 03:38:04.962832	2026-06-04 05:15:05.872942	Kaveri E	spouse	1994-02-15		Self		5.5	63.00	private_employee			ACJPY0782E	\N	1	CUST-20260519-D1IE2M	f	\N	\N	\N	\N	\N	1
25	individual	CHETHAN	H K	\N	mahatichetan@gmail.com	8884580160		karnataka	Bengaluru Urban	1986-03-04	40	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-06-03 00:33:03.244531	2026-06-03 00:33:03.244531	S VASUKIMAHATI	spouse	1991-03-14	\N	Self			\N				\N	\N	1	CUST-20260603-UF53XU	f	\N	\N	\N	\N	\N	1
23	individual	N	ADINARAYANAN		nadinarayanan@gmail.com	9035170488		karnataka	Bengaluru Urban	1950-09-03	75	male	\N	\N		married				\N	\N				t	sub_agent	2026-06-02 15:28:44.202593	2026-06-02 15:32:40.090502	N SHARADA	spouse	1957-09-04		Self			\N				ASQPA6209B	\N	11	CUSLEAD-NXXXX-ASQPA	f	\N	\N	\N	\N	\N	1
15	individual	Mani	D	\N	manikantaishan@gmail.com	9742059226	JP Nagar	Karnataka	Bengaluru 	1990-01-25	36	male	\N	\N	\N	married	\N	\N	\N	600000.0	\N	\N	\N	\N	t	agent_mobile_api_3	2026-05-18 02:50:32.871104	2026-05-18 02:50:32.871104	Indhu R	spouse	1994-05-01	560070	Self	\N	\N	\N	\N	\N	\N	BZSPM4392M	\N	3	CUST-20260518-XFOKLY	f	\N	\N	\N	\N	\N	0
4	individual	G RAVI	KIRAN		grk_sva@ymail.com	9880039901		Karnataka	Bangalore	1975-05-08	51	male	\N	\N		single			Proprietor	1000000.0	\N				t	sub_agent	2026-05-12 04:44:13.885579	2026-05-12 05:10:00.003815	G Madhusudhan	brother	1973-01-01	560004	Self			\N	self_employed	Vallabha Associates		\N	\N	1	CUST-20260512-BIVWPK	f	\N	\N	\N	\N	\N	2
7	individual	PRAMOD	SHIVAKUMAR	\N	PRAMODSHIVKUMAR79@GMAIL.COM	9945780099		karnataka	Bengaluru Urban	1979-06-20	46	male	\N	\N		married	\N	\N	Marketing	300000.0	\N	\N		\N	t	\N	2026-05-13 03:27:06.562474	2026-05-13 03:27:06.562474	Vidarbh	son	2014-10-12	\N	Self		5.17	65.00	salaried			BMRPS1515G	\N	1	CUST-20260513-5P72WP	f	\N	\N	\N	\N	\N	1
6	individual	DR KRISHNA	NAGARAJ	\N	krishnainduvalu@yahoo.co.in	9980639161		karnataka	Mandya	1979-05-28	46	male	\N	\N	MBBS	married	\N	\N	DOCTOR	2500000.0	\N	\N	MANDYA	\N	t	\N	2026-05-13 03:23:57.953796	2026-05-13 03:23:57.953796	Dr Lalitha J	spouse	1986-02-15	\N	Self		5.5	75.00	professional			ADZPN3005G	\N	3	CUST-20260513-NPBJML	f	\N	\N	\N	\N	\N	2
11	individual	Eswaraiah	Sudha	\N	sudha.e68@gmail.com	9686405652	42, Shashwathi Nilaya, 1st A Main Cross Road, Maruthi Layout, RMV 2nd Stage, Blr 560094	karnataka	Bengaluru Urban	1967-07-21	58	female	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-05-16 10:56:46.910213	2026-05-16 10:56:46.910213	Eshwaraiah H	spouse	1956-11-25	\N	Self		5.17	82.00				BSRPS7005K	\N	1	CUSLEAD-ESWAR-BSRPS	f	\N	\N	\N	\N	\N	0
22	individual	HANUMANTHA	M	\N	pradeepdjpradeep16455@gmail.com	9538247661	S/O Marigowda, 230/2, Marchanahalli, Channapatna, Karnataka 562160	karnataka	Ramanagara	1985-06-15	40	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-05-26 00:14:47.792043	2026-05-26 00:14:47.792043	PRAMODINI C	spouse	1992-12-06	\N	Self			\N				AISPH0089E	\N	8	CUSLEAD-HANUM-AISPH	f	\N	\N	\N	\N	\N	1
19	individual	K Krishna	Prasad	\N	prasadsharma5577@gmail.com	8660725693	12-1-34, 'Krishna Nivas', MT Road, New Field Street, \r\nNear Mahamaya Temple, Temple Ward, Car Street,\r\nMangalore, Karnataka 575001	karnataka	Mangaluru	2002-07-03	23	male	\N	\N		single	\N	\N		700000.0	\N	\N		\N	t	\N	2026-05-20 14:01:29.506499	2026-05-20 14:01:29.506499	VEENA BHAT	mother	1976-03-29	\N	Self		5.42	86.00	self_employed			GFVPP2999B	\N	6	CUSLEAD-KRISH-32790	f	\N	\N	\N	\N	\N	2
17	individual	GAJENDRACHARI	A	\N	gajendrachari@gmail.com	9845731819		karnataka	Bengaluru Urban	1976-02-29	50	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-05-19 03:17:12.012063	2026-05-19 03:17:12.012063	SANGEETHA	spouse	1984-02-04	\N	Self			\N	business			AFPPA8777A	\N	1	CUST-20260519-W6WKOL	f	\N	\N	\N	\N	\N	0
8	individual	GURDEEP	MANN	\N	gurdeep.mannn@gmail.com	9980698450		karnataka	Bengaluru Urban	1986-03-12	40	male	\N	\N		married	\N	\N		1000000.0	\N	\N		\N	t	\N	2026-05-13 03:33:28.293153	2026-05-13 03:33:28.293153	Mandeep Kaur	mother	1987-05-01	\N	Self	SINGH	5.83	85.00				ALAPG4528Q	\N	1	CUST-20260513-FOTT6S	f	\N	\N	\N	\N	\N	1
20	individual	N C	NIRANJAN	\N	niranjandev141@gmail.com	9945666226		karnataka	Bengaluru Rural	1995-09-08	30	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-05-25 11:38:26.132769	2026-05-25 11:38:26.132769	Rakshitha H	spouse	2003-12-19	\N	Self		5.75	74.00	business			AWDPN6661M	\N	2	CUST-20260525-JA4TGB	f	\N	\N	\N	\N	\N	0
1	individual	CM	LINGARAJU	\N	nandininaga22@gmail.com	9008666938	62 3rd Cross Durgaparameswarinagar, Kerepalya Main Road Hosakerehalli	karnataka	Bengaluru Urban	1985-05-28	40	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-05-11 11:09:22.128051	2026-05-11 11:09:22.128051	Latha S	spouse	1995-04-24	\N	Self		5.33	55.00				AEXPL1676C	\N	1	CUST-20260511-UQMMSS	f	\N	\N	\N	\N	\N	2
21	individual	N HARISH	KUMAR	\N	sribalajicommunications15@gmail.com	9845393458		karnataka	Bengaluru Urban	1972-06-24	53	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-05-25 12:01:16.612938	2026-05-25 12:01:16.612938	S C GEETHA	spouse	1982-01-27	\N	Self		5.83	90.00	self_employed			ACRPN4891K	\N	1	CUST-20260525-HYDLAG	f	\N	\N	\N	\N	\N	0
12	individual	Tarini	Eshwaraiah	\N	tarinie04@gmail.com	9361682021	RMV Extension	Karnataka	Bengaluru 	1990-04-22	36	female	\N	\N	\N	married	\N	\N	\N	\N	\N	\N	\N	\N	t	agent_mobile_api_1	2026-05-17 12:15:08.905538	2026-05-17 12:15:08.905538	Sudha E	mother	1967-01-01	560094	Self	\N	\N	\N	\N	\N	\N	ABJPE1731A	\N	1	CUST-20260517-9DWYZQ	f	\N	\N	\N	\N	\N	0
3	individual	BASAVARAJ	CHANDRASHEKAR	\N	basu2736@gmail.com	9720008888	CVC Farmhouse, Kushtagai Road, Bharat Gas, Bhagyanagar, Koppal	karnataka	Koppal	1992-08-03	33	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-05-11 12:56:05.070611	2026-05-11 12:56:05.070611	KRUTHIKA S BHOOMARADDI	spouse	1994-11-05	\N	Self		5.58	95.00	business			AQEPC0330M	\N	1	CUST-20260511-DGECKX	f	\N	\N	\N	\N	\N	1
5	individual	N	GOPAL		ngopalg77@gmail.com	9845798137		karnataka	Bengaluru Urban	1977-07-10	48	male	\N	\N		married			Proprietor	600000.0	\N				t	sub_agent	2026-05-13 01:57:36.941377	2026-06-04 05:15:46.926645	M TRIVENI	spouse	1982-04-01		Self		5.92	78.00	self_employed	GT FOODS		ALHPG4776H	\N	1	CUST-20260513-HYC5D3	f	\N	\N	\N	\N	\N	2
24	individual	VINAY	AMARNATH	\N	vudthavinay@gmail.com	9945561709		karnataka	Bengaluru Urban	1983-07-12	42	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-06-02 23:44:48.422829	2026-06-02 23:44:48.422829	Vyshnavi Vinay	spouse	1985-01-16	\N	Self		5.42	71.00				AETPA6347K	\N	4	CUST-20260602-8TQAHL	f	\N	\N	\N	\N	\N	1
26	individual	M N	NAGAVENI	\N	yukthiacharmn@gmail.com	9743901666		karnataka	Bengaluru Urban	1982-07-14	43	female	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-06-03 00:52:20.428928	2026-06-03 00:52:20.428928	B N Prakash	spouse	1975-10-31	\N	Self			\N	salaried			\N	\N	13	CUST-20260603-IY2TG5	f	\N	\N	\N	\N	\N	1
27	individual	SHIVALINGAIAH	M	\N	halkurkeshivu@gmail.com	9740808135		karnataka	Bengaluru Urban	1981-05-12	45	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-06-03 01:03:47.05887	2026-06-03 01:03:47.05887	S B PADMASHREE	spouse	1979-06-12	\N	Self			\N	self_employed			BZBPS1639C	\N	1	CUST-20260603-AX520H	f	\N	\N	\N	\N	\N	1
28	individual	Praveen	NAGARURU	\N	praveennagaruru@gmail.com	9291909767		andhra_pradesh	Anantapur	1985-05-07	41	male	\N	\N	CA	married	\N	\N		\N	\N	\N		\N	t	\N	2026-06-03 01:13:34.245446	2026-06-03 01:13:34.245446	Nagaruru Ramanjineyulu	father	1959-01-01	\N	Self	KUMAR		\N	self_employed			AFBPN0566J	\N	1	CUST-20260603-XQBHCE	f	\N	\N	\N	\N	\N	1
29	individual	HARSHAVARDHANA	R D	\N	harshavardhanrd@gmail.com	9740044566	26 2ND CROSS CHIKKABOMMASANDRA, YELAHANKA NEW TOWN, G K V K POST	karnataka	Bengaluru Urban	1980-08-27	45	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-06-03 01:29:06.796857	2026-06-03 01:29:06.796857	SHWETHA G	spouse	1987-05-31	\N	Self			\N				ACCPH6244F	\N	3	CUST-20260603-2EJKUR	f	\N	\N	\N	\N	\N	2
2	individual	YOGESHWARAPPA	K		yogi.slvglass4@gmail.com	9980990027	61, 14TH CROSS, KEMPEGOWDANAGAR, BYADARAHALLI	Karnataka	Bangalore	1980-11-25	45	male	\N	\N		married			PROPRIETOR	\N	\N				t	sub_agent	2026-05-11 11:25:03.595704	2026-06-04 05:13:33.543966	SHILPA GS	spouse	1984-01-01	560091	Self		5.33	70.00	private_employee	SLV GLASS		ABZPY0767G	\N	1	CUST-20260511-PSEL8R	f	\N	\N	\N	\N	\N	2
31	individual	R	GAYATHRI	\N	rkimpressions@gmail.com	9900094755		karnataka	Bengaluru Urban	1981-02-05	45	female	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-06-03 01:47:16.701428	2026-06-03 01:47:16.701428	VEDHA. K	daughter	2007-10-29	\N	Self			\N	salaried			ANDPG8923E	\N	14	CUST-20260603-TKTGK1	f	\N	\N	\N	\N	\N	1
36	individual	VISHAKANTHE	GOWDA	\N	vgowda664@gmail.com	9880322261		karnataka	Bengaluru Urban	1963-05-20	63	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-06-03 02:23:20.631412	2026-06-03 02:23:20.631412	BHAGYAMMA PH	spouse	1975-05-01	\N	Self			\N	business			\N	\N	15	CUST-20260603-1HJN1I	f	\N	\N	\N	\N	\N	1
37	individual	VISHWANATH	G K	\N	vishytt@yahoo.co.in	9845320335		karnataka	Bengaluru Urban	1959-05-25	67	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-06-03 03:28:10.225912	2026-06-03 03:28:10.225912	ARCHANA VISHWANATH	spouse	1972-02-07	\N	Self			\N	retired			\N	\N	1	CUST-20260603-FPVLYO	f	\N	\N	\N	\N	\N	1
38	individual	ARCHANA	VISHWANATH	\N	vishyatt@yahoo.co.in	9845320333		karnataka	Bengaluru Urban	1972-02-07	54	female	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-06-03 04:52:34.742633	2026-06-03 04:52:34.742633	ADOKSH	son	2005-01-07	\N	Self			\N	salaried			\N	\N	1	CUST-20260603-OODTIX	f	\N	\N	\N	\N	\N	1
40	individual	HONNAPPA	S	\N	honnappaamsh@gmail.com	9743968027		karnataka	Bengaluru Urban	1983-08-05	42	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-06-03 05:19:36.772234	2026-06-03 05:19:36.772234	SUMA B S	spouse	1989-12-24	\N	Self			\N				\N	\N	1	CUST-20260603-8DZK0V	f	\N	\N	\N	\N	\N	1
41	individual	KUMARA	A R	\N	kumarauppi6088@gmail.com	7259887608		karnataka	Bengaluru Urban	1988-06-24	37	male	\N	\N		single	\N	\N	PROPRIETOR	1000000.0	\N	\N		\N	t	\N	2026-06-03 13:58:43.547162	2026-06-03 13:58:43.547162	Seethamma	mother	1980-01-01	\N	Self		5.75	72.00	business	OTP		EZLPK9300R	\N	10	CUST-20260603-LMCP9O	f	\N	\N	\N	\N	\N	1
42	individual	AYAN	M	\N	jravikumar849@gmail.com	8117854975		karnataka	Bengaluru Urban	1977-03-14	49	male	\N	\N		married	\N	\N		\N	\N	\N		\N	t	\N	2026-06-03 17:49:05.269515	2026-06-03 17:49:05.269515	RAVIKUMAR J	other	1977-03-14	\N	Self			\N				IHJPM6548D	\N	7	CUST-20260603-VPCIO4	f	\N	\N	\N	\N	\N	1
44	individual	M P	VIJENDRA	\N	vijendra220@gmail.com	9620455292		karnataka	Bengaluru Urban	1982-05-01	44	male	\N	\N		married	\N	\N	PARTNER	2500000.0	\N	\N		\N	t	\N	2026-06-03 18:23:31.718871	2026-06-03 18:23:31.718871	SOWMYA HT	spouse	1982-05-01	\N	Self		5.25	91.00	business	MAVIN FOODS		AHOPV0261B	\N	8	CUST-20260603-WGTAYM	f	\N	\N	\N	\N	\N	1
39	individual	KRISHNA	MURTHY K		95krishnamurthy@gmail.com	9945708639		karnataka	Bengaluru Rural	1995-07-05	30	male	\N	\N		married				\N	\N				t	sub_agent	2026-06-03 05:07:25.696776	2026-06-04 05:12:56.467011	Renuka L	spouse	2005-08-15		Self		5.08	62.00	self_employed	Kaivalya Enterprises		EPOPK0080R	\N	1	CUST-20260603-1Q9QHT	f	\N	\N	\N	\N	\N	1
\.


--
-- TOC entry 4716 (class 0 OID 18920)
-- Dependencies: 301
-- Data for Name: distributor_assignments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.distributor_assignments (id, distributor_id, sub_agent_id, assigned_at, created_at, updated_at) FROM stdin;
2	1	2	2026-05-11 11:21:55.06397	2026-05-11 11:21:55.066738	2026-05-11 11:21:55.066738
3	2	3	2026-05-13 03:20:56.684339	2026-05-13 03:20:56.690816	2026-05-13 03:20:56.690816
4	1	4	2026-05-13 03:47:37.294087	2026-05-13 03:47:37.299724	2026-05-13 03:47:37.299724
5	1	1	2026-05-15 07:13:48.169008	2026-05-15 07:13:48.173318	2026-05-15 07:13:48.173318
8	1	7	2026-05-19 03:31:22.190801	2026-05-19 03:31:22.195463	2026-05-19 03:31:22.195463
10	4	8	2026-05-26 00:07:03.842115	2026-05-26 00:07:03.848724	2026-05-26 00:07:03.848724
11	5	6	2026-06-02 08:12:46.799883	2026-06-02 08:12:46.807402	2026-06-02 08:12:46.807402
12	6	9	2026-06-02 08:29:51.818753	2026-06-02 08:29:51.823292	2026-06-02 08:29:51.823292
13	7	10	2026-06-02 15:03:01.058949	2026-06-02 15:03:01.062595	2026-06-02 15:03:01.062595
14	1	11	2026-06-02 15:31:37.047128	2026-06-02 15:31:37.050976	2026-06-02 15:31:37.050976
15	8	13	2026-06-03 00:59:21.674633	2026-06-03 00:59:21.680575	2026-06-03 00:59:21.680575
16	1	14	2026-06-03 01:43:27.748806	2026-06-03 01:43:27.75267	2026-06-03 01:43:27.75267
17	1	15	2026-06-03 02:20:36.631105	2026-06-03 02:20:36.635293	2026-06-03 02:20:36.635293
\.


--
-- TOC entry 4694 (class 0 OID 18678)
-- Dependencies: 279
-- Data for Name: distributor_documents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.distributor_documents (id, distributor_id, document_type, created_at, updated_at, r2_file_key, r2_filename, r2_content_type, r2_file_size) FROM stdin;
\.


--
-- TOC entry 4726 (class 0 OID 19063)
-- Dependencies: 311
-- Data for Name: distributor_payouts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.distributor_payouts (id, distributor_id, policy_type, policy_id, payout_amount, payout_date, status, transaction_id, payment_mode, reference_number, notes, processed_by, processed_at, created_at, updated_at, invoiced) FROM stdin;
1	1	health	49	426.25	2026-05-17	paid	sd	bank_transfer	REF_CUSLEAD-ESWAR-BSRPS_1779008104	sd	admin@drwise.com	2026-05-17 08:55:04.894894	2026-05-17 08:55:05.00007	2026-05-17 08:55:05.00007	f
\.


--
-- TOC entry 4692 (class 0 OID 18656)
-- Dependencies: 277
-- Data for Name: distributors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.distributors (id, first_name, middle_name, last_name, mobile, email, role_id, state_id, city_id, birth_date, gender, pan_no, gst_no, company_name, address, bank_name, account_no, ifsc_code, account_holder_name, account_type, upi_id, status, created_at, updated_at, affiliate_count, deactivated, city, state, username, password_digest, original_password, investor_id) FROM stdin;
1	Krama		Consulting	8431174477	krama.consulting@gmail.com	0	\N	\N	\N												0	2026-05-11 10:56:29.458288	2026-05-11 11:05:49.3599	0	f	Bengaluru Urban	karnataka	kramaconsulting6989	$2a$12$/aGNBALtWloM.OXJMSNUYu2pPnrM.ZiSuCSxCMxO5fQDkoB6hzSiS	SmartSwift181	1
2	SHOBHA		LOKESH	9743003428	shobhalokesh982@gmail.com	0	\N	\N	1982-06-17	Female	AEAPL6110N										0	2026-05-13 03:16:28.865472	2026-05-13 03:16:28.865472	0	f	Bengaluru Urban	karnataka	shobhalokesh2188	$2a$12$iV/u.N5ZzhzwMZwjmiFhT.wVYg67ABDqHRM6SklzNI0SsaONFbdMO	BrightBlue353	1
4	M P		VIJENDRA	9845957220	vijendramarvin220@gmail.com	0	\N	\N	1982-05-01	Male	AHOPV0261B				HDFC BANK	50100766300236	HDFC0004876	VIJENDRA M P	Savings		0	2026-05-25 23:55:57.532967	2026-05-25 23:55:57.532967	0	f	Bengaluru Urban	karnataka	mpvijendra3357	$2a$12$U27IA.yxz4wIIrBn0zOhoup9kNa/sdvKIN9AgL.4kRpcy8bCGYl9q	SmartRed149	10
5	GAYATRI		K	9542420736	gurwale.gayatri@gmail.com	0	\N	\N	1978-02-23	Female											0	2026-06-02 08:12:46.199266	2026-06-02 08:12:46.199266	0	f	Bengaluru Urban	karnataka	gayatrik7966	$2a$12$14FOmmU51hULgStWUgmopevHcxXC7TOWNq6bb.EB1Dz4EbAGWpaQ6	BlueGreen985	11
6	INDIRA		MURTHY	6364407948	indiramurthy50@gmail.com	0	\N	\N	1950-06-04	Female	AACPI3929A				HDFC BANK	08771160000171	HDFC0000877	INDIRA MURTHY B	Savings		0	2026-06-02 08:25:50.005414	2026-06-02 08:25:50.005414	0	f	Bengaluru Urban	karnataka	indiramurthy8750	$2a$12$LEuuiNBpiAFNSBTWBAR/luVhiygT3HvFPG74Y3b8dRseW3zZ6pHhq	SmartSmart322	1
7	M		TRIVENI	6362324189	trivenig1482@gmail.com	0	\N	\N	1982-04-01	Female	AZLPT4580C				KARNATAKA BANK	9212500100005401	KARB0000921	TRIVENI\tM	Savings		0	2026-06-02 15:03:00.588005	2026-06-02 15:03:00.588005	0	f	Bengaluru Urban	karnataka	mtriveni2580	$2a$12$TkRXL8opAvL6G1aDSt6AHu5P60pajIdbVf2UUuF4qz2y/3BZKhGDy	BlueBlue728	3
8	B N		SHIVAKUMARA	9743228985	kunigalshivakumara@gmail.com	0	\N	\N	1982-07-20	Male	CDHPS8602J				CANARA BANK	6781101000772	CNRB0006781	SHIVAKUMARA B N	Savings		0	2026-06-03 00:45:53.940728	2026-06-03 00:45:53.940728	0	f	Tumakuru	karnataka	bnshivakumara7553	$2a$12$xs756.IbruhdKhpgw/1p6ui9PthLI8CkSFM.gRN3yDVMOvPgUPHCm	SmartHappy554	9
9	SAMPARKA		ASSOCIATION	8296348359	samparka.blr@gmail.com	0	\N	\N	\N												0	2026-06-04 05:53:58.595177	2026-06-04 05:53:58.595177	0	f	Bengaluru Urban	karnataka	samparkaassociation2438	$2a$12$Hru3cVMpyTsImmFhj7R2BO1W8WO9.Jn.QEeK3NpPULLm5U9alFqO6	QuickSmart629	2
\.


--
-- TOC entry 4666 (class 0 OID 18191)
-- Dependencies: 251
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.documents (id, document_type, documentable_type, documentable_id, created_at, updated_at, title, description, uploaded_by, r2_file_key, r2_filename, r2_content_type, r2_file_size) FROM stdin;
\.


--
-- TOC entry 4642 (class 0 OID 17941)
-- Dependencies: 227
-- Data for Name: family_members; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.family_members (id, customer_id, first_name, birth_date, age, height, weight, gender, relationship, pan_no, mobile, created_at, updated_at, middle_name, last_name, height_feet, weight_kg, additional_information) FROM stdin;
1	1	LATHA	1995-04-24	31	\N	\N	female	spouse			2026-05-11 11:09:22.140883	2026-05-11 11:09:22.140883		S		\N	
2	21	S C	1982-01-27	44	\N	\N	female	spouse			2026-05-25 12:01:16.622491	2026-05-25 12:01:16.622491		GEETHA		\N	
3	24	Vyshnavi	1985-01-16	41	\N	\N	female	spouse			2026-06-02 23:44:48.433976	2026-06-02 23:44:48.433976		Vinay	5.0	56.00	
4	28	Nagaruru	1959-01-01	67	\N	\N	male	father			2026-06-03 01:13:34.256956	2026-06-03 01:13:34.256956		Ramanjineyulu		\N	
5	29	Rukminiyamma	1955-01-01	71	\N	\N	female	mother			2026-06-03 01:29:06.806941	2026-06-03 01:29:06.806941		K		\N	
\.


--
-- TOC entry 4771 (class 0 OID 19742)
-- Dependencies: 356
-- Data for Name: health_insurance_documents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.health_insurance_documents (id, health_insurance_id, document_type, title, description, r2_file_key, r2_filename, r2_content_type, r2_file_size, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4676 (class 0 OID 18301)
-- Dependencies: 261
-- Data for Name: health_insurance_members; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.health_insurance_members (id, health_insurance_id, member_name, age, relationship, sum_insured, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4757 (class 0 OID 19495)
-- Dependencies: 342
-- Data for Name: health_insurance_nominees; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.health_insurance_nominees (id, health_insurance_id, nominee_name, relationship, age, share_percentage, created_at, updated_at) FROM stdin;
1	1	LATHA S	spouse	31	100.0	2026-05-11 11:13:01.205359	2026-05-11 11:13:01.205359
2	2	Shilpa GS	spouse	42	100.0	2026-05-11 11:38:24.679901	2026-05-11 11:38:24.679901
12	27	M TRIVENI	spouse	44	100.0	2026-05-13 11:25:39.019822	2026-05-13 11:25:39.019822
14	31	KRUTHIKA S BHOOMARADDI	spouse	32	100.0	2026-05-13 13:53:04.201113	2026-05-13 13:53:04.201113
15	32	G Madhusudhan	brother	53	100.0	2026-05-13 13:57:30.874835	2026-05-13 13:57:30.874835
16	33	Dr Lalitha J	spouse	40	100.0	2026-05-14 03:16:10.502929	2026-05-14 03:16:10.502929
18	37	Vidarbh	son	12	100.0	2026-05-14 13:55:11.421619	2026-05-14 13:55:11.421619
29	52	VEENA BHAT	mother	50	100.0	2026-05-20 14:05:07.286343	2026-05-20 14:05:07.286343
30	53	Mandeep Kaur	spouse	39	100.0	2026-06-02 23:38:56.776715	2026-06-02 23:38:56.776715
31	54	Vyshnavi Vinay	spouse	41	100.0	2026-06-02 23:47:42.289067	2026-06-02 23:47:42.289067
32	55	S VASUKIMAHATI	spouse	35	100.0	2026-06-03 00:35:54.15871	2026-06-03 00:35:54.15871
33	56	B N Prakash	spouse	51	100.0	2026-06-03 00:54:55.222319	2026-06-03 00:54:55.222319
34	57	S B PADMASHREE	spouse	47	100.0	2026-06-03 01:06:38.244017	2026-06-03 01:06:38.244017
35	58	Nagaruru Ramanjineyulu	father	67	100.0	2026-06-03 01:15:34.760623	2026-06-03 01:15:34.760623
36	59	Swetha G	spouse	39	100.0	2026-06-03 01:32:22.371914	2026-06-03 01:32:22.371914
37	60	Rukminiyamma K	mother	71	100.0	2026-06-03 01:37:14.634935	2026-06-03 01:37:14.634935
38	61	VEDHA. K	daughter	19	100.0	2026-06-03 01:51:00.953544	2026-06-03 01:51:00.953544
39	62	BHAGYAMMA PH	spouse	51	100.0	2026-06-03 02:27:49.551555	2026-06-03 02:27:49.551555
40	63	ARCHANA VISHWANATH	spouse	54	99.99	2026-06-03 03:31:38.469876	2026-06-03 03:31:38.469876
41	64	ADOKSH	son	21	100.0	2026-06-03 05:01:33.200036	2026-06-03 05:01:33.200036
42	65	Renuka L	spouse	21	100.0	2026-06-03 05:10:07.066708	2026-06-03 05:10:07.066708
43	66	SUMA B S	spouse	37	100.0	2026-06-03 05:23:25.281929	2026-06-03 05:23:25.281929
44	67	Seethamma	mother	46	100.0	2026-06-03 14:01:25.864487	2026-06-03 14:01:25.864487
\.


--
-- TOC entry 4650 (class 0 OID 18043)
-- Dependencies: 235
-- Data for Name: health_insurances; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.health_insurances (id, policy_id, insurance_type, claim_process, main_agent_commission_percent, main_agent_commission_amount, main_agent_tds_percent, main_agent_tds_amount, reference_by_name, broker_name, created_at, updated_at, customer_id, sub_agent_id, agency_code_id, broker_id, policy_holder, insurance_company_name, plan_name, policy_number, policy_booking_date, policy_start_date, policy_end_date, policy_term, payment_mode, sum_insured, net_premium, gst_percentage, total_premium, main_agent_commission_percentage, commission_amount, tds_percentage, tds_amount, after_tds_value, policy_type, installment_autopay_start_date, installment_autopay_end_date, notification_dates, is_customer_added, is_agent_added, is_admin_added, product_through_dr, main_agent_commission_received, main_agent_commission_transaction_id, main_agent_commission_paid_date, main_agent_commission_notes, lead_id, distributor_id, investor_id, ambassador_commission_percentage, ambassador_commission_amount, ambassador_tds_percentage, ambassador_tds_amount, ambassador_after_tds_value, sub_agent_commission_percentage, sub_agent_commission_amount, sub_agent_tds_percentage, sub_agent_tds_amount, sub_agent_after_tds_value, investor_commission_percentage, investor_commission_amount, investor_tds_percentage, investor_tds_amount, investor_after_tds_value, company_expenses_percentage, total_distribution_percentage, profit_percentage, profit_amount, policy_added_by_admin, nominee_dob, broker_code_type, insurance_company_code, main_policy_document_key, main_policy_document_filename, main_policy_document_content_type, main_policy_document_size, company_expenses_amount, is_renewed, original_policy_id, premium_frequency, status, start_date, end_date, additional_details, nominee_name, nominee_relation, sum_insured_text) FROM stdin;
35	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-14 13:20:47.12683	2026-06-04 05:28:24.496081	5	1	\N	4	Self	Care Health Insurance Ltd	SUPREME	90475760	2025-10-01	2025-10-08	2026-10-07	1	Yearly	700000.0	27581.01	0.0	27581.01	12.75	3516.58	2.0	70.33	3446.25	Renewal	2025-10-08	2026-10-07	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your health policy (90475760) is due for renewal on 07 Oct 2026. Please renew to continue your coverage.","date":"2026-09-07"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (90475760) expires in 15 days on 07 Oct 2026. Please renew to avoid coverage gap.","date":"2026-09-22"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (90475760) expires in 1 week on 07 Oct 2026. Immediate action required.","date":"2026-09-30"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (90475760) expires tomorrow on 07 Oct 2026. Renew now to avoid coverage gap.","date":"2026-10-06"}]	f	f	t	t	f	\N	\N	\N	CUSLEAD-NXX-137-100-HLT	1	\N	1.0	275.81	2.0	5.52	270.29	4.0	1103.24	2.0	22.06	1081.18	4.0	1103.24	0.0	0.0	1103.24	2.0	9.0	-1.0	-275.81	f	\N	broking	\N	health_insurance/35/main_policy/20260514_132047_3123ea1754e2b9af_2025-26_Gopal N_Care Health Policy.pdf	2025-26_Gopal N_Care Health Policy.pdf	application/pdf	514226	551.62	f	27	annual	active	\N	\N		TRIVENI M	spouse	\N
2	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-11 11:38:24.628897	2026-06-04 05:29:20.382405	2	1	\N	4	Self	Care Health Insurance Ltd	SUPREME	89557128	2024-09-10	2024-09-13	2025-09-12	1	Yearly	1000000.0	24273.58	18.0	28642.82	12.0	2912.83	5.0	145.64	2767.19	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260511-PSEL8R	1	\N	1.0	242.74	5.0	12.14	230.6	5.0	1213.68	5.0	60.68	1153.0	0.0	0.0	0.0	0.0	0.0	5.0	6.0	-1.0	-242.74	t	\N	broking	\N	\N	\N	\N	\N	1213.68	t	\N			\N	\N		\N	\N	\N
52	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-20 14:05:07.274241	2026-05-20 14:05:07.274241	19	6	\N	4	Self	ICICI Lombard	ELEVATE	100063248600	2026-05-20	2026-05-20	2027-05-19	1	Yearly	1000000.0	9838.0	0.0	9838.0	21.0	2065.98	2.0	41.32	2024.66	New	\N	\N	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your health policy (100063248600) is due for renewal on 19 May 2027. Please renew to continue your coverage.","date":"2027-04-19"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (100063248600) expires in 15 days on 19 May 2027. Please renew to avoid coverage gap.","date":"2027-05-04"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (100063248600) expires in 1 week on 19 May 2027. Immediate action required.","date":"2027-05-12"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (100063248600) expires tomorrow on 19 May 2027. Renew now to avoid coverage gap.","date":"2027-05-18"}]	f	f	t	t	f	\N	\N	\N	CUSLEAD-KRISH-32790	1	\N	1.0	98.38	2.0	1.97	96.41	5.0	491.9	2.0	9.84	482.06	5.0	491.9	0.0	0.0	491.9	5.0	11.0	-6.0	-590.28	t	\N	broking	\N	\N	\N	\N	\N	491.9	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
55	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-06-03 00:35:54.145311	2026-06-03 00:35:54.145311	25	1	\N	4	Self	Tata AIG General Insurance	SUPER CHARGE	7090009658	2024-11-15	2024-11-20	2025-11-19	1	Yearly	1000000.0	21095.52	18.0	24892.71	7.5	1582.16	5.0	79.11	1503.05	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260603-UF53XU	1	\N	1.0	210.96	5.0	10.55	200.41	3.0	632.87	5.0	31.64	601.23	0.0	0.0	0.0	0.0	0.0	2.0	4.0	4.0	843.82	t	\N	broking	\N	\N	\N	\N	\N	421.91	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
63	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-06-03 03:31:38.459696	2026-06-03 03:31:38.459696	37	1	\N	4	Self	Manipal Cigna Health Insurance Company Ltd	SARVAH UTTAM	SARVAH050041079	2026-06-03	2025-03-15	2026-03-14	1	Yearly	1000000.0	48008.0	18.0	56649.44	23.0	11041.84	5.0	552.09	10489.75	New	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260603-FPVLYO	1	\N	1.0	480.08	5.0	24.0	456.08	5.0	2400.4	5.0	120.02	2280.38	5.0	2400.4	0.0	0.0	2400.4	5.0	11.0	-6.0	-2880.48	t	\N	broking	\N	\N	\N	\N	\N	2400.4	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
67	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-06-03 14:01:25.855583	2026-06-03 14:01:25.855583	41	10	4	\N	Self	Tata AIG General Insurance	MEDICARE SELECT	7330061278	2025-08-13	2025-08-14	2026-08-13	1	Yearly	1000000.0	8014.39	18.0	9456.98	15.0	1202.16	5.0	60.11	1142.05	New	\N	\N	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your health policy (7330061278) is due for renewal on 13 Aug 2026. Please renew to continue your coverage.","date":"2026-07-14"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (7330061278) expires in 15 days on 13 Aug 2026. Please renew to avoid coverage gap.","date":"2026-07-29"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (7330061278) expires in 1 week on 13 Aug 2026. Immediate action required.","date":"2026-08-06"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (7330061278) expires tomorrow on 13 Aug 2026. Renew now to avoid coverage gap.","date":"2026-08-12"}]	f	f	t	t	f	\N	\N	\N	CUST-20260603-LMCP9O	7	\N	1.0	80.14	5.0	4.01	76.13	5.0	400.72	5.0	20.04	380.68	5.0	400.72	0.0	0.0	400.72	2.0	11.0	-3.0	-240.43	t	\N	direct	\N	\N	\N	\N	\N	160.29	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
30	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-13 13:44:13.517905	2026-06-04 05:29:45.610071	2	1	\N	4	Self	Care Health Insurance Ltd	SUPREME	89557128	2025-10-01	2025-10-01	2026-09-30	1	Yearly	1000000.0	25635.0	0.0	25635.0	12.0	3076.2	5.0	153.81	2922.39	Renewal	2025-10-01	2026-09-30	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your health policy (89557128) is due for renewal on 30 Sep 2026. Please renew to continue your coverage.","date":"2026-08-31"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (89557128) expires in 15 days on 30 Sep 2026. Please renew to avoid coverage gap.","date":"2026-09-15"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (89557128) expires in 1 week on 30 Sep 2026. Immediate action required.","date":"2026-09-23"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (89557128) expires tomorrow on 30 Sep 2026. Renew now to avoid coverage gap.","date":"2026-09-29"}]	f	f	t	t	f	\N	\N	\N	CUSLEAD-YOG-027-251-HLT	1	\N	1.0	256.35	5.0	12.82	243.53	4.0	1025.4	5.0	51.27	974.13	4.0	1025.4	0.0	0.0	1025.4	2.0	9.0	-1.0	-256.35	f	\N	broking	\N	\N	\N	\N	\N	512.7	f	2	annual	active	\N	\N		SHILPA G S	spouse	\N
1	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-11 11:13:01.193853	2026-05-14 08:12:53.692678	1	1	\N	1	Self	Care Health Insurance Ltd	SUPREME	85432300	2024-06-15	2024-06-19	2025-06-18	1	Yearly	700000.0	9126.15	18.0	10768.86	32.0	2920.37	5.0	146.02	2774.35	New	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260511-UQMMSS	1	\N	1.0	91.26	5.0	4.56	86.7	5.0	456.31	5.0	22.82	433.49	0.0	0.0	0.0	0.0	0.0	5.0	6.0	-1.0	-91.26	t	\N	broking	\N	health_insurance/1/main_policy/20260514_081253_e93f561ddbc8cc99_CARE Supreme_Policy Soft Copy_202406190217040427_Lingaraju.PDF	CARE Supreme_Policy Soft Copy_202406190217040427_Lingaraju.PDF	application/pdf	500861	456.31	t	\N			\N	\N		\N	\N	\N
53	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-06-02 23:38:56.74577	2026-06-02 23:38:56.74577	8	1	\N	4	Self	Niva Bupa Health Insurance	REASSURE 2.0 TITANIUM+	34428150202400	2024-11-01	2024-11-09	2025-11-08	1	Yearly	1500000.0	14199.0	18.0	16754.82	23.0	3265.77	5.0	163.29	3102.48	New	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260513-FOTT6S	1	\N	1.0	141.99	5.0	7.1	134.89	5.0	709.95	5.0	35.5	674.45	0.0	0.0	0.0	0.0	0.0	5.0	6.0	-1.0	-141.99	t	\N	broking	\N	\N	\N	\N	\N	709.95	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
64	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-06-03 05:01:33.184615	2026-06-03 05:01:33.184615	38	1	4	\N	Self	Tata AIG General Insurance	SUPER CHARGE	IDV002280092	2025-03-05	2025-03-18	2026-03-17	1	Yearly	1000000.0	23703.0	18.0	27969.54	15.0	3555.45	5.0	177.77	3377.68	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260603-OODTIX	1	\N	1.0	237.03	5.0	11.85	225.18	5.0	1185.15	5.0	59.26	1125.89	5.0	1185.15	0.0	0.0	1185.15	2.0	11.0	-3.0	-711.09	t	\N	direct	\N	\N	\N	\N	\N	474.06	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
15	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-13 01:37:55.300067	2026-05-26 13:54:50.383493	1	1	\N	1	Self	Care Health Insurance Ltd	SUPREME	85432300	2025-06-19	2025-06-19	2026-06-18	1	Yearly	700000.0	9126.15	18.0	10768.86	12.0	1095.14	5.0	54.76	1040.38	Renewal	2026-06-18	2027-06-17	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your health policy (85432300) is due for renewal on 18 Jun 2026. Please renew to continue your coverage.","date":"2026-05-19"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (85432300) expires in 15 days on 18 Jun 2026. Please renew to avoid coverage gap.","date":"2026-06-03"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (85432300) expires in 1 week on 18 Jun 2026. Immediate action required.","date":"2026-06-11"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (85432300) expires tomorrow on 18 Jun 2026. Renew now to avoid coverage gap.","date":"2026-06-17"}]	f	f	t	t	t	20240615001	2024-06-15	referred by Naga CM	CUSLEAD-CMX-938-280-HLT	1	\N	1.0	91.26	5.0	4.56	86.7	5.0	456.31	5.0	22.82	433.49	1.0	91.26	0.0	0.0	91.26	1.0	7.0	2.0	182.52	f	\N	broking	\N	health_insurance/15/main_policy/20260514_055159_7238585fc182b89b_C Lingaraju 2025-26.pdf	C Lingaraju 2025-26.pdf	application/pdf	492469	91.26	f	1	annual	active	\N	\N		LATHA S	spouse	\N
56	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-06-03 00:54:55.178154	2026-06-03 00:54:55.178154	26	13	\N	4	Self	Tata AIG General Insurance	Medicare Premier	7030003418	2024-12-01	2024-12-06	2025-12-05	1	Yearly	1000000.0	32573.17	18.0	38436.34	23.0	7491.83	5.0	374.59	7117.24	New	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260603-IY2TG5	\N	\N	1.0	325.73	5.0	16.29	309.44	5.0	1628.66	5.0	81.43	1547.23	5.0	1628.66	0.0	0.0	1628.66	5.0	11.0	-6.0	-1954.39	t	\N	broking	\N	\N	\N	\N	\N	1628.66	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
57	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-06-03 01:06:38.237714	2026-06-03 01:06:38.237714	27	1	\N	4	Self	Tata AIG General Insurance	Medicare Premier	9740808135	2024-12-25	2024-12-31	2025-12-30	1	Yearly	1000000.0	36014.53	18.0	42497.15	7.5	2701.09	5.0	135.05	2566.04	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260603-AX520H	1	\N	1.0	360.15	5.0	18.01	342.14	4.0	1440.58	5.0	72.03	1368.55	0.0	0.0	0.0	0.0	0.0	2.0	5.0	3.0	1080.44	t	\N	broking	\N	health_insurance/57/main_policy/20260603_010639_0b7e01efb7c8b2af_2024-25_Tata Policy.pdf	2024-25_Tata Policy.pdf	application/pdf	2809182	720.29	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
61	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-06-03 01:51:00.944655	2026-06-03 01:51:00.944655	31	14	\N	4	Self	Care Health Insurance Ltd	SUPREME	95514336	2025-01-05	2025-01-09	2026-01-08	1	Yearly	700000.0	10982.36	18.0	12959.18	12.0	1317.88	5.0	65.89	1251.99	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260603-TKTGK1	1	\N	1.0	109.82	5.0	5.49	104.33	4.0	439.29	5.0	21.96	417.33	0.0	0.0	0.0	0.0	0.0	4.0	5.0	1.0	109.82	t	\N	broking	\N	\N	\N	\N	\N	439.29	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
65	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-06-03 05:10:07.05639	2026-06-04 05:24:25.295001	39	1	1	\N	Self	Star Health and Allied Insurance Company Ltd	WOMEN CARE	7045112500083174	2024-12-18	2024-12-21	2025-12-20	1	Yearly	10000000.0	22680.0	18.0	26762.4	20.0	4536.0	5.0	226.8	4309.2	New	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260603-1Q9QHT	1	\N	1.0	226.8	5.0	11.34	215.46	5.0	1134.0	5.0	56.7	1077.3	5.0	1134.0	0.0	0.0	1134.0	5.0	11.0	-6.0	-1360.8	t	\N	direct	\N	\N	\N	\N	\N	1134.0	f	\N			\N	\N		\N	\N	\N
27	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-13 11:25:39.006988	2026-06-04 05:28:01.669061	5	1	\N	4	Self	Care Health Insurance Ltd	SUPREME	90475760	2024-09-28	2024-10-03	2025-10-02	1	Yearly	700000.0	22249.19	18.0	26254.04	12.0	2669.9	5.0	133.5	2536.4	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260513-HYC5D3	1	\N	1.0	222.49	5.0	11.12	211.37	4.0	889.97	5.0	44.5	845.47	4.0	889.97	0.0	0.0	889.97	2.0	9.0	-1.0	-222.49	t	1982-04-01	broking	\N	\N	\N	\N	\N	444.98	t	\N	annual	active	\N	\N		TRIVENI M	spouse	\N
68	\N	Individual	\N	\N	\N	\N	\N	\N	\N	2026-06-04 15:08:50.649543	2026-06-04 15:08:50.649543	16	\N	\N	\N	Adithyaa Tanmaoy Kasibhatta	To be assigned	Health	REQ-1780585730	2026-06-04	2026-06-04	2027-06-04	1	Yearly	1500000.0	20000.0	0.0	20000.0	\N	\N	\N	\N	\N	New	\N	\N	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your health policy (REQ-1780585730) is due for renewal on 04 Jun 2027. Please renew to continue your coverage.","date":"2027-05-05"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (REQ-1780585730) expires in 15 days on 04 Jun 2027. Please renew to avoid coverage gap.","date":"2027-05-20"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (REQ-1780585730) expires in 1 week on 04 Jun 2027. Immediate action required.","date":"2027-05-28"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (REQ-1780585730) expires tomorrow on 04 Jun 2027. Renew now to avoid coverage gap.","date":"2027-06-03"}]	t	f	f	t	f	\N	\N	\N	CUST-20260519-OK6LC1	\N	\N	2.0	400.0	\N	\N	400.0	2.0	400.0	\N	\N	400.0	2.0	400.0	\N	\N	400.0	2.0	6.0	2.0	400.0	f	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
31	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-13 13:53:04.192699	2026-05-13 13:53:04.192699	3	1	\N	4	Self	Tata AIG General Insurance	Medicare Premier	7000288448-00	2024-09-15	2024-09-19	2025-09-18	1	Yearly	5000000.0	21924.8	18.0	25871.26	23.0	5042.7	5.0	252.14	4790.56	New	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260511-DGECKX	1	\N	1.0	219.25	5.0	10.96	208.29	5.0	1096.24	5.0	54.81	1041.43	5.0	1096.24	0.0	0.0	1096.24	5.0	11.0	-6.0	-1315.49	t	\N	broking	\N	\N	\N	\N	\N	1096.24	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
32	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-13 13:57:30.867265	2026-05-13 13:57:30.867265	4	1	\N	4	Self	HDFC ERGO General Insurance	Optima Secure	2856 2057 2973 7501 000	2024-09-13	2024-09-25	2025-09-24	1	Yearly	1000000.0	21809.0	18.0	25734.62	12.0	2617.08	5.0	130.85	2486.23	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260512-BIVWPK	1	\N	1.0	218.09	5.0	10.9	207.19	4.0	872.36	5.0	43.62	828.74	4.0	872.36	0.0	0.0	872.36	2.0	9.0	-1.0	-218.09	t	\N	broking	\N	\N	\N	\N	\N	436.18	t	\N	\N	\N	\N	\N	\N	\N	\N	\N
33	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-14 03:16:10.493327	2026-05-14 03:16:10.493327	6	3	\N	4	Self	Niva Bupa Health Insurance	REASSURE 2.0 TITANIUM+	34370258202400	2024-10-04	2024-10-13	2025-10-12	1	Yearly	2500000.0	33253.39	18.0	39239.0	12.5	4156.67	5.0	207.83	3948.84	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260513-NPBJML	2	\N	1.0	332.53	5.0	16.63	315.9	4.0	1330.14	5.0	66.51	1263.63	4.0	1330.14	0.0	0.0	1330.14	2.0	9.0	-1.0	-332.53	t	\N	broking	\N	\N	\N	\N	\N	665.07	t	\N	\N	\N	\N	\N	\N	\N	\N	\N
36	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-14 13:40:25.371348	2026-05-14 13:40:25.371348	4	1	\N	4	Self	HDFC ERGO General Insurance	Optima Secure	2856 2057 2973 7502 000	2025-09-23	2025-09-25	2026-09-24	1	Yearly	1500000.0	28184.0	0.0	28184.0	15.0	4227.6	5.0	211.38	4016.22	Renewal	2024-09-25	2025-09-25	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your health policy (2856 2057 2973 7502 000) is due for renewal on 24 Sep 2026. Please renew to continue your coverage.","date":"2026-08-25"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (2856 2057 2973 7502 000) expires in 15 days on 24 Sep 2026. Please renew to avoid coverage gap.","date":"2026-09-09"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (2856 2057 2973 7502 000) expires in 1 week on 24 Sep 2026. Immediate action required.","date":"2026-09-17"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (2856 2057 2973 7502 000) expires tomorrow on 24 Sep 2026. Renew now to avoid coverage gap.","date":"2026-09-23"}]	f	f	t	t	f	\N	\N	\N	CUSLEAD-G R-901-080-HLT	1	\N	1.0	281.84	5.0	14.09	267.75	5.0	1409.2	5.0	70.46	1338.74	5.0	1409.2	0.0	0.0	1409.2	2.0	11.0	-3.0	-845.52	f	\N	broking	\N	health_insurance/36/main_policy/20260514_134025_9a1e1caaf4c8cd06_2025-26_HDFC ERGO_Optima Secure.pdf	2025-26_HDFC ERGO_Optima Secure.pdf	application/pdf	353164	563.68	f	32		active	\N	\N		G Madhusudhan	sibling	\N
37	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-14 13:55:11.403221	2026-05-14 13:55:11.403221	7	1	\N	4	Self	Care Health Insurance Ltd	SUPREME	72895305	2024-10-10	2024-10-18	2025-10-17	1	Yearly	1000000.0	18091.41	18.0	21347.86	15.0	2713.71	5.0	135.69	2578.02	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260513-5P72WP	1	\N	1.0	180.91	5.0	9.05	171.86	5.0	904.57	5.0	45.23	859.34	5.0	904.57	0.0	0.0	904.57	2.0	11.0	-3.0	-542.74	t	\N	broking	\N	health_insurance/37/main_policy/20260514_135511_46a1d11e86566561_2024-25.pdf	2024-25.pdf	application/pdf	491628	361.83	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
58	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-06-03 01:15:34.749433	2026-06-03 01:15:34.749433	28	1	\N	4	Nagaruru Ramanjineyulu	ICICI Lombard	ELEVATE	4225i/ELVT/372710990/00/000	2024-12-15	2024-12-18	2025-12-17	1	Yearly	1000000.0	35428.74	18.0	41805.91	23.0	8148.61	5.0	407.43	7741.18	New	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260603-XQBHCE	1	\N	1.0	354.29	5.0	17.71	336.58	5.0	1771.44	5.0	88.57	1682.87	0.0	0.0	0.0	0.0	0.0	5.0	6.0	-1.0	-354.29	t	\N	broking	\N	health_insurance/58/main_policy/20260603_011535_a73be20549671f24_2024-25_Praveen Kumar ICICI Policy.pdf	2024-25_Praveen Kumar ICICI Policy.pdf	application/pdf	1201224	1771.44	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
38	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-05-15 03:29:10.75663	2026-05-29 10:42:35.292213	6	3	\N	4	Self	Niva Bupa Health Insurance	REASSURE 2.0 TITANIUM+	34370258202501	2025-10-04	2025-10-14	2026-10-13	1	Yearly	2500000.0	46273.0	0.0	46273.0	12.75	5899.81	2.0	118.0	5781.81	Renewal	2025-10-14	2026-10-14	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your health policy (34370258202501) is due for renewal on 13 Oct 2026. Please renew to continue your coverage.","date":"2026-09-13"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your health policy (34370258202501) expires in 15 days on 13 Oct 2026. Please renew to avoid coverage gap.","date":"2026-09-28"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your health policy (34370258202501) expires in 1 week on 13 Oct 2026. Immediate action required.","date":"2026-10-06"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your health policy (34370258202501) expires tomorrow on 13 Oct 2026. Renew now to avoid coverage gap.","date":"2026-10-12"}]	f	f	t	t	t	dsd	2026-05-29	sd	CUSLEAD-DR -161-280-HLT	2	\N	1.0	462.73	20.0	92.55	370.18	4.0	1850.92	2.0	37.02	1813.9	4.0	1850.92	0.0	0.0	1850.92	2.0	9.0	-1.0	-462.73	f	\N	broking	\N	health_insurance/38/main_policy/20260515_032910_b2cf41614cf3f15f_Dr. Krishna N_2025-26.pdf	Dr. Krishna N_2025-26.pdf	application/pdf	918789	925.46	f	33	annual	active	\N	\N		Dr Lalitha J	spouse	\N
54	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-06-02 23:47:42.278758	2026-06-02 23:47:42.278758	24	4	\N	4	Self	ICICI Lombard	ELEVATE	4225i/P-ELVT/363000758/00/000	2024-11-01	2024-11-11	2025-11-10	1	Yearly	1000000.0	23469.22	18.0	27693.68	10.0	2346.92	5.0	117.35	2229.57	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260602-8TQAHL	1	\N	1.0	234.69	5.0	11.73	222.96	4.0	938.77	5.0	46.94	891.83	0.0	0.0	0.0	0.0	0.0	3.0	5.0	2.0	469.38	t	\N	broking	\N	\N	\N	\N	\N	704.08	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
59	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-06-03 01:32:22.359176	2026-06-03 01:32:22.359176	29	3	\N	4	Self	Niva Bupa Health Insurance	REASSURE 2.0 TITANIUM+	34560831202400	2024-12-24	2024-12-31	2025-12-30	1	Yearly	1000000.0	21230.0	18.0	25051.4	12.5	2653.75	5.0	132.69	2521.06	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260603-2EJKUR	2	\N	1.0	212.3	5.0	10.62	201.68	5.0	1061.5	5.0	53.08	1008.42	0.0	0.0	0.0	0.0	0.0	4.0	6.0	0.0	0.0	t	\N	broking	\N	\N	\N	\N	\N	849.2	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
60	\N	Individual	Inhouse	\N	\N	\N	\N	\N	\N	2026-06-03 01:37:14.596645	2026-06-03 01:37:14.596645	29	3	\N	4	Rukminiyamma K	Niva Bupa Health Insurance	SENIOR FIRST	34551958202400	2024-12-24	2024-12-30	2025-12-29	1	Yearly	1000000.0	48026.0	18.0	56670.68	12.5	6003.25	5.0	300.16	5703.09	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUSLEAD-HAR-566-270-HLT	2	\N	1.0	480.26	5.0	24.01	456.25	4.0	1921.04	5.0	96.05	1824.99	0.0	0.0	0.0	0.0	0.0	4.0	5.0	1.0	480.26	t	\N	broking	\N	\N	\N	\N	\N	1921.04	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
62	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-06-03 02:27:49.54368	2026-06-03 02:27:49.54368	36	15	\N	4	Self	Manipal Cigna Health Insurance Company Ltd	ProHealth Prime - Protect	PROPRM050120013	2025-02-15	2025-02-26	2026-02-25	1	Yearly	1000000.0	44548.47	18.0	52567.19	11.0	4900.33	5.0	245.02	4655.31	Porting	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260603-1HJN1I	1	\N	1.0	445.48	5.0	22.27	423.21	5.0	2227.42	5.0	111.37	2116.05	0.0	0.0	0.0	0.0	0.0	2.0	6.0	2.0	890.97	t	\N	broking	\N	\N	\N	\N	\N	890.97	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
66	\N	Family Floater	Inhouse	\N	\N	\N	\N	\N	\N	2026-06-03 05:23:25.256266	2026-06-03 05:23:25.256266	40	1	1	\N	Self	Star Health and Allied Insurance Company Ltd	HEALTH ASSURE	2851112500070677,	2025-03-10	2025-02-17	2026-02-16	1	Yearly	1000000.0	24147.0	18.0	28493.46	20.0	4829.4	5.0	241.47	4587.93	New	\N	\N	\N	f	f	t	t	f	\N	\N	\N	CUST-20260603-8DZK0V	1	\N	1.0	241.47	5.0	12.07	229.4	5.0	1207.35	5.0	60.37	1146.98	5.0	1207.35	0.0	0.0	1207.35	5.0	11.0	-6.0	-1448.82	t	\N	direct	\N	\N	\N	\N	\N	1207.35	f	\N	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- TOC entry 4753 (class 0 OID 19444)
-- Dependencies: 338
-- Data for Name: helpdesk_tickets; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.helpdesk_tickets (id, ticket_number, subject, description, status, priority, category, submitter_type, submitter_id, assigned_to, resolution_notes, resolved_at, sub_agent_id, customer_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4644 (class 0 OID 17960)
-- Dependencies: 229
-- Data for Name: insurance_companies; Type: TABLE DATA; Schema: public; Owner: -
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
-- TOC entry 4718 (class 0 OID 18987)
-- Dependencies: 303
-- Data for Name: investments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.investments (id, customer_id, investment_type, product_name, investment_amount, status, investment_date, maturity_date, notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4700 (class 0 OID 18733)
-- Dependencies: 285
-- Data for Name: investor_documents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.investor_documents (id, investor_id, document_type, created_at, updated_at, r2_file_key, r2_filename, r2_content_type, r2_file_size) FROM stdin;
\.


--
-- TOC entry 4698 (class 0 OID 18711)
-- Dependencies: 283
-- Data for Name: investors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.investors (id, first_name, middle_name, last_name, mobile, email, role_id, state, city, birth_date, gender, pan_no, gst_no, company_name, address, bank_name, account_no, ifsc_code, account_holder_name, account_type, upi_id, status, created_at, updated_at, password_digest, username, original_password, invested_amount, investment_percentage, main_document_key, main_document_filename, main_document_content_type, main_document_size, number_of_shares) FROM stdin;
13	ADITHYAA	TANMAOY	KASIBHATTA	6361404087	adithyaatanmayk@gmail.com	0	karnataka	Bengaluru Urban	2007-10-14	Male	QQSPK1480E				STATE BANK OF INDIA	44621414307	SBIN0018230	ADITHYAA TANMAOY KASIBHATTA	Current		0	2026-05-11 07:38:20.140197	2026-05-19 04:21:04.186992	$2a$12$Ox2gpR4krX0TCnbSWMfubOmPGhP4wdf6g2iWYUoTsrieZ0dsEclFi	adithyatanm	Ganesha@123	100000.0	100.0	\N	\N	\N	\N	1
12	Nitin	Kumar	S	9686291349	nithinkumarsrinivasa@gmail.com	0	karnataka	Bengaluru Urban	1992-07-11	Male	GYRPS1042B				KARNATAKA BANK LTD	9562500100139101	KARB0000956	NITHIN KUMAR S	Savings		0	2026-05-11 07:38:18.002691	2026-05-19 17:00:43.157193	$2a$12$gdsiTq6Uk77J5atbFjZlweAFe8DXVJlQoAJJD1.uRP8TkU2lbJAvW	nitins	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
11	Murali	Krishna	Kasibhatta	8686961074	masterlee911@gmail.com	0	karnataka	Bengaluru Urban	1971-12-11	Male	AOGPK1840J										0	2026-05-11 07:38:15.83892	2026-05-19 17:03:25.640725	$2a$12$iVvZRAfBGGgx84sfteVSN./nHWDWK9FqnNpXfPd8nT07sbyeTi0Tm	muralikasib	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
10	Vijendra	M	P	9845957220	vijendramarvin220@gmail.com	0	karnataka	Bengaluru Urban	1982-05-01	Male	AHOPV0261B				HDFC BANK	50100766300236	HDFC0004876	VIJENDRA M P	Savings		0	2026-05-11 07:38:13.651915	2026-05-19 17:05:33.654569	$2a$12$GVOE.3ACjj8KQk.Y13Jbv.PlqSKaR8e6EneBnAt3xmn5s1SILf4pe	vijendrap	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
8	Ashok		B	9845128927	srinanjundeswaratph@gmail.com	0	karnataka	Bengaluru Urban	1983-04-01	Male	AJAPA6347D				STATE BANK OF INDIA	64130013877	SBIN0040894	ASHOK B	Savings		0	2026-05-11 07:38:09.334301	2026-05-19 17:09:14.558163	$2a$12$ycc1VxOWC4Tf9vNL74X6luykFFCfJ2I.GF..K2pm3Y4MaDOve0a.G	ashokb	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
7	Krishna		MURTHY K	9945708639	95krishnamurthy@gmail.com	0	karnataka	Bengaluru Urban	1995-07-05	Male	EPOPK0080R										0	2026-05-11 07:38:07.194447	2026-05-19 17:10:32.154886	$2a$12$fx.6MaZyARv.gPmisT0.R.ovkVvXXIy.IHNfUz9nnO.OjfYKPOMiy	krishnamurt	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
6	N C 		NIRANJAN	9945666226	niranjandev141@gmail.com	0	karnataka	Bengaluru Urban	1995-09-08	Male	AWDPN6661M				AXIS BANK	916010062549984	UTIB0001204	NIRANJAN N C	Savings		0	2026-05-11 07:38:04.989153	2026-05-19 17:12:48.089518	$2a$12$ooIEUeY0cYJP5OU9NyITKOXlBN3DJsrXLbBDmjhxThAZYHLBrmdv6	niranjannir	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
5	YOGESHWARAPPA		K	9980990027	yogi.slvglass4@gmail.com	0	karnataka	Bengaluru Urban	1980-11-25	Male	ABZPY0767G		S L V GLASS	61, 14TH CROSS, KEMPEGOWDANAGAR, BYADARAHALLI,  BENGALURU 560091							0	2026-05-11 07:38:02.850939	2026-05-19 17:15:10.505227	$2a$12$QvrOmlk2ElC3IjAvnaL8n.4x4MwGOZv92WdpPJyzlvlPErbbBm8HK	yogeshslv	Ganesha@123	25000.0	25.0	\N	\N	\N	\N	1
4	Manjunatha		R	9035722613	MANJUNATHA1105@GMAIL.COM	0	karnataka	Bengaluru Urban	1983-05-11	Male	ASAPM6418Q										0	2026-05-11 07:38:00.705507	2026-05-19 17:16:51.139043	$2a$12$OME1ylMJx4vuLT0d7OpnoOrdfvTjClWYxTOzoptbyUIH2IPofD.C.	manjunathar	Ganesha@123	100000.0	100.0	\N	\N	\N	\N	1
3	N		GOPAL	9845798137	ngopalg77@gmail.com	0	karnataka	Bengaluru Urban	1977-07-10	Male	ALHPG4776H				STATE BANK OF INDIA	64038146543	SBIN0040655	N GOPAL	Savings		0	2026-05-11 07:37:58.503701	2026-05-19 17:18:48.159382	$2a$12$u.r.iZjvLDUVucAx5YwIdej4KqZuCUXl5TjGpbH9H6.MbmjKbe2C.	gopaln	Ganesha@123	25000.0	25.0	\N	\N	\N	\N	1
2	DEVARAJ		T H	9845588357	devrajth99@gmail.com	0	karnataka	Bengaluru Urban	1985-05-20	Male	AUQPD5436M				STATE BANK OF INDIA	64063539941	SBIN0040781	DEVARAJ T H	Savings		0	2026-05-11 07:37:56.329779	2026-05-19 17:20:29.266099	$2a$12$SYw/NPVfg5zNp.Rrfq7tM.SOlVcsYbDYfZbkFUKjE912TraKVssJu	devarajth	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
1	DEVARAJ		JAYRAM	7411417470	devraaj.jayram@gmail.com	0	karnataka	Bengaluru Urban	1976-03-04	Male	AERPJ8932K			96, 1st Floor Basappa Layout Hanumanthanagar\r\n	HDFC BANK		HDFC0004876	DEVARAJ J	Savings		0	2026-05-11 07:37:54.024883	2026-05-28 09:18:00.31577	$2a$12$A9ZLeNBcmI2qbm4HqmEHveRIcn/Tne.eH6Ee2YLGliIvklh45aIpS	devarajjayr	Ganesha@123	200000.0	100.0	\N	\N	\N	\N	2
9	Shivakumar		B N	9743228985	kunigalshivakumara@gmail.com	0	karnataka	Bengaluru Urban	1982-07-20	Male	CDHPS8602J				CANARA BANK	6781101000772	CNRB0006781	B N SHIVAKUMARA	Savings		0	2026-05-11 07:38:11.504436	2026-06-03 01:01:01.256951	$2a$12$d7qqxP4UAYTyQT2umv9x6.dtw8DtexUkjosRYYsPyqOloHDVFwsA.	shivakumarn	Ganesha@123	100000.0	100.0	\N	\N	\N	\N	1
\.


--
-- TOC entry 4755 (class 0 OID 19476)
-- Dependencies: 340
-- Data for Name: invoice_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.invoice_items (id, invoice_id, payout_type, payout_id, description, amount, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4730 (class 0 OID 19138)
-- Dependencies: 315
-- Data for Name: invoices; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.invoices (id, invoice_number, payout_type, payout_id, total_amount, status, invoice_date, due_date, paid_at, recipient_name, recipient_email, recipient_address, notes, created_at, updated_at) FROM stdin;
2	INV-DIST-202605-00001	distributor	1	426.25	paid	2026-05-17	2026-05-17	2026-05-17 08:55:05.212301	Krama Consulting	krama.consulting@gmail.com	\N	Monthly distributor commission for 1 payouts in May 2026	2026-05-17 08:55:05.213421	2026-05-17 08:55:05.213421
3	INV-AMB-202605-00001	ambassador	1	426.25	paid	2026-05-17	2026-05-17	2026-05-17 08:55:05.246912	Krama Consulting	krama.consulting@gmail.com	\N	Monthly ambassador commission for 1 payouts in May 2026	2026-05-17 08:55:05.247578	2026-05-17 08:55:05.247578
4	INV-AFF-202605-00008	affiliate	8	4994.16	paid	2026-05-01	2026-05-01	2026-05-29 06:47:51.807331	SOWMYA H T	vijendramarvin220@gmail.com	\N	Backfilled affiliate commission for 1 policies in May 2026	2026-05-29 06:47:52.382808	2026-05-29 06:47:52.382808
5	INV-AMB-202605-00004	ambassador	4	170.45	paid	2026-05-01	2026-05-01	2026-05-29 06:48:04.494849	M P VIJENDRA	vijendramarvin220@gmail.com	\N	Backfilled ambassador commission for 1 payouts in May 2026	2026-05-29 06:48:06.271755	2026-05-29 06:48:06.271755
6	INV-AFF-202605-00006	affiliate	6	446.46	paid	2026-05-29	2026-05-29	2026-05-29 10:46:05.28939	Murali Krishna Kasibhatta	masterlee311@gmail.com	\N	Monthly affiliate commission for 1 policies in May 2026: sssdsd	2026-05-29 10:46:05.290255	2026-05-29 10:46:05.290255
1	INV-AFF-202605-00001	affiliate	1	433.49	paid	2026-05-17	2026-05-17	2026-05-17 08:54:47.976103	DEVARAJ J	bittideva@gmail.com	\N	Monthly affiliate commission for 1 policies in May 2026: 28000000342787	2026-05-17 08:54:47.982374	2026-05-17 08:54:47.982374
7	INV-AFF-202606-00006	affiliate	6	34.40	paid	2026-06-02	2026-06-02	2026-06-02 13:55:03.041148	Murali Krishna Kasibhatta	masterlee311@gmail.com	\N	Monthly affiliate commission for 1 policies in June 2026: D268395947	2026-06-02 13:55:03.046843	2026-06-02 13:55:03.046843
8	INV-AMB-202606-00005	ambassador	5	6.88	paid	2026-06-02	2026-06-02	2026-06-02 13:55:14.687324	GAYATRI K	gurwale.gayatri@gmail.com	\N	Monthly ambassador commission for 1 payouts in June 2026	2026-06-02 13:55:14.688111	2026-06-02 13:55:14.688111
\.


--
-- TOC entry 4656 (class 0 OID 18100)
-- Dependencies: 241
-- Data for Name: leads; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.leads (id, name, contact_number, email, referred_by, product_interest, current_stage, created_date, note, created_at, updated_at, lead_id, address, city, state, lead_source, call_disposition, referral_amount, transferred_amount, notes, attachments, stage_updated_at, converted_customer_id, policy_created_id, product_category, product_subcategory, is_direct, affiliate_id, first_name, middle_name, last_name, birth_date, gender, pan_no, gst_no, company_name, marital_status, height, weight, birth_place, education, business_job, business_name, job_name, occupation, type_of_duty, annual_income, additional_information, height_feet, weight_kg, business_job_type, business_job_name, duty_type, is_branch_out, ambassador_id, customer_type, parent_lead_id) FROM stdin;
7	Eswaraiah Sudha	9686405652	sudha.e68@gmail.com		\N	converted	2026-05-01	\N	2026-05-16 10:49:54.198969	2026-05-16 10:56:46.923298	CUSLEAD-ESWAR-BSRPS	42, Shashwathi Nilaya, 1st A Main Cross Road, Maruthi Layout, RMV 2nd Stage, Blr 560094	Bengaluru Urban	karnataka	agent_referral	interested	0.00	f		\N	2026-05-16 10:56:46.923332	11	\N	insurance	health	f	1	Eswaraiah		Sudha	1967-07-21	female	BSRPS7005K	\N	\N	married	5.17	82								\N		\N	\N	\N	\N	\N	f	\N	individual	\N
8	Girish Shivanna 	9845269391	girishatshivanna@gmail.com	Friend Reference	\N	lead_generated	2026-05-16	\N	2026-05-16 11:29:33.834678	2026-05-17 06:29:20.728451	CUSLEAD-GIRIS-69468		No 7 tr nagara bengaluru 	karnataka	agent_referral		0.00	f	For mutual funds how to trigger	\N	2026-05-16 11:29:33.833938	\N	\N	insurance	other	f	3	Girish		Shivanna	\N						4.17									\N		\N	\N	\N	\N	\N	f	\N	individual	\N
18	Krishna Prasad	9150845577	kp@gmail.com	Friend Reference	\N	converted	2026-05-18	\N	2026-05-18 02:26:28.990715	2026-05-20 14:01:29.520124	CUSLEAD-KRISH-32790		Bengaluru 	Karnataka	agent_referral	\N	0.00	f	Financial planning 	\N	2026-05-20 14:01:29.520192	19	\N	insurance	health	f	6	Krishna	\N	Prasad	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
16	Geetha Guruwale	6515432866		Friend Reference	\N	one_on_one	2026-05-17	\N	2026-05-17 12:24:15.711271	2026-05-25 07:15:42.286969	CUSLEAD-GEETH-91656		Hyderabad 	telangana	agent_referral		0.00	f	Personal Accident policy	\N	2026-05-25 07:15:42.287032	\N	\N	insurance	other	f	1	Geetha		Guruwale	\N															\N		\N	\N	\N	\N	\N	f	\N	individual	\N
19	HANUMANTHA M	9538247661	pradeepdjpradeep16455@gmail.com	VIJENDRA MP	\N	converted	2026-05-24	\N	2026-05-26 00:11:49.467249	2026-05-26 00:42:02.081352	CUSLEAD-HANUM-AISPH	S/O Marigowda, 230/2, Marchanahalli, Channapatna, Karnataka 562160	Ramanagara	karnataka	agent_referral	interested	0.00	f	\n\nUpdated: Policy created - 112233 on 2026-05-26	\N	2026-05-26 00:42:02.070582	22	13	insurance	motor	f	8	HANUMANTHA		M	1985-06-15	male	AISPH0089E	\N	\N	married										\N		\N	\N	\N	\N	\N	f	\N	individual	\N
21	 T SHIVANNA 	9743003428		Friend Reference	\N	follow_up	2026-05-26	\N	2026-05-26 13:23:41.093111	2026-05-26 13:39:15.162461	CUSLEAD-TXXXX-68187	No 7 	Banglore 	Karnataka	agent_referral	\N	0.00	f		\N	2026-05-26 13:39:15.16249	\N	\N	insurance	motor	f	3	T	\N	SHIVANNA	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
23	DR KRISHNA NAGARAJ	9980639161	krishnainduvalu@yahoo.co.in		\N	consultation_scheduled	2026-05-27	\N	2026-05-27 16:49:42.904498	2026-05-29 06:31:25.839194	CUSLEAD-DR KR-ADZPN		Mandya	karnataka	walk_in	follow_up	0.00	f	Created from existing customer: DR KRISHNA  NAGARAJ (ID: 6)	\N	2026-05-29 06:31:25.839241	\N	\N	investments	mutual_fund	t	\N	DR KRISHNA		NAGARAJ	1979-05-28	male	ADZPN3005G	\N	\N	married			MANDYA	MBBS	professional				DOCTOR	2500000.0		\N	\N	\N	\N	\N	t	\N	individual	\N
24	K Krishna  Prasad	8660725693	prasadsharma5577@gmail.com	Murali Krishna Kasibhatta	\N	converted	2026-05-29	\N	2026-06-02 13:52:21.995089	2026-06-02 13:52:21.995089	CUSLEAD-K K-693-030-MTR	12-1-34, 'Krishna Nivas', MT Road, New Field Street, \r\nNear Mahamaya Temple, Temple Ward, Car Street,\r\nMangalore, Karnataka 575001	Mangaluru	karnataka	agent_referral	\N	0.00	f	Auto-generated lead from motor insurance policy creation. Policy Number: D268395947	\N	2026-06-02 13:52:21.982697	19	17	insurance	motor	f	6	K Krishna	\N	Prasad	2002-07-03	male	GFVPP2999B	\N	\N	single	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
25	VINOTH KUMAR	9585180207	vinothvjk57@gmail.com	GOPAL N	\N	consultation_scheduled	2026-06-01	\N	2026-06-02 14:44:32.630161	2026-06-02 15:09:30.63666	CUSLEAD-VINOT-BRZPV			tamil_nadu	agent_referral		0.00	f		\N	2026-06-02 15:09:30.636718	\N	\N	insurance	health	f	10	VINOTH		KUMAR	1996-06-18	male	BRZPV6093D			single			PK ROAD	BE	self_employed					900000.0		\N	\N	\N	\N	\N	f	\N	individual	\N
26	N ADINARAYANAN	9035170488		N HARISH KUMAR	\N	converted	2026-06-01	\N	2026-06-02 15:26:07.965781	2026-06-02 16:49:57.725515	CUSLEAD-NXXXX-ASQPA		\N		agent_referral		0.00	f	\n\nUpdated: Policy created - D268909373 on 2026-06-02	\N	2026-06-02 16:49:57.721994	23	18	insurance	motor	f	1	N		ADINARAYANAN	1950-09-03	male	ASQPA6209B	\N	\N	married										\N		\N	\N	\N	\N	\N	f	\N	individual	\N
27	AYAN  M	8117854975	jravikumar849@gmail.com	RAVIKUMAR J	\N	converted	2026-05-19	\N	2026-06-03 17:54:50.593687	2026-06-03 17:54:50.593687	CUSLEAD-AYA-975-140-MTR	\N	\N	\N	agent_referral	\N	0.00	f	Auto-generated lead from motor insurance policy creation. Policy Number: 0907003126P102573254	\N	2026-06-03 17:54:50.579748	42	19	insurance	motor	f	7	AYAN	\N	M	1977-03-14	male	IHJPM6548D	\N	\N	married	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
28	M P  VIJENDRA	9620455292	vijendra220@gmail.com	SOWMYA H T	\N	converted	2026-06-02	\N	2026-06-03 18:26:58.127915	2026-06-03 18:26:58.127915	CUSLEAD-M P-292-010-MTR	\N	\N	\N	agent_referral	\N	0.00	f	Auto-generated lead from motor insurance policy creation. Policy Number: 6107213023 00 00	\N	2026-06-03 18:26:58.116693	44	20	insurance	motor	f	8	M P	\N	VIJENDRA	1982-05-01	male	AHOPV0261B	\N	\N	married	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
29	Ravikumar 	7899087018	ganga.ravi07@gmail.com	Friend Reference	\N	follow_up	2026-06-04	\N	2026-06-04 14:10:44.322071	2026-06-04 14:34:35.749682	CUSLEAD-RAVIK-34762	Ullalla 	Bengaluru 	Karnataka	agent_referral	\N	0.00	f	Vehicle insurance 	\N	2026-06-04 14:34:35.749715	\N	\N	insurance	motor	f	3	Ravikumar	\N	Name	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
30	Lalithamma 	7795346209	Lalithammays@gmail.com	Friend Reference	\N	lead_generated	2026-06-04	\N	2026-06-04 15:27:26.095718	2026-06-04 15:27:26.095718	CUSLEAD-LALIT-36214				agent_referral	\N	0.00	f		\N	2026-06-04 15:27:26.094743	\N	\N	insurance	health	f	1	Lalithamma	\N	Name	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	f	\N	individual	\N
\.


--
-- TOC entry 4704 (class 0 OID 18790)
-- Dependencies: 289
-- Data for Name: life_insurance_bank_details; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.life_insurance_bank_details (id, life_insurance_id, bank_name, account_type, account_number, ifsc_code, account_holder_name, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4706 (class 0 OID 18809)
-- Dependencies: 291
-- Data for Name: life_insurance_documents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.life_insurance_documents (id, life_insurance_id, document_type, document_name, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4702 (class 0 OID 18771)
-- Dependencies: 287
-- Data for Name: life_insurance_nominees; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.life_insurance_nominees (id, life_insurance_id, nominee_name, relationship, age, share_percentage, created_at, updated_at) FROM stdin;
5	9	Kaveri E	spouse	32	100.0	2026-05-29 02:39:18.709326	2026-05-29 02:39:18.709326
\.


--
-- TOC entry 4678 (class 0 OID 18392)
-- Dependencies: 263
-- Data for Name: life_insurances; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.life_insurances (id, customer_id, sub_agent_id, policy_holder, insured_name, insurance_company_name, agency_code_id, broker_id, policy_type, payment_mode, policy_number, policy_booking_date, policy_start_date, policy_end_date, risk_start_date, policy_term, premium_payment_term, plan_name, sum_insured, net_premium, first_year_gst_percentage, second_year_gst_percentage, third_year_gst_percentage, total_premium, term_rider_amount, term_rider_note, critical_illness_rider_amount, critical_illness_rider_note, accident_rider_amount, accident_rider_note, pwb_rider_amount, pwb_rider_note, other_rider_amount, other_rider_note, nominee_name, nominee_relationship, nominee_age, bank_name, account_type, account_number, ifsc_code, account_holder_name, reference_by_name, broker_name, bonus, fund, extra_note, main_agent_commission_percentage, commission_amount, tds_percentage, tds_amount, after_tds_value, installment_autopay_start_date, installment_autopay_end_date, active, created_at, updated_at, notification_dates, is_customer_added, is_agent_added, is_admin_added, distributor_id, investor_id, sub_agent_commission_percentage, sub_agent_commission_amount, distributor_commission_percentage, distributor_commission_amount, investor_commission_percentage, investor_commission_amount, main_income_percentage, main_income_amount, total_distribution_percentage, company_expenses_percentage, profit_percentage, profit_amount, sub_agent_tds_percentage, sub_agent_tds_amount, sub_agent_after_tds_value, distributor_tds_percentage, distributor_tds_amount, distributor_after_tds_value, investor_tds_percentage, investor_tds_amount, investor_after_tds_value, product_through_dr, main_agent_commission_received, main_agent_commission_transaction_id, main_agent_commission_paid_date, main_agent_commission_notes, lead_id, ambassador_commission_percentage, ambassador_commission_amount, ambassador_tds_percentage, ambassador_tds_amount, ambassador_after_tds_value, broker_code_type, policy_added_by_admin, original_policy_id, renewal_policy_id, is_renewed, insurance_company_code, main_policy_document_key, main_policy_document_filename, main_policy_document_content_type, main_policy_document_size) FROM stdin;
9	18	1	Self	YOGESHA MS	ICICI Prudential Life Insurance	\N	4	New	Half-Yearly	K7676680	2025-11-15	2025-11-28	2026-11-27	2025-05-28	1	1	iProtect Smart+	10000000.00	74024.00	0.00	0.00	0.00	74024.00	0.00	\N	0.00	\N	0.00	\N	0.00	\N	0.00	\N			\N								0.00	0.00		40.50	29979.72	2.00	599.59	29380.13	2025-11-28	2026-05-27	t	2026-05-29 02:39:18.696995	2026-06-04 05:26:07.287088	[{"type":"renewal","title":"Life Policy Renewal Reminder - 1 Month","message":"Your life policy (K7676680) is due for renewal on 27 Nov 2026. Please renew to continue your coverage.","date":"2026-10-28"},{"type":"renewal","title":"Life Policy Renewal Reminder - 15 Days","message":"Your life policy (K7676680) expires in 15 days on 27 Nov 2026. Please renew to avoid coverage gap.","date":"2026-11-12"},{"type":"renewal","title":"Life Policy Renewal Reminder - 1 Week","message":"Your life policy (K7676680) expires in 1 week on 27 Nov 2026. Immediate action required.","date":"2026-11-20"},{"type":"renewal","title":"Life Policy Renewal Reminder - Final Notice","message":"Your life policy (K7676680) expires tomorrow on 27 Nov 2026. Renew now to avoid coverage gap.","date":"2026-11-26"}]	f	f	t	1	\N	5.00	3701.20	1.00	740.24	5.00	3701.20	40.50	29979.72	12.00	5.00	23.50	17395.64	2.00	74.02	3627.18	0.00	0.00	740.24	0.00	0.00	3701.20	t	t	sdds	2026-05-29	sd	CUST-20260519-D1IE2M	1.0	740.24	2.0	14.8	725.44	broking	t	\N	\N	f		\N	\N	\N	\N
\.


--
-- TOC entry 4720 (class 0 OID 19006)
-- Dependencies: 305
-- Data for Name: loans; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.loans (id, customer_id, loan_type, loan_amount, interest_rate, loan_term, emi_amount, loan_date, status, notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4765 (class 0 OID 19664)
-- Dependencies: 350
-- Data for Name: motor_insurance_documents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.motor_insurance_documents (id, motor_insurance_id, document_type, title, description, r2_file_key, r2_filename, r2_content_type, r2_file_size, created_at, updated_at, r2_url) FROM stdin;
\.


--
-- TOC entry 4761 (class 0 OID 19533)
-- Dependencies: 346
-- Data for Name: motor_insurance_nominees; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.motor_insurance_nominees (id, motor_insurance_id, nominee_name, relationship, age, share_percentage, created_at, updated_at) FROM stdin;
10	13	PRAMODINI C	spouse	33	100.0	2026-05-26 00:42:02.038953	2026-05-26 00:42:02.038953
14	17	VEENA BHAT	mother	50	100.0	2026-06-02 13:52:21.75924	2026-06-02 13:52:21.75924
15	18	N SHARADA	spouse	68	100.0	2026-06-02 16:49:57.674955	2026-06-02 16:49:57.674955
16	19	RAVIKUMAR J	other	49	100.0	2026-06-03 17:54:50.488351	2026-06-03 17:54:50.488351
17	20	SOWMYA HT	spouse	44	100.0	2026-06-03 18:26:58.011686	2026-06-03 18:26:58.011686
\.


--
-- TOC entry 4652 (class 0 OID 18062)
-- Dependencies: 237
-- Data for Name: motor_insurances; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.motor_insurances (id, vehicle_type, class_of_vehicle, registration_number, registration_date, engine_number, chassis_number, mfy, make, model, variant, seating_capacity, discount_loading_percent, previous_policy_number, ncb, legal_liability, electrical_accessories, non_electrical_accessories, zero_depreciation, roadside_assistance, engine_protector, key_replacement, return_to_invoice, consumable_cover, personal_accident_cover, financier, vehicle_idv, cng_idv, total_idv, tp_premium, payout_od, payout_tp, payout_net, main_agent_commission_percent, main_agent_commission_amount, main_agent_tds_percent, main_agent_tds_amount, broker_name, created_at, updated_at, notification_dates, policy_end_date, policy_start_date, policy_booking_date, insurance_company_name, policy_holder, policy_type, gst_percentage, net_premium, gst_amount, after_tds_value, is_customer_added, is_agent_added, is_admin_added, reference_by_name, extra_note, customer_id, sub_agent_id, agency_code_id, broker_id, insurance_type, total_premium, policy_number, sum_insured, status, product_through_dr, main_agent_commission_received, main_agent_commission_transaction_id, main_agent_commission_paid_date, main_agent_commission_notes, lead_id, distributor_id, investor_id, sub_agent_commission_percentage, sub_agent_commission_amount, sub_agent_tds_percentage, sub_agent_tds_amount, sub_agent_after_tds_value, distributor_commission_percentage, distributor_commission_amount, distributor_tds_percentage, distributor_tds_amount, distributor_after_tds_value, investor_commission_percentage, investor_commission_amount, investor_tds_percentage, investor_tds_amount, investor_after_tds_value, ambassador_commission_percentage, ambassador_commission_amount, ambassador_tds_percentage, ambassador_tds_amount, ambassador_after_tds_value, total_distribution_percentage, company_expenses_percentage, profit_percentage, profit_amount, commission_amount, tds_percentage, tds_amount, main_agent_commission_percentage, policy_added_by_admin, payment_mode, plan_name, broker_code_type, installment_autopay_start_date, installment_autopay_end_date, nominee_name, nominee_relation, nominee_dob, insurance_company_code, company_expenses_amount, main_policy_document_key, main_policy_document_filename, main_policy_document_content_type, main_policy_document_size, main_policy_document_url, vehicle_number, vehicle_make, vehicle_model) FROM stdin;
13	Old Vehicle	Goods Vehicle	KA05AL7275	\N	275CNG17DXXS55868	MAT556002NVD24092	2022	2022	ACE		\N	\N	\N	\N	\N	\N	\N	f	f	f	f	f	f	\N		645281.0	\N	645281.0	0.0	\N	\N	\N	\N	9688.68	\N	\N	\N	2026-05-26 00:42:02.02894	2026-05-28 09:12:29.923377	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your motor policy (112233) is due for renewal on 24 May 2027. Please renew to continue your coverage.","date":"2027-04-24"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your motor policy (112233) expires in 15 days on 24 May 2027. Please renew to avoid coverage gap.","date":"2027-05-09"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your motor policy (112233) expires in 1 week on 24 May 2027. Immediate action required.","date":"2027-05-17"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your motor policy (112233) expires tomorrow on 24 May 2027. Renew now to avoid coverage gap.","date":"2027-05-23"}]	2027-05-24	2026-05-25	2026-05-25	Liberty General Insurance	Self	Rollover	18.00	17942.00	\N	9494.91	f	f	t			22	8	\N	2	Comprehensive	21171.56	201350020126790157300000	\N	\N	f	t	IN22614707389020	2026-05-27	9671	CUSLEAD-HANUM-AISPH	4	\N	28.00	5023.76	2.00	100.48	4923.28	2.00	358.84	\N	\N	\N	5.00	897.10	0.00	0.00	897.10	1.00	179.42	2.00	3.59	175.83	36.00	5.00	13.00	2332.46	9688.68	2.00	193.77	54.00	t	Yearly	\N	broking	2026-05-25	2027-05-24	\N	\N	\N	\N	897.1	\N	\N	\N	\N	\N	\N	\N	\N
18	Old Vehicle	Two Wheeler	KA05HU3069	\N			\N				\N	\N	\N	\N	\N	\N	\N	f	f	f	f	f	f	\N		8220.0	\N	8220.0	0.0	\N	\N	\N	\N	344.35	\N	\N	\N	2026-06-02 16:49:57.665628	2026-06-02 16:49:57.665628	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your motor policy (D268909373) is due for renewal on 13 Jun 2027. Please renew to continue your coverage.","date":"2027-05-14"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your motor policy (D268909373) expires in 15 days on 13 Jun 2027. Please renew to avoid coverage gap.","date":"2027-05-29"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your motor policy (D268909373) expires in 1 week on 13 Jun 2027. Immediate action required.","date":"2027-06-06"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your motor policy (D268909373) expires tomorrow on 13 Jun 2027. Renew now to avoid coverage gap.","date":"2027-06-12"}]	2027-06-13	2026-06-14	2026-06-01	Go Digit Insurance	Self	Rollover	18.00	732.66	\N	337.46	f	f	t			23	11	\N	2	Comprehensive	864.54	D268909373	\N	\N	t	f	\N	\N	\N	CUSLEAD-NXXXX-ASQPA	1	\N	14.00	102.57	2.00	2.05	100.52	2.00	14.65	\N	\N	\N	5.00	36.63	0.00	0.00	36.63	1.00	7.33	2.00	0.15	7.18	22.00	5.00	20.00	146.53	344.35	2.00	6.89	47.00	t	Yearly	\N	broking	2026-06-14	2027-06-13	\N	\N	\N	\N	36.63	\N	\N	\N	\N	\N	\N	\N	\N
17	Old Vehicle	Two Wheeler	KA05QB8165	\N			\N	TVS	JUPTIER	125	\N	\N	\N	\N	\N	\N	\N	f	f	f	f	f	f	\N		73194.0	\N	73194.0	0.0	\N	\N	\N	\N	322.92	\N	\N	\N	2026-06-02 13:52:21.751303	2026-06-02 16:44:45.520656	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your motor policy (D268395947) is due for renewal on 28 May 2027. Please renew to continue your coverage.","date":"2027-04-28"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your motor policy (D268395947) expires in 15 days on 28 May 2027. Please renew to avoid coverage gap.","date":"2027-05-13"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your motor policy (D268395947) expires in 1 week on 28 May 2027. Immediate action required.","date":"2027-05-21"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your motor policy (D268395947) expires tomorrow on 28 May 2027. Renew now to avoid coverage gap.","date":"2027-05-27"}]	2027-05-28	2026-05-29	2026-05-29	Go Digit Insurance	Self	Rollover	18.00	702.00	\N	316.46	f	f	t			19	6	\N	2	Own Damage	828.36	D268395947	\N	\N	t	t	IN22614909224291	2026-05-29		CUSLEAD-K K-693-030-MTR	5	\N	5.00	35.10	2.00	0.70	34.40	2.00	14.04	\N	\N	\N	5.00	35.10	0.00	0.00	35.10	1.00	7.02	2.00	0.14	6.88	13.00	10.00	23.00	161.46	322.92	2.00	6.46	46.00	t	Yearly	\N	broking	2026-05-29	2027-05-28	\N	\N	\N	\N	70.2	\N	\N	\N	\N	\N	\N	\N	\N
19	Old Vehicle	Goods Vehicle	KA15A8905	\N			\N				\N	\N	\N	\N	\N	\N	\N	f	f	f	f	f	f	\N		700000.0	\N	700000.0	0.0	\N	\N	\N	\N	7883.52	\N	\N	\N	2026-06-03 17:54:50.476759	2026-06-03 17:54:50.476759	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your motor policy (0907003126P102573254) is due for renewal on 19 May 2027. Please renew to continue your coverage.","date":"2027-04-19"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your motor policy (0907003126P102573254) expires in 15 days on 19 May 2027. Please renew to avoid coverage gap.","date":"2027-05-04"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your motor policy (0907003126P102573254) expires in 1 week on 19 May 2027. Immediate action required.","date":"2027-05-12"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your motor policy (0907003126P102573254) expires tomorrow on 19 May 2027. Renew now to avoid coverage gap.","date":"2027-05-18"}]	2027-05-19	2026-05-20	2026-05-19	United India Insurance Company	Self	Rollover	9.00	16424.00	\N	7725.85	f	f	t			42	7	\N	2	Comprehensive	17902.16	0907003126P102573254	\N	\N	t	f	\N	\N	\N	CUSLEAD-AYA-975-140-MTR	1	\N	31.00	5091.44	2.00	101.83	4989.61	2.00	328.48	\N	\N	\N	5.00	821.20	0.00	0.00	821.20	1.00	164.24	2.00	3.28	160.96	39.00	5.00	4.00	656.96	7883.52	2.00	157.67	48.00	t	Yearly	\N	broking	2026-05-20	2027-05-19	\N	\N	\N	\N	821.2	\N	\N	\N	\N	\N	\N	\N	\N
20	Old Vehicle	Two Wheeler	KA41EY6548	\N			\N				\N	\N	\N	\N	\N	\N	\N	f	f	f	f	f	f	\N		115385.0	\N	115385.0	0.0	\N	\N	\N	\N	177.3	\N	\N	\N	2026-06-03 18:26:57.997517	2026-06-03 18:26:57.997517	[{"type":"renewal","title":"Policy Renewal Reminder - 1 Month","message":"Your motor policy (6107213023 00 00) is due for renewal on 28 Jun 2027. Please renew to continue your coverage.","date":"2027-05-29"},{"type":"renewal","title":"Policy Renewal Reminder - 15 Days","message":"Your motor policy (6107213023 00 00) expires in 15 days on 28 Jun 2027. Please renew to avoid coverage gap.","date":"2027-06-13"},{"type":"renewal","title":"Policy Renewal Reminder - 1 Week","message":"Your motor policy (6107213023 00 00) expires in 1 week on 28 Jun 2027. Immediate action required.","date":"2027-06-21"},{"type":"renewal","title":"Policy Renewal Reminder - Final Notice","message":"Your motor policy (6107213023 00 00) expires tomorrow on 28 Jun 2027. Renew now to avoid coverage gap.","date":"2027-06-27"}]	2027-06-28	2026-06-29	2026-06-02	Tata AIG General Insurance	Self	Rollover	18.00	1182.00	\N	173.75	f	f	t			44	8	3	\N	Own Damage	1394.76	6107213023 00 00	\N	\N	t	f	\N	\N	\N	CUSLEAD-M P-292-010-MTR	4	\N	5.00	59.10	2.00	1.18	57.92	2.00	23.64	\N	\N	\N	5.00	59.10	0.00	0.00	59.10	1.00	11.82	2.00	0.24	11.58	13.00	2.00	0.00	0.00	177.30	2.00	3.55	15.00	t	Yearly	\N	direct	2026-06-29	2027-06-28	\N	\N	\N	\N	23.64	\N	\N	\N	\N	\N	\N	\N	\N
\.


--
-- TOC entry 4801 (class 0 OID 20818)
-- Dependencies: 386
-- Data for Name: mutual_fund_nominees; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mutual_fund_nominees (id, mutual_fund_id, nominee_name, relationship, age, share_percentage, created_at, updated_at) FROM stdin;
1	1	ddsd	father	23	19.00	2026-05-20 01:19:57.886337	2026-05-20 01:19:57.886337
\.


--
-- TOC entry 4799 (class 0 OID 20757)
-- Dependencies: 384
-- Data for Name: mutual_funds; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.mutual_funds (id, customer_id, sub_agent_id, distributor_id, investment_type, amount, fund_name, folio_number, plan_name, start_date, maturity_date, bank_name, account_type, account_number, ifsc_code, account_holder_name, reference_by_name, broker_name, bonus, fund, extra_note, main_agent_commission_percentage, commission_amount, tds_percentage, tds_amount, after_tds_value, sub_agent_commission_percentage, sub_agent_commission_amount, sub_agent_tds_percentage, sub_agent_tds_amount, sub_agent_after_tds_value, distributor_commission_percentage, distributor_commission_amount, distributor_tds_percentage, distributor_tds_amount, distributor_after_tds_value, investor_commission_percentage, investor_commission_amount, company_expenses_percentage, company_expenses_amount, total_distribution_percentage, profit_percentage, profit_amount, main_policy_document_key, main_policy_document_filename, main_policy_document_content_type, main_policy_document_size, installment_autopay_start_date, installment_autopay_end_date, is_admin_added, is_customer_added, is_agent_added, active, created_at, updated_at) FROM stdin;
2	5	1	1	SIP	2000.00				\N	\N								0.00	0.00		0.00	0.00	0.00	0.00	0.00	2.00	40.00	0.00	0.00	40.00	0.00	0.00	0.00	0.00	0.00	2.00	40.00	0.00	0.00	4.00	-4.00	-80.00	\N	\N	\N	\N	2026-05-20	2026-05-20	t	f	f	t	2026-05-20 03:41:26.693977	2026-05-20 03:41:26.693977
1	16	1	1	SIP	232000.00	dsds	2233	Growth	2026-05-20	2026-06-04								0.00	0.00		0.50	1160.00	2.00	23.20	1136.80	0.20	464.00	2.00	9.28	454.72	0.05	116.00	2.00	2.32	113.68	0.10	232.00	0.05	116.00	0.35	0.10	232.00	mutual_fund/1/20260520_011957_1f801d6d8d1d6d53_logo.jpeg	logo.jpeg	image/jpeg	22400	2026-05-20	2026-05-20	t	f	f	t	2026-05-20 01:19:57.872968	2026-06-02 22:37:59.947443
\.


--
-- TOC entry 4773 (class 0 OID 19761)
-- Dependencies: 358
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.notifications (id, recipient_type, recipient_id, notification_type, title, message, reference_type, reference_id, is_read, sent_at, read_at, created_at, updated_at) FROM stdin;
1	SubAgent	2	helpdesk_comment_added	New Comment on Your Support Ticket	An admin has added a comment to your support ticket: Help Request from Samparka Association	ClientRequest	4	f	2026-05-17 12:03:20.939055	\N	2026-05-17 12:03:20.938867	2026-05-17 12:03:20.938867
2	SubAgent	1	helpdesk_comment_added	New Comment on Your Support Ticket	An admin has added a comment to your support ticket: Help Request from DEVARAJ J	ClientRequest	3	f	2026-05-18 03:31:39.615763	\N	2026-05-18 03:31:39.615698	2026-05-18 03:31:39.615698
3	SubAgent	3	helpdesk_comment_added	New Comment on Your Support Ticket	An admin has added a comment to your support ticket: Help Request from LOKESH SHIVANNA	ClientRequest	5	f	2026-05-26 14:14:35.537952	\N	2026-05-26 14:14:35.537891	2026-05-26 14:14:35.537891
4	SubAgent	3	helpdesk_comment_added	New Comment on Your Support Ticket	An admin has added a comment to your support ticket: Help Request from LOKESH SHIVANNA	ClientRequest	2	f	2026-05-28 08:55:20.660303	\N	2026-05-28 08:55:20.660233	2026-05-28 08:55:20.660233
\.


--
-- TOC entry 4769 (class 0 OID 19702)
-- Dependencies: 354
-- Data for Name: other_insurance_documents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.other_insurance_documents (id, other_insurance_id, document_type, title, description, r2_file_key, r2_filename, r2_content_type, r2_file_size, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4759 (class 0 OID 19514)
-- Dependencies: 344
-- Data for Name: other_insurance_nominees; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.other_insurance_nominees (id, other_insurance_id, nominee_name, relationship, age, share_percentage, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4654 (class 0 OID 18081)
-- Dependencies: 239
-- Data for Name: other_insurances; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.other_insurances (id, policy_id, other_policy_type, main_agent_commission_percent, main_agent_commission_amount, main_agent_tds_percent, main_agent_tds_amount, reference_by_name, broker_name, created_at, updated_at, notification_dates, policy_end_date, policy_start_date, policy_booking_date, product_through_dr, main_agent_commission_received, main_agent_commission_transaction_id, main_agent_commission_paid_date, main_agent_commission_notes, lead_id, distributor_id, investor_id, policy_holder, broker_code_type, agency_code_id, broker_id, gst_percentage, payment_mode, plan_name, policy_term, claim_process, commission_amount, tds_percentage, tds_amount, after_tds_value, sub_agent_commission_percentage, sub_agent_commission_amount, sub_agent_tds_percentage, sub_agent_tds_amount, sub_agent_after_tds_value, investor_commission_percentage, investor_commission_amount, investor_tds_percentage, investor_tds_amount, investor_after_tds_value, ambassador_commission_percentage, ambassador_commission_amount, ambassador_tds_percentage, ambassador_tds_amount, ambassador_after_tds_value, company_expenses_percentage, total_distribution_percentage, profit_percentage, profit_amount, installment_autopay_start_date, installment_autopay_end_date, main_agent_commission_percentage, policy_type, is_customer_added, is_agent_added, is_admin_added, policy_added_by_admin, is_renewed, original_policy_id, insurance_company_code, main_policy_document_key, main_policy_document_filename, main_policy_document_content_type, main_policy_document_size, company_expenses_amount, total_premium, net_premium, sum_insured, insurance_company_name, customer_id, insurance_type, sub_agent_id, policy_number) FROM stdin;
6	\N	\N	\N	\N	\N	\N	\N	\N	2026-05-17 11:43:23.047349	2026-05-17 11:43:23.047349	\N	2026-05-31	2026-05-17	2026-05-17	f	f	\N	\N	\N	CUSLEAD-NXX-137-100-OTH	\N	\N	N  GOPAL	\N	\N	\N	18.0	Yearly	Home Ins	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	New	t	f	f	f	\N	\N	\N	\N	\N	\N	\N	\N	1500.00	1500.00	10000000.00	To be assigned	5	General Insurance	\N	REQ-1779018203
7	\N	\N	\N	\N	\N	\N	\N	\N	2026-05-17 13:04:09.369584	2026-05-17 13:04:09.369584	\N	2026-05-17	2026-05-17	2026-05-17	f	f	\N	\N	\N	CUSLEAD-BAS-888-030-OTH	\N	\N	BASAVARAJ  CHANDRASHEKAR	\N	\N	\N	18.0	Yearly	Bfbf	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	New	t	f	f	f	\N	\N	\N	\N	\N	\N	\N	\N	5.00	5.00	56.00	To be assigned	3	General Insurance	\N	REQ-1779023049
8	\N	\N	\N	\N	\N	\N	\N	\N	2026-05-17 13:05:27.436159	2026-05-17 13:05:27.436159	\N	2026-05-17	2026-05-17	2026-05-17	f	f	\N	\N	\N	CUSLEAD-BAS-888-030-OTH-01	\N	\N	BASAVARAJ  CHANDRASHEKAR	\N	\N	\N	18.0	Yearly	Bxh	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	New	t	f	f	f	\N	\N	\N	\N	\N	\N	\N	\N	656.00	656.00	6565.00	To be assigned	3	General Insurance	\N	REQ-1779023127
\.


--
-- TOC entry 4714 (class 0 OID 18882)
-- Dependencies: 299
-- Data for Name: payout_audit_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payout_audit_logs (id, auditable_type, auditable_id, action, changes, performed_by, ip_address, notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4712 (class 0 OID 18857)
-- Dependencies: 297
-- Data for Name: payout_distributions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payout_distributions (id, commission_receipt_id, recipient_type, recipient_id, distribution_percentage, calculated_amount, paid_amount, pending_amount, status, payment_date, payment_mode, transaction_id, reference_number, payment_notes, processed_by, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4728 (class 0 OID 19086)
-- Dependencies: 313
-- Data for Name: payouts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.payouts (id, policy_type, policy_id, customer_id, total_commission_amount, status, payout_date, processed_by, processed_at, notes, reference_number, created_at, updated_at, main_agent_percentage, main_agent_commission_amount, main_agent_commission_id, affiliate_percentage, affiliate_commission_amount, affiliate_commission_id, ambassador_percentage, ambassador_commission_amount, ambassador_commission_id, investor_percentage, investor_commission_amount, investor_commission_id, company_expense_percentage, company_expense_amount, company_expense_commission_id, commission_summary, net_premium, main_agent_commission_received, main_agent_commission_transaction_id, main_agent_commission_paid_date, main_agent_commission_notes) FROM stdin;
18	health	36	4	28184.0	pending	2026-06-13	system_auto	\N	Structured payout for health policy #2856 2057 2973 7502 000	PAYOUT_HEALTH_36_1778766025	2026-05-14 13:40:25.485232	2026-05-14 13:40:25.509325	\N	4227.60	\N	\N	1338.74	\N	\N	267.75	\N	\N	1409.20	\N	\N	563.68	\N	\N	28184.0	\N	\N	\N	\N
19	health	37	7	18091.41	pending	2026-06-13	system_auto	\N	Structured payout for health policy #72895305	PAYOUT_HEALTH_37_1778766911	2026-05-14 13:55:11.462167	2026-05-14 13:55:11.526739	\N	2713.71	\N	\N	859.34	\N	\N	171.86	\N	\N	904.57	\N	\N	361.83	\N	\N	18091.41	\N	\N	\N	\N
20	health	38	6	46273.0	pending	2026-06-14	system_auto	\N	Structured payout for health policy #34370258202501\nMain agent commission paid - Transaction: dsd on 2026-05-29	PAYOUT_HEALTH_38_1778815750	2026-05-15 03:29:10.821362	2026-05-29 10:42:35.616067	\N	5899.81	\N	\N	1813.90	\N	\N	370.18	\N	\N	1850.92	\N	\N	925.46	\N	\N	46273.0	t	dsd	2026-05-29	sd
49	motor	18	23	732.66	pending	2026-07-02	system_auto	\N	Structured payout for motor policy #D268909373	PAYOUT_MOTOR_18_1780418997	2026-06-02 16:49:57.683561	2026-06-02 16:49:57.705539	\N	344.35	\N	\N	100.52	\N	\N	7.18	\N	\N	36.63	\N	\N	36.63	\N	\N	732.66	\N	\N	\N	\N
9	health	27	5	2224.19	pending	2026-06-12	system_auto	\N	Structured payout for health policy #90475760	PAYOUT_HEALTH_27_1778671539	2026-05-13 11:25:39.026727	2026-05-13 11:25:39.047877	\N	266.90	\N	\N	84.52	\N	\N	21.13	\N	\N	88.97	\N	\N	44.48	\N	\N	2224.19	\N	\N	\N	\N
11	health	29	3	10000.0	pending	2026-06-12	system_auto	\N	Structured payout for health policy #sd	PAYOUT_HEALTH_29_1778675729	2026-05-13 12:35:29.094001	2026-05-13 12:35:29.125626	\N	1000.00	\N	\N	100.00	\N	\N	300.00	\N	\N	100.00	\N	\N	200.00	\N	\N	10000.0	\N	\N	\N	\N
12	health	30	2	25635.0	pending	2026-06-12	system_auto	\N	Structured payout for health policy #89557128	PAYOUT_HEALTH_30_1778679853	2026-05-13 13:44:13.605415	2026-05-13 13:44:13.627719	\N	3076.20	\N	\N	974.13	\N	\N	243.53	\N	\N	1025.40	\N	\N	512.70	\N	\N	25635.0	\N	\N	\N	\N
13	health	31	3	21924.8	pending	2026-06-12	system_auto	\N	Structured payout for health policy #7000288448-00	PAYOUT_HEALTH_31_1778680384	2026-05-13 13:53:04.205932	2026-05-13 13:53:04.229773	\N	5042.70	\N	\N	1041.43	\N	\N	208.29	\N	\N	1096.24	\N	\N	1096.24	\N	\N	21924.8	\N	\N	\N	\N
14	health	32	4	21809.0	pending	2026-06-12	system_auto	\N	Structured payout for health policy #2856 2057 2973 7501 000	PAYOUT_HEALTH_32_1778680650	2026-05-13 13:57:30.880193	2026-05-13 13:57:30.894453	\N	2617.08	\N	\N	828.74	\N	\N	207.19	\N	\N	872.36	\N	\N	436.18	\N	\N	21809.0	\N	\N	\N	\N
15	health	33	6	33253.39	pending	2026-06-13	system_auto	\N	Structured payout for health policy #34370258202400	PAYOUT_HEALTH_33_1778728570	2026-05-14 03:16:10.508653	2026-05-14 03:16:10.527729	\N	4156.67	\N	\N	1263.63	\N	\N	315.90	\N	\N	1330.14	\N	\N	665.07	\N	\N	33253.39	\N	\N	\N	\N
17	health	35	5	27581.01	pending	2026-06-13	system_auto	\N	Structured payout for health policy #90475760	PAYOUT_HEALTH_35_1778764847	2026-05-14 13:20:47.286487	2026-05-14 13:20:47.313838	\N	3516.58	\N	\N	1081.18	\N	\N	270.29	\N	\N	1103.24	\N	\N	551.62	\N	\N	27581.01	\N	\N	\N	\N
39	health	51	9	11500.0	pending	2026-06-17	system_auto	\N	Structured payout for health policy #REQ-1779073559	PAYOUT_HEALTH_51_1779073559	2026-05-18 03:05:59.850105	2026-05-18 03:05:59.861835	\N	1150.00	\N	\N	\N	\N	\N	230.00	\N	\N	230.00	\N	\N	230.00	\N	\N	11500.0	\N	\N	\N	\N
40	health	52	19	9838.0	pending	2026-06-19	system_auto	\N	Structured payout for health policy #100063248600	PAYOUT_HEALTH_52_1779285907	2026-05-20 14:05:07.315195	2026-05-20 14:05:07.402785	\N	2065.98	\N	\N	482.06	\N	\N	96.41	\N	\N	491.90	\N	\N	491.90	\N	\N	9838.0	\N	\N	\N	\N
4	health	15	1	9126.15	pending	2026-06-12	system_auto	\N	Structured payout for health policy #85432300\nMain agent commission paid - Transaction: 20240615001 on 2024-06-15	PAYOUT_HEALTH_15_1778636275	2026-05-13 01:37:55.970395	2026-05-26 13:54:50.794624	\N	1095.14	\N	\N	433.49	\N	\N	86.70	\N	\N	91.26	\N	\N	91.26	\N	\N	9126.15	t	20240615001	2024-06-15	referred by Naga CM
50	health	53	8	14199.0	pending	2026-07-02	system_auto	\N	Structured payout for health policy #34428150202400	PAYOUT_HEALTH_53_1780443536	2026-06-02 23:38:56.784255	2026-06-02 23:38:56.800559	\N	3265.77	\N	\N	674.45	\N	\N	134.89	\N	\N	\N	\N	\N	709.95	\N	\N	14199.0	\N	\N	\N	\N
31	life	1	9	32332.98	pending	2026-06-14	system_auto	\N	Structured payout for life policy #wq32223	PAYOUT_LIFE_1_1778844633	2026-05-15 11:30:33.484565	2026-05-15 11:30:33.501679	\N	14549.84	\N	\N	646.66	\N	\N	966.76	\N	\N	646.66	\N	\N	646.66	\N	\N	32332.98	\N	\N	\N	\N
34	life	4	10	10000.0	pending	2026-06-14	system_auto	\N	Structured payout for life policy #Udx 	PAYOUT_LIFE_4_1778854620	2026-05-15 14:17:00.108912	2026-05-15 14:17:00.12245	\N	\N	\N	\N	200.00	\N	\N	200.00	\N	\N	200.00	\N	\N	200.00	\N	\N	10000.0	\N	\N	\N	\N
44	health	2	2	24273.58	pending	2026-06-10	system_auto	\N	Structured payout for health policy #89557128	PAYOUT_HEALTH_2_1779877791	2026-05-27 10:29:52.168418	2026-05-27 10:29:57.472848	\N	2912.83	\N	\N	1153.00	\N	\N	230.60	\N	\N	\N	\N	\N	1213.68	\N	\N	24273.58	\N	\N	\N	\N
51	health	54	24	23469.22	pending	2026-07-02	system_auto	\N	Structured payout for health policy #4225i/P-ELVT/363000758/00/000	PAYOUT_HEALTH_54_1780444062	2026-06-02 23:47:42.294986	2026-06-02 23:47:42.369354	\N	2346.92	\N	\N	891.83	\N	\N	222.96	\N	\N	\N	\N	\N	704.08	\N	\N	23469.22	\N	\N	\N	\N
45	health	1	1	9126.15	pending	2026-06-10	system_auto	\N	Structured payout for health policy #85432300	PAYOUT_HEALTH_1_1779877798	2026-05-27 10:29:59.168377	2026-05-27 10:30:04.269122	\N	2920.37	\N	\N	433.49	\N	\N	86.70	\N	\N	\N	\N	\N	456.31	\N	\N	9126.15	\N	\N	\N	\N
41	motor	13	22	17942.0	pending	2026-06-25	system_auto	\N	Structured payout for motor policy #201350020126790157300000\nMain agent commission paid - Transaction: IN22614707389020 on 2026-05-27	PAYOUT_MOTOR_13_1779877762	2026-05-27 10:29:23.821291	2026-05-28 09:12:30.186421	\N	7176.80	\N	\N	4994.16	\N	\N	170.45	\N	\N	897.10	\N	\N	538.26	\N	\N	17942.0	t	IN22614707389020	2026-05-27	9671
52	health	55	25	21095.52	pending	2026-07-03	system_auto	\N	Structured payout for health policy #7090009658	PAYOUT_HEALTH_55_1780446954	2026-06-03 00:35:54.164643	2026-06-03 00:35:54.183986	\N	1582.16	\N	\N	601.23	\N	\N	200.41	\N	\N	\N	\N	\N	421.91	\N	\N	21095.52	\N	\N	\N	\N
48	motor	17	19	702.0	pending	2026-07-02	system_auto	\N	Structured payout for motor policy #D268395947\nMain agent commission paid - Transaction: IN22614909224291 on 2026-05-29	PAYOUT_MOTOR_17_1780408341	2026-06-02 13:52:21.840888	2026-06-02 13:57:25.280378	\N	322.92	\N	\N	34.40	\N	\N	6.88	\N	\N	35.10	\N	\N	70.20	\N	\N	702.0	t	IN22614909224291	2026-05-29	
47	life	9	18	74024.0	pending	2026-06-28	system_auto	\N	Structured payout for life policy #K7676680\nMain agent commission paid - Transaction: sdds on 2026-05-29	PAYOUT_LIFE_9_1780022358	2026-05-29 02:39:18.715572	2026-05-29 10:37:24.984295	\N	29380.13	\N	\N	3627.18	\N	\N	725.44	\N	\N	3701.20	\N	\N	3701.20	\N	\N	74024.0	t	sdds	2026-05-29	sd
53	health	56	26	32573.17	pending	2026-07-03	system_auto	\N	Structured payout for health policy #7030003418	PAYOUT_HEALTH_56_1780448095	2026-06-03 00:54:55.238319	2026-06-03 00:54:55.286984	\N	7491.83	\N	\N	1547.23	\N	\N	309.44	\N	\N	1628.66	\N	\N	1628.66	\N	\N	32573.17	\N	\N	\N	\N
54	health	57	27	36014.53	pending	2026-07-03	system_auto	\N	Structured payout for health policy #9740808135	PAYOUT_HEALTH_57_1780448798	2026-06-03 01:06:38.247769	2026-06-03 01:06:38.263929	\N	2701.09	\N	\N	1368.55	\N	\N	342.14	\N	\N	\N	\N	\N	720.29	\N	\N	36014.53	\N	\N	\N	\N
55	health	58	28	35428.74	pending	2026-07-03	system_auto	\N	Structured payout for health policy #4225i/ELVT/372710990/00/000	PAYOUT_HEALTH_58_1780449334	2026-06-03 01:15:34.765785	2026-06-03 01:15:34.779782	\N	8148.61	\N	\N	1682.87	\N	\N	336.58	\N	\N	\N	\N	\N	1771.44	\N	\N	35428.74	\N	\N	\N	\N
56	health	59	29	21230.0	pending	2026-07-03	system_auto	\N	Structured payout for health policy #34560831202400	PAYOUT_HEALTH_59_1780450342	2026-06-03 01:32:22.37843	2026-06-03 01:32:22.394035	\N	2653.75	\N	\N	1008.42	\N	\N	201.68	\N	\N	\N	\N	\N	849.20	\N	\N	21230.0	\N	\N	\N	\N
57	health	60	29	48026.0	pending	2026-07-03	system_auto	\N	Structured payout for health policy #34551958202400	PAYOUT_HEALTH_60_1780450634	2026-06-03 01:37:14.640096	2026-06-03 01:37:14.653565	\N	6003.25	\N	\N	1824.99	\N	\N	456.25	\N	\N	\N	\N	\N	1921.04	\N	\N	48026.0	\N	\N	\N	\N
58	health	61	31	10982.36	pending	2026-07-03	system_auto	\N	Structured payout for health policy #95514336	PAYOUT_HEALTH_61_1780451460	2026-06-03 01:51:00.958086	2026-06-03 01:51:00.970261	\N	1317.88	\N	\N	417.33	\N	\N	104.33	\N	\N	\N	\N	\N	439.29	\N	\N	10982.36	\N	\N	\N	\N
59	health	62	36	44548.47	pending	2026-07-03	system_auto	\N	Structured payout for health policy #PROPRM050120013	PAYOUT_HEALTH_62_1780453669	2026-06-03 02:27:49.556325	2026-06-03 02:27:49.569459	\N	4900.33	\N	\N	2116.05	\N	\N	423.21	\N	\N	\N	\N	\N	890.97	\N	\N	44548.47	\N	\N	\N	\N
60	health	63	37	48008.0	pending	2026-07-03	system_auto	\N	Structured payout for health policy #SARVAH050041079	PAYOUT_HEALTH_63_1780457498	2026-06-03 03:31:38.476112	2026-06-03 03:31:38.565265	\N	11041.84	\N	\N	2280.38	\N	\N	456.08	\N	\N	2400.40	\N	\N	2400.40	\N	\N	48008.0	\N	\N	\N	\N
61	health	64	38	23703.0	pending	2026-07-03	system_auto	\N	Structured payout for health policy #IDV002280092	PAYOUT_HEALTH_64_1780462893	2026-06-03 05:01:33.207564	2026-06-03 05:01:33.228926	\N	3555.45	\N	\N	1125.89	\N	\N	225.18	\N	\N	1185.15	\N	\N	474.06	\N	\N	23703.0	\N	\N	\N	\N
62	health	65	39	22680.0	pending	2026-07-03	system_auto	\N	Structured payout for health policy #7045112500083174	PAYOUT_HEALTH_65_1780463407	2026-06-03 05:10:07.074235	2026-06-03 05:10:07.094744	\N	4536.00	\N	\N	1077.30	\N	\N	215.46	\N	\N	1134.00	\N	\N	1134.00	\N	\N	22680.0	\N	\N	\N	\N
63	health	66	40	24147.0	pending	2026-07-03	system_auto	\N	Structured payout for health policy #2851112500070677,	PAYOUT_HEALTH_66_1780464205	2026-06-03 05:23:25.290446	2026-06-03 05:23:25.311284	\N	4829.40	\N	\N	1146.98	\N	\N	229.40	\N	\N	1207.35	\N	\N	1207.35	\N	\N	24147.0	\N	\N	\N	\N
64	health	67	41	8014.39	pending	2026-07-03	system_auto	\N	Structured payout for health policy #7330061278	PAYOUT_HEALTH_67_1780495285	2026-06-03 14:01:25.869454	2026-06-03 14:01:25.883409	\N	1202.16	\N	\N	380.68	\N	\N	76.13	\N	\N	400.72	\N	\N	160.29	\N	\N	8014.39	\N	\N	\N	\N
65	motor	19	42	16424.0	pending	2026-07-03	system_auto	\N	Structured payout for motor policy #0907003126P102573254	PAYOUT_MOTOR_19_1780509290	2026-06-03 17:54:50.500125	2026-06-03 17:54:50.525495	\N	7883.52	\N	\N	4989.61	\N	\N	160.96	\N	\N	821.20	\N	\N	821.20	\N	\N	16424.0	\N	\N	\N	\N
66	motor	20	44	1182.0	pending	2026-07-03	system_auto	\N	Structured payout for motor policy #6107213023 00 00	PAYOUT_MOTOR_20_1780511218	2026-06-03 18:26:58.020409	2026-06-03 18:26:58.047122	\N	177.30	\N	\N	57.92	\N	\N	11.58	\N	\N	59.10	\N	\N	23.64	\N	\N	1182.0	\N	\N	\N	\N
\.


--
-- TOC entry 4684 (class 0 OID 18533)
-- Dependencies: 269
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.permissions (id, name, module_name, action_type, description, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4648 (class 0 OID 17984)
-- Dependencies: 233
-- Data for Name: policies; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.policies (id, customer_id, user_id, insurance_company_id, agency_broker_id, policy_number, policy_type, insurance_type, plan_name, payment_mode, policy_booking_date, policy_start_date, policy_end_date, policy_term_years, risk_start_date, sum_insured, net_premium, gst_percentage, total_premium, bonus, fund, note, status, created_at, updated_at, policy_holder) FROM stdin;
\.


--
-- TOC entry 4763 (class 0 OID 19645)
-- Dependencies: 348
-- Data for Name: policy_documents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.policy_documents (id, policy_type, policy_id, document_type, title, description, uploaded_by, r2_file_key, r2_filename, r2_content_type, r2_file_size, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4740 (class 0 OID 19268)
-- Dependencies: 325
-- Data for Name: reports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reports (id, name, report_type, filters, report_data, status, generated_at, created_by_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4686 (class 0 OID 18551)
-- Dependencies: 271
-- Data for Name: role_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.role_permissions (id, role_id, permission_id, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4682 (class 0 OID 18516)
-- Dependencies: 267
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.roles (id, name, description, status, created_at, updated_at) FROM stdin;
1	super_admin	Full system access with all privileges.	t	2026-05-11 07:28:54.135721	2026-05-11 07:28:54.135721
2	sub_agent	\N	t	2026-05-11 11:05:19.526756	2026-05-11 11:05:19.526756
\.


--
-- TOC entry 4635 (class 0 OID 17898)
-- Dependencies: 220
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: -
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
20260601000001
20260605030204
20260605032336
\.


--
-- TOC entry 4750 (class 0 OID 19345)
-- Dependencies: 335
-- Data for Name: session_activities; Type: TABLE DATA; Schema: public; Owner: -
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
82	2	login	2026-05-30 03:30:01.55884	162.158.54.39	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	0ff3c5459e36f3e54ad383b9945ba475	2026-05-30 03:30:01.587608	2026-05-30 03:30:01.587608
83	2	login	2026-05-30 06:47:36.290575	172.69.123.141	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	782997e8798b12643b00f59e2145fc17	2026-05-30 06:47:36.32079	2026-05-30 06:47:36.32079
84	2	login	2026-05-30 09:23:18.168602	172.69.131.183	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	5c177b7eb8d0393de948afe8b55906c5	2026-05-30 09:23:18.181395	2026-05-30 09:23:18.181395
85	2	login	2026-06-01 05:47:47.649436	162.158.79.191	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	3b72a431d3ad13edb17311f05059de1e	2026-06-01 05:47:47.664425	2026-06-01 05:47:47.664425
86	2	logout	2026-06-01 13:43:50.203423	162.158.54.39	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	1f947b26745a147bec4c9b936cadaded	2026-06-01 13:43:50.278046	2026-06-01 13:43:50.278046
87	2	login	2026-06-01 13:44:07.444261	162.158.54.39	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	68d667465f11f85b523d379caed50a86	2026-06-01 13:44:07.444797	2026-06-01 13:44:07.444797
88	2	logout	2026-06-01 14:50:38.227104	162.158.54.38	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	e0bc899951183d464e5c33e68cc10885	2026-06-01 14:50:38.227779	2026-06-01 14:50:38.227779
89	2	login	2026-06-02 07:11:20.335352	172.71.194.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	d247b8a90e3f66ec14833abfab08403e	2026-06-02 07:11:20.3495	2026-06-02 07:11:20.3495
90	2	logout	2026-06-02 10:42:54.05387	162.158.54.39	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	74f6230cd30e9eaa322a44e3601cc141	2026-06-02 10:42:54.068442	2026-06-02 10:42:54.068442
91	2	login	2026-06-02 11:26:38.645404	172.69.123.140	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	2f07cb4278050398eca63ff1945dddee	2026-06-02 11:26:38.645941	2026-06-02 11:26:38.645941
92	2	logout	2026-06-02 15:35:19.429829	172.68.146.154	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	a8857dfd7343ea634a4ce0428626ebb8	2026-06-02 15:35:19.441869	2026-06-02 15:35:19.441869
93	2	login	2026-06-02 16:30:32.733915	162.158.54.39	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	66b851bb347d49383fea0928f55a2581	2026-06-02 16:30:32.734525	2026-06-02 16:30:32.734525
94	2	logout	2026-06-02 17:00:55.220504	172.68.146.154	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	87685dc5da231a08985babb37ed4fa2e	2026-06-02 17:00:55.24837	2026-06-02 17:00:55.24837
95	2	login	2026-06-02 22:00:56.517421	172.69.123.141	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	dd316b8d8895340bf6ae1ddfde19c7f8	2026-06-02 22:00:56.518129	2026-06-02 22:00:56.518129
96	2	logout	2026-06-03 05:36:56.979561	162.158.54.38	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	162d0ff8d4af97f5fa277624194f6b32	2026-06-03 05:36:56.980281	2026-06-03 05:36:56.980281
97	2	login	2026-06-03 07:44:18.863552	172.69.131.174	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	21012cd8d96cc5d9f85ad7fe24c3e602	2026-06-03 07:44:18.86415	2026-06-03 07:44:18.86415
98	2	logout	2026-06-03 14:06:03.446411	104.23.209.214	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	0526f3040a7aea7a94b62a4c0e8dd899	2026-06-03 14:06:03.447266	2026-06-03 14:06:03.447266
99	2	login	2026-06-03 16:55:27.009779	172.69.123.140	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	dd88dcae27408085c1dea62f2a0640ae	2026-06-03 16:55:27.010511	2026-06-03 16:55:27.010511
100	2	logout	2026-06-03 18:31:28.412769	172.71.194.166	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	de59063d2a698c92035f2f57e3e33e82	2026-06-03 18:31:28.413544	2026-06-03 18:31:28.413544
101	2	login	2026-06-04 04:57:06.814107	162.158.54.39	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	339d30c22c9163e5c67c355c478574a2	2026-06-04 04:57:06.814694	2026-06-04 04:57:06.814694
102	2	logout	2026-06-04 05:20:46.376623	172.69.123.140	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	d620c9dce320b639f643c79afbbf548a	2026-06-04 05:20:46.377556	2026-06-04 05:20:46.377556
103	2	login	2026-06-04 05:21:01.419005	172.69.123.140	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	59ebe20d755ae3ac27712d0d5453d13d	2026-06-04 05:21:01.419613	2026-06-04 05:21:01.419613
104	2	logout	2026-06-04 06:32:20.500077	162.158.54.39	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	d347d92fdf2bbb854bafc9b21765031a	2026-06-04 06:32:20.500857	2026-06-04 06:32:20.500857
105	2	login	2026-06-04 08:02:53.892588	162.158.79.191	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	00c46d6d50f1a00881d0bc687d5529c9	2026-06-04 08:02:53.893235	2026-06-04 08:02:53.893235
106	2	logout	2026-06-04 11:45:44.674085	162.158.79.192	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	8a4cc68b56de135ae6e231e22b879957	2026-06-04 11:45:44.674851	2026-06-04 11:45:44.674851
107	2	login	2026-06-04 13:52:08.316945	172.69.123.140	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	7e6f28c5e368c8725ea4d3bed9421194	2026-06-04 13:52:08.317627	2026-06-04 13:52:08.317627
108	2	logout	2026-06-04 15:59:57.329797	172.68.146.154	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	6e12b93c977cf0098c100a57d82fc9ae	2026-06-04 15:59:57.330662	2026-06-04 15:59:57.330662
109	2	login	2026-06-05 01:31:50.04052	162.158.55.78	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	eb6efde1a90ed2b84fc9a0170bed0d27	2026-06-05 01:31:50.041058	2026-06-05 01:31:50.041058
110	2	login	2026-06-05 03:19:14.264068	172.69.123.140	Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36	0de1e860475a9745c0d702f8365f204b	2026-06-05 03:19:14.281953	2026-06-05 03:19:14.281953
\.


--
-- TOC entry 4775 (class 0 OID 19785)
-- Dependencies: 360
-- Data for Name: solid_cache_entries; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.solid_cache_entries (id, key, value, created_at, key_hash, byte_size) FROM stdin;
494	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32365f7633	\\x0011810c9bf2876b85da41ffffffff789c8d945d4fd35018c76fccd8c6c69c6c6040439d895e18b06f6bbbd31b0f6cb23236e636480c89cd613db0266b3bfb22cc7d04131334d1af40c2bdf19278addfc03baf4cbcf11b785ada2151716dd2a6e7fff4ff7b9ea73dcfb5f86806ccd9d8c487a8af6a1e56bb9667ba7a1c2cdab88b4db73f54f1d140b7b1162a31301b853b2e723d6714570aa996bf84b51888553a7a922c34b1a9e9e6414c8e77743fa0726e123c67c0e2c0eaeb5d1d3be7e62450752ccb24d8f988e6f67447352c93dc636021425a838165bb9ea9bbe46522e4ceb35423bfddcc280912ee70809542ae6eb9964d29a6e3d9c8ec629f0dd25dcf712d03db24a706b5bed5849bc1fa8dc061a89a9eb11788478e464e271053031b1bba67ec4fb11c4868c8c58a07121dddc0e9dadba5b3e32da51f0389979689e951524eff1d2dcf28856c1536b6ebb0d1a942aa1e2c6694c26d9666b8224d931b2b88259a298a1ced1f41c0f5fd2423967856ce2a9e7c23fd88f052cfa993983c1bb2f2558cfa6eef4f58be46d56cdde999886adac8415a04cc32c45ce0585e12c6904449e2a490f1facdd2197ce8e62e18ffaae7d62a6cc31dd8821bd41a29addc82ed6aa5065b1169b65579b2cc88a4289667f88815673017a29609eaf3cdcad309caf9fd735df666244ee4a366b12b1ce643f707c4fdfbe98f8fff2f24bb56a73695c6ba5fca76444854b59e769173e47a8fb8fe04f0d985ebeca6be8f27cf582a49122fb091333beec65de2fcbe72624ed08d5cc5394436d2518f6a7b5a0f8d19ac14fc3b34c7b3a224465de139ba2884946942f974a7989a80325f6e51b596d2ae3620d5804177c6208ee7449a2d4a2cb9d0cc1824b06254ceb7e3a5b377af4edd094073cd16ac6f95a97655d98135b245c6bf505a64a55291a41f12d28c449798159e09215f08247fffc3571f0216c28daadaf80536c93473c9e0d076a747532019cc12e257c65dcacf39d8d9d3c8f0a79a0732abfa01517403f5932540afd0a329394fa23790e9470b017dce93e72fa98ff1de156a1dd957a87070955a47c3cb6a8e9188cc09459ea505090b60319a94e3591a0ee85fbbb09382	2026-05-26 14:26:47.79523	-6487686728793729287	990
850	\\x70726f64756374696f6e3a64617368626f6172645f646174615f35316232656237315f323032362d30312d30315f323032362d31322d33315f7636	\\x00118173e68c6ee287da41ffffffff789c8d56fd6e1a4710b7920a0c263138d869d328715d454e55c5026230cc49ede1b856edc6f9b013b52a7f9c96bb39d8e4ee96eeee91523f43fb227d98be411fa04fd1d9bb031b3721157f703bf3dbf9f8cdecec7eb27cfe10aa5a6816386eacb408512a7e1fd699abf918e7641b298c857da614f304094b504e8501324ff132545d118d516af43251112a4364811e3aae8823cd73b01a701fb3d5129443a185cc9679280b3d4439d3ae672e7d9f079c6954fc26dce6d17f825b82fbc69d937a575c44ce08a58b916603f48bbbcd9ddd26dc4a8d8d44c05d4ea696e16e269118f238a4dd41802ec5ee173aedc7ed69c28a543c52b124c5721d5bb036c2c8e3d1204b7105aa53c1884d44ac550cabfb7c70802e0f59b05e6f436da7be5b6bb61aadf61eedaf8c18f766586b2345346bcddd4e7bafdec426ac6581cd201ba9914ebd5e6f349bed2659a94ed3770652bcd34322612dc96d9209fce2a3e6de4e1d6e4df39b893bbb3b1d2af194d50b031b17c5bd1096136a67cbea259225edf60b446f93cc8d074ee67fcc8218f9b5bf4a702f14911e061347a21b4b69389238c6c8a8ffbc0e151253915222056c3ea57f806e52de537485f49c530c98265f1bb06287c2c3c02d24a8155bb37e8002ca5d8901c02bb32a40d18e5888475bc5c4640e72dfbd22e8db80b2b2cb50b1f564448dc394462960ebb2273241ba27890ae0848d72d657e91663d9614495aa41c94e9253e705585168daa557843cf7a094b0441f051300ac99744d6acab420acba129939154c43f11db53805fe70defb3451801f8dfe49c062853928db543e8fbba6fb7b39019fa5e93e232a14c03eea7788519ef20ed0d767b099aabb5a4bde8fb5c1ccbef37043664eec8a553fdaba1455ce7a784844493e186a01eb734eba9197839bb63be4814739f5f202befe50ec2f63949399c792b56ddf81bb29674e1f7d21d19995e035140ec87d6f852ff1ebf2f707f4473fbfd468743af5569d7232d0d7703cef6c66fd04f5507814e02b1ee2cf22c227b3cebc2aa39af6a8628e336e384e6fa9b724a03b6f9570115593f6763d36223cd97d21941e483c7bf914e0f9d1416a940a1a8e0ab06aeae272e38c26c08aad5c16608d3e021e725d23be34817fa3086af0a92d88589a5b34caa6c11b68428b7d0fd66c278efa34f33cd36a069f124674391ea3fe638a60c2fa26e1d3faf6b565a7a4fdfd47469abd6975ed2faca39a756c6f5b3fd4aca7f636142931ca9b9ae6ee5c3d0f50b9e9c0ca11c7f8eb489e599dbc05ef6f8a6292105fa5d60f04f3d0abc1ed8b9e74fa317585394c5fcef3f9628ad84f0179eb011df02b07cea44b556426c9e5e4b8956d46a13ac999b32bb494e807695d0ca743167901d5a657ece5dde533a45ead2ff64bfd22259b7c9f6ecc59a7f623da5a4c84c2fa692af8fcfd0d2d60f763e6a7d0ccc392b17ecaa201fe8fd012dc95d0cafb4c71f779ff0d652d60ef63262ea12f1ba21ad1acc4812991164e32390fe196edc79a2e321ac22a0ea84b6f10bfc6b232edc8d424720fcd08a5ae3d240b6a28e2c073902698744cf16ba434f5317390acaa5f0223d1ec2d1a53c2f7156a3255b65de60ed1798b135a55b35576344972677a23657781a369ac78bdca39cdb1e4c238daba71cca2cd46add1a21ea409ce42f322a08bb0d8a17bb0769eb738610eb13fc3586fae6a4f985ca0ed8e16694fd8645ebb6ab475baa2b199418ee3681e5249eee8bdc78d560b1fcf40c1a218e2c102ed198e16689fbb7a81f699182fd0d2cbe47d5a73b587215749951c8f4653012ad32792f0b9f64b8f1aedc64ea3031bf474a019696e37a9cd8c3263ac9a09a996a9681bca9968824cf26bffe4ff0542756956	2026-06-03 01:51:10.204662	802740614287139925	1557
606	\\x70726f64756374696f6e3a64617368626f6172645f646174615f35653039666162665f323032362d30312d30315f323032362d31322d33315f7635	\\x001181faf89a66a286da41ffffffff789c8d55ff4e1b4710466965631b6203c6495b944454885491906dc0e039a93d138a0a254d02895ad57f9cd67773f696bd5b77778fd4cd33b47dc33e409fa2b3776783d3b4a9fc876f67bf9b1fdf7c33f7f1e2db6da81b6998f0fc441b19a1d2fc3eac33dff06b9cb33532188b064c6b16483296a0961905b240f306d47d195fa33218e4a61aac8c900933f27c99c486d7a12a7888f9a908b5481aa9f263016ad28c707a5c80f53c641872c19941cdcb708fc7ff486e011eda705e165d73197b63543ec6860d312c77f6760e5ab096391b4bc17d4eae1ec2466e5118f124a2b785409f720fefee7577dbadce4ea733ad5ad33d8f75a2e8b6b2bbd3ece201ac8e310e783ccc4bad407d6a18b3894c8c4ea07ac487c7e8f38889f5d62134770e0fbbbbbb7bbb9d16eec3ca98f16086751a19a2d33c6c759bbbad7d42ace609ce208d14d2daeb1eecb7f73a071dec10e5390dde50c937664464aca6354e6e0c6bd3126796f519a737b6c64d6b6f8cb594d8d9b17e8b62456f87254b2eb9bb1e7a79d46b2612e4773e3d8307918ccd484c3c857ea2946546e135c6f67afb0f582133b528a34fc2a373fa07e8a5cdbd405faac0bb40c10cc56a40c58d6480c22fa5a88a6bd840a0845a4fa10078654f2528bb318bf074b39cba2c40e1eb5704bd1254957b17565c3319936c9836a8246cde8e442ee8ee697a05f08c8d0bce17d92bd6b3c7882add8425372d4ebf2d4145a3154bbf0c451ec052ca123d946c02b06acbb5a5692b40a8fa0a999d0966a0fc86044e893f9e8f3e2d14e07b7bff54b04423cd834b9d0bb86fb5df2f48f8242bf73ba242031ca179831817a96e81a1b98447d975cf18c50789b198d9731196551ec4ad3aadd3cd5b59159cc7274494e2c39191b03e17a4170705b8ebfa232e02aaa95f94f0e4df727f99a09acc222e39dbee7dd8c838f306184a85deac05afa1744ce1fb15bec03f52bf6dd11ffdc2a576bbdb6d755a549385be86b3f96033efcfd08c644009bee211fe28637c3a53e6bb36ea699f3ae679d76dcfeb2ff41724f4e6bd122ea66ed2bbbd808d094f7e5f486d860a2f5f9e033c3f3dce9c5243a37109aab62f3eb7c168ee2baef699c0263d081e71d324be0c817fa50c9a70df95442c6d2d5a64d3e42d34a5c5dd8055d74be2016dbcc04acde233c2882e2f60a43fa609269d2f533e9daf5e3b6e46da9fbfe7a4b90f9c9efbd0396d3a67ee96f36dd33977b7a04c8551dd249a8db97e1ea3f6b33555208ef197b1ba74ba4507de2f8a725a10af92f4856401064db877a3496f90902aec307d3ecfe78b29e22803149d2d1af07706ce964b5d64b6c8c574dc6a2ea354bd74e6dc2a1d158622eb8be574c4e240506ffae57ed15fbc44d26aebbfe3925e9462936fb2170bce85fb845e2da746e9fc30357cf67e414bd8fb90fb29348fb060bd5fb07888ff23b514f74e6ab523a6b9ff7cf013552de1e0432e6ea16f3ba21ed1aec4a16d91915eba394f60cd0d13435f305ac23a11a4d265e2d77ad6568e4c4f62ffc4ae5052ed0979d0239988c043da60cab3cd6fd2a5ed8fdd83e455ff2cacc5b02bb4ae64186a34e4aae6facc1fa17785133ad5f3533e9ad6e2cb28e23a3d79018d400956a61f621972132eb7daf4fddbd93f80067da36818ed1a55c60e839d977a6e241167a62da8e5a60932c5effc55fc1b417105e8	2026-05-30 06:49:18.423752	-8528069747268823026	1427
734	\\x70726f64756374696f6e3a64617368626f6172645f646174615f35393536333265305f323032362d30312d30315f323032362d31322d33315f7636	\\x001181e9144c7ab687da41ffffffff789c8d566d53db461066928e8d0d14430c49dab461e884a6d3869131067b35d3ca843285425e209976ea0f9ab3b4b22f9174eeddc9a9cb6f687f627f407f45f724d9609a3a1d7fb06ef7b97d79766fef3e9abf7c0c552d340b5d2f515a442815bf076bccd37c8853b2f50cc6a22e538af982840b50c98421325ff125a87a221ea2d4e8e7a27958e9230b75dff544126b5e80e5900798afe6a012092de4d552e83e5e2dd7729741c043ce342a5e86bb3cfe577073f0d0b87333ef8a8bd81da0f430d6ac8741a9bebfdd803b99ad8108b9c7c952011ee41289114f22da1c86e851e841a9d5ac37c7f92a52f158259214f335dc83d501c63e8f7b798665a88e050336128956092c1ff0de217a3c62e15aad09d676b356b7acfdda5e031bb03260dc9f60edf50cd1b06acdc6de7ecd2056f3c06e406af5da6e73afde6c5210d571f26e4f8a77ba4f14aca6a98d7241507ed2ac6fd7e1ce38bd89b8d520f1da84d32b03eb57a5bd1256526227cbea358a25ed760a646ad87373df431626c86fc55bf0792462dd0f47ae442f91d2d0237188b151efde8615125379320e056c9cd23f403b2dec397a42faee39864c939f75587022e163e89552d482a35937440195b6c410e0955995a0ecc42cc2e3cd726ab20085ef5f11f46d481939cbb0e2e8d1805a86298d52c0e6754f6482744f5315c0191b14ecafb22dc6b2cb882665c1a29326a72e4bb0a0d0744aa70c45eec362ca107d944c00b06ad235a929d37cb0ec4964e63c300de577d4dc14f8e369efe344017e32faa7214b1416a0e250e97cee99beef1404dccfd27d4654288003d4ef10e322e51d62a02f602353b7b596bc9b6883997c176149e64e9c8a5d3bdebc1655c17e7c444449deeb6b016b534edab15f808f1dafcf439f72ea14057cfd5fb1bf4c508e261e17ed2f9dfbf020e3cced622024ba9312bc86d221b9ef2cf0397e5bfef188fee8172ceeecb45ab5bd1ae564a0afe164dad9c4fa19eabef029c0573cc25f448c4f275d79534635ed50c55c77b8e3ba9db9ce9c80f6b455c2c5544ddadbf6d980f064f78550ba27f1e2e529c0f3e3c3cc2815341a9460d9d4c5e3c6190dc00547792c448b3e421e716d115f9ac0bf530416dc7304114b138b86d83878034d69713e8355c74de22e4d3bdfb49ac16784115daecfa8ff982298b0bf4df9b4bf7b6d3b19697ffd9993e63cb4dbce867d6cd927ce96fda3659f3a5b50a6c4286f6a9a0753f53c44e565b3aa401ce36f037961b78a36bcbf29ca69427c995a3f14cc47df82bb573de97613ea0a7398be98e6f3c5187190018af6233ae0370e9c4997aac84c92f3e971ab388c4275d333e75468293108b3ba184efb2cf643aa4da7dc297af31748bd5a9bed97fa454a36fa21db58b0cf9d6f686b39150afbe7b1e0d3f737b480dd0f991f43730f73c6fa398b7bf83f424b713742ab1c30c5bde7dd3794b580fd0f99b886be6e886a44b3127ba6445ab8e9e43c823b4e9068bac36808ab24a42e5d227e8d6565da91a951ec1d99114a5d7b4416545f24a1ef224d30e99ae25ba434f5317390acaa5f4323d1ec2d1a532208146a3255713ce6f5d17d8b235a55f3557e3449f2c9f836caef0257d358f13b2b9734c7d20be37873e984c51b3bd6ce1ef5204d701699b700dd81e5165d81d665d1e68439c2ee0463bfb9a93d637286b63d98a53d63a369edb2d19a0701eee69093249e61e0240967394f7a33b4173898a17deee919da676238434baf91f769cd7d1e455ca5e5717d9a492558193f8b44c075b0f8a4d1b2b677e83944ef051a8ee65a93da0c2733bfaab9908a9889b6a0928b46c824bff577f11f36936564	2026-06-02 13:21:01.21483	6492289317128330824	1531
674	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30362d30315f7633	\\x0011816fbae0045f87da41ffffffff789c8d94cb6ed3401486bb406992c60d699a566a411d6583c4a28ceff67883514be3a649233754425d586e326d2cc5e3e00b10f20848485c772c281b047bd67d01de801d0f807803c6ae1db50255f1c2a399ffccffcdb1e79c1bf9c9225af131c1cfeca1d58fb0d5f322123a39b4eee31e26e1706ce1e723c7c7fd54c9a36a161e8476180593bc512f99f112eee7506ebbebccd1850e267d879ce6b47cd7c9d1f9f68549322fa3f59137747a0e0e2ecc69a015781ea1d8d58c160e9cc0723d42c739b49621bdd1c8f3c3883821dd4c85e58b535a99df5169524485703cc246bdbae79c60609020f26dd2c3311a31bd28083d17fb46bdfcd83bc5c1c006ad83445a4a3cc61689dce358679ab2244b920213b534f2b1eb44ee4951162027a042df0eb111a142d7713173f676e3fcf3d9dd8f395478e1110c27458d31eacb2d2ff4fcab27d0168d7aa5a1b71fb5f476b7a18356b25836eab739c8f2228474e0245985ac28f3307e92809b27455656054eab1891b6c4dca7bcd213f025a7555356ad81ed6138f817566b82a6ef040362838e6f07763f0356586a2ef19ca04853484155782565bc7ab371aedf0b976760ac6e99a0691a078db60edafa8e6eeabb19a5ca0bbc0c3951e1e80bb2593282c4c97c0afaf57ae3fcc3cb6fe10ca0958ea9b7f6b7c041c338d49bf41b9a1987913945157928a6048655a0ca6e0a6c0af94121b53bdf7fce00a9ec00533f3440d330f576e67f8b53440970509401a7ca3c9045c8814b7f87535845b8c47af7f5fda71958a536d8d9efe87bd3345428c8a22c65be0c278b0abb092fa7417eff31636bb496de49cbc74f31a1b51bd232e91f2d4ce65131a91ceab76b137a6a4e4a2ef182edc6351ca1f203e7740bf71cd71e16550437e1645eabd1e887f8781aadad44daea15b565fbd7a8fae83ab5658fafaae5588daf1b16d290dd88fccf00ad672d61da34d24ef417fd104d5b	2026-06-01 12:31:23.514707	-3273753645161115653	906
810	\\x70726f64756374696f6e3a64617368626f6172645f646174615f62343638323032615f323032352d30312d30315f323032352d31322d33315f7636	\\x0011811b5a8415de87da41ffffffff789c8d56db6edb461035d256b2243b92af495b23095c184d11d4a0145d87404b39ae51bb762e768216d503b12287d2262457592e95aafe8202ed47f4f3fa179d2529c9325ca7e003b93367e77a76969f2e5f3e864d2514f36d278e940850467c09b698a3f8181764db298c057d1645cc1589b0920a7d64ae5e6e3a221ca354e8ce446b4364be1ada8e8843c58b50f6b987d92a0795402821b32599136a88f3e556e6d2f3b8cf99c288afc03d1ede10dc43edce4ebd475c84f608a583a1620324ed466a67247cee70b252829d4c2231e071401b7d1f1d0adbbb5bab1aeddad3fd6a739a70447a1e46b1246da9badfac630bd64718ba3c1ccc139f0a466c226215c5503ee083437478c0fcad6a1b8cfdced366bbd56e371bd880b511e3ee0c6b6e173b0430603d8beaba7c739aaa3d90e2831a92c3f524994926f00adfd6b10a1bd37c32e9b2b1dfa45e4ecb37dfbd3defe25c58496a385b6e5ea9a6a4dd092dc6033b733c667e8cfc4ef70f781088500dfd892dd189a5d4559038c650abff3e8435125327d2520978744a6f806ed2c373748474ed73f499223fdb50b202e1a2ef141254c952acefa3804a57a20ff05aaf0a50b44216e0f16e31319983dc0faf09facea78cacbbb066a9c988d8c1228552c0ee554f648274cf1215c0191be5cc6fd22ddab2cda84c91012b56925c74598052849a18bd22e4b90b2b4985e8a3a00380759dae4e2dd23c83b2239169ea3305c50fc4630afcf1a2f769a2003f6bfd339fc511d229b0a8712e7734c57b39019fa7e93ea752440007a83e208679cadb474f5dc0a354dd554af27eac3466f69d87559939b1ca66f578f74a5439f3f111154af2c15009d85a70d20ddd1cdcb59c21f75dcaa99717f0e4bf627f15a39ccc3cae985f5bf76127ad99dd474f48b4672d7803854372df2bf125fec9677feed18b1e6fa556eb74aacd2ae5a4a16fe064d1d9ccfa19aaa17029c0d73cc05f4588cf66acbc2ea39ef6a863b63daed9766fa9b724a0bb689570217593f6765d36223cd97d2922359078f1ea14e0c5f1616a941a1a8c0a50d67d71b8764633a364450ef3d1a00f9f075c19542f45e0df290203ee5b820a4bc389e6d534780d4dca62edc0ba65c7619f069baba9a6f169c1a85cb6cb887f2c229830bf4bea697effc6b4d2a2bdff2b2b9af5c0ec5a0fcd63c33cb1f6cc9f0cf3d4da832225467913697616fa798891938ea41cd5187f1bc90bb39337e166521493847899a8ef0be6a26bc0bd3927ed7e4cacd087e9abc57abe9c220e5240dedca3037eedc0e974a98b4c27b99c1cb78ac528543b3973569996123d3fed8baee99085ae4fbde9157b7967f90289abd5dbfd125fa464931fd38d39f3dc7a425b8b895098bf4c055fde4c6801f58f999f42330f4bdafa390b07f83f424b70d742ab1cb0883b2ffa6f296b01ad8f99b882be6a887a44b31207ba454ad8c9e43c820dcb8b15dd563484a3d82796ae527db5e548d3914593d039d22394587b4416a2a1887dd7469a60d2d6cd3748a9fba3e720598ddefb5aa2d83bd4a684e745a8c854c572983344fb1d4e68b599adb2a349922fa677517617d88ac68adb5bbba439965c18c7bbab272c7c54336a0de2204d7016e86b7f76eb5de64d4e9823eccf30e6dbebda33266fd17647b769cfd8e416ed491c2e6ad7d35bbc5a6b561b589fa1fcdbfcc7835bb417385ad456b4b6d6aeb6ebd8c8302f1cb588d948a3e8d4db1da33a833d17e31b4cb5ea466d6e8a7e466e0a46dff341c0a3a46db64bb36a19d6a67f47c2e3ca5bad365a4f5bfbad066cd38f044d4d7ddf49a5a7961e6c9b9990ba9b8af6a0928926c824bff34ffe5f06656661	2026-06-03 00:36:58.072327	-1778884406486744755	1534
639	\\x70726f64756374696f6e3a64617368626f6172645f646174615f35393536333265305f323032342d30312d30315f323032342d31322d33315f7635	\\x00118148871f45b186da41ffffffff789c8d556d6f1b4510b64a65274ed2388ee314085025aada0aa93aa7491acf49704e42444a4adbbc08843f9cd67773f692bd5bb3bbe760fa0f10dff98bfc023e337be79738b414f9833db3b333f33cf3ecf8eedcdb475033d230e107a9363246a5f97d586381e1039cf1d5f330167798d62c94e42c4025770a64a1356b814c06a80c8613d74a0f99303d3f906962c85e163cc2895589a5916a6a4ad3c3a9b9362a19455c706650f332acf3e45fcd15e00b5bcecfab6b2e13bf8f2ac0c4b02ed2e96a9ea72f050f386559878d914761ccd3982e0a8101b51ddd7bd66cec341b4ff7f6c780359df344a78a4e8b0e54fb98843ce94e318f1d7d3694a9d1292c1ff0ee11063c6662adb10fced3fdc633c779ded8dbc55d58e9331e4e62dd7a358b6838cdddc60eee4075d4d8fbce6b63d47e57c96bd3a306aa19aee1d4b13a8635f1ac4d289cfaead3494e9d958cc78959bbc1a8a2db59aa41d71f551c309122bff3f7057c1ecbc4f4c4d05718a44a593a140e3049ed951572d22c72c6243c38a56f805636c5330ca40afd3314cc50953a2c78b10c5104f359d482675847a0844a4ba100b8b0d63c94bd84c578b259ce5216a1f8cd05855e09c2e32dc28a67867dd207d3069584cd9b9528059d1d6647002f59bfe83ec9afd8cc3e2392b4038b5e064dbf9d87058d561aed329478088b193ff463de3600550bd642d35669b01c286456fccc40f99a944c8d3f9ead3e060af0833d3f142cd558848a47330b796045de2e4af83887fb3d51a1010ed05c232625c22d3032e7f0203f6e19a37827353666f2bb044b6a54c45b721b279b37ba2aba8f8f8928c5bb3d23616da6482b098b70cf0b7a5c8484a95d92f0e5fb7a7f93a21a4e2a2eba8fbc3a6ce49cf91d8ca4427f32824b983fa2f2ed055ee01ffdf9fb43faa24fb4b8bddd6c36f61a84c9865ec28bd96293ec2fd1f464480d5ef0187f92091e4e3479db47336dd3c47c7fb0edfbed42bb20a1359b95e2129a26dd6d85ac4ff194f7b5d4a6abf0fccd29c0ab93a33c290d34eecfc3b29d4bc06d31be40cce9800974e887e031370ef16528f837eac081fb9e2462693dd1c61a376f43335abc4fa0eaf969d2a1d5165aa9d9f89c30a2cb0f19e98f690a93ee57199feed797ae979376f78f1169de86dbf23e734f1cf785b7e57ee7b8a7de16940918e126d16cccccf30875906fa622718cbff6d5b9db2cb9f06e519433407c99a42f240b3174607daa49bf93922aec63da9ae5f3f538e2200f28b90fe981df7a70162e4d91599073d973ab788c5af5b337e72d91a93012f95c2ca73d96848266d32eb74bc1dc3992561bff5d97f4a2141b7e9b5f2cba67de13ba5ace9cd2fd71ecf8f4dd8296b0f3a1f4e3d0518582cd7ec6922efe8fd6b2b85bad550e98e6c1abcecf845ac2f30fa5b8117d3311cd88762576ed888cf4b3cd790cab5e941afabfa215ac53412a5d227e6d666de5c8f430098eed0a25d51e5306dd93a9087da40da67c3b7c870eed7cec1ea4acfa17613d865da14d25a348a3a154152f60410ffd2b1c92551b59a3a7693d818c63ae33cb0fe909ccc1caf86f5746dc7825a8d3bf123d42bb3e95b18fc0be93dac849e2cd5d5b5019b986c814bff357e91f4802fe5b	2026-05-30 11:03:04.493273	9067504973198393319	1380
482	\\x70726f64756374696f6e3a64617368626f6172645f646174615f39396465333539385f323032362d30312d30315f323032362d31322d33315f7635	\\x0011814cf9774b6185da41ffffffff789c8d55db6edb461015d2428a6427926dd97151230952184911d4906cd99686404bd9ae51a74993f8825ef440acc8a1b4f592abee2ee5aaf986f613fb017dee077496a4642b4d9b400fe2ce0ecfcc3973e1c7b7df3c86ba918609cf4fb491112acdd76195f9868f71ceb696b9b1a8cfb466812463196a9951200b345f81ba2fe3312a83416eaac2d210993043cf97496c781daa8287989f8a508ba4912a3f16a026cd10af8fab79c830e48233839a57e01e8fff955c011ed8705e165d73197b23543ec6860d30acec37b75a3bb092818da4e03e27a80dd8c82d0a239e44f4b610e853eee1dd9dcede6e6b6f6baf3d65ade99ec73a5174bbb0bdd5e8e03e2c8f300e783cc8a996a13e358cd844264627503de08323f479c4c46ab30d8dadfd56a3d3d96f3577711796468c07335f676d39f568efb4dabbbbd882e53cbbd97d86d0de6eb5dadb9d14a13e95c01b2879658624c472ca6f726d5899d29b5956677a5edbd6aecb7a6daca5a2ce8ef51bf22a7a3b2c5b61096e3cf0f2a8632612e4b77e3c84fb918ccd504c3c857ea2945545e118637bfdf71896c84ce5c9a493f0f039fd0374d3c29ea22f55e09da2608662adc1821bc900855f4ebd165cc3fa0225d4ba0a05c0b93d95a1e2c62cc293479514b208c5afcfc9f552102bf72e2cb96632a29661daa092f0e8662482a0bbc3f40ae0051b159dcfb3572cb2c7482add80453725a7df946141a36d945e054a3c80c554257a28db0460d9d2b5d4b46d3ea8fa0a999d0766a07245cd4d893f998f3e250af0bdbd3f142cd148a3e152e502eedbbeef15257c92d1fd8ea4d0000768ae10e312f116189a3378985d778d51bc9f18eb337b2ec11d950771ab4ef3e4d18dac8ace9363124af1c1d048589d0bd28d8322dc75fd21170171ea95243cfdafdc5f27a826b3888bce63771d3632cdbc3e8652a1372bc105948f287c6f8117f847eaf74dfaa35fb8b8bddde934f79ac4c9ba5ec0b3f96033f417688632a004cf79843fc9180f679df9b68d6adaa38a79de78dbf37a855e4142771e95fc62aa26bddb0dd888fc09f795d466a0f0ecf57380972747192815341a95a16aebe2731b8c2f9072da67021bf42078c44d83f432e4fc1b65d080755792b0b4b168894d93b7aea92cee062cbb5e12f769db05b6d5ac7f2618c9e5058cfa8f697293ce97a99ece57178e9b89f6e71fb968ee7da7eb3e704e1ace3377d3f9b6e13c7737a142c4883735cdc65c3d8f50fbd98a2a92c6f8eb489d399d9203ef6e8a4a4a8856f8a22b240b3068c0bdeb9ef4fa0975851da6cfe6f57c35f538c81c4ace260df85b0367e952159925793b1db79acb28552f9d39b74a4785a1c8ea62351db23810549b5ea557f26f9f21f56af3ffe352bf28c526df642f169d53f729bd5a498dd2f9616af8f4dd0d2da1f53ef8a96b1ea160d14f593cc00f482df57b2bb5da01d3dc7fd9ff99584bd87f1fc40def9b405423da9538b02532d24b37e731acb86162e8eb454b582782baf40ee96b91b56d47a627b17f6c572875ed3121e8a14c44e0216d30e5d9e237e8d2d6c7ee4142d5bf086b31ec122d940c438d86a06aaecffc217a9738a1533d3fe5a3692dbe8c22aed39317d008946169fa11962137e19d2f7677f65a5b8d7d58a36f140da35da3cad861b0f352cf8dd4c49969136ab969824cf15b7f95fe01a8bf05fb	2026-05-26 11:29:05.883126	-4130484541935872278	1423
793	\\x70726f64756374696f6e3a64617368626f6172645f646174615f63333136333136315f323032342d30312d30315f323032342d31322d33315f7636	\\x001181f6212cb5da87da41ffffffff789c8d566d6f1b45108e4a652776dc38af8512a04a54d10a11ddf92df19c04e7344424347d495a81f087d3fa6e6c6f7b776b76f75c4cfe00427ce76ff0b3f819ccdef9258e428afcc1de9967e7e599d919df5dbc7c0c1b5a68167a7ea2b488502abe009bccd77c8873b2ad0cc6a20e538a052215963361882c30c70d5fc443941a83a968b58f2cd47dcf1749ac79095642dec5f189ee47420b393b0addc7d97173ecb2dbe521671a152fc27d1edf10dc17c69d9779575cc4de00a58fb1663d24ed7a66672042ee73b25282edb14462c493882e8621fa1476f79edda8352b8dbd7a6592b0223d8f5522495bb4f7aa35dc87b501c6018f7bb3c42782011b8944ab04560e79ef087d1eb170d33e006befa0b16f37aa07cd3ad66175c07830c53a5b6b29c2b69a75bb8635581b47f75ffa8d49ea5e4f8af7ba4f01aca5c98d6682f5496e53c9e694c7996c6b56ce99b09c92393d6e5ca155d2edd4d4b0e78d3d0e599820bff3fb4bf83c12b1ee87234fa29f4869e89038c4d8a8ffa6a4494c25c93813f0f0197d03b4d2629ea32f64e09d63c834f9d982a21b8900437f2945155dcd3a210a28b7248600afcd69090a6ecc223cd929a4267390fbee3541df859491bb0cabae1e0da84d98d22805ec5cf5442648f73455019cb141ce79925d31963d4634290b96dd343975b9044585a643da05c8f300965386e8c7920900d64cba2635651a0e567c89ccbc01a6a1f09e1a9a027f3cef7d9228c08f46ff346489c21c945daa5ac07dd3ebed9c804fb2749f13150ae010f57bc4384f7987d8d517f03053b7b496bc93688399fece43498e9db825c73ed9b91255ce797c4c4449deeb6b019b734e5a7190837baedfe7614039b5f302befaafd85f252847538fcbce97ee166c679c791dec0a89deb4046f60e988dcb78b7c817ff4d71f8fe88b3edde54aa5d9b41b36e564a06fe074ded9d4fa19eabe0828c0d73cc29f458c4fa75d795d46356d53c53c6f58f1bcf6427b41406bde2ae162aa26dd6d056c4078b2fb5228dd9378f1ea19c08b93a3cc2815341a2cc18aa98bcf8d331a414557f92c448b7e843ce2da22be34817fa3082cf8d815442c4d291a5c93e00d34a5c57d006bae97c41d9a7081693583cf0823babc8051ff314530e17c93f2e97cfbc67133d2eefe3926cddd765aee67ce89e59cbabbce0f96f3ccdd850225467953d36ccfd5f308959fcda61c718cbf0ee485d3cc3b70735314d284f80ab57e2858808105f7673de97512ea0af39876e7f97c39411c6680bcf3881ef8b50767d2a52a3293e462fadcca2ea350bdf4cdb9253a4aec86595d0ca77d160721d5a65d68e7fdc50ba45eb56ff74bfd22251b7d9f5dcc39e7ee13ba5a4885c2f96922f8f4e6861650fb90f90974ec61c1583f67710fff476829ee5a68e543a6b8ffa2f396b216b0ff211357d0570d518d685662cf94480b2f9d9cc7b0ee76134d6b8b86b04a42ead212f16b2c2bd38e4c8d62ffd88c50eada63b2a0fa2209030f698249cf14df22a5a98f99836455fd121a8966efd09812ddae424da6caaecffc3e7aef7044a78df169fc3449f260b288c6bbc0d3345682f6ea25cdb174619cec944e59fcb062556ad48334c15964f63fadbd4293b69e75997738618eb133c5386faf6bcf98bc45db1adca63d63a35bb4a7493cafcd9671d3ae34ec3ad6a6a8f036ff49ef16ed050ee6b5eba987c68165ed570fb03e86bdf0f54db0fd6abd596d36a7b0e762380f2b1b5f76cdbe82a13f2637c563567d14719556ce0b685c2dc2eae49f92e872dd2d7d5db5adfdbd6a15b6e8bf040d4eb3f2a43683cbccb68db1900a9c8976a13c168d90497ee79ffcbf41c36903	2026-06-02 23:39:19.279139	-8104170849814736727	1535
354	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32315f7633	\\x0011811f1692b8c683da41ffffffff789c8d94cb6ed34014863728cdb5a54ddaa216a92648b0400dbe2576c62bb7098d9b260d4e5b0955c29ac6d366a4781cf942097904242458c02b20758f5856ace10dd8b14262c31b3076ed441550c50b5b9efff7ff9d33f29c5bc9f13c58711041e77060983e327ab64f3c9c04eb0eea21e20d46067a39c40e32232501f2b1ddf5a0e7bbe3a456cceac112321320513fc069bad041c4c4e42ca1240f7060a85f8584ef0b607d680f700f23f72a9c1a0dd7b609c5aec634af8f5dc3b2097d26c05a8cb48743dbf17c823dfa31150a57551a71de716e9c06296f34445a71b981e0c0eb331a717d07921e0ae020d7f35dcfb690430d4da6e960b74f20d371a00bc3eac052983532886f9d04ae458e65d98ac08b728565434776e8200bfbd669aa2a0b324899d0439a0f5207d842b937ef362ed5c75e210152af6c82d8715ac969c542cbf66ce77a29cabc56bcbba576d52355577799ed86daaee96ab7516faa7aa82f68c5bc5e7fbac9495295e5454e0cf1caedd30c57e26424288b9aaf2ce53629f1eb9dfab384928f68ffec3cc065dbccce7e47ddfb3b9e9305498ce2d37c49406294fe88a6ffbcf8f5799afebf5e16b75bcc9ed6de09ba398c09a986d937a765b3e549f0031afc1ba8cfa7c1f93d7c8a662f5aaecab258e1a3f0243fd990fb34f943fd239961430a75f71c3a10c33ed3f5cd3e9c3078990d2f41e425598a374614d87225a26428e5cbbd727606ca6a4d679abad66db455a6ad861b340109a220b17c59e6e98de526a00a2fc5edfc78bb71f9fef585370368a5a3abadfd1ad36d68476af3b035fd9172122f57cbb4fc8890e33941944a72dccd370a597ef8e97b00016bd10f6e38e80522742878f4fc99c799f11c48874792e6d5508f096a0e4f44065ac170f0c1c2163ea30ab6e0205d056c891dcf29cbd4bd0b49e0ae84f4155f59bda63e412737a82de8dca0aac39bd4161c5d570b9c4c65a12a725551105005acc703673292a239f707bbf865bc	2026-05-21 14:44:58.286546	507695315660009467	927
383	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32345f7633	\\x001181480d2c88ba84da41ffffffff789c8d94cb6ed34014863728cdb5a54ddaa216a92648b0400dbe2576c62bb7098d9b260d4e5b0955c29ac6d366a4781cf942097904242458c02b20758f5856ace10dd8b14262c31b3076ed441550c50b5b9efff7ff9d33f29c5bc9f13c58711041e77060983e327ab64f3c9c04eb0eea21e20d46067a39c40e32232501f2b1ddf5a0e7bbe3a456cceac112321320513fc069bad041c4c4e42ca1240f7060a85f8584ef0b607d680f700f23f72a9c1a0dd7b609c5aec634af8f5dc3b2097d26c05a8cb48743dbf17c823dfa31150a57551a71de716e9c06296f34445a71b981e0c0eb331a717d07921e0ae020d7f35dcfb690430d4da6e960b74f20d371a00bc3eac052983532886f9d04ae458e65d98ac08b728565434776e8200bfbd669aa2a0b324899d0439a0f5207d842b937ef362ed5c75e210152af6c82d8715ac969c542cbf66ce77a29cabc56bcbba576d52355577799ed86daaee96ab7516faa7aa82f68c5bc5e7fbac9495295e5454e0cf1caedd30c57e26424288b9aaf2ce53629f1eb9dfab384928f68ffec3cc065dbccce7e47ddfb3b9e9305498ce2d37c49406294fe88a6ffbcf8f5799afebf5e16b75bcc9ed6de09ba398c09a986d937a765b3e549f0031afc1ba8cfa7c1f93d7c8a662f5aaecab258e1a3f0243fd990fb34f943fd239961430a75f71c3a10c33ed3f5cd3e9c3078990d2f41e425598a374614d87225a26428e5cbbd727606ca6a4d679abad66db455a6ad861b340109a220b17c59e6e98de526a00a2fc5edfc78bb71f9fef585370368a5a3abadfd1ad36d68476af3b035fd9172122f57cbb4fc8890e33941944a72dccd370a597ef8e97b00016bd10f6e38e80522742878f4fc99c799f11c48874792e6d5508f096a0e4f44065ac170f0c1c2163ea30ab6e0205d056c891dcf29cbd4bd0b49e0ae84f4155f59bda63e412737a82de8dca0aac39bd4161c5d570b9c4c65a12a725551105005acc703673292a239f707bbf865bc	2026-05-24 12:06:00.691021	6394342634204306558	927
400	\\x70726f64756374696f6e3a64617368626f6172645f646174615f323032362d30312d30315f323032362d31322d33315f7634	\\x001181114cd8e40985da41ffffffff789c8d55db6edb461035d242b2643b926dd94951230952184911d4a06559b286404b39ae51a74993d8097ad103b12287d2364baebabb54aae61bda4fec07f4b91fd0599292ad346d023d883b7b38973367861f2fbfb9070d230d137e906a2363549a6fc1160b0c9fe0826d3b87b178c0b466a124e332d473a340166abe0e8d4026135406c3c2b406eb2364c28cfc40a689e10da8091e61712a413d9646aae2b8047569467879dc2a424611179c19d4bc023778f2afe4966033478ea5e001479bee6d9b809fe7a3b94cfc31aa0013c3861855dbedbd7607768a9714c63c8d092b0406947b74fda07dd86a3a7beda359d59aee79a25345b72bcd3da78b1dd8186312f26458945a81c6cc306653991a9d42ed980f4f30e031135bfb47e0ec755a4eb7db69ed1fe221ac8f190fe758777b23431c1db48e0e0fb1051b4576f3fbdcc351b3d53a6a76330f8d1905fe50c9d76644446c64144c2f0d9bb3f2e696ad399f97b6edcbb65e1aeb1985f363e30a998ade8e2a446387dc4d867e1175c2448afc5ae747b815cbc48cc4d45718a44a5956144e30b1d77f4f609dccd48c9c3a09771ed33f402f6bec39065285fe390a6628d636ac78b10c5104950cb5e219361028a1de5328005ed85305aa5ec2623cbb5bcd5c96a0f4f50b82be125495771dd63d331d93649836a824dcbd1a895cd0ddc3ec0ae0091b97dccff357ac679f1155da81552f2b4ebfa9c08a462b947e15ca3c84d58c257aa8d80460c3966b4bd3566a500b14323b0fcc40f535899b12bfbf187d5628c0f7f6fea160a9461a0d8f3a17f2c0eabe5f92f0495eee774485063846f31a312953dd0223730177f2eb9e318a0f526331f3e732aca922885773f7cfee5ec9aae4de3f25a2141f8e8c84ad8520bd242cc1752f187111524dfdb28407ff95fbf314d5741e71d5bde7dd849d9c337f809154e8cf5bf0122a2714bebfc297f847eaf75dfaa35fb4da6c76bbfbed7daac9425fc2a3c56073ef4fd08c644809bee031fe24137c3857e6db36ea699f3ae6fb93a6eff797fa4b127a8b5e09975037e9dd5ec8c68427bfcfa436438517cf1f033c3d3bc99d5243e371056ab62f01b7c1f80a31a70326d0a107c1636e1ce2cb10f837cac0819b9e24626963d1129b256fa1192dde0e6c787e9a0c68db85566a169f134674f92123fd314d30e97e99f1e97ef5d2f572d2fefca320cdbbe5f6bcdbee99e33ef276dd6f1df7b1b70b552a8cea26d1ec2cf4f3047590afa812718cbf8ed585db2dbbf06e5154b382788da42f240b3174e0c6a526fd414aaab0c3f4d9229fcf6688e31c50767769c0df1a385b2e7591d92297b371ab7b8c52f5b399f36a74541889bc2f96d3114b4241bde957fbe560f90249abfbff1f97f4a2149b7e93bf5872cfbd07f46a35334af78799e1d3770b5a42eb7dee67d022c292f57ece92217e406a19eeadd4eac74cf3e0e9e067aa5a42e77d2eaea0af3aa21ed1aec4a16d91917eb6394f61d38b52435f2f5ac23a15a4d235e2d77ad6568e4c4f93e0d4ae5052ed2979d023998ad047da60cab7cd77e8d2f6c7ee41f2aa7f11d662d82bb4ae64146934e4aaee052c18a1ff0aa7746a14a76234ad259071cc7576f2431a810aaccf3ec232e2265afbe2f0a0ddda733ab04ddf281a46bb4695b1c360e7a5511849c4b96917ea85698a4cf16b7f95ff01dd0905e0	2026-05-25 10:37:27.47303	-1225987541988415736	1414
497	\\x70726f64756374696f6e3a64617368626f6172645f646174615f38626337613234615f323032362d30312d30315f323032362d31322d33315f7635	\\x00118170454bef9085da41ffffffff789c8d556d4f1b4710466965c786c4060ca12a4aa25428a9a2a2336083e7a4f60c149534691220ea8b3f9cd67773f6367bb7eeee9ea99bdfd0fec4fe807eee0fe8ecddd9e0346d227fb077f6d967669e79f1c737df3c84869186093f48b591312acd37608d05868f71ceb69ec358dc675ab35092b102f5dc2890859a37a011c8648cca6058986ab03c4426ccd00f649a1882d4048fb03895a01e4b2355715c80ba3443bc3aae152ea3880bce0c6a5e853b3cf957700b70cfbaf373ef9acbc41fa10a30316c8051b5ddde6eefc36a4e369282079ca83661b3b0288c791ad36b2130a0d8a3dbbb9d766b8f5e1d4cb3d674cf139d2aba5ddcd9763ab80f2b234c429e0c8a54abd0981a466c2253a353a81df2c131063c6662b57900cef6feceaed33ce8600b96478c8733a4bbdec8ee3b4eabb9d36eb6700f568ae86688b50c71d0dc6ded365b046991dc8504fe40c94b33242156b2fc265786d5697a33cbda4ccf2bdbfa5559af8cf54cd4d9b1714d5e45afa30a09bb4f74e3815f781d339122bff1e311dc8d65628662e22b0c52a5ac2a0ac798d8ebbfc7b04c662a4f2e9d84fb4fe91ba09b15f60c03a942ff0c0533e46b1d16bd588628824a865af40ceb0b9450ef2a140017f65481aa97b0184f1f5433ca1294bebe20e86b415979b761d9339311b50cd306958407d73d1105dd1d655700cfd8a8e47e9e3fb1cc3e23a9b4034b5e969c7e5381458db6517a5528f310963295e847c506002b365d9b9ab6cd07b54021b3f3c00c542fa9b929f047f3dea789027c6fef8f044b35d2687854b99007b6ef7b25099fe4e97e47526880433497884999f216189973b89f5f778d51bc9f1a8b99fd2ec32d5538f16a6ef3f4c1b5a84aeea313124af1c1d048589b73d24dc212dcf682211721e5d42b4b78fc5fb1bf4c514d661e97dc87de066ce69af97d8ca4427f568257503926f7bd45bec03f52bf6fd1177da2a59d9d4ea7d96e524e16fa0a9ecc3b9bb13f433394210578c163fc49267834ebccb76d54d31e55ccf7c73bbedf5be82d48e8ceb3122ea16ad2db6ec8468427de17529b81c2f3974f019e9f1ee7a454d07854819aad4bc0ad33be48cae9800974e887e031370ee96508fc1b45e0c086274958da58b4c4a6c15b68268bb7092b9e9f267dda76a16d358bcf0523b9fc9051ff314d30e97e99e9e97ef5caf572d1fefca310cdbbeb76bd7beea9e33ef1b6dc6f1df7a9b705554a8cf2a6a6d99cabe731ea205f5125d2187f1da973b75376e1dd4d51cd12a215bee409c9420c1db873d5937e3fa5aeb0c3f4d9bc9e2fa688c31c5076b768c0df1a389b2e5591d9246f66e356f71885ea6733e7d5e8a83012795daca6439684826ad3abf6cac1cd73a45e6dfebf5fea17a5d8e49bfc61c93df31ed3d36a6694ee0f53c3a7ef6e68097befa39f420b0f0b96fd8c2503fc80d032dc5ba1d50f99e6c1f3fecf94b584fdf7515c435f27a21ad1aec4812d91917eb6394f60d58b5243ff5eb484752aa84b6f91be9659db76647a920427768552d79e10831eca54843ed20653be2dbe4397b63e760f12abfe45588b61afd152c928d26888aaee052c18a2ff1a27746a14a76234ad259071cc7576f2431a810a2c4fff8465c44d74eb8bd66e7b6fdbd98775fa8fa261b46b54193b0c765e1a85919a38376d41bd304d90297ee3aff23f5b1205ef	2026-05-27 01:02:09.208805	-3410260119940185397	1423
945	\\x70726f64756374696f6e3a64617368626f6172645f646174615f65613239373236315f323032362d30312d30315f323032362d31322d33315f7636	\\x001181010f6c229288da41ffffffff789c8d566d73db4410ce14c68eed8438899352283413a62f0c3463bbf1db6a06e434644868fa92b403833f68ced2cabe56d299bb938bc96f809fc877f815ec49b21387e232fe60ddee73fbf2ecdede7db87cf1002a5a6816386eacb408512a7e1fb698abf918e764db298c857da614f3040957a19c0a03649ee29b5071453446a9d1cb442bb03e4416e8a1e38a38d23c0f6b01f7315b2d4139145ac86c5980b2d0439433ed56e6d2f779c09946c5cb709347ff0a6e09ee18774eea5d71113923942e469a0dd05f6e600d3653532311709793a112dcce2412431e87b43708d0a5c8fd62bdd37ed49ee6ab48c72315cb44b3d7c0266c8c30f2783498e558990a466c2262ad62583be083437479c882ed5a1baa7bf56aabd3ae3daaefd7c9c0fa88716f06b6b6b71248a3dad8efb45bb5063660230b6e06c9ac34da8d47b55aa7d1222b952901ce408ab77a48346c24f94d32815f7898a43e4d3193161fb69b7b6daaf194d6cbfddb97d5bd1496136e67cbca159625edb673646a3c7032d76316c4c86f849bf07928223d0c268e443796d2f023718c9151ffb506eb24a60aa5240ad87942ff00dda4b667e80ae9396718304d7eb6a16487c2c3c02d24a892ad593f4001e5aec400e0a55915a068472cc4e3dd62623207b9ef5e12f44d4019d9e4cfd69311750d531aa580ddab9ec804e91e272a805336ca595fa65b8c6587114daa0a2b76929cba284049a1e9965e11f2dc83958421fa28980060c3a46b5253a6ff60cd95c8cc91601a8a6fa9bf29f007f3dea78902fc68f48f03162bcc41d9a6d279dc35addfcb09b895a6fb94a8500007a8df224679ca3b405f9fc34eaaee6a2d793fd60633fbcec3aacc9cd865ab76bc7b25aa9cf5e08888927c30d402b6e69c74232f071fd9ee90071ee5d4cb0bf8eabf627f11a39ccc3cae58f7ed5b703be5cce9a32f243ab312bc82c221b9ef95f812ff40fe7e97fee8e7afd4eb9d4ead59a39c0cf4159ccc3b9b593f453d141e05f89287f8b388f0f1ac2bafcba8a63daa98e38ceb8ed35bea2d09e8ce5b255c44d5a4bd5d8f8d084f769f0ba50712cf5f3c0178767c981aa58286a302ac99bab8dc38a34152b295cb02acd247c043aeabc49726f06f1441153eb605114b438be6d83478034d68b13f830ddb89a33e0d3ccfb49ac1a784115d8ec7a8ff982298b0be49f8b4be7d65d929697ffe919166dfb1baf68e755cb54eec7bd60f55eb897d0f8a9418e54d4d737bae9e87a8dc7458e58863fc7524cfad4ede82773745314988af51eb078279e855e1e6654f3afd98bac21ca62fe6f97c3e451ca480bc75970ef8b50367d2a52a3293e47272dcca36a3509de4ccd9655a4af483b42e86d3218bbc806ad32bf6f2eef23952afd616fba57e91924dbe4f37e6ac33fb6bda5a4c84c2fa692af8f4dd0d2d60ff7de6a7d0ccc392b17ec6a201fe8fd012dcb5d0ca074c71f759ff35652da0f53e1357d0570d518d6856e2c094480b27999c47b069fbb1a66b8c86b08a03ead255e2d75856a61d999a44ee9119a1d4b54764410d451c780ed204938e297e9594a63e660e9255f54b60249abd41634af8be424da6cab6cbdc213a6f7042ab4ab6ca8e26493e99de46d95de0681a2b5e6ffd82e65872611cefae9eb068a75ead37a9076982b3d03c07e80e2c76e80aac5ee42d4e9823eccf30d6ebebda53261768bba345da533699d7968db6deec34f7b191614ee2681eb399decfb54e6dbfd9bc020b1685110f1668cf71b440fbccd50bb44fc57881961e26efd29a9b3d0cb94a0ae578349d0ab03e7d24099f6bbfd46aedef355bb04d0f079a92e67e93da4c2933c82a9990aa998aee4139134d90497ee3effc3f33fb6979	2026-06-05 03:49:49.699175	5238773081309235697	1545
663	\\x70726f64756374696f6e3a64617368626f6172645f646174615f35393536333265305f323032362d30312d30315f323032362d31322d33315f7635	\\x001181809b0c4b5487da41ffffffff789c8d555b73db4414ce14c68e9d9be3dccab4944e48a705663256aeced10cc849c89092d2369781c10f9ab574642f5969cdee2aa9e96f809fc81b2ffc009e392bc94e1c0a65fc60edd94fe7f29def1c7d38f9f6292c1a6998f083541b19a3d2fc3e2cb1c0f02b1cb32de730167798d62c9464ac402d370a64a1e633b018c8e40a95c1b0304dc27c0f99303d3f906962781de6048fb03895a0164b2355719c809a343dbc392e1521a3880bce0c6a5e85159efc23b909f8c486f3f3e89acbc4efa30a3031ac8b516573777d1b16725f7d2978c0c9d30a3c2c2c0a639ec6f4b2101850ead1ece69eb3b5e7acef3487456bbae7894e15dd4e6dacef6de22ed4fb98843ce9169556617168e8b3814c8d4e616e9f770f31e031134b4e131aeb4d67b3d1d87576b6711be6fb8c8723acbb9c23b61b4e737b67d7b1887a91e01d88b3e96c3577369b4ddc21c20b12fcae92d7a64754d4b31207378685618523cbd288d11bdbf24d636f8cb58cd6d171f116c18adef64ae4eaaaeb1711af984891dffbeb1c1ec532313d31f01506a9529614855798d8eb3fdec03c99a9393973121e9fd03f402b6beb29065285fe290a6628ce324c79b10c5104950c35e519d61128a1d6522800ceeda902552f61311eaf56339725287d7d4ed04b4115793330ef99419f04c3b4412561f5762472417707d915c00bd62fb99fe5af58cf3e239a7403a6bdac38fdb602531aad4eda5528f310a63386e8a1621380ba2dd796a6adf4602e50c8ec343003d56b923625fe6c3cfab05080efedfd8160a9461a0c8fba16f2c0aabe5d92f0515eee77448506d847738d9894a96e81913983c7f975cb18c53ba9b198d17319665411c49b759de3d55b5995dc67474494e2dd9e91b03416a495842598f5821e1721d5d42e4bf8e2df727f9da21a8c224ebb4f3d9aaf9c33bf839154e88f5a700195430adf9ee213fc03f5eb13faa35f34bdb1b1b7e7ec385493855ec0f3f16023ef2fd0f46448099ef3187f94091e8c5479d7463d6d53c77cff6ac3f7db13ed0909ad71af844ba89bf46e2b647dc293df57529baec2b3d727002f8f0f73a7d4d0b85f8139db9780db607c8a98d30113d8a007c1636e1ac49721f02f944103ee7b9288a57d452b6c98bc8566b4780fa0eef969d2a15d175aa9597c4e18d1e5878cf4c734c1a4fb65c6a7fbd585ebe5a4fdfe5b419af7b1dbf21eb9c70df7b9b7e67edb704fbc35a85261543789e6e1583f0f5107f9862a11c7f8a6afcedcbdb20bef1645352b88cf91f4856421860d58b9d1a4df49491576983e1de7f3d510b19f03caee131af03b0367cba52e325be464366e358f51aa7e3673de2c1d154622ef8be5b4c79250506fdad57639983c43d2aaf3df71492f4ab1c137f98b25f7d4fb9c5ead6646e9fe30343c78b7a0256cbdcffd105a4498b0de4f59d2c5ff915a86bb935a6d9f691ebcecfc44554bd87d9f8b5be8db8ea847b42bb16b5b64a49f6dce2358f0a2d4d0c78b96b04e05a97486f8b59eb59523d3832438b22b94547b441e744fa622f4913698f26df31b7469fb63f72079d53f0b6b31ec12ad2b19451a0db9aa79010b7ae85fe2804e8bc5a9184d6b09641c739d9dfc9046a002f3c36fb08cb889669c0da7b9411f3858a6ef130da35da3cad861b0f3b2581849c4b9690d6a8569804cf17b7f96ff06232e05d4	2026-06-01 09:25:20.216879	-526233773087364838	1419
853	\\x70726f64756374696f6e3a64617368626f6172645f646174615f35316232656237315f323032352d30312d30315f323032352d31322d33315f7636	\\x00118126d398a7e287da41ffffffff789c8d56db6edb461035d256b225db92af495b23095c184d11d42015c99286404b39ae11bb712e768216d503b12247d2262457592e95aafe85f6bbfa2dfd8bce92146519ae53e841dc99c3b99c999de1e78b978f605309c57cc78d23250294115f802de62a3ec639d9760a63418f4511f34422aca6421f99a78f9bae08c728157ab9686d88cc5743c71571a878192a3eef63762a4035104ac8ec48e6841ae2ecb895b9ecf7b9cf99c288afc25d1ede10dc03edce49bd475c84ce08a58ba1620324ed466a67247cee72b2b20c3b994462c0e3805ef47d7429ecfe6aad66b68cc67ea3364d38223d0fa35892b66cee374d6cc2fa08438f878359e253c1884d44aca2182a877c70842e0f98bf65b6c0d837eb46e3a076d06ae201ac8d18f772acb55d6a13c080f52caaebf2cd69aace408a8f6a480ed793642699a05ffabef164ff096c4c13cac5f5dabe49e59c323833b03d2be44c584d68cc8f9b570895f476d219e38193f91e333f467ee7ef4bb81f88500dfd8923d18da5d444481c63a8d5f567b046622a46ca968087cfe91fa09394f11c5d213de71c7da6c8cf3694ed4078e8bb4b09aa6c2bd6f35140b523d10778a34f4b50b24316e0c96e29315980c24f6f08fadea78cec5558b3d564440dc2228552c0ee554f6482744f1315c0191b15acefd257b46587114d9101cb76925c74b904e508756f744b50e41e2c270cd1c3920e00d675ba3ab548b71a545c894c773f5350fa48ad4c813f9af73e4d14e017ad7feab33842ba083695cee3aeeef26e41c09769ba2f888a08e010d547c4b04879fbd85717f03055779492bc172b8dc99f8bb022332776c5324f76af4455b01e1d1351920f864ac0d69c934ee81560d57687dcf728a76e51c0e3ff8afd758c72927b5cb6beb5efc14eca99d3c3be90e8e425780b4b47e4be5be60bfcb32ffedca33ffaf5976bb576db3c3029270d7d0ba7f3ce72eb67a886c2a300dff0007f13213ecdbbf2ba8c6adaa58a39ceb8e638dd85ee8280cebc55c285544d7ab7e3b111e1c9ee2b11a981c48bd7cf015e9e1ca546a9a0c168092aba2e2ed7ce687895edc8653e1af4e0f3802b83f85204fe832230e09e2d88589a4f34b2a6c16b68428bbd03ebb613873d9a6d9e6e358d4f0923ba1c8f51ffb18860c2fa21e1d3faf1ad65a7a47df82b23cdbe6f75ec07d689619dda7bd6cf86f5dcde831225467953d3ecccd5f30823379d4a05e2187f1fc90bab5db4e0e6a6282509f10ab5be2f98879e0177673de9f462ea0a7d99be99e7f3d5147198028ad61e5df06b174ea74b55643ac9c5e4ba556d46a13ac99db32b7494d8f7d3ba684e872cf47caa4db7d42dba8b1748bd6adeee97fa454a367996be58b0ceedc7f46a29110aebd7a9e0eb9b1b5a40fd53e6a7d0ccc382b67ecec201fe8fd012dcb5d0aa872ce2eecbde3bca5a40f35326aea0af1aa21ad1acc4812e91124e32398f61c3eec78a16160de128f6a94b57885f6d39d2edc8a249e81eeb114a5d7b4c16a2a1887dcf419a60d2d1c53748a9eba3e720598d3ef85aa2d87bd4a644bf1fa1225355db65ee109df738a1d36676caae2649be9a6ea36c17388ac68ad75dbba439962c8c93dd9553163eac19b506f5204d7016e8cd4f8b6f235d9946bb557b72808dcba2c5097c8cbd1c6cbdcbf763a63d63f2166d67749bf68c4d6ed19ec6e1bc763d09af6dd60ecc06d673947f9bff78708bf60247f3daaad6d65a66ab9e67ffd255f39894a476bbde6a1b660e7b21c637986ad68ddacc147d98dc148c5ef841c0a3a47e8e47436b11d6a65f4aa2cf557fc56cb4eacdfd4613b6e98b82c6a75e7c52e9f1a527dc6626a432a7a23da866a20932c9effc53fc175fee68d2	2026-06-03 01:54:58.391885	2784965512174684517	1547
528	\\x70726f64756374696f6e3a64617368626f6172645f646174615f65383039666134355f323032362d30312d30315f323032362d31322d33315f7635	\\x0011815dc77a421686da41ffffffff789c8d556d6f1b45108e0ab26b3bad9dc4718b88daaa286a514574761a3b9e93e09c86889496b6492310fe705adfcdd94bf76ecdee5e82e917fe00fc447e00bf82d9bbb3139742913ff876f6b967669e79b98fafbf7d004d230d137e906a2363549adf864d16187e8e4bb6560e63f18869cd4249c60a3472a340166ade82662093735406c3c2d480b5093261267e20d3c4f026d4058fb03895a0114b23d5e5519a09ce8f2bb059b88c222e3833a879156ef1e41fc1adc05debcecfbd6b2e137f8a2ac0c4b03146d5eee39d5e1b3672b2a9143ce0447507b60a8bc298a731bd2d0406147b74f371bbdfee7776badd79d69aee79a25345b7b5ce8ed3c71eac4f310979322e52ad41736e98b2994c8d4ea17ec0c78718f09889cdf63e383bfb7bbdbd6e7fbfdbc63d589b321e2eb06e2b47743afb5d6777b7bd4788f522c005a49541da0e11f476dbbd2e7649f242067face485999018eb598eb34bc3c63cc5856573a1e9a5ad7559da4b63231376716c5e9158d1db51c58a4b74e763bff07ace448afcda6f03b813cbc44cc4cc5718a44a5965149e6362afeb17b046662a512e9f847bcfe81f609015f70403a942ff040533e4ab05352f96218aa092a16a9e612381121a038502e0b53d55a0ea252cc6e3fbd58cb204a5af5f13f48da0acbc9bb0e699d994da8669834ac2fdab9e8882ee9e645700cfd9b4e47e9ebf62997d4652690756bd2c39fdb602358db659865528f310563395e8a1620380759bae4d4ddb06847aa090d9996006aa17d4e014f8c365eff34401beb7f74f044b35d23c7854b99007b6f78725099fe4e97e47526880033417884999f216189953b8975f0f8c517c941a8b593c97e1862a9c7875b77d7cff4a5425f7e11109a5f87862246c2e39192461096e7ac1848b90721a96253cfab7d85fa5a8660b8fabee03ef366ce59af9238ca4427f518233a81c92fb618daff08fd4efdbf447bf68b5d3e9f7dbdd36e564a167f074d9d982fd399a890c29c0d73cc61f65824f169df9ae8d6a3aa48af9fe79c7f7872bc31509836556c225544d7a7710b229e189f7a5d466acf0f4d5338017c787392915349e56a06eeb1270eb8ce6bee6e9800974e841f0981b87f43204fe952270e0b6274958da5ab4c8e6c15b68268bb705eb9e9f2623da78a16d358bcf0523b9fc9051ff314d30e97e99e9e97e75e67ab9687ffe5188e6dd7107de5df7d8719f7adbeeb78efbccdb862a25467953d36c2dd5f3107590afa912698cbf4cd5a9db2fbbf0fea6a86609f13ab5be902cc4d0815b973de98f52ea0a3b4c9f2debf9728e38c80165779b06fc9d81b3e95215994df27a366e0d8f51a87e36735e9d8e0a2391d7c56a3a614928a836c3eab01c5c3f45ead5f67ffba57e518acdbec95f2cb927de237ab59a19a5fbc3dcf0e9fb1b5ac2e30fd1cfa1858715cb7ec29231fe8fd032dc3ba1350e98e6c18bd14f94b584de8728aea0af12518d6857e2d896c8483fdb9c47b0e145a9a12f182d619d0aead21ba4af65d6b61d999e25c1915da1d4b547c4a0273215a18fb4c1946f8befd0a5ad8fdd83c4aa7f16d662d81bb454328a341aa26a78010b26e8bfc1199d9ac5a9184d6b09641c739d9dfc9046a0026bf30fb18cb8896e7cb1b74b5f15a7072dfa46d130da35aa8c1d063b2fcdc2484d9c9bb6a1519866c814bff657f96f418e0612	2026-05-28 14:57:33.919442	-6455888098242456190	1424
499	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3237	\\x001101c75332162086da41ffffffff04085b087b093a0e74696d657374616d706c2b079142166a3a106475726174696f6e5f6d73660c323036362e32393a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b07c820176a3b06660c323732382e30313b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07c820176a3b06660c323039352e36333b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-27 01:02:09.978143	-3451998204444592750	401
481	\\x70726f64756374696f6e3a64617368626f6172645f63616368655f67656e	\\x001104000000000000f0bfffffffff6561323937323631	2026-05-26 11:27:05.298723	4365665205905785338	193
702	\\x70726f64756374696f6e3a64617368626f6172645f646174615f35393536333265305f323032352d30312d30315f323032352d31322d33315f7636	\\x001181722f92dea187da41ffffffff789c8d56db6edb461035d256b2243b92af495b23095c184d11d42065c9b286404b39ae51bb712e768216d503b12287d2262457592e95aafe8202ed47f4f3fa179d2529c9325ca7e003b93367e77a76969f2e5e3e867525140b1c3789950851c67c013698abf808e7649b198c853d16c7cc13a9b0960903649e5eaebb221aa154e84d452b0364811a38ae4822c5cb500db88ff9aa00b5502821f32599136a80b3e546eed2f779c099c298f6dfe3d10dc13dd4ee9ccc7bcc45e40c51ba1829d647d2ae65768622e02e272b15d8ca2512439e84b43108d0a5b0fdbb75d338a8efed9afb938463d2f3284e24692be6ee7e035bb03ac4c8e3517f96f84430646391a83881ea21ef1fa1cb43166c980760ec1e987b86d132f79bd8849521e3de146b6d96db043060358feaba7c7d92aad397e2831a90c3d53499712ef0cbdf9a8ddd3d589b24948b4b7beddd36757352c0d9fecd591f67c25a5ac5e972fd4a3d25ed4e8931ea3bb9eb110b12e4773a7fc08350446a108c1d896e22a5ae83c411465afdf711ac90987a91154bc0a367f406e8a45d3c475748cf39c78029f2b309153b141e066e2945556cc57a010aa875240600aff5aa04653b62219e6c9753930528fcf09aa0ef02cac8be0b2bb61a0f891f2c5628056c5ff5442648f73455019cb161c1fa26dba22d3b8cca141bb064a7c9c59725a8c4a8a9d12d43917bb09456883e4a3a0058d5e9ead462cd34a8ba1299263f5350fe404ca6c01fcf7b9f240af0b3d63f0d5812239d039b3ae7715793bc5b10f07996ee732a450c7088ea036254a4bc03f4d5053ccad41da524ef254a63a6df455896b913bb6a9927db57a22a588f8fa95092f7074ac0c69c934ee415e0aeed0e78e0514edda28027ff15fbab04e578ea71c9fadabe0f5b59cd9c1efa42a2336dc11b281d91fb6e852ff04f3efb73875ef4f84bf57abb6dee9b949386be81d3796753eb67a806c2a3005ff3107f15113e9db2f2ba8c7adaa58e39cea8ee38dd85ee8280cebc55c245d44ddadbf1d890f064f7a588555fe2c5ab67002f4e8e32a3d4d0705882aaee8bcbb5339a1a153b765980067d043ce4caa07a2902ff4e111870df1654581a4f34b126c16b685a167b0b566d27897a34da3c4d358dcf0a46e5723c46fc6331c184f55d5a4febfb37969d15edfd5f79d1ec0756c77e689d18d6a9bd63fd6458cfec1d285362943791666bae9f4718bbd9502a508df1b7a1bcb0da450b6e2645394d885789fa81601e7a06dc9b71d2e925c40a7d98be9aafe7cb09e2300314ad1d3ae0d70e9c4e97bac874928be971abd98c4275d23367576929d10fb2bee89a0e58e405d49b6eb95b74172f90b86adeee97f822251bff986d2c58e7f613da5a4e85c2fa6522f8f266420b687cccfc049a7b58d0d6cf59d4c7ff115a8abb165aed90c5dc7dd17b4b590b687dccc415f45543d4239a95d8d72d52c24927e731acd97ea2e8bea2211c2701b17499eaab2dc79a8e2c1e47eeb11ea1c4da63b2100f4412780ed204938e6ebe414add1f3d07c96afc3ed012c5dea136257c3f4645a66ab6cbdc013aef704cabf57c951f4d927c31b98cf2bbc0513456bceeca25cdb1f4c238d95e3e65d1a3ba516f12076982b3505ffcd37befb26871c21c636f8ab1de5ed79e31798bb633bc4d7bc6c6b7684f93685ebb9adee36db3be6f36b1314505b7f94ffab7682f7038afad696dfdc03c686033c7bc70d53c662d8ba2dd38681be614f65c8c6e30d56a18f59929fa1db929187dcf87218fd3b6391ecdaa455899fc1f099f2b7fd96cb6f65abbad266cd28f044d4d7ddf49a5a7961e6cebb990ba9b8976a0968bc6c824bff34ff15f4102667f	2026-06-02 07:29:18.28793	1371537268586942400	1537
857	\\x70726f64756374696f6e3a64617368626f6172645f646174615f62313034313163395f323032362d30312d30315f323032362d31322d33315f7636	\\x00118190ec453ae587da41ffffffff789c8d56fd6e1b45108f5a64c78e4becd449a15425045529428d6cc776ec3909ce69884868fa91b402e13f4eebbb397bdbbb5bb3bb9762f20cf0223c0c6fc003f014ccde9d9d38b42ef21fbe9df9ed7cfc6676763f5abe7808552d340b1c37565a842815df8475e66a7e8e73b28d14c6c201538a7982842528a7c20099a77819aaae88ce516af43251112a2364811e39ae8823cd73b01a701fb3d5129443a185cc9679280b3d4239d3ae672e7d9f079c69547c15eef0e83fc12dc1e7c69d937a575c44ce18a58b916643f48bcdd64eb305b753636311709793a965b8974924863c0e697710a04bb1fb856e67b7334d58918a472a96a458ae631bd6c618793c1a6629ae40752a18b38988b58a61759f0f0fd0e5210b36ea1da8edd49b9d4e77b7d16c37c94065ccb837035b1beb09a4556b35bb9dbd7a0b5bb0964536836456badd6673b75edfeb9295ea347f6728c55b3d2216d692e42699c02f3e6a377628f169823371b7b5d3a11a4f69bd34b07159dd4b6139e176b6ac5e6159d26ebf40fcb6c8dcf9d0c9fc9fb320467ee3af12dc0f45a447c1c491e8c6521a92249e6364d47fde840a89a94a299302369fd03f402fa9ef29ba427ace29064c93af0d58b143e161e01612d48aadd9204001e59ec400e0a55915a068472cc4a3ad62623207b9ef5e12f44d4059d965a8d87a32a6ce614aa314b075d5139920dde3440570c2c639ebab748bb1ec30a24ad5a06427c9a98b02ac2834fdd22f429e7b504a58a28f820900d64cba2635657a10565d89cc1c0ba6a1f8967a9c027f38ef7d9a28c08f46ff3860b1c21c946d2a9fc75dd3fefd9c804fd3749f12150a601ff55bc4284f7907e8eb33d84cd53dad251fc4da6066df79b825332776c5aa1f6d5d892a673d3c24a2241f8eb480f53927bdc8cbc1c7b63be2814739f5f302be7e5fec2f62949399c792b56ddf857b2967ce007d21d19995e015140ec87d7f852ff19bf2f707f4473fbfd46874bbf5769d7232d057703cef6c66fd04f5487814e04b1ee2cf22c2c7b3cebc2ea39af6a9628e73de709cfe527f49406fde2ae122aa26eded796c4c78b2fb5c283d9478f6e209c0b3a383d42815341c1760d5d4c5e5c6198d80155bb92cc01a7d043ce4ba467c6902ff4611d4e0135b10b134b868964d8337d08416fb3eacd94e1c0d68e879a6d50c3e258ce8723c46fdc714c184f54dc2a7f5ed2bcb4e49fbfb8f8c347bd3ead95f584735ebd8deb67ea8594fec6d285262943735cdbdb97a1ea072d38995238ef1d7b13cb3ba790bdedd14c524219abc253b10cc43af06772e7bd219c4d415e6307d39cfe7f329623f05e4ad0774c0af1d38932e559199249793e356b61985ea2467ceaed052a21fa475319c8e58e405549b7eb19f7797cf907ab5bed82ff58b946cf27dba31679dda8f686b31110aeba7a9e0b37737b480e687cc4fa199872563fd944543fc1fa125b86ba195f799e2eeb3c16bca5ac0de874c5c415f354435a259894353222d9c64721ec26ddb8f35dd643484551c5097de227e8d6565da91a949e41e9a114a5d7b4816d448c481e7204d30e998e2d74869ea63e6205955bf0446a2d91b34a684ef2bd464aa6cbbcc1da1f30627b4aa66abec6892e4eef446caee0247d358f1fa950b9a63c98571b475eb98459b8d5aa34d3d48139c85e649401761b14bf760ed226f71c21ce26086b15e5fd79e30b940db1b2fd29eb0c9bc76d568eb7445632b831cc7d13ca492dcd17bbb8d761b7767a060510cf17081f60cc70bb4cf5cbd40fb549c2fd0d2d3e45d5a73b587215749951c8f4653012ad33792f0b9f64b8f1a9dc64ea30b1bf474a019696e37a9cd8c3263ac9a09a996a9681bca9968824cf21bffe4ff054f76699e	2026-06-03 02:38:53.095125	4768155983378925940	1557
504	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32375f7633	\\x001181abbd3150c885da41ffffffff789c8d94d14ed35018c76fccd8c626c20618d150e7a501dbd3aeedda1b8b5456c6061634315c2c87f5e08ed9dad9732acc5d796162626282266ae20b90f0025e12ef4c7c0baf4c7c084f4b3b440d6c176b76fea7bfdff79daedfa5f4e0b236e32317edc14ed30950b3e5052ec5696dce472de4d24ebf89f67bd8474e9ca4b442b29d50480332485ba59c1d2e2127a5a5cc2d9c650b1bc875b0fb24a5a7b770b8c13c8144bf27b4b99ed7c12d8cc8099c6d6c12cf73997636b1d13626cdaee7b26b4abb9628bd5ecff369e062ca6e6641f1a4ca66c2db9e1864b50cedf790552ad63deaf99ce592c0876e0b856e2ddf0a08f5bac8673535b895f50d632d5a9f8a08fda61b7477c2306bdba66d4651aee7a32e0ebabb6911885ac68114598196d9c25d947ffa7efef8d3cbd79f535ae685e7227e90d5f3ff37eb97add255c3c1b4dd8790ab418277da905218651356699c10e290e880f42bbb79004400162baa3e6905fa541e324fedd53729a5172e70fcd955c8cded87584262f0181063648d210fd6adcec5c8c9aad17858371a5b5583ab27dc1b8017c432cfb30b90950a2f9415910f3fb1282b281509c4aebbcc957bc61d9ebaa6ab087668fb5fd9748dabf998b45dc86df8904027114e0a0c2e8b4052e5a1245351c5e488debe9b3f36eed0e2c5fd5c5f32368d47866dac72f7586bcbb6b159356b869d980ab6f960415058534012a4c495165072740b4cf5fdaaf9788476fe7e1ca76c41151529392cb0282229a6df66f49f47bfbe9cd20b6b78178dce562baa2ac920a91b0cebbec5c81fcd437784ba8b26d9833ec4b0cd6d064e7bf8372d00357acabc2801455592fa25912fcbb1659c59bede2ce746b0cc2edb5ccdb636ab0d836b182be123198a44495478505601fbe285a148064ad2ce8f83f9e30f6f8e6828d2aec56f69d347cf91cb06196533c3d91e1f8c69d9688c58a5fc326a71212e7aadc761371c688136b1849fb0047761275bd1f8457e30a64fb3ddabd00d77cb917a26d067cfa4f7d1ce39691dfae7a446efbcb40efb67d3a2a0b25894cb8a24ca2a92b5b964480ec7683c9b7f03b638954a	2026-05-27 16:50:16.374404	-9172075995407740820	984
742	\\x70726f64756374696f6e3a64617368626f6172645f646174615f39616461373035385f323032362d30312d30315f323032362d31322d33315f7636	\\x001181fa56ec21bb87da41ffffffff789c8d566d6f1a4710b6d20a0c7662b0b193a651eaba8a9caab2050430cc49ede1b856edc679b113b52a1f4ecbdd1c6c72774b77f748a97f43fb13fb03fa2b3a7b7760e3a6a4e203b733cfcecb33b3b3fbe9f2e563a868a159e0b8b1d22244a9f83dd864aee6639c936da53016f69952cc13245c81522a0c90798adf818a2ba2314a8d5e262a4079882cd043c71571a4790ed602ee63b65a825228b490336549e821ca99763373e9fb3ce04ca3e245b8cba37f05b7045f18774eea5d71113923942e469a0dd02f361afb8d066ca4c64622e02e27537978904924863c0e697710a04bb1fb854efb497b9ab022158f542c49b15cc316ac8f30f27834c8522c42652a18b18988b58a61ed900f8ed0e5210b366b6da8eeb76b8d6aab5a6b35b109e511e3de0c6b6da58866b5d9e8b40f6a06b19e057603527b52eb349bed769b82a84cb3770652bcd743e2603d496d9209fce25eabb57f001bd3f432f1f25ea749f59d527ab57debaab257c252c2eb6c59b9c6b0a4dd7ec1704be6c60327f33e66418cfcd6c1063c0c45a487c1c491e8c6521a82248e3132eae8132893982a94b22860fb19fd037493da9ea32ba4e79c63c034f9da82153b141e066e2141add89af5031450ea4a0c005e9b55018a76c4423cd92926267390fbfe3541df0594955d82b2ad2723ea1aa6344a013bd73d9109d23d4d5400676c94b3be4eb718cb0e23aa541556ed24397559801585a6577a45c8730f561396e8a36002807593ae494d99fe833557223347826928bea7fea6c01fcf7b9f260af093d13f0d58ac908e834dc5f3b86b5abf9713f0599aee73a242011ca27e8f18e529ef007d7d01dba9baabb5e4fd581bccec3b0fb765e6c42e5bb5939d6b51e5acc7c74494e483a116b039e7a41b7939b863bb431e7894532f2fe09bff8afd558c7232f3b86aeddaf7e141ca99d3475f487466257803852372df5be14bfc13f9c723faa39fbf5aaf773ab5568d7232d037703aef6c66fd0cf5507814e06b1ee22f22c2a7b3cebc29a39af6a8628e33ae3b4e6fa9b724a03b6f9570115593f6763d36223cd97d29941e48bc78f50ce0c5c9516a940a1a8e0ab066eae272e38c66e08aad5c1660953e021e725d25be34817fa708aa70cf16442c0d2d9a63d3e00d34a1c57e08ebb613477d1a789e6935834f0923ba1c8f51ff314530617d9bf0697df7c6b253d2fefa3323cddeb6baf697d649d53ab577ad1fabd6337b178a9418e54d4df360ae9e47a8dc745ae58863fc6d242fac4ede820f3745314988af51eb078279e855e1ee554f3afd98bac21ca6afe6f97c39451ca680bcf5880ef88d0367d2a52a3293e47272dc4a36a3509de4ccd9655a4af483b42e86d3218bbc806ad32bf6f2eef20552afd616fba57e91924d7e4837e6ac737b8fb61613a1b07e9e0a3eff70430b687cccfc149a795832d6cf5934c0ff115a82bb115ae99029eebee8bfa5ac051c7cccc435f4754354239a95383025d2c24926e7316cd87eace916a321ace280baf436f16b2c2bd38e4c4d22f7d88c50eada63b2a086220e3c07698249c714bf4a4a531f3307c9aafa353012cddea131257c5fa1265325db65ee109d7738a155255b65479324f7a7f7517617389ac68ad72b5fd21c4b2e8c939ddba72cdaae57eb2dea419ae02c34cf01ba058b1dba04ab97798b13e618fb338cf5f6a6f68cc905daee6891f68c4de6b56b465ba3fb199b19e4348e1618388d8345cee3c102ed058e16685fb87a81f6b9182fd0d27be4435a73a787215749791c8f6612bdd9a60f23e173edafee35eaedfd761db6e8cd40c3d15c6b529be164e6572513521153d12e9432d10499e4b7feceff034a5a6633	2026-06-02 14:40:27.695836	1277936611370546453	1537
533	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32385f7633	\\x001181cd9ade061786da41ffffffff789c8d94d14ed35018c76fccd8c626c20618d150e7a501dbd3aeedda1b8b5456c6061634315c2c87f5e08ed9dad9732acc5d796162626282266ae20b90f0025e12ef4c7c0baf4c7c084f4b3b440d6c176b76fea7bfdff79daedfa5f4e0b236e32317edc14ed30950b3e5052ec5696dce472de4d24ebf89f67bd8474e9ca4b442b29d50480332485ba59c1d2e2127a5a5cc2d9c650b1bc875b0fb24a5a7b770b8c13c8144bf27b4b99ed7c12d8cc8099c6d6c12cf73997636b1d13626cdaee7b26b4abb9628bd5ecff369e062ca6e6641f1a4ca66c2db9e1864b50cedf790552ad63deaf99ce592c0876e0b856e2ddf0a08f5bac8673535b895f50d632d5a9f8a08fda61b7477c2306bdba66d4651aee7a32e0ebabb6911885ac68114598196d9c25d947ffa7efef8d3cbd79f535ae685e7227e90d5f3ff37eb97add255c3c1b4dd8790ab418277da905218651356699c10e290e880f42bbb79004400162baa3e6905fa541e324fedd53729a5172e70fcd955c8cded87584262f0181063648d210fd6adcec5c8c9aad17858371a5b5583ab27dc1b8017c432cfb30b90950a2f9415910f3fb1282b281509c4aebbcc957bc61d9ebaa6ab087668fb5fd9748dabf998b45dc86df8904027114e0a0c2e8b4052e5a1245351c5e488debe9b3f36eed0e2c5fd5c5f32368d47866dac72f7586bcbb6b159356b869d980ab6f960415058534012a4c495165072740b4cf5fdaaf9788476fe7e1ca76c41151529392cb0282229a6df66f49f47bfbe9cd20b6b78178dce562baa2ac920a91b0cebbec5c81fcd437784ba8b26d9833ec4b0cd6d064e7bf8372d00357acabc2801455592fa25912fcbb1659c59bede2ce746b0cc2edb5ccdb636ab0d836b182be123198a44495478505601fbe285a148064ad2ce8f83f9e30f6f8e6828d2aec56f69d347cf91cb06196533c3d91e1f8c69d9688c58a5fc326a71212e7aadc761371c688136b1849fb0047761275bd1f8457e30a64fb3ddabd00d77cb917a26d067cfa4f7d1ce39691dfae7a446efbcb40efb67d3a2a0b25894cb8a24ca2a92b5b964480ec7683c9b7f03b638954a	2026-05-28 15:13:39.479046	-1269971856344746695	984
798	\\x70726f64756374696f6e3a64617368626f6172645f646174615f33353037376437345f323032362d30312d30315f323032362d31322d33315f7636	\\x001181f5002034db87da41ffffffff789c8d56fd6e1b45108f5a64c7764aecd44969a94a08aa528412d98eedc473129cd3109190f4236905c27f9cd67773f6b677b766772fc5e419e0457818de8007e02998bd3b3b71282ef21fbe9df9ed7cfc6676763f5abc7c02552d340b1c37565a842815bf0fabccd5fc0267646b298c857da614f304094b504e8501324ff132545d115da0d4e865a2225486c8023d745c11479ae76039e03e66ab052887420b992df350167a8872aa5dcd5cfa3e0f38d3a8f812dce3d1bf825b80cf8c3b27f5aeb8889c114a1723cd06e8179baded660beea6c64622e02e27538bf03093480c791cd2ee20409762f70b9dbd9dbd49c28a543c52b124c5621ddbb032c2c8e3d1204bb104d58960c4c622d62a86e57d3e384097872c58adef416dbb53dbdb6bd477db756c4165c4b837c55a6b29a2556b353b7bbbf5162156b2c0a690b504526fd69b3b8d5a73b74d515427e93b0329dee92191b092e436ce047e61ab8575b83b492f9316b73acded5daaf084d4abfd6b57b5bd12961366a7cbea358e25edf60bc46e8bcc5d0c9cccfd050b62e4b7fe5c8247a188f430183b12dd584a4391c40b8c8cfa8fdb502131d528e551c0fa09fd037493ea9ea12ba4e79c61c034f95a83921d0a0f03b790a04ab666fd000594bb12038057665580a21db1108f368a89c91ce4be7d45d0b701656597a162ebf188fa86298d52c0c6754f6482744f1315c0291be5ac2fd32dc6b2c3882a5583253b494e5d16a0a4d0744baf0879eec152c2127d144c00b062d235a929d381b0ec4a64e650300dc577d4e114f89359ef9344017e30faa7018b15e6a06c53f93cee9ae6efe504dc4fd37d465428807dd4ef10a33ce51da0afcf613d5577b596bc1f6b83997ee7e18ecc9cd815ab7eb4712daa9cf5e49088927c30d40256679c74232f071fdbee90071ee5d4cb0bf8eabf627f19a31c4f3d2e599bf603789872e6f4d117129d69095e43e180dcf74a7c81df96bf3da63ffaf94b8d46a7536fd72927037d0dc7b3cea6d64f510f854701bee221fe24227c3aedcc9b32aa698f2ae638170dc7e92df416047467ad122ea26ad2deaec7468427bb2f84d20389e72f4f009e1f1da446a9a0e1a800cba62e2e37ce6800946ce5b2006bf411f090eb1af1a509fc2b4550834f6c41c4d2d8a2493609de40135aec47b0623b71d4a791e7995633f89430a2cbf118f51f530413d6d7099fd637af2d3b25edafdf33d2ec75ab6b7f6e1dd5ac637bd3fabe669dd89b50a4c4286f6a9a8733f53c40e5a6f32a471ce32f23796e75f216bcbf298a49427c995a3f10cc43af06f7ae7ad2e9c7d415e6307d31cbe78b09623f05e4adc774c06f1c38932e559199241793e356b61985ea2467ceaed052a21fa475319c0e59e405549b5eb1977717cf917ab53edf2ff58b946cfc5dba31679dd95bb4b5980885f5e344f0e9fb1b5a40f343e627d0ccc382b17ec6a201fe8fd012dc8dd0cafb4c71f779ff0d652d60f74326aea1af1ba21ad1acc4812991164e32390fe1aeedc79aee311ac22a0ea84bef10bfc6b232edc8d438720fcd08a5ae3d240b6a28e2c073902698744cf16ba434f5317390acaa9f0323d1ec2d1a53c2f7156a3255b65de60ed1798b635a55b355763449f2607223657781a369ac78bdca25cdb1e4c238dab873cca2f546add1a61ea409ce42f320a07bb0d8a16bb07699b738610eb13fc5586f6e6a4f999ca3ed8ee6694fd97856bb6cb475baa1b195418ee368165249aee8dd9d46bb8d3b5350302f867830477b8ea339dae7ae9ea37d262ee668e961f23eadb9dac390aba44a8e47a3a90095c90b49f85cfb4b5b8dbdc676a3036bf474a019696e37a9cd8c3263ac9a09a996a96813ca99688c4cf25b7fe7ff01c6d06940	2026-06-02 23:47:48.503794	-5485300412992253405	1558
646	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d33305f7633	\\x001181f12d7aabb186da41ffffffff789c8d94cb6ed340148659a0a449e39634492bb5a08eb2416251c6e3cbf8b2c1a8a571d3a4911b2aa12e2c37993696e271f0050879042424ae3b16940d823debbe006fc08e0740bc0163378e5a2155f5c2a339fff1ffcd19cf999b7393056d3920943c7786763f2676cf8f69e4e6b5b580f4088d86639bbc18b901e9cf944a961e464e14879339b35eb29210e9e7b4dc56d72db24087d0be4b4f72fa5cd7cdb3f9d6b9493a5fd0d646fed0edb9243c37678976e8fb9499af64b468e086b6e75336ded05633a43f1af941145337621f33a17abe4a3bf33b2c4d8a5a211a8f8859afecbac70498348c0387f64882d6b85e1c46be4702b3bef8c43f21e1c001adfd545a4a3dc6368dbda344e79a58c6b2acc0542d8d02e2b9b1775cc42244a256e83b113163add0753dc29dbe5b3ffb727aef534e2bbcf4298193a2ce99f56acb8ffce0f20af405b35e6e18edc72da3dd6d18a0950617cdfa1d04794182900d48c62ae4252cc0e449136e1d1779ac8a482f9bb1bec43d60bcd253f035a757a6ac5a8338c368f03facd604cdc00d07d4019dc0099d7e062cf3cc5c1690a8c8334841550465ca78fd76fdccb81f55afc158d9b440d332f71b6d03b48d6dc33276324a4510050c91a420f6827c568c28232c4c41bfdfac9f7d7cf53dba0668b96319adbd4db0df300f8c26db432be3701829aa2440694ae07805aafc86c84f213f19a476f7c7af6b40cadbc0320e4cd0342da39df9df468a240304250c908a05802588c085bf83145e112fb0de7ffbf0f91aac521b6cef758cdd59192a14b184e5cc97435852f80d78b10cfae7af95586babd3336907e419a1ac7723d626fdc3f9495e2ba69dc3fc36490f245b9f1ee279c74b7a38d6161fba274c713d67585435b8012779bdc6b2771c9a64cb297d39d6572ea98fc8d1156acb09ae508dd1556acb195f56abbcc26401f382a2c80a91b5b5ec5e98dd1cd3ebe81f80664e4a	2026-05-30 11:12:53.90986	-5436255390467786981	908
785	\\x70726f64756374696f6e3a64617368626f6172645f646174615f66383132626366355f323032362d30312d30315f323032362d31322d33315f7636	\\x0011818cbe8b4dd987da41ffffffff789c8d56fd6e1b45108f5a64c7764aecd4494ba94a08aa528412d94e9cd873129cd3109190f4236905c27f9cd67773f6b67bb7666fcfc5e419e0457818de8007e02998bd3b3b71282ef21fbe9df9ed7cfc6676763f5abc7c02552d35138e1b475a06a8227e1f5699abf90867646b298c053d1645cc93242c4139150a645ec4cb5075653842a5d1cb4445a80c90093d705c19879ae76059701fb3d5029403a9a5ca9679284b3d4035d5ae662e7d9f0bce341a8ff778f8afe016e033e3ce49bd475c86ce10958ba1667df48bbbcdeddd26dc4d8d0da5e02e27538bf03093280c781cd06e21d0a5d8fd42bbb5d39a241c918a8751ac48b158c73d581962e8f1b09fa55882ea4430646319eb2886e503de3f4497074cacd65b50db6ed5db3bf59d46bb894da80c19f7a6586b2d45346bcddd766bbf6e102b596037206460b7556fd44c10d549f64e5fc9777a401cac24a98d33815fd86a621dee4eb2cba4c5adf6eef63e1578c2e9d5feb5abd25e09cb09b1d365f51ac58a76fb0522b749e6467d27733f6222467eebcf257814c8500fc4d851e8c64a1986148e3034ea3f6e4385c454a2944609eba7f40fd0498a7b8eae549e738e8269f2b506253b901e0ab790a04ab6663d8112ca1d8502e0955915a068872cc0e38d62623207b96f5f11f4ada0acec32546c3d1e52dbb048a392b071dd139920ddd3440570c68639ebcb748bb1ec30a22aaac1929d24175d16a014a169966e11f2dc83a58425fa28980060c5a46b528b4c03c2b2ab909933c13414df518353e04f66bd4f1205f8c1e89f0a16479883b24de5f3b86b7abf9b93f0499aee33a222023840fd0e31cc53de027d7d01eba9baa3b5e2bd581bccf43b0f7754e6c4ae58f5e38d6b51e5ac27474494e2fd8196b03ae3a4137a39f8d876075c789453372fe1abff8afd658c6a3cf5b8646dda0fe061ca99d3435f2a74a625780d854372df2df1057e5bfdf698fee8e72f351aed767daf4e3919e86b38997536b57e867a203d0af0150ff02719e2d36967de94514dbb5431c719351ca7bbd05d90d099b54ab890aa497b3b1e1b129eecbe9091ee2bbc78790af0fcf830354a050d860558367571b97146e7bf64472e1358a30fc103ae6bc49726f0af14410deedb9288a5a945836c12bc8126b4d88f60c576e2b04713cf33ad66f029614497e331ea3f16114c5a5f277c5adfbcb6ec94b4bf7ecf48b3d7ad8efdb9755cb34eec4debfb9a756a6f429112a3bca9691eced4f31023371d5739e2187f19aa0bab9db7e0fd4d514c12e2cbd4fa42320fbd1adcbbea49a717535798c3f4c52c9f2f2688831490b71ed301bf71e04cba544566925c4c8e5bd96614aa939c39bb424b85be48eb62381db0d013549b6eb19b77172f907ab53edf2ff58b526cfc5dba31679ddb5bb4b59808a5f5e344f0e9fb1b5ac2ee87cc4fa099870563fd9c857dfc1fa125b81ba1950f58c4dde7bd3794b584fd0f99b886be6e886a44b312fba6445a3ac9e43c82bbb61f6bbac6680847b1a02ebd43fc1acb916947168d43f7c88c50eada23b2100d642c3c07698229c714bf464a531f3307c96af4b33012cddea231257d3f424da6cab6cbdc013a6f714cab6ab6ca8e26491e4c6ea4ec2e70348d15af5bb9a439965c18c71b774e58b8dea835f6a8076982b3c0bc07e81a2cb6e916ac5de62d4e9823ec4d31d69b9bda33a6e6683bc379da33369ed52e1b6d9d2e686c669093389c8554921b7a7fa7b1b7873b5390981743dc9fa3bdc0e11ced7357cfd13e93a3395a7a97bc4f6baef620e0515225c7a3d15480cae481247daefda5ad46abb1dd68c31a3d1d68469adb4d6933a3cc18ab6642aa652ada8472261a2353fcd6dff97f00053c6901	2026-06-02 23:15:22.187822	-7912254328128739308	1551
946	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30362d30355f7633	\\x001181e38592f59188da41ffffffff789c8d94cb6e13311486594048d2a6a10d6da1057514165c0495edb9782eab81b4641a2684108aaa0a456ee236168927cca510f20c8805ac901052791176ac59c30bf01638e94c2052452b8d34639f7ffeefd8c73ee7d3c33973c9a79cbe26dd663ba2cd9617f190a5cc559fb6280fbb83267dd3673e6dc791b45948e44148c22818a69de26c7d3445db2933b5d160e7c4448df236e307292bdd602931de3836198faf9bab7dafcb5a8c06c7e642d80c3c8f0bec72420b3b2c68f63c2edee7cc9504e9f5fb9e1f469c85e26711b87c9c6533f1dbcd0fb366261cf4a9535c2c53d20d3b92c383c827bc45477033d78a82d0eb51df295eb1db2cec0c08912a24607b1d128664ac5918db0d9a3ceaed8d8485fac6937b10eb40d5552c83b166b6efd31e8b7afb69441533d32621752233d3603d9a7bff71eddbc3dfb76fa4cccc5b8f5330cc5a39a778d9f542cf9f4ec79a738af3ae5493b69dad8d6aa96e8f27f322790d028ca00c902c01209e71e0d27e06421d59f34e642de47c8179a77f7999b20aa72066ec1dbb2ab989f95560000c800c9156830089352155890159a829488909af04e1f9e6cd9f7f09276eea0891af3c73edba2dd9523dc1e4b12c03a04184f5d87c56075059978dd89e0bfbb5b9cf17ce625f7e5caddab59a2d3d4dec9790ae4208910a80588d86f1dd640948810a8e195430b2bf3fbc380363b152779e96abb6e43eab37ca3b5265520c0c143526e932c4c95ecda275a4e954f907b5f9ab7feb0ca865bbfea06c0bd4b6203e171f8d72029b774adb0020a40360a0c98a640ce47f30377f2ca44e2f7ba12ad925a72aca22ca6f5727752989ac0d60c8588efd67c40958d7b4185013806bb73e7d3f1db058912a3e0b3a9c48359f04a43d85900dd550708c4863909c5b57f87f3fdcfdf1d7bff088edd3138abee31dd0a043247752f45c056b58d3f4e43e64b10226c7f5e8c3dab7af47773e8f8ccd95f882367d7a48b9e86ca16822eddd99e145333bee2bc26c8b700901a48d6ff40ce98d3a5c64e6efb383126db11ee9660d13ac83e1456b51a837e9de446d2d45d6f254d425fe7fa276ff7f51970ca6a3974651a4199a42d558b315f1694d01ea231134a0a26954355793d63969ae71c7fe03086e9571	2026-06-05 03:49:50.288941	-1424844604141273114	1028
799	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30362d30325f7633	\\x0011817a914507db87da41ffffffff789c8d944b4f135114c75998d2164a2da59080a6936e3424d23befd7866b5ae950666c4ac1101693a1bdd049da993a0fb4f6239098f8880b8d1b7461e2dea5e98e950bf7ee4cfc1cdeb6338586f0482699dc7bcefdffce3de79e7327da9b93161d64a117464b6ff848afdbbee5991169c541756479adae8e5e764c0735024b544a87eeae6778bedb8b2ab9d9ea600b352252a45833a7f04605590dd33a8ac8d19a19c1ebe24864b84e492b1dbb65d64de48ec4b1a3eedab685b14b21cd6b9aaedeb62dfc9f929643a4dde9d88ee75ba6870f63c3c2284a3dd4db9febc5a598d7ed2025972921a3e53509c5727dc7b0ea6800971275dff5ec3672945c7a57d1e01e015558d560ad3434cf0f95babae5b70f063e3986a258335f7954dcdaade5698e0600f0ac9007007f607864b6e3a0b6e9b70f1314cd70e21a4549b186e121c5976235b38d12cfde67fbffd6bffe8c48b157b685402f2e27ae084f9e5372a98d9d6aa158ac102ad4b4e16612c74a330c25902ca000c58cc0f2ddc338c990a228a7145f9e1f62568d934f11391d201654dbb39dcb84b446c002be7b15ee410d8e19c902c5092210699e0ef467789a5ae3b80050c1807b0f3f9edd0cc89489b263ba4dcb202a8ee11a8d09042db222c30788280fa8405fc5fa67c7fbbfcff5d35be621ba2c9fdcb38f90db3408753b144e94798ee738619c199ec1890a844fdf65fb5f4e573fdf1c78aa04b51d9cf75a09126aa87d9f0224cd029c7a92e27811902c3f780617aac08b4c788975cc9a7d4e7c3b675d59e82bb39422b13847538cc08d213151a08580f1fa6db60ff3dec22d184b852a51ae2adb250d121adcc025dfbcf0a4689c7c56c04f8a0564781986a3783a00fd7d93ed7f38f9eedd02b458a942f56981d82e29bbb08c73581d9786a70491a5011b1012a40044728d2103c82f0cc93cf8f1670091968366d21d748c2c3c8f3cdcfa8dfd99deb4141f4e03acb76958048e991b76df8cd11ecc255f4a3e368f0aa86eb68d565c94c01ae84dcb19ecfd041d8cbde5455f5e9ab0aa86738d1576aeb3aa4677d29a1c5849c032880d5c367d6bd225450ad807b715c7215a5a09a7dd781e0643f63f2eef8443	2026-06-02 23:47:49.090127	2002452791985109399	1005
801	\\x70726f64756374696f6e3a64617368626f6172645f646174615f33353037376437345f323032342d30312d30315f323032342d31322d33315f7636	\\x0011811d97a435db87da41ffffffff789c8d566d6f1b45108e4a6527ce9bf35a2801aa4415ad10d1d9f1eb9c80731a22129abe24a940f8c3697d37b6b7ddbb357b7b2e26ff00f19d5fc47fe167307b77b6e328a4c81fec9d79765e9e999df1fdf9ab27b0a9a566c2f5e248cb0055c4e7608b799a0f7146b69dc258d06151c47c99088ba95020f3cd71d393e11095467f225aeb2313baef7a320e355f8155c1bb989de87e20b554d3a3d47d9c1eb73297dd2e179c698cf8123ce0e12dc17d61dcb9a9f788cbd01da0f230d4ac87a4dd48ed0ca4e01e272b2bb0934914063c0ee8a210e851d8dd9552a371d0aceed72be38423d2f3308a1569174bfb950ad6617d80a1cfc3de34f1b160c04632d6510cab87bc77841e0f98d82a35c0da6f5a8d46b954af95b00a6b03c6fd09d6de5e4f1025ab592d55b002eb5974ffa5df1ca7eef6947caffb14c07a92dc682ad818e736916c4d789ccab6a7e59c0a8b099993e3e6355a15dd4e4c0d7b6ee671c8448cfcdedfafe1f34086ba2f46ae422f56cad0a17088a1515f7e036b24a692a49c4978f49cbe015a4931cfd193ca77cf51304d7eb661d109a48fc25b48508b8e661d81128a2d8502e0d29c16a0e0842cc093dd42623207b9ef2f09fa4e5046ce12ac397a34a0366191462561f7ba273241ba67890ae08c0d72f6d3f48ab1ec32a229b260c949928bae16603142d321ed02e4b90f4b0943f463c10400eb265d935a641a0e563d85ccbc01a6a1f09e1a9a027f32eb7d9c28c04f46ff4cb038c21c141daa9acf3dd3ebed9c844fd2745f101511c021eaf788619ef216d8d517f02855b7b456bc136b8399fccec3b2ca9c38cb76e964f75a5439fbc93111a578afaf256ccd3869857e0e561cafcf854f39b5f312befaafd85fc7a846138f4bf697ce36eca49cb91dec4a85eea4046f60e188dcb717f91cffe8af3f1ed3177dba4be572b359aa952827037d03a7b3ce26d6cf50f7a54f015ef2007f91213e9b74e54d19d5b44d1573dd61d975db73ed3909ad59ab840ba99a74b7e5b301e1c9ee2b19e99ec28bd7cf015e9e1ca546a9a0c16001564d5d3c6e9cf145622ef298408b7e081e706d115f9ac0bf5304167cec482296a6140dae71f0069ad0e23c8475c78dc30e4d38dfb49ac1a784115daecfa8ff584430697f9bf0697ff7c67652d2eeff9991e6ecd82de733fbc4b24f9d3dfb47cb7eeeec418112a3bca9697666ea79849197cea61c718cbf0dd485ddccdb707b53149284f82ab5be90cc47df8207d39e743b317585794c7bb37cbe1a230e5340de7e4c0ffcc68333e952159949723e796e458751a86ef2e69c653a2aec8ab42e86d33e0b7d41b56917da796ffe02a9574b77fba57e518a8d7e482fe6ec73e7295d2d244269ff3c167c7a7b434ba87cc8fc189a799833d6cf59d8c3ff115a82bb115af19045dc7bd9794b594ba87fc8c435f4754354239a95d83325d2d24d26e7316c38dd58d3daa2211cc582ba7499f8359623d38e2c1a85deb119a1d4b5c76421eacb58f82ed20453ae29be454a531f3307c96af4ab3012cddea13125bbdd0835992a3a1ef3fae8bec3119d36b353f63449f270bc88b25de06a1a2b7e7bed8ae658b2304e76974f59f8a86c952bd48334c15960f63fadbd4293b69e7595b739618eb133c1d86f6f6acf98ba43db1adca53d63a33bb4a77138ab4d9771b354ae95aa5899a0c45dfee3de1dda0b1ccc6a37120fb58665d50f1a58cd602f3d7d1bac7e506d1e349b13d80b39bc0d7650afd51ae5f20446ff4d6e0bc96cfb20e051523cd7a789350f6be33f4bb2cb7577f9eb72eda0bedfacc236fd9da0d969b69ed2667699f1b69909a9c6a9680f8a9968844cf17bffe4ff05caef699c	2026-06-02 23:47:54.575253	3805284940665391652	1536
807	\\x70726f64756374696f6e3a64617368626f6172645f646174615f62343638323032615f323032342d30312d30315f323032342d31322d33315f7636	\\x001181c0000e10de87da41ffffffff789c8d566d6f1b45108e4a65278ed338af8512a04a54d10a119d1dbfce49704e434442d397a415087f38adefc6f6b677b76677cfc5e41f20bef3cbf80ffc0c66efce761ca529f2077b679e9d976766677c77f1f2316c6aa159e07ab1d22244a9f8026c314ff311cec9b653180bbb4c29e68b44584a850132df1c373d118d506af4a7a2b501b2400f5c4fc491e6abb01af01e6627ba1f0a2de4ec28f40067c7adcc65afc703ce342a5e84fb3cba21b8af8c3b37f5aeb888dc214a0f23cdfa48da8dd4ce5004dce3646515763289c490c7215d0c02f428ecdebd8ad5aab6cafb95fa2461457a1ea9589276b9bc5fab6203d68718f93ceacf129f08866c2c62ad62583de4fd23f478c882ad7213acfdd641bdd96836eb35acc1da90717f8ab5b7d71344d96ad5ca55acc27a16dd87f49b93d4ddbe14eff58002584f921bcf041b93dca692ad298f33d9f6ac9c33612921737adcbc42aba4db89a951dfcd3c8e581023bff3cf2bf83214911e046357a2174b69e89038c2c8a82b47b046622a49ca998087cfe81ba09d14f31c3d217df71c03a6c9cf362c3ba1f031f09612d4b2a359374001a5b6c400e0b5392d41c189588827bb85c4640e723fbc26e8bb8032728ab0e6e8f190da84298d52c0ee554f6482744f1315c0191be6ec27e91563d9654493b2a0e824c9a9cb255856683aa453803cf7a19830443f964c00b06ed235a929d370b0ea4964e60d300d85f7d4d014f8e379ef9344017e36faa7018b15e6a0e450d57cee995eefe4047c96a6fb9ca8500087a8df234679ca3bc09ebe8087a9baadb5e4dd581bccf4771e5664e6c459b1cb27bb57a2cad98f8f8928c9fb032d606bce493bf27370cff1063cf029a74e5ec0371f8afd558c723cf558b4bf76b66127e5cced624f4874a72578034b47e4beb3cc17f8277ffff988bee8d32b562aad56b95ea69c0cf40d9cce3b9b5a3f433d103e05f89a87f8ab88f0e9b42bafcba8a61daa98eb8e2aaedb59e82c0868cf5b255c44d5a4bb6d9f0d094f765f0aa5fb122f5e3d03787172941aa58286c325583575f1b871c6978939e5b1002dfa11f0906b8bf8d204fe8322b0e0534710b134a568704d8237d08416e701ac3b6e1c7569c2f9a6d50c3e258ce8727d46fdc714c184fd5dc2a7fdfd1bdb4949bbfb57469ab363b79d2fec13cb3e75f6ec9f2cfb99b307054a8cf2a6a6d999abe7112a2f9d4d39e2187f1fca0bbb95b7e1e6a6282409d1802c3a81603efa16dc9ff5a4db8da92bcc63da9be7f3e504719802f2f6237ae0d71e9c4997aac84c928bc9732b398c42759337e7acd051622f48eb62381db0c80fa8369d4227ef2d5e20f56af976bfd42f52b2f18fe9c59c7dee3ca1ab854428ec5f2682cf6f6e6801d58f999f40330f0bc6fa398bfaf83f424b70d7422b1d32c5bd17ddb794b580c6c74c5c415f354435a259897d53222ddc64721ec386d38b35ad2d1ac22a0ea84b57885f63599976646a1c79c7668452d71e9305351071e0bb48134cbaa6f816294d7dcc1c24abeab7c048347b87c694e8f5146a3255723ce60dd07d87633a6d66a7ec6992e4c1641165bbc0d53456fcceda25cdb164619cecae9cb2e861c5aa54a9076982b3d0ec7f5a7b85166d3deb326f73c21c63778ab1df5ed79e31798bb63dbc4d7bc6c6b7684fe3685e9b2ee356b9522fd7b03a4505b7f98ffbb7682f7038afdd483cd49b96d53868622d83bdf0f44db0c641ad75d06a4d61cfc5e82658add9a81f34aa5318fd37b92924b3edc390aba478ae4f136b11d6267f96448febdecab7e546abba5f3e806dfa3b41b3d36c3da9cdec32e36d3313528d53d11e9432d11899e477fecdff07c4976999	2026-06-03 00:36:36.228032	6461410475735311307	1536
510	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3238	\\x0011015418dfcc6e86da41ffffffff04085b0e7b093a0e74696d657374616d706c2b077bff176a3a106475726174696f6e5f6d73660c313737302e38373a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b070103186a3b06660c323231382e38343b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b072008186a3b06660c313039342e36333b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b079d08186a3b06660c313734392e38353b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07e30b186a3b06660c313538312e37383b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07f30b186a3b066609392e32323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b073c39186a3b06660c323334332e34373b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07df57186a3b06660c323231312e35383b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07a35b186a3b06660c313833302e39323b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-28 08:40:27.091336	8585746061094854253	722
789	\\x70726f64756374696f6e3a64617368626f6172645f646174615f63333136333136315f323032362d30312d30315f323032362d31322d33315f7636	\\x001181ced9cdb2da87da41ffffffff789c8d56fd4e1b4710474965639b149b1892a6514aa922525520db6063cf49ed99505428e40312b5aaff38adefe6ec4dee6edddd3d529767685fa40fd337e803f4293a7b773698a64ec51f78677e3b1fbf999db98f162f9f40550bcd02c78d9516214ac5efc32a7335bfc019d95a0a63619f29c53c41c21294536180cc53bc0c5557441728357a99a8089521b2400f1d57c491e639580eb88fd96901caa1d04266c73c94851ea29c6a573397becf03ce341a8ff778f4afe016e033e3ce49bd2b2e226784d2c548b301fac5dde6f66e13eea6c64622e02e27538bf03093480c791cd2ed20409762f70b9df64e7b92b022158f542c49b158c716ac8c30f27834c8522c41752218b1b188b58a61799f0f0ed0e5210b56eb6da86db75b7bf5d64ebbd3c42654468c7b53acb596229ab5e66ea7bd573788952cb01b90face5ea3d56ab44c10d549f6ce408a777a481cac24a98d33815fd86a621dee4eb2cba4c5adceeef61e1578c2e9d5fdb5abd25e09cb09b1d363f51ac5926efb0522b749e62e064ee6fe820531f25b7f2ec1a350447a188c1d896e2ca56148e2054646fdc76da890984a94d22860fd84fe037493e29ea12ba4e79c61c034f95a83921d0a0f03b790a04ab666fd000594bb12038057e65480a21db1108f368a89c91ce4be7d45d0b701656597a162ebf188da86298d52c0c6754f6482744f1315c0291be5ac2fd32bc6b2c3882a5583253b494e5d16a0a4d0344baf0879eec152c212fd28980060c5a46b5253a60161d995c8cc9b601a8aefa8c129f027b3de278902fc60f44f03162bcc41d9a6f279dc35bddfcb09f8244df71951a100f651bf438cf2947780be3e87f554ddd55af27eac0d66fa3b0f7764e6c4ae58f5a38d6b51e5ac27874494e483a116b03ae3a41b7939f8d876873cf028a75e5ec057ff15fbcb18e578ea71c9dab41fc0c39433a78fbe90e84c4bf01a0a07e4be57e20bfcb6fced31fda33f7fa9d1e874eaad3ae564a0afe178d6d9d4fa29eaa1f028c0573cc49f44844fa79d79534635ed51c51ce7a2e138bd85de8280eeac55c245544dbadbf5d888f064f785507a20f1fce509c0f3a383d42815341c1560d9d4c5e5c619bdff92ad5c16608d7e043ce4ba467c6902ff4a11d4e0be2d88589a5a34c826c11b68428bfd08566c278efa34f13cd36a069f124674391ea3fe638a60c2fa3ae1d3fae6b565a7a4fdf57b469abd6e75edcfada39a756c6f5adfd7ac137b138a9418e54d4df370a69e07a8dc745ce58863fc6524cfad4ede82f737453149882f53eb078279e8d5e0de554f3afd98bac23ca62f66f97c3141eca780bcf5981ef88d0767d2a52a3293e462f2dcca36a3509de4cdd9153a4af483b42e86d3218bbc806ad32bf6f2eee23952afd6e7fba57e91928dbf4b2fe6ac337b8bae1613a1b07e9c083e7d7f430bd8fd90f90934f3b060ac9fb16880ff23b4047723b4f23e53dc7dde7f43590bd8fb90896be8eb86a846342b71604aa485934cce43b86bfbb1a635464358c50175e91de2d75856a61d991a47eea119a1d4b58764410d451c780ed204938e297e8d94a63e660e9255f57360249abd45634af8be424da6cab6cbdc213a6f714ca76a76ca9e26491e4c3652b60b1c4d63c5eb552e698e250be368e3ce318bd61bb5468b7a9026380bcdf700adc16287b660ed326f71c21c627f8ab1dedcd49e323947db1dcdd39eb2f1ac76d968ebb4a0b199418ee36816524936f4de0e2d68dc9982827931c48339da731ccdd13e77f51ced337131474bdf25efd39ad51e865c2555723c1a4d05a84c3e9084cfb5bfb4d56837b61b1d58a34f079a9166bb496d66941963d54c48b54c459b50ce44636492dffa3bff0fda066919	2026-06-02 23:39:11.220813	3763713479528250734	1551
428	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3236	\\x0011816e17b25bc385da41ffffffff789c8d94bb4a034114864524173704c10bd806ac84c3ce7d27db79030b11248d58ac6b2e642531926c1a632368e10388be41aab43e8e9d0a4a1aedc54966528aa75b98fde63fe7e7db5dc89d9406f972314ddaf55e1ab72f5b9bd9c3d795f3f252addf8dd3a47311b57b8d02a5428256e56235ae36eb5133492be68d388da35ea7dfadd6f74bebd3935ad4485a69bd6b1e26a7997266b732c88773e6d6c4dc1a661a1e1502840cb39530f71715e66750f46621c924088a84b2ef53a840b866c005927ab494273405ce90d0d3878b925401c36ef5f369291a5033a0465274ecb288e4a00224b565a9bc06895dead8210234b6f2efb12b4f6af0b135ac7db91ab84f406129b5b16a29664422d81a024b7981af406395882c34e98e23913d329b4e690814927a1096629231a05821aeb75d16315968cfaf4e5d160d185ed99d33db9f714f0376adbbae1b5019cf0996bab794a7b4c4bb7474b3ea3e44f3cd0bace9f3b78ea281028595fd6038a3cc4f91630d7cb6d422315b61939647b3ad7c1f7c6cd270e45cd71c18568b97911b8f03f977bc5fe975bfa6	2026-05-26 00:11:59.67831	-2192069948009749153	601
511	\\x70726f64756374696f6e3a64617368626f6172645f646174615f38636464306331615f323032362d30312d30315f323032362d31322d33315f7635	\\x00118124101a0b0186da41ffffffff789c8d556d6f1b45108e0ab26b3b899dd4718388daaa286a514574ce8b5dcf49704e42444a4bdba415087f38adefe6eca57bb766772fc1f40b7f007e223f805fc1ecddd9894ba1c81f7c3bfbdcbc3cf3ccdcc737df3e80a69186093f48b591312acd37618305865fe082ad95c3583c645ab35092b1028ddc2890859ab7a019c8e40295c1b03035606d8c4c98b11fc83431bc0975c1232c4e2568c4d248757594668cb3e3126c1421a3880bce0c6a5e85db3cf947724b70d786f3f3e89acbc49fa00a30316c8451b5b3bfd36dc3addcd9440a1e70727507b60a8bc298a731bd2d0406947bb4badfeeb57bbb3b9dceac6a4df73cd1a9a2dbdaee8ed3c32eac4f300979322a4aad41736698b0a94c8d4ea17ec847c718f098898df66370767abd83bdbdee41a78d07b036613c9c63dd563347388ff7e8fe00f761bdc86f8e686588b6f3b8d3eeeeb5bb1dec10e3050bfe48c94b33262ed6b312a757865bb30ae7968d39a557b6d65567af8c8d8cd7f9b1798d61456f4715cb2db9bb18f945d40b2652e4377eebc39d5826662ca6bec22055ca12a3f002137b5dbf843532538772f624dc7b4aff00fdacb767184815fa672898a1582da879b10c5104950c55f30c1b0a94d0e82b1400afeca902552f61319edeaf662e4b50fafa1541df08aaca5b8535cf4c27a41aa60d2a09f7af4722177477945d013c639392fb79fe8af5ec33a24a3bb0ec65c5e9b715a869b45a1954a1cc4358ce58a2878a4d00d66db9b6346df507f54021b323c10c542f49df94f8c3c5e8b34201beb7f74782a51a691c3cea5cc8032bfd4149c22779b9df11151ae010cd256252a6ba0546e61ceee5d77d63141fa6c662e6cf6558514510afeeb64fef5fcbaae43e3c21a2141f8d8d848d8520fd242cc1aa178cb908a9a64159c2a37fcbfd658a6a3a8fb8ec3ef036612be7cc1f622415faf316bc86ca31851fd4f812ff48fdbe4d7ff48b9677777bbd76a74d3559e86b78b2186ceefd199ab10c29c1573cc61f6582477365be6ba39e0ea863be7fb1ebfb83a5c19284fea257c225d44d7ab71fb209e1c9ef0ba9cd48e1f9cba700cf4f8f73a7d4d0785281baed4bc06d301afb9aa70326d0a107c1636e1ce2cb10f857cac0814d4f12b1b4b4688fcd92b7d08c166f0bd63d3f4d86b4f0422b358bcf0923bafc9091fe98269874bfccf874bf7aed7a39697ffe5190e6dd71fbde5df7d4719f78dbeeb78efbd4db862a1546759368b616fa798c3ac8b7548938c65f26eadced955d78bf28aa5941bc4ed2179285183a70fb4a93fe302555d861fa6c91cf1733c4610e28bbdb34e0ef0c9c2d97bac86c9137b3716b788c52f5b399f3ea74541889bc2f96d3314b4241bd195407e5e0e6399256dbff1d97f4a2149b7e93bf5872cfbc47f46a35334af78799e1d3f70b5ac2fe87dccfa0458425ebfd8c2523fc1fa965b877526b1c32cd83e7c39fa86a09dd0fb9b886beee887a44bb1247b64546fad9e63c815b5e941afa80d112d6a92095ae10bfd6b3b672647a9a04277685926a4fc8831ecb54843ed20653be6dbe4397b63f760f9257fdb3b016c3dea07525a348a321570d2f60c118fd3738a553b33815a3692d818c63aeb3931fd20854606df61d961137d1ca17077bf45571bad0a26f140da35da3cad861b0f3d22c8c24e2dcb40d8dc23445a6f88dbfca7f0347db05e0	2026-05-28 08:55:28.476608	2262779037054788273	1424
620	\\x70726f64756374696f6e3a64617368626f6172645f646174615f35393536333265305f323032352d30312d30315f323032352d31322d33315f7635	\\x0011812bcb73a6ab86da41ffffffff789c8d556d6f1b45108e0ad8b193344ee23805025489aab642aaecb44de33909ce49884849699b1781f087d5fa6ece5eb277ebeeee3998fe05f8a1fc013e337be79738145af9833db3b333f33cf3ecf8e3f9b7f7a16a95e59205a9b12a466dc41d58e78115039cf1d5f2301e77b8313c54e49c834aee94c843675603950c505b0c27ae951e72697b2c506962c95e9622c289558995557a6a2adbc3a9b93e2a1945420a6ed188326c88e45fcdcdc157ae1ccbab1ba112d6471d60627917e9742dcfd357520482b26cc0e6c8a33116694c17a5c480da8e6e3f6e369e341b8f76f7c6800d9d8bc4a49a4e0b7558ed63128aa43bc53c76f4f950a5d6a4b0bc2fba87188898cbf5c61ed41fed351ed7ebcf1abb4ff129acf4b90827b15eaddca4004a3b6ae8a6bf3a46c9ba5a5dd91e155ccd700ca78eb5318c89677d42d9d4579b4e6eeaac64bc4dccea350635ddce520dba6c5471c0658ae2d6dfe7f065ac12db9343a63148b576f0350e3049dd95157212f739430aee9ed037402b9bda29064a87ec1425b754a5060b7eac429441298b5af02def48545069699400e7ce2a41d94f788cc75be52c65010adf9d53e8a5243cfe22acf876d8273d7063512bd8ba5e8952d0d9417604f082f70bdec3fc8acbcc389164eab0e867d0ccdb122c1874526897a1284258ccf8a11f25d700ac3ab00e9a71ca82e540237762e716ca57a45c6afcc16cf53150809fdcf981e4a9c102547c9a59280227ea7641c1a739dc1f890a03b08ff60a3129126e89913d83bbf971cb5a2d3aa9753193df4558d2a322fe92d738debad655c17b70444469d1ed5905eb33455a495880db7ed01332244ceda282afffabf7d729eae1a4e2a277dfafc166ce19eb60a434b2c9082ea07448e5db0b624e7cf4c91ff7e88b3ed1e2ce4eb3d9d86d1026177a01cf678b4db2bf40db532135782e62fc45257830d1e44d1fcdb44d13636cb0c3587bae3da7a0359b95e2129a26dd6d85bc4ff194f79532b6abf1ecf509c0cbe3c33c290d34ee9760d9cd2510ae985820e64cc025d6e98714b1b075e2cb52f0efd4411deef88a88a575441b6adcbc0bcd68f13f83559fa549875659e8a4e6e273c2882e1672d21f3714a6bc6f323ebd6f2f3c3f27edcd9f23d2fc4dafe57fe11dd7bde7feb6f743dd3bf1b7a14cc00837896673669e8768827c13158863fcadafcfbc66d183778ba29c0112cb247da97888611d36a69a649d9454e11ed3f62c9fafc611fb7940d1bb470ffcc6837370698adc819ccf9e5bc5e7d42acbde9cbf44a6c648e673719cf678124a9a4dbbdc2e06f367485a6dfc7f5dd28bd67cf87d7eb1e09dfa0fe96a39732aefe7b1e3f3770b5ac193f7a51f878e2accb9eca73ce9e207b496c5dd68adb2cf8d085e767e25d40a9ebd2fc5b5e8eb896846b42bb1eb466415cb36e711acf9516ae9ff8956b04925a97489f875998d932337c32438722b94547b44194c4fa53264481b4c3337fc3a1dbaf9b83d4859cd1be93c965fa24ba5a2c8a0a554153fe0410fd9250ec9aa8eacd1d3749e40c5b13099c5427a02f3b032fe9b5591b07e116af4af448fd0ad4f6ddd2370efa43a72927873d7365446ae21722d6efd55fc073cb9fa90	2026-05-30 09:27:09.890228	3031756340493076348	1371
345	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32305f7633	\\x001181ca88b3197083da41ffffffff789c8d94cb6ed34014863728cdb5a54ddaa216a92648b0400dbe2576c62bb7098d9b260d4e5b0955c29ac6d366a4781cf942097904242458c02b20758f5856ace10dd8b14262c31b3076ed441550c50b5b9efff7ff9d33f29c5bc9f13c58711041e77060983e327ab64f3c9c04eb0eea21e20d46067a39c40e32232501f2b1ddf5a0e7bbe3a456cceac112321320513fc069bad041c4c4e42ca1240f7060a85f8584ef0b607d680f700f23f72a9c1a0dd7b609c5aec634af8f5dc3b2097d26c05a8cb48743dbf17c823dfa31150a57551a71de716e9c06296f34445a71b981e0c0eb331a717d07921e0ae020d7f35dcfb690430d4da6e960b74f20d371a00bc3eac052983532886f9d04ae458e65d98ac08b728565434776e8200bfbd669aa2a0b324899d0439a0f5207d842b937ef362ed5c75e210152af6c82d8715ac969c542cbf66ce77a29cabc56bcbba576d52355577799ed86daaee96ab7516faa7aa82f68c5bc5e7fbac9495295e5454e0cf1caedd30c57e26424288b9aaf2ce53629f1eb9dfab384928f68ffec3cc065dbccce7e47ddfb3b9e9305498ce2d37c49406294fe88a6ffbcf8f5799afebf5e16b75bcc9ed6de09ba398c09a986d937a765b3e549f0031afc1ba8cfa7c1f93d7c8a662f5aaecab258e1a3f0243fd990fb34f943fd239961430a75f71c3a10c33ed3f5cd3e9c3078990d2f41e425598a374614d87225a26428e5cbbd727606ca6a4d679abad66db455a6ad861b340109a220b17c59e6e98de526a00a2fc5edfc78bb71f9fef585370368a5a3abadfd1ad36d68476af3b035fd9172122f57cbb4fc8890e33941944a72dccd370a597ef8e97b00016bd10f6e38e80522742878f4fc99c799f11c48874792e6d5508f096a0e4f44065ac170f0c1c2163ea30ab6e0205d056c891dcf29cbd4bd0b49e0ae84f4155f59bda63e412737a82de8dca0aac39bd4161c5d570b9c4c65a12a725551105005acc703673292a239f707bbf865bc	2026-05-20 14:06:38.804434	1918383142847409599	927
424	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32355f7633	\\x0011813189e5463885da41ffffffff789c8d94cd6ed340148537284dd2a4a54ddaa216a92648b0402dfe8bed8c576e131a374d1a9cb612aa84358da7cd48f138f20f25e41190906001af80d43d6259b1863760c70a890d6fc0d8b5135540152f6c79cef1f9ee5c79eeadf4680e2cbb88a073d837ad00995d27203e4e8335177511f1fb4313bd1c601759b1920285c4eef9d00fbc515a2fe58c7009592990aa1de02c5d68236261729652d3073834d4ae42a2f779b03670fab88b9177154e8da6e738846257129adfc39e693b843e536035413a8381e3fa01c13efd980ac5ab2acd24ef383fca828c3f1c20bdb45447b0eff7189d78810b4917857090ef069eefd8c8a58606d370b1d7239069bbd08351756031ca1a9a24b04f42d702c7b2ac24f0a222b16ce4c80d5c64e3c03ecd54144101190bfa480f40e600db28ffe6ddfaa5f6d82fa640e69543103bcaaa79bd546c3abee35e2f459dd34b77b7b48e76a419da2eb35dd75a5543ebd46b0dcd88f479bd54306a4f373859aeb0bcc889115ebd7d9ae690a02ee881ba98dfa0b8af776acf526a2146fd73db212bd76276f6dbdadedfd99c22c8629c9de5370524c6e98f68facf8b5f9f27e9ffdbc8c27693d9d35b3be1560e1342a66ef5ac49cd49ea039afa1b68cf27a9853d7c8aa6af58a9288a28f149323feec67d9afca1f6914cd18d62cd3b872ec4b0c77402ab07c70c5e61a34b1079599193ae88025b9662ca2ca57cb957ce4d4159a91a4cc3d03bf596c6b4b4a83b6390200a32cb97159ede586e0c927839d9ce8fb7eb97ef5f5ff8538096db86d6dcaf329dba7ea4350e9b935f282ff34aa54ccb8f09794e612bdca6c8c5906f14b2f4f0d3f7100256e35fdb74d10b44e838f0e9c9b38e674733201b1d469a57455d26ac393a0bb3d00ec74200e6b7f01955b00dfbd90a6037d9d18cba44ddbb90846e29a22f07eaca35f5093ab9416d42f706551bdca436e1f0ba5ae4142a0b5259e459494112584b46cd7818c513ee0f535b6483	2026-05-25 23:52:03.589815	-5112128871628215544	923
340	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3230	\\x0011015c5cd0f3c783da41ffffffff04085b097b093a0e74696d657374616d706c2b07f3500d6a3a106475726174696f6e5f6d73660b313739312e393a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b078e690d6a3b066609313931313b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07eebf0d6a3b06660c313536382e30323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b073fc00d6a3b066609362e39373b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-20 06:13:07.289466	-7595484867282993172	448
387	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3235	\\x0011019815e60c9085da41ffffffff04085b147b093a0e74696d657374616d706c2b07eb9e136a3a106475726174696f6e5f6d73660b313532382e363a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b0746e5136a3b06660c323034302e38313b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07edfa136a3b06660c333330312e38323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b075aff136a3b06660c313639342e30323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b075d1e146a3b06660c323034312e32333b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b076926146a3b06660c333738332e37333b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07ea26146a3b06660b3933322e32363b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07602a146a3b06660c313936312e39313b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b072035146a3b06660c323232322e37333b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07013f146a3b06660c323032392e39383b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b070c3f146a3b066608362e323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b078c41146a3b06660c323730392e36313b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07fc69146a3b06660c323430342e31343b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b074b6a146a3b06660b3232362e38343b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07a3e0146a3b06660b323134392e343b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-25 00:59:23.786665	-2485433758477823667	1041
351	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3231	\\x00110184b1927e1e84da41ffffffff04085b077b093a0e74696d657374616d706c2b0796fe0e6a3a106475726174696f6e5f6d73660c313831332e34313a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b076a1a0f6a3b06660c323230382e32363b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-21 12:46:14.373954	2444336715856916634	347
594	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32395f7633	\\x0011819d1339f86d86da41ffffffff789c8d944f4fd3601cc72f666c6363c2c69f80863a6f1ab07ddab55d77b14895320658a609e1b03cac0fec315b3bfb3c15e64e1e4c3c99a8074d8c17bc90f8063c126f26be11135f844f4b3b021a462fcdd3efd3cfe7f73cedf3bb96ec8f69531e72d0016c376c1f359aaeef509cd4e63cd4440e6df71ae8b08b3d640f927c3c9d50487dd24f9ac58c153c4276424b18759c660f36916363673f5149d67130c1388584e39c36d775dbb889113985b3890de2ba0e834fc736dac2a4d1711d764f68b3b1d2ed765d8ffa0ea6ec6516144eab6cc4bc9d5c3fada568af8bcc627e0def21ce7488ef41a78902b5966dfa84ba1de499c5dcb6bb8f480b72b5ad309a0819bd86e37776833c5b55644596553e4c335d0f75b0dfd94b2b120f242d65438a4c5f4bd57107658f3ecc9f7c3dbaf325a1a55eba0ee2fbe94ad62c166a2e75bdf31554c6d866ac738f3636f5b5709c338b69cb322c231c5ddf4b8a40ac8c9b7e6522fb8c513fbd7af33951c90f21cee836a6ad1e845c1512bcdb8294c2983e4a08b1891de1b30088002c96d5c80199a3fafaa734dc71b1eacc61802524028f0ccaae32e4bb0db33d1c39bea2af3fa9e9ebf5159dabc5dc9b8017c412cfb31b9095322f9414910fae48941694b20422d77de6ca3ce78ecf5c932b08b669eb5fd96495ab7a98b41cc86d7a90403b168e0b0c2e8b4052e581245556c5788bdebe9f3fd1efd1c2f0f5dc58d2b7f4a7baa5af720fd8d2962d7d6bc5a8ea566cca5bc6e30541618b029220c5aea480e2ad5b60aa5f33c6f6159673f1739cb1055554a478b3c0a288a4887e97d17f7ffbf3fd8cfe9f2372195b2dabaa2483b86e30a8fb36237f348e9d2bd45d30c801f420862d6ecbb75b83df340fd4f02bf3a204145589eb9744be2447965166f971ab94092cda6c74201b1e7a811cd6b828eb11f6ce687f444b876d839de065d4e4000f4ae1091e859da081f95a6e09efb30477603b5dd6f845be3f529964b357a113cc9643f5945f993e973e44bb97a435e85d92eaddcbd21aec9d4f0b82ca62492c070d4845b2361737c541db8c7af15f45ad91a7	2026-05-29 15:57:28.892642	2585407363702622422	976
374	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3234	\\x001101539e2c4e1285da41ffffffff04085b0a7b093a0e74696d657374616d706c2b07734e126a3a106475726174696f6e5f6d73660c313732352e37373a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b07284f126a3b06660b3537312e35373b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b0753e0126a3b06660c313530322e31353b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07ede8126a3b06660c323031352e31393b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07a8e9126a3b06660a3537392e363b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-24 01:03:47.395132	2877994654342782884	506
464	\\x70726f64756374696f6e3a64617368626f6172645f646174615f323032362d30312d30315f323032362d31322d33315f7635	\\x001181b9e9fb295185da41ffffffff789c8d556d6f1b4510b60ab26b27a91dd7498b1ab55551d4a28ac8719cc49e93e09c86889494b67911087f38adefe6eca57bb76677cfc1f437c04fe407f0991fc0ecddd9894ba1953ff87676ee9999679e99fbf4e6dbc7d030d230e1f989363242a5f95d5863bee1135cb0ad676e2c1a30ad5920c958865a6614c802cdebd0f0653c416530c84db76075844c9891e7cb2436bc0155c143cc4f45a845d248951f0b5093668457c7b53c641872c19941cd2b7087c7ff4aae000f6c382f8baeb98cbd312a1f63c3861856f6ba5bad1db89d818da5e03e27a87bb0915b14463c89e86d21d0a7dcc35b3bddf6fe6e7b6baf33ab5ad33d8f75a2e876a9b5d5ece23ed4c718073c1ee6a596a131338cd954264627503de0c343f479c4c4da76079a5bfbed66b7bbdfdedec55d581d331ecc7d9df57aead1d969777677b10df53cbbf97d86d069b5db9d56374568cc28f0864a5e9a1111514feb9b5e196ecfca9b5bd6e67c5ed9d6afda7a65aca5a4ce8f8d6bf42a7a3b2c5b62096e32f4f2a8132612e437ee1cc1fd48c66624a69e423f51cab2a27082b1bdfe7b02ab64a6f664d449787842ff00bdb4b1a7e84b1578a72898a158ebb0e4463240e19753af25d7b0814009b59e4201706e4f65a8b8318bf0f85125852c42f19b73727d23a82a9754e89ae99824c3b44125e1d1f548044177cfd22b80176c5c74bec85eb1c81e23aa741396ddb438fdb60c4b1aad50fa1528f100965396e8a16c1380ba2dd796a6adf8a0ea2b64761e9881ca25899b127fb2187d5628c00ff6fe996089461a0d973a1770dfeabe5f94f05956eef7448506384073891897a86e81a1398387d975cf18c50789b13ef3e712aca83c885b75b68f1f5dcbaae83c3922a2141f8e8c84b58520bd3828c22dd71f7111504dfd9284a7ff95fbeb04d5741e71d979ecde858d8c336f80a154e8cd5b7001e5430adf5fe205fe89fa7d93fee8172eb75addeef6de36d5645d2fe0f962b039fa0b3423195082e73cc29f648ccfe6ca7cd7463ded53c73c6fd2f2bc7ea15f90d05b4425bf98ba49eff60236267fc27d25b5192a3c7b7d02f0f2f83003a58646e332546d5f7c6e83f125624efb4c60931e048fb869125f869c7fa30c9a70d795442c6d2c5a62b3e4ad6b4a8bbb0175d74be2016dbbc04acdfa6784115d5ec0487f4c939b74be4af974bebe70dc8cb43fffc84973ef3b3df78173dc749ebb9bce774de7c4dd840a15467593683616fa7988dacf56549138c65fc7eacce9961c78bf282a6941bc4ad21792051834e1ce9526bd4142aab0c3f4f9229faf661e079943c9d9a4017f67e06cb9d445668bbc998e5bcd6594aa97ce9c5ba5a3c250647db19c8e581c08ea4dbfd22ff937cf90b4bafdff71492f4ab1e9b7d98b45e7d47d4aaf5652a3747e9c19eebd5fd012da1f829fb9e6110a16fd94c543fc88d452bf7752ab1d30cdfd97839fa96a09fb1f82b8e67d1d887a44bb1287b645467ae9e63c82db6e9818fa7ad112d6892095ae10bf16595b39323d8dfd23bb4249b54784a04732118187b4c194679bdfa44bdb1fbb070955ff22acc5b03768a164186a340455737de68fd07b83533a35f2533e9ad6e2cb28e23a3d79018d401956671f61197213ae7cb9bbb3d7de6aeec33a7da36818ed1a55c60e839d97466e241167a64da8e5a62932c56ffc55fa07382505c2	2026-05-26 06:53:47.936877	-5718463762700479890	1413
535	\\x70726f64756374696f6e3a64617368626f6172645f646174615f62643564343663395f323032362d30312d30315f323032362d31322d33315f7635	\\x00118150368dde3d86da41ffffffff789c8d556d6f1b45108e0ab26b3b899dd4718388daaa286a5145747612a79e93e09c84889496b6492b10fe705adfcdd94bf76ecdee5e82e917fe00fc447e00bf82d9bbb3139742913ff876f6b967669e79b98f6fbe7d004d230d137e906a2363549a6fc2060b0cbfc0055b2b87b178c8b466a12463051ab951200b356f413390c9052a8361616ac0da189930633f9069627813ea8247589c4ad088a591eaea28cd1867c725d8285c4611179c19d4bc0ab779f28fe096e0ae75e7e7de3597893f41156062d808a36a776fe7a00db772b289143ce0447507b60a8bc298a731bd2d0406147bb4bad7eeb57b9d9d6e7796b5a67b9ee854d16dadb3e3f4f000d62798843c1915a9d6a039334cd854a646a7503fe4a3630c78ccc446fb31383b8f77f73b7bddc7dd36eec3da84f1708e755b39a2b3eff43addddf63e21d68b00e7905606693b4470b0db3ee86297242f64f0474a5e9a3189b19ee538bd32dc9aa538b76ccc35bdb2b5ae4a7b656c64c2ce8fcd6b122b7a3baa587189ee62e4175e2f984891dff8ad0f77629998b198fa0a835429ab8cc20b4cec75fd12d6c84c25cae59370ef29fd03f4b3e29e612055e89fa160867cb5a0e6c5324411543254cd336c285042a3af5000bcb2a70a54bd84c5787abf9a5196a0f4f52b82be119495b70a6b9e994ea86d9836a824dcbfee8928e8ee28bb0278c62625f7f3fc15cbec33924a3bb0ec65c9e9b715a869b4cd32a8429987b09ca9440f151b00acdb746d6ada3620d40385ccce043350bda406a7c01f2e7a9f250af0bdbd3f122cd548f3e051e5421ed8de1f94247c92a7fb1d49a1010ed15c222665ca5b6064cee15e7edd3746f1616a2c66fe5c86155538f1ea6efbf4feb5a84aeec313124af1d1d848d85870d24fc212ac7ac1988b90721a94253cfab7d85fa6a8a6738fcbee036f13b672cdfc214652a13f2fc16ba81c93fb418d2ff18fd4efdbf447bf68b9d3e9f5dadd36e564a1afe1c9a2b339fb333463195280af788c3fca048fe69df9ae8d6a3aa08af9fe45c7f7074b832509fd4556c225544d7ab71fb209e189f785d466a4f0fce55380e7a7c7392915349e54a06eeb1270eb8ce6bee6e9800974e841f0981b87f43204fe95227060d393242c6d2d5a64b3e02d3493c5db8275cf4f93216dbcd0b69ac5e782915c7ec8a8ff98269874bfccf474bf7aed7ab9687ffe5188e6dd71fbde5df7d4719f78dbeeb78efbd4db862a25467953d36c2dd4f3187590afa912698cbf4cd4b9db2bbbf0fea6a86609f13ab5be902cc4d081db573de90f53ea0a3b4c9f2deaf9628638cc0165779b06fc9d81b3e95215994df266366e0d8f51a87e36735e9d8e0a2391d7c56a3a664928a83683eaa01cdc3c47ead5f67ffba57e518a4dbfc95f2cb967de237ab59a19a5fbc3ccf0e9fb1b5ac2de87e867d0c2c392653f63c908ff476819ee9dd01a874cf3e0f9f027ca5ac2c18728aea1af13518d6857e2c896c8483fdb9c2770cb8b52435f305ac23a15d4a52ba4af65d6b61d999e26c1895da1d4b527c4a0c73215a18fb4c1946f8befd0a5ad8fdd83c4aa7f16d662d81bb454328a341aa26a78010bc6e8bfc1299d9ac5a9184d6b09641c739d9dfc9046a0026bb30fb18cb88956bed8dfa5af8a73002dfa46d130da35aa8c1d063b2fcdc2484d9c9bb6a15198a6c814bff157f96ffe960609	2026-05-29 02:13:34.20855	1605984047799203678	1424
363	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32325f7633	\\x001181c8e57293f483da41ffffffff789c8d94cb6ed34014863728cdb5a54ddaa216a92648b0400dbe2576c62bb7098d9b260d4e5b0955c29ac6d366a4781cf942097904242458c02b20758f5856ace10dd8b14262c31b3076ed441550c50b5b9efff7ff9d33f29c5bc9f13c58711041e77060983e327ab64f3c9c04eb0eea21e20d46067a39c40e32232501f2b1ddf5a0e7bbe3a456cceac112321320513fc069bad041c4c4e42ca1240f7060a85f8584ef0b607d680f700f23f72a9c1a0dd7b609c5aec634af8f5dc3b2097d26c05a8cb48743dbf17c823dfa31150a57551a71de716e9c06296f34445a71b981e0c0eb331a717d07921e0ae020d7f35dcfb690430d4da6e960b74f20d371a00bc3eac052983532886f9d04ae458e65d98ac08b728565434776e8200bfbd669aa2a0b324899d0439a0f5207d842b937ef362ed5c75e210152af6c82d8715ac969c542cbf66ce77a29cabc56bcbba576d52355577799ed86daaee96ab7516faa7aa82f68c5bc5e7fbac9495295e5454e0cf1caedd30c57e26424288b9aaf2ce53629f1eb9dfab384928f68ffec3cc065dbccce7e47ddfb3b9e9305498ce2d37c49406294fe88a6ffbcf8f5799afebf5e16b75bcc9ed6de09ba398c09a986d937a765b3e549f0031afc1ba8cfa7c1f93d7c8a662f5aaecab258e1a3f0243fd990fb34f943fd239961430a75f71c3a10c33ed3f5cd3e9c3078990d2f41e425598a374614d87225a26428e5cbbd727606ca6a4d679abad66db455a6ad861b340109a220b17c59e6e98de526a00a2fc5edfc78bb71f9fef585370368a5a3abadfd1ad36d68476af3b035fd9172122f57cbb4fc8890e33941944a72dccd370a597ef8e97b00016bd10f6e38e80522742878f4fc99c799f11c48874792e6d5508f096a0e4f44065ac170f0c1c2163ea30ab6e0205d056c891dcf29cbd4bd0b49e0ae84f4155f59bda63e412737a82de8dca0aac39bd4161c5d570b9c4c65a12a725551105005acc703673292a239f707bbf865bc	2026-05-22 03:47:33.798405	-7243172349780379515	927
358	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3232	\\x001101897b73594c84da41ffffffff04085b087b093a0e74696d657374616d706c2b0793c40f6a3a106475726174696f6e5f6d73660c313339322e37323a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b0777ca0f6a3b06660c313933322e37363b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07d5d10f6a3b06660c313530332e32333b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-22 02:50:59.495859	-7360975985040348908	401
369	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30352d32335f7633	\\x0011816049c0ed8e84da41ffffffff789c8d94cb6ed34014863728cdb5a54ddaa216a92648b0400dbe2576c62bb7098d9b260d4e5b0955c29ac6d366a4781cf942097904242458c02b20758f5856ace10dd8b14262c31b3076ed441550c50b5b9efff7ff9d33f29c5bc9f13c58711041e77060983e327ab64f3c9c04eb0eea21e20d46067a39c40e32232501f2b1ddf5a0e7bbe3a456cceac112321320513fc069bad041c4c4e42ca1240f7060a85f8584ef0b607d680f700f23f72a9c1a0dd7b609c5aec634af8f5dc3b2097d26c05a8cb48743dbf17c823dfa31150a57551a71de716e9c06296f34445a71b981e0c0eb331a717d07921e0ae020d7f35dcfb690430d4da6e960b74f20d371a00bc3eac052983532886f9d04ae458e65d98ac08b728565434776e8200bfbd669aa2a0b324899d0439a0f5207d842b937ef362ed5c75e210152af6c82d8715ac969c542cbf66ce77a29cabc56bcbba576d52355577799ed86daaee96ab7516faa7aa82f68c5bc5e7fbac9495295e5454e0cf1caedd30c57e26424288b9aaf2ce53629f1eb9dfab384928f68ffec3cc065dbccce7e47ddfb3b9e9305498ce2d37c49406294fe88a6ffbcf8f5799afebf5e16b75bcc9ed6de09ba398c09a986d937a765b3e549f0031afc1ba8cfa7c1f93d7c8a662f5aaecab258e1a3f0243fd990fb34f943fd239961430a75f71c3a10c33ed3f5cd3e9c3078990d2f41e425598a374614d87225a26428e5cbbd727606ca6a4d679abad66db455a6ad861b340109a220b17c59e6e98de526a00a2fc5edfc78bb71f9fef585370368a5a3abadfd1ad36d68476af3b035fd9172122f57cbb4fc8890e33941944a72dccd370a597ef8e97b00016bd10f6e38e80522742878f4fc99c799f11c48874792e6d5508f096a0e4f44065ac170f0c1c2163ea30ab6e0205d056c891dcf29cbd4bd0b49e0ae84f4155f59bda63e412737a82de8dca0aac39bd4161c5d570b9c4c65a12a725551105005acc703673292a239f707bbf865bc	2026-05-23 23:41:51.006185	-6522873222930103940	927
367	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3233	\\x001101b1d0b1bee684da41ffffffff04085b087b093a0e74696d657374616d706c2b079f36126a3a106475726174696f6e5f6d73660c313632342e32373a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b073f3b126a3b06660c313433392e39333b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b076a3b126a3b066609372e36313b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-23 23:22:07.606379	8381921440239734887	398
650	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30362d3031	\\x001101b2ebeecdb687da41ffffffff04085b107b093a0e74696d657374616d706c2b070f1d1d6a3a106475726174696f6e5f6d73660c313933382e33323a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b072d311d6a3b06660c313637382e31313b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b0732351d6a3b06660b323030322e393b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b070f4b1d6a3b06660c323431322e31383b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07804d1d6a3b066609323136393b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b0701501d6a3b06660b313931392e373b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b072a601d6a3b06660c313739352e35393b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b0734601d6a3b06660c313131372e30373b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b079b7b1d6a3b06660c313532312e31373b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07a17b1d6a3b06660b3638352e36323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07a77b1d6a3b06660c313035362e31343b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-06-01 05:47:59.620174	-5560688083517231777	827
724	\\x70726f64756374696f6e3a64617368626f6172645f646174615f35393536333265305f323032342d30312d30315f323032342d31322d33315f7636	\\x0011811258e695a387da41ffffffff789c8d566d4f1b47104669648331c1e62d6d4ada0814355155746730e039a93d138a0a85bc0051abfac3697d37b637b9bb7577f7485dfe41d5effd8bfd199dbd3bdb1811a7f207dfce3c3b2fcfccceeefdd9eb67b0a28566a1e7274a8b08a5e233b0ca7ccdaf7042b696c158d4664ab140a4c24a260c910566b9e28bf80aa5c66024aaf69085bae7f92289352fc362c83b98af687f24b490e3a5d03d1c2f5773979d0e0f39d3a878091ef2f88ee0be36eebcccbbe222f6fa287d8c35eb226997333b7d11729f939532ace71289114f22da1886e853d89d0776dddaabed6dd56bc38415e979ac1249da797bcb6ee01e2cf5310e78dc1d273e14f4d940245a25b078c0bb87e8f38885abf63e585bfbf6b665edd9bb75ac43b5cf7830c23a6b4b29c2b61a757b077760298fee63fa9561ea5e578a0fba47012ca5c90dc682e5616e23c9ea88c7b16c6d5cceb1b09292395aaedca055d2eed4d455d7cb3d5eb130417eeff1257c158958f7c28127d14fa4347448bcc2d8a8ab3654494c25c93813f0e494fe019a6931cfd11732f0ce31649afcacc1bc1b8900437f2e45cdbb9ab5431450694a0c012ecd6a0e4a6ecc223cde28a5260b50f8f192a0ef43cac82d43d5d5833eb509531aa5808d9b9ec804e95ea42a8033d62f38cfb32dc6b2c788266541d94d9353d77330afd07448ab04451e403965883ee64c00b064d235a929d370b0e84b64e60c300da50fd4d014f8b349efc344017e31fa17214b1416a0e252d502ee9b5e6f15047c91a5fb92a8500007a83f20c645ca3bc48ebe802799baa9b5e4ed441bcce8bb080b3277e22e38f6f1c68da80aceb323224af26e4f0b589d70d28c83023c70fd1e0f03caa95514f0edc7627f93a01c8c3c969d6fdc3558cf38f3dad81112bd5109dec2dc21b96fcdf319fed93f7f3da53ffa75cab55aa361efda949381be8593496723eb67a87b22a0002f7984bf89185f8cbaf2b68c6adaa28a79de55cdf35a33ad1901cd49ab848ba99ab4b719b03ee1c9ee6ba17457e2c59b538057c78799512a68d49f834553179f1b677c9e98533e0bd1a28f90475c5bc49726f09f1481059fbb8288a52945836b18bc81a6b4b88f60c9f592b84d132e30ad66f0196144971730ea3fa608269cef533e9d1fde3a6e46dafdbf73d2dc75a7e93e768e2de7c4dd747eb69c5377134a9418e54d4db33e51cf43547e369b0ac431fed197174ea3e8c0dd4d514a13e28bd4faa1600106163c1cf7a4d74ea82bcc61da9ce4f3f5107190018ace533ae0b70e9c4997aac84c92b3e971abb88c42f5d233e72ed0526227ccea6238edb13808a936ad52abe8cf5e20f5aa3ddd2ff58b946cf053b6b1e09cbbcf696b29150ae7d7a1e0cbbb1b5ac0cea7cc0fa1b9871963fd9cc55dfc1fa1a5b85ba1550e98e2feabf63bca5ac0dea74cdc40df344435a259895d53222dbc74721ec1b2db49345d5b3484551252972e10bfc6b232edc8d420f68fcc08a5ae3d220baa279230f0902698f44cf12d529afa98394856d5efa19168f61e8d29d1e928d464aae2faccefa1f71e07b45ac957f9d124c9a3e14594df059ea6b112b4aad734c7d20be37863e184c54f6a566d877a9026388bccfd4fd75ea941b79e755d7438618eb03dc238ef6e6bcf989ca26df6a769cfd8608af6248927b5d965dcb06bbb761d7746a8709affa43b457b81fd49ed72ea61779fde0bdbfb58cf61af7c7d176c6fbbded86e3446b097e26a8a2f7a92dca535977c147195d6cc0b6850cd4275f846121dae3b0bdfd51abbf5aded1d58a357048d4c73d9496d4696996a2bb9904a9b8936a1928b06c824bff76ff13fae906671	2026-06-02 07:58:34.178153	2072941295349310504	1525
804	\\x70726f64756374696f6e3a64617368626f6172645f646174615f62343638323032615f323032362d30312d30315f323032362d31322d33315f7636	\\x00118109eb170ede87da41ffffffff789c8d56fd6e1b45108f0ab2633b2576eaa450aa1282aa14a144b6633bf69c04e734442434fd485a81f01fa7f5dd9cbdedddadd9dd4b31790678111e8637e001780a66efce4e1c8a8bfc876f677e3b1fbf999ddd0f972f1f41550bcd02c78d9516214ac5efc13a7335bfc039d9460a63e18029c53c41c21294536180cc53bc0c5557441728357a99a8089511b2408f1c57c491e639580db88fd96a09caa1d04266cb3c94851ea19c69d73397becf03ce342abe027779f4afe096e033e3ce49bd2b2e22678cd2c548b321fac5666bb7d9823ba9b1b108b8cbc9d432dccf2412431e87b43b08d0a5d8fd42b7b3d79926ac48c523154b522cd7b10d6b638c3c1e0db3144b509d0ac66c2262ad62583de0c3437479c882f57a076abbddbd7667bfd369b7b0059531e3de0c6b6da48856add5ec76f6eb06b196057603526f361b7bfbfbad0e05519d66ef0ca578ab47c4c15a92da2413f8859d16d6e1ce34bb4c5adce93677f7a9c0534eaff66f5c95f64a584e889d2dabd72896b4db2f10b92d3277317432f7172c8891dffa73051e8422d2a360e2487463290d43122f3032ea3f3e800a89a944298d02369fd03f402f29ee19ba427ace19064c93af0d28d9a1f030700b09aa646b36085040b92731007869560528da110bf178ab9898cc41eedb97047d13505676192ab69e8ca96d98d228056c5df7442648f73851019cb271cefa32dd622c3b8ca8523558b193e4d465014a0a4db3f48b90e71eac242cd147c104006b265d939a320d08abae4466ce04d3507c4b0d4e813f9af73e4d14e007a37f1cb058610eca3695cfe3aee9fd7e4ec02769ba4f890a057080fa2d6294a7bc03f4f5396ca6ea9ed6920f626d30b3ef3cdc969913bb62d58fb7ae4595b31e1d1151920f475ac0fa9c935ee4e5e023db1df1c0a39cfa79015ffd57ec2f62949399c7156bdbbe07f753ce9c01fa42a2332bc12b281c92fb7e892ff10fe46f0fe98f7efe4aa3d1edd6db75cac9405fc1c9bcb399f553d423e151802f79883f89081fcf3af3a68c6adaa78a39ce45c371fa4bfd2501bd79ab848ba89ab4b7e7b131e1c9ee73a1f450e2f98b2700cf8e0f53a354d0705c80555317971b6774fe4bb672598035fa0878c8758df8d204fe9522a8c1c7b62062696ad1209b066fa0092df60358b39d381ad0c4f34cab197c4a18d1e5788cfa8f298209ebeb844feb9b57969d92f6d7ef1969f6a6d5b33fb78e6bd689bd6d7d5fb39ed8db50a4c4286f6a9afb73f53c44e5a6e32a471ce32f63796e75f316bcbb298a49427c955a3f10cc43af0677af7ad219c4d415e6307d31cfe7f329e22005e4ad8774c06f1c38932e559199249793e356b61985ea2467ceaed052a21fa475319c8e58e405549b7eb19f7797cf917ab5bed82ff58b946cf25dba31679dd93bb4b5980885f5e354f0e9bb1b5a40f37de6a7d0ccc392b17ec6a221fe8fd012dc8dd0ca074c71f7d9e035652d60ff7d26aea1af1ba21ad1acc4a12991164e32398fe08eedc79aae311ac22a0ea84b6f13bfc6b232edc8d424728fcc08a5ae3d220b6a24e2c073902698744cf16ba434f5317390acaa9f0323d1ec0d1a53c2f7156a3255b65de68ed07983135a55b355763449726f7a23657781a369ac78fdca25cdb1e4c238deba7dc2a2cd46add1a61ea409ce42f31ea06bb0d8a55bb07699b738618e7030c358af6f6a4f995ca0ed8d17694fd9645ebb6ab475baa0b195414ee2681e52496ee8fdbd46bb8d7b3350b0288678b8407b8ee305da67ae5ea07d2a2e1668e95df22eadb9dac390aba44a8e47a3a90095e90349f85cfb2b3b8d4e63b7d1850d7a3ad08c34b79bd46646993156cd8454cb54b40de54c344126f9adbff3ff008912692c	2026-06-03 00:36:28.379819	5013463005638040303	1554
600	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3330	\\x00110191557e710987da41ffffffff04085b157b093a0e74696d657374616d706c2b077b2f1a6a3a106475726174696f6e5f6d73660c313639342e31353a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b0756301a6a3b06660c313134302e31393b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b072f5b1a6a3b06660c313937352e38333b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b076e881a6a3b06660c313537372e32343b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b075ead1a6a3b06660c313735362e38323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b076dad1a6a3b06660c313136322e30383b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b0779ad1a6a3b06660b3439332e37323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b0719b01a6a3b06660c313537322e32333b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07acbe1a6a3b06660c313639392e39313b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b0754c01a6a3b06660b313336382e323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07d8c11a6a3b06660c313434302e31373b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b070ac31a6a3b06660c313533372e32383b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07e9c31a6a3b06660c313735362e39353b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07ecc31a6a3b06660a31302e31353b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07a1c51a6a3b06660c313738332e38363b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b0735c61a6a3b06660a3833352e313b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-05-30 00:29:47.288733	5194094733967695405	1097
591	\\x5f5f736f6c69645f63616368655f656e7472795f73697a655f6d6f76696e675f617665726167655f657374696d61746573	\\x3833313532	2026-05-29 11:57:23.49489	6706543775222517821	194
478	\\x70726f64756374696f6e3a64617368626f6172645f646174615f305f323032362d30312d30315f323032362d31322d33315f7635	\\x001181decf8d9f6085da41ffffffff789c8d556d6f1b45108e0ab26b27ad1dc749831ab55551d4a28ac8719c17cf49704e42444a4adbbc08843f9cd67773f692bd5bb3bbe760fa1be027f203f8cc0f60f6eeecc4a1d0ca1f7c3b3bf7cccc33cfcc7d7af7dd33a81b6998f0fc441b19a1d27c1596996ff808676c2b991b8b7a4c6b16483296a09a1905b240f31ad47d198f50190c72d37d581c201366e0f932890daf4345f010f35301aa913452e5c739a84a33c0ebe3721e320cb9e0cca0e66578c0e37f2537078f6d382f8baeb98cbd212a1f63c3fa189677da1bcd2d58cac08652709f13d44358cb2d0a239e44f4b610e853eee1fdadf6ce76736b63676f52b5a67b1eeb44d1ed7c73a3d1c65da80d310e78dccf4b2d417d6218b2b14c8c4ea0b2cffb87e8f38889e5cd3d686cecb61aedf66e6b731bb76171c87830f575566aa9c7de566b6f7b1b5b50cbb39bde67087bcd566bafd94e11ea130abcbe9257664044d4d2fac6d786a5497953cbf294cf6bdbca755baf8dd594d4e9b17e835e456f87254b2cc18dfa5e1e75c44482fccee0081e4532360331f614fa8952961585238cedf5df23582433b527a34ec29313fa07e8a48d3d455faac03b45c10cc55a81793792010abf947acdbb86f5044aa876140a80737b2a41d98d5984c74fcb2964010adf9c93eba5a0aa5c52a16bc643920cd3069584a737231104dd1da45700afd8b0e07c91bd62913d4654e9062cb86971fa5d09e6355aa174cb50e4012ca42cd143c92600355bae2d4d5bf141c557c8ec3c3003e52b123725fe7c36faa450801fecfd816089461a0d973a1770dfeabe5b90f05956eef7448506d84773851817a96e81a1398327d975c718c57b89b13ed3e722dc537910b7e26c1e3fbd9155c1797e444429de1f1809cb33413a715080fbae3fe022a09aba45092ffe2bf7b709aaf134e282f3cc5d85b58c33af87a154e84d5b7001a5430adf9de773fc13f5fb3afdd12f5c6836dbedcd9d4daac9ba5ec0cbd96053f457680632a004cf79843fc9180fa6cabc6da39e76a9639e376a7a5e77ae3b27a1338b4a7e317593deed046c48fe84fb466ad35778f6f604e0f5f161064a0d8d8625a8d8bef8dc06e3f3c49cf699c0063d081e71d320be0c39ff46193460d595442c6d2c5a6293e4ad6b4a8bbb0635d74be21e6dbbc04acdfa6784115d5ec0487f4c939b74be4af974bebe70dc8cb43fffc849731f391df7b173dc705ebaebce770de7c45d87321546759368d666fa7988dacf56548138c65f87eacc69171d78bf28ca6941bc42d21792051834e0c1b526bd5e42aab0c3f4f92c9f6f261efb9943d159a701bf3570b65cea22b345de4dc7adea324ad54b67ceadd0516128b2be584e072c0e04f5a65bee16fdbb67485addfcffb8a417a5d8f8dbecc58273eabea057cba9513a3f4e0c0fdf2f6809ad0fc14f5cf3087316fd94c57dfc88d452bf5ba955f799e6feebdecf54b584dd0f41dcf0be09443da25d897ddb2223bd74731ec1921b2686be5eb484752248a5f7885f8bacad1c991ec7fe915da1a4da2342d0039988c043da60cab3cd6fd0a5ed8fdd8384aa7f11d662d8255a2819861a0d41555d9ff903f42e714ca77a7eca47d35a7c19455ca7272fa01128c1e2e4232c436ec27b5f6e6fedb4361abbb042df281a46bb4695b1c360e7a59e1b49c499691daab9698c4cf13b7f15ff0126a6060f	2026-05-26 11:17:38.221499	-8050382658065991170	1415
556	\\x70726f64756374696f6e3a64617368626f6172645f646174615f34643433306132655f323032362d30312d30315f323032362d31322d33315f7635	\\x0011812759ad105086da41ffffffff789c8d55e16e1b45108e0ab26b3b899dd4710b444d5514a5a852643b8953cf49704e42444a4adb241508ff38adefe6eca57bb766772fc1f4198037e401780a66efce4e1c0a45fee1dbd9b96f66bef966eee3bbefb6a06ea461c2f3136d64844af307b0c67cc32f71ced6c8dc5834605ab34092b104b5cc2890059a37a0eecbf81295c12037d56065844c9891e7cb2436bc0e55c143cc4f45a845d248951f0b50936684d3e302ace521c3900bce0c6a5e86fb3cfe47720bb061c3795974cd65ec8d51f9181b36c4b0dcd9ddde6fc1bd0c6c2c05f739416dc07a6e5118f124a2b785409f720f9777bb3bed5667bbd39956ade99ec73a51745bd9d96e76711f56c718073c1ee6a556a03e358cd944264627503de0c323f479c444a3f50c9adbadf66e67affb6ca7d3c20eac8c190f66ce4e632d7569ef35bbedce4e6b0ff76035cf70e692a3ec76f7f70869bf4328f5290fde50c92b33223656d32227d7867bd31a6796b519a9d7b6c6756faf8db594d9d9b17e8363456f8725cb2ec15d0ebd3cea251309f23b9f3e8787918ccd484c3c857ea294a546e125c6f67aeb0f582133f528e34fc2a353fa07e8a5dd3d435faac03b43c10cc56a40c58d6480c22fa55e15d7b0814009b59e420170614f2528bb318bf0e47139852c40e1eb0b727d2ba82a7719565c3319936e9836a8243cbe198920e8ee30bd0278c1c605e78bec158bec31a24a3761d14d8bd3ef4a50d168d5d22f439107b098b2440f259b00acda726d69da2a10aabe4266878219285f91c229f127f3d1a785027c6fef0f054b34d240b8d4b980fb56fcfd82844fb272bf232a34c0019a2bc4b848750b0ccd393ccaae7bc6283e488cf5993d176149e541dcaad33a797c23ab82f3e49888527c383212d6e682f4e2a000cbae3fe222a09afa45094fff2df7d709aac92ce2a2b3e53e80f58c336f80a154e8cd5af0064a4714be5fe10bfc23f5db26fdd12f5c6cb7bbdd56a7453559d737f07c3ed80cfd059a910c28c10b1ee18f32c6c399326fdba8a77dea98e75db63dafbfd05f90d09b4725bf98ba49eff60236267fc27d25b5192a3c7f7d0af0f2e42803a58646e312546d5f7c6e83d1e0575ced33814d7a103ce2a6497c1972fe953268c2035712b1b4b668934d93b7ae292dee3aacba5e120f68e505566ad63f238ce8f20246fa639adca4f365caa7f3d51bc7cd48fbf3f79c34f7a1d373379c93a6f3dcdd74be6d3aa7ee2694a930aa9b44b33ed7cf23d47eb6a70ac431fe3256e74eb7e8c0fb45514e0be25592be902cc0a009f7af35e90d1252851da6cfe7f97c35f538c81c8ace260df8ad81b3e55217992df26e3a6e359751aa5e3a736e958e0a4391f5c5723a627120a837fd72bfe8df3d47d26aebbfe3925e9462936fb2170bce99fb945e2da746e9fc30357cf67e414bd8fd10fcd4358fb060d1cf583cc4ff915aea772bb5da01d3dc7f39f889aa96b0ff21881bde3781a847b42b71685b64a4976ece63b8e78689a14f182d619d0852e912f16b91b59523d393d83fb62b94547b4c087a24131178481b4c79b6f94dbab4fdb17b9050f5cfc25a0c7b8b164a86a146435035d767fe08bdb738a1533d3fe5a3692dbe8c22aed39317d008946065fa25962137e152abdddc696defed4383be51348c768d2a6387c1ce4b3d37928833d326d472d30499e277fe2afe0d372e061a	2026-05-29 07:24:06.771704	-24054342219910978	1426
537	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30352d3239	\\x00118166486dbec586da41ffffffff789c8dd3bd4ac35014077007691b538a9b3a29e2a470ccb91fb9b9c9e0e4a0082ec5c5218434a591d66a9a16a183938f20f826aee213f8000a82bba3838bc6e4a69b70b6c0cdef9ec3b9ffb3dc3adf9c5b7e274f47c9248f4657c3bde6e9d7fa85bfda9b66519e8e2fc3d1a4df46a51150fa9d388a07493848f36ef1479447e1643ccde2e4687ba33ce985fd74982759f1f177daf01b87ddb9152c15b7de15b7068dbecdb406ce82663768fda702ab46673f256aa3640e20559dec6e948aa187e07944f550294b83e444f201a690e30a702551bd61a5504b0da8898a0ba3846020a9a3583b30ca631e6897a89e87f5001d0714b5c3efebba43c6810ba2bacf4a654ba64121116d4debc12b018a3a8cfd4ad90239bdd47b85562457402df4690c3a20a975d8ac8a9f0b4a11c9f1ac4e2c79a1e29979239402047535725348824b254f0b22a9f9799d9924b81a1875062f37755499024eed6ee7d6285e4481531777f0b8580b0e8caad24ad9a8196116bfc50890ea	2026-05-29 02:13:35.179081	-8016969246444872464	566
861	\\x70726f64756374696f6e3a64617368626f6172645f646174615f62313034313163395f323032352d30312d30315f323032352d31322d33315f7636	\\x0011810607593ce587da41ffffffff789c8d565b73db5410ce14b013e762e7d2b440a674c26428d321233b8a63af66404e438684a697a405063f688ea5957d5a49c73d3a723179e319fe0d7f8a7fc11e4996e34c48193f5867f7d35ebeddb3ab8fe72f1fc186128a058e9bc44a8428633e077799abf80867649b198c853d16c7cc13a9b0960903649e3e6eb8221aa154e815a2d501b2400d1c572491e24b500db88ff9a904b5502821f32399136a80d3e3dddca5eff380338531afc23d1edd10dc17da9d93798fb9889c214a1723c5fa48daf5ccce5004dce5646519b67289c4902721bd1804e852d8fe4aa3d9dcdbdfdb6db72709c7a4e7519c48d22ed6775b753c80b521461e8ffad3c42782211b8b44c509540f79ff085d1eb260b3de0263b76eb65aedbd86d934b109ab43c6bd026c6d56da8430602d0febba7c6392abd397e2bd1a90c7b5349b712ef02bdf98cddd03589f645488f78c5d93ea39a1706a60735ac9a9b096f2581c37ae302ae9edb435467d27f73d624182fcceca1ff02014911a046347a29b48a9999038c248abfffe0956494cd5c8e812f0f029fd0374d23a9ea32ba4e79c63c014f9d984453b141e06ee428a5ab415eb0528a0d6911800bcd2a705a8d8110bf164bb929a2c41e9fb57047d1b5046f60aacda6a3ca40e61b1422960fbaa273241ba27a90ae08c0d4bd6d7d92bdab2c388a6d880253b4d2ebe5c80c5187573742b50e61e2ca50cd1c3820e00d674ba3ab558f71a545d894cb73f5350794fbd4c813f9af53e4914e067ad7f12b02446ba093695cee3ae6ef36e49c0a759bacf888a18e010d57bc4a84c7907e8ab0b7898a93b4a49de4b94c614cf655896b913bb6ad54fb6af4455b21e1d135192f7074ac0dd19279dc82bc18aed0e78e0514eddb280c7ff15fbcb04e5b8f0b8647d65df87ad8c33a787be90e81425780d0b47e4bebbc8e7f8479ffcb9437ff4f3971a8d76bbdeac534e1afa1a4e679d15d6cf500d844701bee221fe2a227c5274e57519d5b44b15739c51c371ba73dd39019d59ab848ba89af46ec76343c293dd1722567d89172f9f023c3f39ca8c5241c3e10254755d5cae9df145622e765980063d043ce4ca20be14817fa7080cb86f0b22960614cdac49f01a9ad2626fc19aed24518f869ba75b4de333c2882ec763d47f2c2698b0be4df9b4be7b6dd91969effeca49b31f581dfb0bebc4b04eed1deb47c37a6aef408512a3bca969b666ea7984b19b8da512718cbf0de585d52e5b70735354d28468c22ed981601e7a06dc9bf6a4d34ba82bf465fa7296cf1713c46106285b3b74c1af5d389d2e5591e924e7d3eb56b31985eaa477ceaed251a21f6475d19c0e58e405549b6ea55b76e72f907ab57ebb5fea1729d9f887ecc592756e3fa6572ba95058bf4c049fdfdcd002cc0f999f40730f73dafa398bfaf83f424b71d742ab1db298bbcf7b6f286b01071f3271057dd510d5886625f675899470d2c9790cebb69f28da583484e324a02e5d267eb5e558b7238bc7917bac472875ed3159880722093c076982494717df20a5ae8f9e8364357e176889626f519b12be1fa3225335db65ee009db738a6d3467ecaaf26493e9b6ca37c17388ac68ad75dbda439962e8c93ede553163d6c188d7dea419ae02cd4ab9f16df7ab6338d76abb1d7c4fdcbb2c5097c8cbd026cbd2960a6b96fb6cc830276c6e42c2c5ba3b9b633bc4d7bc6c6b7684f936856bb9606d0ae379af57d340b54709bffa47f8bf60287b3da9ad6365af59659e4f7dc5537d1d06e9badb6512f60cfc4e8065307a6d1989aa24f949b82d19b3f0c799c16d2f1687acdc3eae49b49f85cf9cbf5e6c15e6b77df844dfab4a039aa37a0547a8ee951b7910ba9de9968076ab9688c4cf23bff94ff05197b6b19	2026-06-03 02:39:01.39431	-3043575902710213806	1558
887	\\x70726f64756374696f6e3a64617368626f6172645f646174615f30626238613564355f323032362d30312d30315f323032362d31322d33315f7636	\\x001181064edabd0488da41ffffffff789c8d56fd72db4410cfb48c1d3b2eb1532785d22921d04919a619db89ed783503721a322434fd48da81c17f68ced2cabe56d299bb938bc933c08bf030bc010fc053b027c94e1c8acbf80feb767fb71fbfdddbbb0f962f1e42550bcd02c78d9516214ac5bf8075e66a3ec639d9460a63619f29c53c41c21294536180cc53bc0c55574463941abd4c5484ca1059a0878e2be248f31cac06dcc76cb504e5506821b3651eca420f51ceb4eb994bdfe701671a155f853b3cfa57704bf0a971e7a4de1517913342e962a4d900fde25e7367af09b753632311709793a965b8974924863c0e697710a04bb1fb85cefeeefe3461452a1ea9589262b98e2d581b61e4f16890a5b802d5a960c42622d62a86d5033e384497872cd8a8ef436da7dea9b59bcddd7a6b8f0c54468c7b33b0b5b19e409ab5e65e67bf5d6f6213d6b2c86690d44a63afbe5b6bd6f7db1db2529de6ef0ca478ab87c4c25a92dc2413f8c547edc64e1b6e4f139c893bad9d0ed5784aeba5818dcbea5e0acb09b7b365f50acb9276fb05e2b749e6c60327f33f66418cfcc69f25b81f8a480f838923d18da53424491c6364d47fdc840a89a94a299302369fd03f4037a9ef19ba427ace19064c93af0d58b143e161e01612d48aad593f4001e5aec400e0a55915a068472cc4e3ad62623207b96f5f12f44d4059d965a8d87a32a2ce614aa314b075d5139920dde3440570ca4639ebcb748bb1ec30a24ad5a06427c9a98b02ac2834fdd22b429e7b504a58a28f820900d64cba2635657a10565d89cc1c0ba6a1f8967a9c027f38ef7d9a28c00f46ff3860b1c21c946d2a9fc75dd3febd9c808fd3749f12150ae000f55bc4284f7907e8eb73d84cd55dad25efc7da6066df79b825332776c5aa1f6f5d892a673d3c22a2241f0cb580f53927ddc8cbc187b63be4814739f5f202befaafd85fc42827338f256bdbbe0bf752ce9c3efa42a2332bc12b281c92fbde0a5fe237e56f0fe88f7e7ea9d1e874eaad3ae564a0afe064ded9ccfa29eaa1f028c0973cc49f44848f679d795d4635ed51c51c67dc709cde526f494077de2ae122aa26eded7a6c4478b2fb5c283d9078fee209c0b3e3c3d42815341c1560d5d4c5e5c6198d80155bb92cc01a7d043ce4ba467c6902ff4a11d4e0235b10b134b868964d8337d08416fb3eacd94e1cf569e879a6d50c3e258ce8723c46fdc714c184f575c2a7f5cd2bcb4e49fbebf78c347bd3eada9f59c735ebc4deb6beaf594fec6d285262943735cdbdb97a1ea272d38995238ef197913cb73a790bdedd14c524219abc253b10cc43af06772e7bd2e9c7d415e6307d3ecfe7f329e22005e4ad0774c0af1d38932e559199249793e356b61985ea2467ceaed052a21fa475319c0e59e405549b5eb1977797cf917ab5bed82ff58b946cf25dba31679dd98f686b31110aebc7a9e0937737b480bdf7999f42330f4bc6fa198b06f83f424b70d7422b1f30c5dd67fdd794b580f6fb4c5c415f354435a259890353222d9c64721ec16ddb8f35dd643484551c5097de227e8d6565da91a949e41e99114a5d7b4416d450c481e7204d30e998e2d74869ea63e62059553f0746a2d91b34a684ef2bd464aa6cbbcc1da2f30627b4aa66abec6892e4eef446caee0247d358f17a950b9a63c98571bc75eb84459b8d5aa3453d48139c85e649401761b143f760ed226f71c21c617f86b15e5fd79e32b940db1d2dd29eb2c9bc76d568eb74456333839cc4d13ca492dcd1eddd46ab85bb3350b0288678b0407b8ea305da67ae5ea07d2ac60bb4f4347997d65ced61c8555225c7a3d15480caf48d247caefdd2a3c67e63a7d1810d7a3ad08c34b79bd46646993156cd8454cb54b40de54c344126f98dbff3ff003e5b699b	2026-06-03 11:36:43.41381	1988780500727313057	1559
681	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30362d3032	\\x0011810425a5ce3288da41ffffffff789c9596bf6b535114c715246d9a525dbb5870b06ae1f0eeef7b131d1d04eba0091422c6901fe4b5492bc9eb54dd445cdc8a5d1c5cd422383b29b8b9bb3838886bff096f7ce7d649f89a29907cdef7dceff99ef3eeb9c5b63fa8d6578a7c329815ddc9a3f1c6c28d2b17b7eb17fafbd36e91efed7626b3e1b2f64a92d4f5955eb7371a744679d18cffe816ddce6c6f7fda1bdcbab4fae7977e67988f8bc1347e99ff5aa9576e360faa8d33f1a99bf1a98dca7059182948b8c642b3b1f82fac514dd416533a0b9e9401a97149551d0901225fdaa59012ce5326416af361a264461aa5ce0f98ca8222811eeaf6d392923a56180248ad3f63cacbd8410f527798123af65d58907a595235e904190542979f97522e649e345a2053352f9c26344ceb2c657c0c135ce02925628101a5be31a582c928a0c960aaa6bc30844aadbe602969a317a819d79892360be4d0106e246a1e0cdc8c43aed068431a8dd3ec036ba99091432dfcf49d29a33519947afb2bb9a134090d52f74f980aca9045a9afd535f6500b92a81bc77713e51ceec6f57b6b3cc8d1798966e3414955e3a646cb1b2521630329d48a6da66416a7c4a3d4e3442919c8a2877a9228273c3934ba8725b524347974e71e25c6e00bed155b2e2ca1b3f8b1591e480ba948a3e69d6d7171ff6178dee2e6ba60c9a2afd4cf4949904363f4e32f0357f79399b8d405daa293560a9e95e4d169baba55524ad9781b41a9a3366bc50f6568854bfd14f2b8690d9a89d7793a978faf1d347ceff2d4dff9dd0c1d8de3a42585248576f8cd4ea26cbc32a1c3fb7ee7748f05e01af31bb0c4025d	2026-06-02 00:47:57.992036	5500830270860278411	787
560	\\x70726f64756374696f6e3a64617368626f6172645f646174615f39636635656361345f323032362d30312d30315f323032362d31322d33315f7635	\\x001181306e797b5b86da41ffffffff789c8d55ff6e1b45108e0ab26b3b899dc4710b446d5514b5a852643b8e8de72438272122a5a56dd20a84ff38adefe6eca57bb766772fc1f4198037e401780a66efce4e5c0aadfc876f67bf9b1fdf7c33f7f1cd370fa06ea461c2f3136d64844af3dbb0cd7cc32f70c9d6c8602c1a31ad5920c958825a6614c802cd1b50f7657c81ca60909b6ab0314126ccc4f365121b5e87aae021e6a722d42269a4ca8f05a84933c1f97105b6f39061c8056706352fc32d1eff2bb915b86bc3795974cd65ec4d51f9181b36c6b0dcedecf55ab095399b4ac17d4eaeeec24e6e5118f124a2b785409f720fd73bfdfd76abbbd7edceabd674cf639d28baadecef35fbd883cd29c6018fc779a915a8cf0d53369389d109540ff9f8187d1e31b1ddfa129a7bfd8376afdf6b765b78001b53c68305d6696488834ea7d7ee755b0784d8cc135c401a29a4d5e9f70eda9d6eaf8b5da23ca7c11b2b79692644c6665ae3eccab0352f7161d95e707a656b5cb5f6ca584b895d1cebd72856f47658b2e492bb8bb19747bd6022417ee3d3c7702792b1998899a7d04f94b2cc28bcc0d85e3ff81336c84c2dcae89370ef09fd030cd2e69ea12f55e09da160866235a0e2463240e1975254c5356c2450426da05000bcb4a71294dd9845787abf9cba2c40e19b97047d2da82a771d365c339b926c9836a824dcbf1e895cd0dd517a05f0944d0bce17d92bd6b3c7882add8455372d4ebf294145a315cbb00c451ec06aca123d946c02b069cbb5a5692b40a8fa0a999d0966a07c4902a7c41f2e479f170af083bd3f122cd148f3e052e702ee5bed0f0b123ec9cafd9ea8d00087682e11e322d52d3034e7702fbb1e18a3f8283116b3782ec29aca83b855a7757aff5a5605e7e10911a5f87862246c2f0519c44101d65d7fc24540350d8b121efd57ee2f1254b345c455e7817b1b7632cebc118652a1b768c12b281d53f86185aff08fd4efbbf447bf70b5ddeef75bdd16d564a1afe0f172b085f7a7682632a0045ff2087f92311e2d94f9b68d7a3aa48e79de45dbf3862bc315098365af848ba99bf4ee206053c293dfe7529bb1c2f3174f009e9d1e674ea9a1d1b40455db179fdb6034f71557fb4c60931e048fb869125f86c0bf51064db8ed4a2296b6162db279f2169ad2e2eec0a6eb25f188365e60a566f1196144971730d21fd30493ce57299fced7af1c3723edaf3f72d2dc3bcec0bdeb9c369dc7eeaef35dd379e2ee42990aa3ba49343b4bfd3c46ed676baa401ce3af5375eef48b0ebc5b14e5b4205e25e90bc9020c9a70eb4a93de282155d861fa7c99cfe773c46106283abb34e06f0d9c2d97bac86c9137d371abb98c52f5d29973ab7454188aac2f96d3098b0341bd19968745ffe63992565bff1f97f4a2149b7d9bbd5870cedc47f46a39354ae7c7b9e1b3770b5a42e77deee7d03cc28af57ec6e2317e406a29eeadd46a874c73ffd9e867aa5a42ef7d2eaea1af3ba21ed1aec4b16d91915eba394f60cb0d13435f305ac23a11a4d235e2d77ad6568e4ccf62ffc4ae5052ed0979d0139988c043da60cab3cd6fd2a5ed8fdd83e455ff22acc5b0d7685dc930d468c855cdf5993f41ef35cee854cf4ff9685a8b2fa388ebf4e405340225d8987f8865c84db8d66a37f75b7b073d68d0378a86d1ae5165ec30d879a9e746127166da855a6e9a2153fcc6dfc57f0082c005f1	2026-05-29 10:38:57.979667	4476806376399974554	1427
881	\\x70726f64756374696f6e3a64617368626f6172645f646174615f30626238613564355f323032352d30312d30315f323032352d31322d33315f7636	\\x001181f02ff965ef87da41ffffffff789c8d566d73db4410ce14b01327a99d97a60532a5132643990e19c9f1eb6a06e4346448e86bd20e0cfea0394b6bfb5a49e79e4e2e265ff801f01ff879f02fd8936439ce9894f107fb769fdb9767f776fdf1f2e543d8564231df71e348890065c497e00e73151fe39c6c2785b1a0c7a2887922115652a18fccd3c76d578463940abd5cb43144e6aba1e38a3854bc0c659ff7313b15a012082564762473420d7176bc93b9ecf7b9cf99c288eedfe5e182e0bed0ee9cd47bc445e88c50ba182a3640d26ea57646c2e72e272b15d8cd2412031e0774d1f7d1a5b0fbb70f1bd5aa691eb4dbd38423d2f3308a256957ab07a6894dd81c61e8f170304b7c2a18b18988551443f9880f8ed1e501f377cc16180766db68d6eb8766a3860dd81831eee5606ba7d42684019b5958d7e5dbd35c9d8114efd5903c6e26d94c3241bff4cda17970085bd38c72b1691c34a99e530a67067666959c092b098ff971fb0aa3926e27ad311e3899ef31f363e4b7fefa1dee072254437fe248746329351312c7186af5df316c9098aa91d225e0c113fa06e824753c475748cf39479f29f2b303ab76203cf4dd9504b56a2bd6f35140a523d10778a54f2b50b24316e0e95e29315980c2f7af08fad6a78cecdbb061abc9883a84450aa580bdab9ec804e91e272a80a76c54b0be4eaf68cb0e239a2203d6ec24b9e872055623d4cdd12d41917bb09630443f567400b0a9d3d5a945bad7a0ec4a64bafd9982d27bea650afce1bcf769a2003f69fd639fc511d24bb0a9741e77759b770b023e4dd37d4654440047a8de238645cadbc7beba8007a9baa394e4bd58694cfebb08eb327362972df374ef4a5405ebe1091125f960a804dc9973d209bd02dcb6dd21f73dcaa95b14f0e8bf627f19a39ce41ed7acafec7bb09b72e6f4b02f243a79095ec3ca31b9efaef225fed1277fecd3177dfa6bd56abb6d364cca49435fc3d9bcb3dcfa535443e15180af7880bf88101fe75d795d4635ed52c51c675c759cee5277494067de2ae142aa26dded786c4478b2fb42446a20f1e2e51380e7a7c7a9512a68305a81b2ae8bcbb533be4acc452ef3d1a01f3e0fb832882f45e0df280203eed98288a50145336b1abc8626b4d8bbb0693b71d8a3e1e6e956d3f89430a2cbf118f51f8b0826ac6f133eadef5e5b764adabb3f33d2ecfb56c7fec23a35ac337bdffad1b09ed8fb50a2c4286f6a9addb97a1e63e4a663a9401ce3af237961b58b162c6e8a5292104dd835db17cc43cf80bbb39e747a3175857e4c5fcef3f9628a384a01456b9f1ef8b507a7d3a52a329de472f2dc2a36a3509de4cdd9653a4aecfb695d34a743167a3ed5a65bea16dde50ba45e356ff64bfd22259bfc905e2c58e7f623ba5a4a84c2fa792af87c71430ba87dc8fc149a7958d2d6cf5938c0ff115a82bb165ae58845dc7dde7b43590b687ec8c415f4554354239a9538d02552c24926e7096cd9fd58d1c6a2211cc53e75e93af1ab2d47ba1d593409dd133d42a96b4fc8423414b1ef3948134c3abaf80629757df41c24abd13b5f4b147b8bda94e8f7235464aa62bbcc1da2f3162774dace4ed9d324c967d36d94ed0247d158f1ba1b9734c7928571bab77ec6c20755a35aa71ea409ce02bdfa69f16da53bd368b7aa870dac5f162d4ee013ece560eb4d0e6bb41aed7aad99c39e32390fabe835da349bb4bca798cee81a265db5b985c90ddab3389cd76e2661b4cd6ac3ac632d47f937d8e8c4831bb417385a9041b565b66a7906cf5db5888c76bbd66a1bb3449f89f122326a4675668afea82c0a46efff20e051524ec7a319b60c1bd37f4ea2cf557fdd341bedd68159871dfa8341d354ef41a9f434d3036f3b1352d553d13e5432d10499e4b7fe29fe0bd23b6d58	2026-06-03 05:32:27.899699	-2476830858032609791	1562
756	\\x70726f64756374696f6e3a64617368626f6172645f646174615f66383132626366355f323032352d30312d30315f323032352d31322d33315f7636	\\x001181b49c9525d587da41ffffffff789c8d56db6edb461035d256b2243b92af495b23095c184d11d42065c9b686404b39ae51bb712e768216d503b12247d2262457d95d3a55fd0505da8fe8e7f52f3a4b529265b84ec1077267cecef5ec2c3f9dbf7c0cab5a68167a7ea2b488502a3e076bccd7fc026764eb198c455da6140b442aac65c210596096abbe882f506a0c26a2a501b2500f3c5f24b1e665a886bc87f9aa00b5486821f32599137a80d3e55aeeb2d7e321671a15afc03d1edf10dc43e3cecbbc2b2e626f88d2c758b33e927625b3331421f7796a652397488c7812d1c630449fc2eeddaddbd67e7d67dbde1d27ac48cf639548d256eceddd06eec1f210e380c7fd69e263c1908d44a25502d503de3f449f472c5cb3f7c1dadeb75b3bf64ebdd5c4262c0d190f265867bddc228005cb7954d7e5abe354bdbe141ff4801c2ea7c98c7241affcadddd8de81957142b9b8b4d3da6e5137c7059cee5f9ff6712aaca5559c2c57afd453d2ee9418177d2f777dc1c204f99df61ff02012b11e84234fa29f4869ea20f10263a3fefb1096484cbdc88a25e0d1337a03b4d32e9ea12f64e09d61c834f959878a1b890043bf94a22aae66dd1005d4da124380d7665582b21bb3088f37cba9c902147e784dd0772165e4de8525578f86c40fa6344a019b573d9109d23d4d5500a76c5870bec9b618cb1ea332290b16dc34397559828a42438d4e198a3c8085b442f4513201c0b249d7a4a60cd3a0ea4b6486fc4c43f9033199027f3ceb7d9c28c0cf46ff346489423a072e752ee0be2179a720e0f32cdde7540a057080fa03625ca4bc43ece9737894a9db5a4bde4db4c14cbe8bb02873276ed5b18f37af4455701e1f51a124ef0fb480b51927ed3828c05dd71ff030a09c3a45014ffe2bf65709cad1c4e382f3b57b1f36b29a795dec0989dea4056fa07448ee3b153ec73ff9eccf2d7ad1d35ba8d75b2d7bd7a69c0cf40d9ccc3a9b583f453d100105f89a47f8ab88f1e98495d765d4d30e75ccf32eea9ed799ebcc0968cf5a255c4cdda4bded800d094f765f0aa5fb12cf5f3d0378717c9819a58646c312544d5f7c6e9cd1d4a8b8ca67215af411f2886b8beaa509fc3b4560c17d575061693cd1c41a076fa06959dc0d5876bd24eed2680b0cd50c3e2b1895cb0b18f18f298209e7bbb49ecef76f1c372bdafbbff2a2b90f9cb6fbd039b69c1377cbf9c9729eb95b50a6c4286f22cdc64c3f0f51f9d9502a508df1b7a13c775a45076e2645394d885789faa160010616dc9b72d2eb26c40a7398be9aade7cb31e22003149d2d3ae0d70e9c4997bac84c92f3e971abb98c42f5d233e7566929b117667d31351db03808a9379d72a7e8cf9f2371d5bedd2ff1454a36fa31db5870cedc27b4b59c0a85f3cb58f0e5cd8416d0f898f93134f73067ac9fb1b88fff23b414772db4da0153dc7fd17d4b590bd8fb98892be8ab86a847342bb16f5aa485974ece2358717b89a6fb8a86b04a4262e922d5d75856868e4c8d62ffc88c5062ed115950039184818734c1a4679a6f91d2f4c7cc41b2aade8746a2d93b34a644afa75093a99aeb337f80de3b1cd16a355fe54793245f8c2fa3fc2ef0348d95a0b37449732cbd308e37174f58fca86ed59bc4419ae02c3217ffe4debb2c3a9c3047d89d609cb7d7b5a74cdea26d0f6fd39eb2d12dda93249ed52ea7f778cbaeefda4d6c4c50e16dfe93fe2dda731cce6a6b465bdfb7f71bd8cc312f7c3d8b59c9a26835f65b963d813d17173798da6b58f5a929fa1db9291873cf47115769dbbc8066d53c2c8dff8f448febdea2dddcdbd9dbde6bc23afd48d0d434f79dd4666a99c1b69a0ba9bb99680b6ab968844cf23bff14ff05a47c668a	2026-06-02 22:04:24.672579	8769444907492558922	1537
760	\\x70726f64756374696f6e3a64617368626f6172645f646174615f66383132626366355f323032342d30312d30315f323032342d31322d33315f7636	\\x001181d11b522ad587da41ffffffff789c8d566d4f1b4710466964836d82cd5bda94b411286aa2aae8ce60c073527b2614150a7901a256f587d3fa6e6c6fb277ebeeed3975f90755bff72ff66774f6ce2f1811a7f2077b679e9d976766677c7ffefa19ac6aa999f0fc24d6324415f3395863bee67d9c92ad673016b6581cb340a6c2722614c802735cf565d447a531188b2a5d6442773d5f2691e6255812bc8dc313dd0fa5966a7294ba8b93e3dad065bbcd05671a635e84873cba23b8af8d3b2ff31e7319793d543e469a7590b42b999d9e14dce764a5041b4389c29027215d14027d0abbfdc0ae59fbd5fded5a7594704c7a1ec589226dd1deb6ebb80fcb3d8c021e7526898f043d3690898e13583ae49d23f479c8c49a7d00d6f6815ddfb177aaf51ad6a0d2633c18639df5e514615bf59abd8bbbb03c8cee63fad551ea5e47c90fba4b012ca7c90d268295516e63c9da98c7896c7d52ce89b09c92393eaedea055d1edd454bfe30d3df6994890df7b7c055f8532d25d31f014fa8952860e857d8c8cba624385c454928c33094fcee81ba09116f3027da902ef0205d3e4671d8a6e280314fe428a2aba9ab5044a2837140a802b735a80821bb1104f360ba9c91ce47ebc22e87b4119b925a8b87ad0a33661b1462561f3a6273241ba17a90ae09cf572cef3ec8ab1ec31a229b6a0e4a6c9c5d70b508cd17448b300791e402965887e2c980060d9a46b528b4dc3c192af909937c034143e504353e0cfa6bd8f1205f8c5e85f0896c49883b24b550bb86f7abd9993f04596ee4ba222063844fd0131ca53de02dbfa129e64ea86d68ab7126d30e3df7958544327eea2639f6cde882ae73c3b26a214ef74b584b529278d28c8c103d7ef7211504ecdbc846f3f16fb9b04d560ecb1e47ce3aec346c699d7c2b654e88d4bf016168ec87db3c8e7f867fffcf594bee8d32e55abf5babd67534e06fa164ea79d8dad9fa3eeca8002bce221fe26237c31eecadb32aa69932ae679fdaae735e79a73121ad35609175135e96e23603dc293ddd732d61d85976fce005e9d1c6546a9a0616f01964c5d7c6e9cd1082abab1cf045af443f0906b8bf8d204fe9322b0e0735712b134a568708d8237d09416f7112cbb5e12b568c205a6d50c3e238ce8f20246fdc7628249e7fb944fe787b78e9b9176ffef2169ee86d3701f3b279673ea6e393f5bce99bb05054a8cf2a6a6d998aae711c67e369b72c431fed153974e3defc0dd4d514813e24bd4fa42b200030b1e4e7ad26b25d415e6316d4df3f97a8438cc0079e7293df05b0fcea44b556426c9f9f4b9955d46a17ae99b7317e9a8b02db2ba184ebb2c0a04d5a65968e6fdf94ba45eb567fba57e518a0d7eca2ee69c0bf7395d2da442e9fc3a127c7977434bd8fd94f91174e861ce58bf605107ff476829ee5668e5431673ff55eb1d652d61ff53266ea06f1aa21ad1acc48e2991965e3a398f61c56d279ad6160de13811d4a58bc4afb11c9b7664f120f28fcd08a5ae3d260b71572622f0902698f24cf12d529afa98394856e3df859168f61e8d29d96ec7a8c954d9f599df45ef3d0ee8b43a3c0d9f26491e8d16d17017789ac64ad0ac5cd31c4b17c6c9e6e2298b9e54adea2ef5204d70169afd4f6baf50a7ad675de71d4e98636c8d31cebbdbda73a666681bbd59da733698a13d4da2696db68ceb7675cfaee1ee182566f94f3a33b497d89bd6aea41ef60e2c6b7fe7006b43d82b5fdf05dbdfa9d577eaf531eca5eccff0457f49eed29a251f863c4e6be60534a8e6a132fa8f24db5cb717bfabd6f76adb3bbbb04eff2268649a65a7b4195966aaad0e8554da4cb405e5a168804cf17bffe6ff031245667c	2026-06-02 22:04:44.076362	-4880349569725938897	1526
815	\\x70726f64756374696f6e3a64617368626f6172645f646174615f31623761333031355f323032362d30312d30315f323032362d31322d33315f7636	\\x001181f16d7824df87da41ffffffff789c8d56fd6e1b45108f5a64c78e43ecd449a1ad4a08aa528412d98eedc473129cd31091d0f4236905c27f9cd67773f6b677b766772fc5e419e0457818de8007e02998bd3b3b71282ef21fbe9df9ed7cfc6676763f5abc7c0c552d340b1c37565a842815bf0f6bccd5fc026764eb298c857da614f304094b504e8501324ff132545d115da0d4e865a2225486c8023d745c11479ae76025e03e66ab052887420b992df350167a8872aa5dcb5cfa3e0f38d3a8f832dce5d1bf825b80cf8c3b27f5aeb8889c114a1723cd06e8179bad9d660beea4c64622e02e27538bf02093480c791cd2ee20409762f70b9dfdddfd49c28a543c52b124c5621ddbb03ac2c8e3d1204b7109aa13c1888d45ac550c2b077c70882e0f59b056df87da4ebdd66e7476f76a2dda5f1931ee4db1d67a8a68d55acdcefe5ebd852d58cd029b42d65323adf67e73b7b5d73656aa93f49d8114eff49048584d721b6702bfb0ddc23adc99a497498bdb9de6ce1e557842ead5fef5abda5e09cb09b3d365f51ac79276fb0562b745e62e064ee6fe820531f25b7f96e06128223d0cc68e443796d25024f10223a3fee33654484c354a7914b0f194fe01ba4975cfd015d273ce30609a7cadc3921d0a0f03b790a0966ccdfa010a2877250600afccaa00453b62211e6f16139339c87dfb8aa06f03caca2e43c5d6e311f50d531aa580cdeb9ec804e99e242a805336ca595fa65b8c65871155aa06253b494e5d166049a1e9965e11f2dc8352c2127d144c00b06ad235a929d381b0e24a64e650300dc577d4e114f8e359ef9344017e30fa27018b15e6a06c53f93cee9ae6efe5047c9aa6fb8ca8500007a8df214679ca3b405f9fc346aaee6a2d793fd60633fdcec3b2cc9cd815ab7ebc792daa9cf5f88888927c30d402d6669c74232f071fdbee90071ee5d4cb0bf8eabf627f19a31c4f3d96ac2dfb1e3c483973fae80b89ceb404afa17048ee7b4b7c81df96bf3da23ffaf9a546a3d3a9b7eb949381be8693596753eba7a887c2a3005ff1107f12113e9976e64d19d5b44715739c8b86e3f4167a0b02bab35609175135696fd76323c293dd1742e981c4f3974f019e1f1fa646a9a0e1a8002ba62e2e37ce68002cd9ca6501d6e823e021d735e24b13f8578aa0069fd88288a5b145936c12bc8126b4d80f61d576e2a84f23cf33ad66f029614497e331ea3fa60826acaf133ead6f5e5b764ada5fbf67a4d91b56d7fedc3aae5927f696f57dcd7a6a6f419112a3bca9691eccd4f310959bceab1c718cbf8ce4b9d5c95bf0fea6282609f1156afd40300fbd1adcbdea49a71f535798c3f4c52c9f2f2688831490b71ed101bf71e04cba544566925c4c8e5bd96614aa939c39bb424b897e90d6c5703a649117506d7ac55ede5d3c47ead5fa7cbfd42f52b2f177e9c69c75666fd3d6622214d68f13c1fdf737b480e687cc4fa099870563fd8c4503fc1fa125b81ba1950f98e2eef3fe1bca5ac0de874c5c435f374435a259890353222d9c64721ec11ddb8f35dd633484551c50972e13bfc6b232edc8d438728fcc08a5ae3d220b6a28e2c073902698744cf16ba434f5317390acaa9f0323d1ec2d1a53c2f7156a3255b65de60ed1798b635a55b355763449726f7223657781a369ac78bdca25cdb1e4c238de5c3e61d146a3d668530fd20467a17910d03d58ecd03558bbcc5b9c3047d89f62ac3737b5a74cced17647f3b4a76c3cab5de9247778ab89ad0c721247b3904a7245efed36da6ddc9d82827931c48339da731ccdd13e77f51ced337131474b0f93f769cdd51e865c2555723c1a4d05a84c5e48c2e7da2f6d37f61b3b8d0eacd3d38166a4b9dda43633ca8cb16a26a45aa6a22d2867a23132c96ffd9dff0759196950	2026-06-03 00:55:01.890826	2345240684817718725	1557
818	\\x70726f64756374696f6e3a64617368626f6172645f646174615f31623761333031355f323032342d30312d30315f323032342d31322d33315f7636	\\x001181409f1126df87da41ffffffff789c8d566d6f1b45108e4a65274edc38af8512a04a54d10a119ddfe33909ce69884868fa923402e10fa7f5ddd8def6eed6eceea598fc03c477fe143f845fc06766efce761ca569e50ff6ce3c3b2fcfcccef8eefce56358d742b3c0f562a5458852f139d8609ee6173823db4c612cec32a5982f1261291506c87c735cf744748152a33f11ad0c90057ae07a228e342fc172c07b989de87e28b490d3a3d0039c1e373297bd1e0f38d3a87811eef3e886e0be32eedcd4bbe2227287283d8c34eb2369d7523b4311708f9395126c651289218f43ba1804e851d8bd7b955ac56ad4766bd571c28af43c52b124ed6279b751c326ac0e31f279d49f263e160cd948c45ac5b0bccffb07e8f190051be53db076cb56a3d2aa36ad3a366065c8b83fc1da9bab19a2552fd7b006ab5974efd3af8f5377fb52bcd3030a6035496e3415ac8d739b4836263c4e659bd3724e85a584ccc971fd0aad926e27a62efa6ee6f1820531f23bff9dc397a188f42018b912bd584a4387c40b8c8cfa9fe7b042622a49ca998087cfe81ba09d14f3143d217df71403a6c9cf262c3aa1f031f01612d4a2a359374001a5b6c400e0b5392d40c189588847db85c4640e723fbc26e8db8032729660c5d1a321b509531aa580edab9ec804e99e262a801336ccd94fd22bc6b2cb882665c1929324a72e176051a1e9904e01f2dc87a58421fab16002805593ae494d998683654f22336f806928bca386a6c01fcf7a1f270af0b3d13f0d58ac30072587aae673cff47a2727e0b334dde7448502d847fd0e31ca53de01f6f4193c4cd56dad25efc6da6026bff350949913a768978fb6af4495b31f1f125192f7075ac0c68c9376e4e7e09ee30d78e0534e9dbc806fde17fbab18e568e271c9fedad984ad9433b78b3d21d19d94e01c160ec87d6791cff14ffefef3117dd1a7b754a9b45ae546997232d073389e7536b17e827a207c0af0350ff15711e1d349575e97514d3b5431d7bda8b86e67ae3327a03d6b9570115593eeb67d36243cd97d2994ee4b3c7bf50ce0c5d1416a940a1a0e1760d9d4c5e3c6195f24e694c702b4e847c043ae2de24b13f80f8ac0824f1d41c4d294a2c1350ede40135a9c07b0eab871d4a509e79b5633f89430a2cbf519f51f530413f677099ff6f7e7b6939276f7af8c3467cb6e3b5fd847967dececd83f59f63367070a9418e54d4db33553cf03545e3a9b72c431fe3e9467762b6fc3cd4d514812e2cbd4fa81603efa16dc9ff6a4db8da92bcc63da99e5f3e518b19f02f2f6237ae0d71e9c4997aac84c92f3c9732b398c42759337e714e928b117a475319c0e58e407549b4ea193f7e6cf907ab57cbb5fea1729d9e8c7f462ce3e759ed0d5422214f62f63c1e73737b480da87cc8fa199873963fd94457dfc88d012dcb5d04afb4c71ef45f70d652da0f9211357d0570d518d685662df94480b37999c87b0e6f4624d6b8b86b08a03ead222f16b2c2bd38e4c8d22efd08c50eada43b2a006220e7c17698249d714df22a5a98f99836455fd161889666fd19812bd9e424da64a8ec7bc01ba6f7144a7f5ec943d4d923c182fa26c17b89ac68adf59b9a439962c8ca3ede2318b1e56ac4a8d7a9026380bcdfea7b55768d1d6b32ef33627cc21762718fbcd75ed0993b768dbc3dbb4276c748bf6388e66b5e9326e952b8d721d6b1354709bffb87f8bf60c87b3dab5c44363cfb29ad53dac67b0179ebe09d6acd65bd5566b027b2e2e6e82d5f79a8d6ab33681d17f939b60d54abd592d37b16ed67e18729554d1f56974cdc3caf85f93e871dd2b7e4bf6f676eb15d8a4ff153444cdfa93da0c3133e7d63321153b15ed4029138d90497ee7dffcff65786c57	2026-06-03 00:55:08.282627	-3372366342356562926	1541
820	\\x70726f64756374696f6e3a64617368626f6172645f646174615f31623761333031355f323032342d30312d30315f323032342d30312d33315f7636	\\x00118160ea0b2adf87da41ffffffff789c8d55e96e2345108e008de323c4499c2ccb461019adc80a098dc3922535128c9310919065777308847fb4da3365bb49cfb4e9ee493079035e8027e19d780caa677cc45160917f78eaebea3abe3afabdc5db67d0b0ca72c9a2cc5895a0366201d67964c535ce611b851a4fbadc181eab1cac17a0441e3bb111a9f41ab5c5780aad0c904b3b6091ca524bf2b2143d9c4af54459a567a2b2039c89eb6397bd9e90825b3462091e89f481e03e76ee58e1dd0895b221ea0853cbfb48a76b859da1922212e8f437c788c64464095d9412230abbe7f993440de1223599c638f4607588692cd2fe2cd50930e423955993c1f2bee81f6224122ed75b5f81ff79cbdfddd9fbe285ff25eec2ca908b78aa1b6c54f648c187d5711cf7f1c62439d6d7eac60ec8e16a1efe6806ac4da29f22eb53a666d8c6ac6033b09ed335151b7788d3743b3775dd67638fd75c660efb2851a91dc811d318655abbe4355e639a1fae10488417fc28d83aa57f80765eaa338c948ed9194a6ec9c70654c344c528a372ae550d2def4a54506f6b9400174e2a43254c7982c7cd4a6ed203efdb0b52bd92944d588595d08e86d404dc58d40a9a773d91093a3bc88f005ef2a1173c2bae38cb8c1345c6875a9827666ecb5035e8eadfa94049c450cbd9a18fb20b00565db22e35e3da0996238ddc7538b750b9a176a5c0b7e7bd4f1205f8d19d1f489e19f4a01e52c56211b94eee780a1e17e9fe405418807db437886989f296d8b3e7b0551cb7add5a29b59a733fd2ec1921e3b096b41ebb879272a2fd83e22a2b4e80fac82f53927ed34f6e0fd301a0819534e9d9282cffe2df63719ead1d4632df8345c87cd8233d6c59ed2c8a625b884f221b9ef54c58278f7cf3f9ed21ffd7ab59d9dbdbdd66e8b7272aa977032ef6c6afd25da818a29c00b91e0cf2ac5836947dec7a8a61daa1863d73b8c75163a0b0adaf356492fa56ad2dd76cc87a44f765f2b63fb1acfdf9c02bc3a3e2c8c5241936119965d5d22e19c892a3167222ed1a70f2912617de2cb92f2ef14810f1f848a88a51d446b6912bc53cd69091fc36ac8b2b44bfb2b76ade6f40bc2882e1673ea3f6e484d055fe77c06df5c066141da5f13d2c227413bdc0c8efde0246c06dffbc169d8840a25467953d36cced5f3104d54ec218f38c6df86fa3cd82b05f0705354f284c432b5be543cc6d88747b39e64dd8cbac20dd327f37cbe9e68ec170aa5e0290df8bd8173e95215b94b72311fb77ac8295496cf5c582351634f1675719c0e781a4baa4da7d229458be748bddafa6fbfd42f5af3d177c5452f380bb7e96a250755f0d30478f270432b78fe36f313d5b1870567fd8ca77dfc1fa1e57af742abef7323a257dd5f286b052fde66e28ef65d435423da95d87725b28ae59bf308d6c25e66e971a2156c32495dba44fc3acbc6b52337a3343a722b94baf6882c9881ca64cc90369866aef83e1dbafab83d4856cdafd221965fa133a57a3d83964cd5c388470364573822a93196c6a349c887934768fc12304b6b25ee78b7b4c7f2e7e2b8b974c2d3ad1d7fe739f5206d709eb8d7fdee53a7924498dc1e8b69884ab032799d554f587a7c37e855a331760b585b37466ed21a6390dc155013ea6368845c8b77fe264363208f4478ff00e57011e3	2026-06-03 00:55:24.191376	-1119442363384938315	1396
822	\\x70726f64756374696f6e3a64617368626f6172645f646174615f31623761333031355f323032342d30342d30315f323032342d30342d33305f7636	\\x00118109e9062bdf87da41ffffffff789c8d556d6f1b45108e00d9b59d1027b1534a23888c2a5221a1b329299993e09c84889494b67911087f58adefc6f692bd5bb3bb9760f20fe08ff2995fc0ecddd98ea340913ff8e6d9d97979e665df7b70f3141a56592e59981aab62d4462c419387565ce102b699abf1b8cf8de191cac07a0e4ae491131ba14aae505b8c66d0da08b9b42316aa34b124af4a31c099548f95557a2e2a3bc2b9d82c5c0e06420a6ed188157828927b82fbd8b963b9772354c2c6a8434c2c1f229d6ee476c64a8a50a0d3df2a108db14863ba28258614f6a0e44d1335848bc4a41aa3a004eb634c22910ce7a94e81319fa8d49a1456f7c5f010431173d96c7f05dee76d6fb7b3f7c573ef4bdc85b53117d14cd7dfacee918207eb451c77f1c6343936d4eada8ec8e17a16fe640e6c4ca39f21cd1953736c735eb03958cfe89a898d5bc469ba9d99ba1ab2c2e31597a9c33e8a55624772c23486a9d62e798d579864876b0412e1393f0ab64fe81fa09b95ea1443a523768a925bf2b109b5205611cab09269d502cbfb1215d4bb1a25c0b9932a500d121ee371ab9a992c41e9db7352bd94944d5083b5c04ec6d404dc58d40a5ab73d91093a3bc88e005ef271c97f9a5f719619278a8c07cb419698b9a940cda0ab7faf0a6511c172c60e7d545c00b0ee9275a919d74eb01a6ae4aec3b985ea35b52b05beb3e87d9a28c08feefc40f2d46009ea01552c12a1ebe45e49c1a33cdd1f880a03b08ff61a312953de1207f60cb6f3e3aeb55af453eb7466df6558d1859360d96f1fb76e4555f2778e88282d8623aba0b9e0a49b4425783f084742469453aface0b37f8bfd4d8a7a32f3b8ec7f1a34612be78cf571a034b259092ea07248ee7b35b124defdfb8f27f447bfc172a7b3b7d7de6d534e4ef5025e2c3a9b597f8976a4220af05cc4f8b34af060d6917731aa698f2ac6d85587b1de526f494177d12ae925544dbadb8df898f4c9ee6b65ec50e3d99b138057c787b9512a683caec0aaab4b289c335123e64cc8257af421452cac477c5952fe9d22f0e0834011b1b483682d4d8377aa192dc123580f589af4697f45aed59c7e4e18d1c5224efdc70da929ffeb8c4fff9b0b3fc8495bfdb3202d78ec77832dffd8f35f042dff7bcf3f095a50a5c4286f6a9aad857a1ea209f33d54228ef1b7b13ef3f7ca3edcdf14d52c21b14aad2f158f30f2e0e1bc27593fa5ae70c3f4c9229fafa71afbb942d97f42037e67e05cba5445ee927c908d5b3de0142acb662e582651e340e675719c8e781249aa4dafda2b870fce907ab5fddf7ea95fb4e693eff28b25ff34d8a1abd50c54fe4f53e0f1fd0dade0d9dbcc4f550b0f4bcefa294f86f83f42cbf4ee8456dfe74684affabf50d60a9ebfcdc42deddb86a846b42b71e84a6415cb36e7116c0483d4d2e3442bd8a492ba7485f875968d6b476e264978e4562875ed1159302395ca88216d30cd5cf13d3a74f5717b90ac9a5fa5432cbf44674a0d06062d99aa07210f47c82e714252a3908ad124e4c3e92354bc04ccd25a897aa51bda63d97371dc5ae98ef576c7eb3ca31ea40dce63f7badf7eea541c0b93d963110d5119d6a6afb31a084b8fef26bd6a34c66e016bebc6c84d5aa300c95d0eb5a05e4013e45abcf317192a802c1251f9075da411a6	2026-06-03 00:55:28.16885	2208326984561408827	1395
824	\\x70726f64756374696f6e3a64617368626f6172645f646174615f31623761333031355f323032342d30372d30315f323032342d30372d33315f7636	\\x0011810d27112cdf87da41ffffffff789c8d556d6f1b45108e00d9b59310274d522801aa4415ad10e86c4a4be62458a72122a5a56d5e04c21f56ebbb397bc9deadd9dd4b31fd09fc517e06b3f762c751a1c81f7cfbececbc3cf3ecec7b375edf874da79d503ccaadd3291a2b97604b444e5ee202b65d9a897428ac15b12ec04e092a14b15f6e463abb44e3309e41eb6314ca8d79a4f3ccd17a4dc90467ab4eaa9d36f3a576639c2fb7aa90492295140ead5c855b327b43729ffa70bc8c6ea5cef8044d84991323a4dd9ba59f89563292e8ed772ac4602af3940e2a8511a59d3482ba504bb8cc6c6e30660dd8986016cb6c342fb5062662aa736773583b90a3438c642ad456f71b08beec060f7bfb5f3d0abec687b03e11329ed986dbed7d320860a3cae33abe5917c74746bf72630ab851a43fad80a4f545177b70b3aea044599b5a57b3353fba3d6fda1cec1494cd969b57c83374ba50c1e58857512f85ca3df649aa333756536e30ca8df10418bcc4acd85c2790482f39d270e729fd03f48b769d60a44dcc4f50094731b66199a53a4615b50aab65e6c450a1864edfa00238f3ab16b45926523cde6d172e1bd0f8fe8c4c2f1455c356609db9e9848420ac43a361f76a2472417b8f8b2d806762d208ef9747bc672e88221bc00a2b0ab3af5bb06cd16b60d086a68c61a560873e5a3e01d8f0c5fad2ac9714ac45068557b970d07e4592a5c4ef2d46af0b05f8d9ef3f5622b7d8800ea38ec532f26a1e34347c5896fb135161010ed0bd42cc9a54b7c2c49dc29d72bbef9c91c3dc799bd97713564d1584ad86dde3dd2b5935c27b47449491a3b1d3b0b510a49fc50d789f4563a962aa69d0d4f0f9bfe5fe3247339d455c093f63dbb05372c6879868837cd68273681d52f8c1b25c92ef3efbeb2efdd12f59e9f5f6f7bb0fbb5493373d87278bc166de9fa11beb98123c9329feaa337c3c53e4758c7a3aa08e717ed9e37cb03458d2d05ff44a76197593cef66331217bf2fb425b373278faf229c0f3e3c3d22935349db460cdf725923e985c26e66c241406f4a1642a5d407c3932fe933208e003a689589a43349aeae4bd69410bbb0d1b8ce7d9906658eca5e6ed4bc2882e1e0bd29fb064a6c36f0b3ec3efce435692765193c676c23efb383c0ec2276c2ffc31089fb23d6853615437896667a19f8768a37216358863fc63624ec3fd66086f1645bb2848ae91f4951631c601dc9a6b920f735285bf4c7b8b7cbea82d0e4a836678972ef8b50be7cba52e0a5fe48de2ba7598a0547971e7d82a2d0d26aaec8be7742cb258516f06ed4133ba718aa4d5ee7fc725bd1823a63f94071be109bb4f47db05a8c35f6ae0a3370b5ac383b7b9af4dab084bdefb89c846f83f522becaea5d639105646cf87bf51d51a1ebdcdc515ebab8ea847342b71e45be4342f26e711dc6449eee881a2116c73452a5d257ebd67ebe528ec348b8efc0825d51e91073bd6b98a39d20433dc373fa04ddf1f3f07c9abfd5d79c4890bf4ae74925874e4aac322118d915fe094569bd5aaba9a84dcae1fa1ea25e08ec64a3c68bca639563c17c7bbab4f7275a717f41e900669828bd4bff0579f3b9da6d216fe784c97a809ebf50bad13e9e801dea6578daeb11fc0c6f96be46fda660552b812da834e054d5118f9cedfe4a8028a4ce4ca3f90181259	2026-06-03 00:55:32.271901	8003226521526963621	1401
826	\\x70726f64756374696f6e3a64617368626f6172645f646174615f31623761333031355f323032342d30382d30315f323032342d30382d33315f7636	\\x00118147b66b2ddf87da41ffffffff789c8d55eb6e1b45148e00d9f525c449ec94d208225715a990d0da94949c95609d84889494b6b908847f8cc6bbc7f690d91d33339b60f206f0a23c0667767d8d0245fee13ddf9c3997ef5ce68307b7cfa06e95e59285a9b12a466dc40a347868c5352e615bb91a8f7bdc181ea90cace5a0441e39b11eaae41ab5c56806ad0f914b3b64a14a134bf29a147d9c49b55859a5e7a2b2439c8b8d89cb7e5f48c12d1ab10a0f45724f709f3a772cf76e844ad808758889e503a4d3cddcce4849110a74fadb1344632cd2982e4a892185dd2f78d3440de12231a9c62828c0c6089348248379aa5360c4c72ab52685b5033138c250c45c365a5f83f745cbdb6bef7ff9c2fb0af7607dc44534d3f5b7cafba4e0c1c6248ebb787d9a1c1b68756387e470230b7f3c0736a7d1cf90c68ca939b6352fd81cac6574cdc4fa02719a6e67a6ae076ce2f19acbd4619fc42ab14339661ac3546b97bcc66b4cb2c3750289f09c1f053ba7f40fd0c94a7586a1d2113b43c92df9d8824a10ab086558cab42a81e53d890a6a1d8d12e0c249252807098ff1a459ce4c16a0f0dd05a95e49ca26a8c07a60c7236a026e2c6a05cd454f6482ce0eb32380577c54f09fe5579c65c68922e34135c81233b725a81874f5ef96a12822a866ecd047c905001b2e59979a71ed046ba146ee3a9c5b28df50bb52e0bbcbdea78902fce4ce0f254f0d16a01650c52211ba4eee16143ccad3fd91a8300007686f109322e52db16fcf61273fee58ab452fb54e67f65d84553d711254fdd6497321aa82bf7b4c446931185a058d25279d242ac08741381432a29cba45059fff5bec6f53d4e399c7aaff59d080ed9c33d6c3bed2c86625b884d211b9ef56c48a785ffef594fee8d7afb6dbfbfbadbd16e5e4542fe1e5b2b399f55768872aa2002f448cbfa8040f671d7917a39a76a9628c5db719ebae7457147496ad925e42d5a4bb9d888f489fecbe51c60e349ebf3d05787d72941ba582c6a312acb9ba84c239131562ce845ca2471f52c4c27ac49725e53f28020f3e0a14114b3b88d6d23478a79ad1123c828d80a5498ff657e45acde9e784115d2ce2d47fdc909af2bfc9f8f4bfbdf4839cb43fa7a4058ffd4eb0ed9f78fecba0e9ffe0f9a74113ca9418e54d4db3bd54cf233461be870ac431fe3ed2e7fe7ed187fb9ba29c2524d6a8f5a5e211461e3c9cf724eba5d4156e989e2cf3f966aa71902b14fda734e07706cea54b55e42ec907d9b8d5024ea1b26ce6822a891afb32af8be374c89348526dbae56e317c708ed4abadfff64bfda2351f7f9f5f2cf867c12e5d2d67a0f27f9e028fef6f6805cfdf657eaa3af1b0e2ac9ff16480ff23b44cef4e68b5036e44f8baf72b65ade0c5bb4c2c682f1aa21ad1aec4812b91552cdb9cc7b019f4534b8f13ad60934aead255e2d75936ae1db91927e1b15ba1d4b5c764c10c552a2386b4c13473c5f7e8d0d5c7ed41b26a7e930eb1fc0a9d29d5ef1bb464aa16843c1c22bbc23149f58934194d423e9e3e42939780595a2b51b7704b7b2c7b2e4e9aab9d74b0d3f6dacfa9076983f3d8bdee8b4f9d8a6361327b2ca2212ac2faf475567d61e9f1dda2578dc6d82d606ddd18b949ab4f407297434da84da031722ddefb9b0c4d802c12b1fa0f9802119a	2026-06-03 00:55:37.686855	4728035091964362875	1391
868	\\x70726f64756374696f6e3a64617368626f6172645f646174615f65323830363234635f323032352d30312d30315f323032352d31322d33315f7636	\\x001181f51f7e55e887da41ffffffff789c8d56db6edb461035d256b2e49b7c8993b64612b8309a228841cab42c0d8196725ca37673b563b4a81e881539943621b9ca72e954f50ff4a1fdd0fe4567498ab60cd729f420edccd9b99c999dd1e7b3178f614d09c542d74b13252294099f81bbcc53fc1ca764eb398c457d9624cc1799b0910b4364be3eae79223e47a9d02f45cb4364a11aba9e4863c5176029e40116a70a3422a1842c8e644ea8215e1eef162e8380879c294cf812dce3f10dc13dd4eedcdc7bc245ec8e507a182b3640d2aee6764622e41e272b8bb0514824463c8de86218a24761078b3ba6b5d332b73b9d49c209e9799ca492b473a430710f564618fb3c1e5c263e118cd858a42a4961699f0f0ed0e3110bd7cd3618db666bcfda6bee582d0b5bb03c62dc2fc1f67abd430803568ab0aecbd726b9ba03293eaa21795cc9b2191782a0f6d4421356270915d2fa53736fbb43e59c3078797ffdb29097c2464663795cbb42a8a4db59679c0fdcc2f5390b53e4773efc090f2211ab613876257aa9949a0889e7186bf55900cb24a662e46c0978f49cbe01ba59194fd013d2774f30648afcacc39c13091f43af96a1e61cc5fa210a68742586006ff5a906752766111e6dd6339315a8fcf896a0ef43cac8598465478d47d4202c5128056c5ef5442648f72c5301bc60a38afd5d7e455b7619d1941830ef64c9251735984b50f746af0e55eec37cc610fda8e9006045a7ab534b74abc1922791e9ee670aea1fa99529f0c7d3de278902fca2f5cf429626480fc1a1d2f9dcd35ddeab08f8324ff725519100eca3fa88185729ef1003750a8f72755729c9fba9d298f277151664e1c459b2cda3cd2b5155ecc7874494e483a1127077ca4937f62bb0e878431efa9453af2ae0c97fc5fe2645392e3dcedbdf3af76123e7cced632024ba6509cea07640ee7b737c867ff6c55f5bf4459f60bed9ec74cc96493969e8191c4f3b2badbf4035143e05f89647f89b88f159d995d76554d31e55cc75cf9baedb9be9cd08e84e5b255c4cd5a4bb5d9f8d084f765f8b440d249ebe790ef0eae820374a058d463558d275f1b876c6e788b9c463211af423e4115706f1a508fc074560c07d4710b1349f68644d82d7d08c166703561c378dfb34db7cdd6a1a9f134674b93ea3fe6309c184fd7dc6a7fdc399ede4a47df8bb20cd7960779d87f691611f3b5bf6cf86fddcd9823a25467953d36c4cd5f300132f9f4a15e2187f1fc953bb53b5e1e6a6a86709d1809d7742c17cf40db877d9936e3fa5aed08fe99b693e5f4f10fb39a06a6fd103bff6e074ba5445a6939ccd9e5bc36114aa9bbd3967898e128330af8be674c8623fa4daf4eabdaa377b8ad4abe6ed7ea95fa464e39ff28b15fbc4794257eb9950d8bf4e045fdfdcd002ac4f999f400b0f33dafa098b07f83f42cb70d7426becb3847baffaef286b017b9f3271057dd510d58866250e74899470b3c97908ab4e902a5a5834849334a42e5d207eb5e544b7234bc6b177a8472875ed21594886220d7d176982495717df20a5ae8f9e836435f9106a8962ef519b124190a022530dc763de10ddf738a6d35a712a9e2649be9a6ca36217b88ac68adf5bbea039962d8ca3cd8563163f6a1acd5dea419ae02cd29b9ff6de6abe328d4ebbb9d3c2dd8baacd097c88fd126cbf2b6196b56bb5adbd12f682c96958436f51ab6d18ed12d31d5dc3e49bb6b430be457b9cc6d3da952c8c8ed96c99bb6895a8f0161bdd74708bf614473764d06c9b6dabcce095a76e22a3d3b1da1dc32c612fc5f90da6f62ca379698afea7dc148cdeff51c493ac9cae4f336c1696277f9c44c055b060eeb477dbdb460bd6e90f064d53bd07a5d2d34c0fbcb5424855cf455bd02844636492dff9a7fa2f82d66c9f	2026-06-03 03:31:53.078317	-3112774477998008658	1560
806	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30362d3033	\\x00118188d861637488da41ffffffff789c8d953f6b145114c54564934d42501044022ae98c7079ffffec904a52d868b39dc532ecce928dbb467727888c842016a6098105855441f01308565ada889d9fc38f20f8d6f75e3af1740333bf77ee3bf7dc3b57961f53d3eeacd7a34935abcbc9b3f1bda5b517b7f73a570707d3b21eed3fed4d66c335e1b822a73aebfdb2bf5bf5764775377c51d6656fb67f30ed570f366ffe7d33e80d47e3ba9a8687c5db56a7b5d36ddac5a570eaf5706ad10a4709edc9db62a95b2cff0b2bda99ba15a915cec81890d94a4a5c3a470ea5de476ad548454a82d0b049529e4b720ea4c699b28c93d620f5aa49050a4b4681d05186a4212d40e84d82b4d72451e8382b2941ca83d04982ace07826de45a81d2c479b7bd6a4184962a8cc87cc70b2a8091f33a3f1be7ece8c22c941e657ee50802c1abbedc334815c1bb26879f70f73589d21860ec6c3d7b140e19c2634ac276fa39464c6914133343bce8b8531126877bfce13e53cc397c4b7793643877947bbf57d9e02ebe1c06e9ea7f27cd87c1eb5e2eef9c58ed564502b2ea8e03b1ec18d4f89d25ee20b73f025df2b6829d48d2799925e9140e374e3f29d14271d3c44a9ad48ad0a63f15fce8f6b514aa8702d865aa854a238132451ad47552a5069078fd6698416536c49a005bedc4b05fa459ed03df333522bde9145957e3f4ff579177af5df75fb078cda6eb6	2026-06-03 00:36:28.934797	-348718404128945180	699
828	\\x70726f64756374696f6e3a64617368626f6172645f646174615f31623761333031355f323032342d30392d30315f323032342d30392d33305f7636	\\x001181ab15852edf87da41ffffffff789c8d556d6f1b45108e0ab21d276e9c37174a802a51452b447576dabccc49704e43444a4bdba41515feb05adfcdd94bf76ecdee5e8ae94fa8f81ffc347e06b377673b8e0a45fee0dbd9d97979e699998f6b6fefc28655964b1666c6aa04b5110bb0c9432b2e704ed62ad478d2e7c6f048e5c2662194c82377dc08557a81da623415ad0e914b3b64a1ca522b6ab022458ce589de27ca2a3d3b2a3bc4d971b37419c7420a6ed18806dc10e97b82fbd2b96385772354ca46a8434c2d1f20ddae1776464a8a5090951a6c95128d89c8127a2825861476dcd83bf0bcfd7bbb07937c0d5d8bd4649a2e6bfbb8076b234c23910e66494f04233e56993519ac1c89c1318622e172b37d00debdb6b7d739dcddf71ed0fbd51117d154d76fd50f49c183b532a2abf28d499a6ca0d51b3b24876b7922e399607d92c754b239c56c266bcd4a37133673e0a6c78d4b106a7a9d9bba18b0d2e30597198a6b7fbe822f1295daa11c338d61a6b54b5fe305a6ee7aa705ab2426f80b8c14dc7a4cff00ddbc7067182a1db13394dc929f162c05898a50868bb9d65260795fa2826657a30478e14e8b500f529ee0e9763d375981caf72f48f5b5a48c8265580dec784494e0c6a256b07dd91399a0bb87f915c0133eaaf8778b27ce32e30493f16039c893336f1761c9a06343af0e5511c1728e107d2cba0060cda5eb52338e5cb0126ae48eefdc42fd0d919702bf33ef7d9228c0cfeefea1e499c10a3403aa5a2442c7eb5e45c1a745ba3f111406e008ed1bc4b44a794b8ced39dc2aaebbd66ad1cfacd3997e57a1a14b2741c36f9f6e5f8aaae2df3921a0b4180cad82cd3927dd34aac0f5201c0a19514ebdaa82afff2df6e719eaf1d4e3b2ff55d082ad0233d6c7586964d312bc84c56372df5b120be2a377ef6ed31ffde2e54ee7f0b0bdd7a69c9cea4b7834ef6c6afd09daa18a28c01722c15f548a0fa7acbc2aa39af6a8628c5d7418eb2df4161474e7ad925e4ad5a4b7dd888f489fec3e53c60e349e3f7f0cf0f4f4b8304a054d468bb0e2ea120ae74c2c117226e4123dfa902211d623bc2c29ff411178f049a008589a4834a426c13bd51c96e026ac052c4bfb34cd224735a75f004670b18813ffb82135e57f9be3e97ff7d20f0ad0fe9a80166cf9dde073ffd4f31f053bfe8f9eff38d8813a2546791369b6e6ea798c262c66518530c6df47fadc3facfaf07e52d4f384c40a515f2a1e61e4c18d1927593f2356b866da99c7f3d944e3a850a8fab7a9c1af349c4b97aac85d92b5bcdd9a01a75059de7341838e1a6359d4c5613ae46924a936bd7aaf1ad6ce91b8dafe6fbfc417adf9f887e261c53f0beed2d37a2e54feab89e0b3f7135ac1fd0f999fa8961e169cf5339e0ef07f8496eb5d09ad79c48d089ff67fa5ac15ec7fc8c425edcb86a846342b71e04a6415cb27e709ac0771666947d1103699249636085f67d9383a72334ec313374289b52764c10c5526238634c13473c5f7e8d2d5c7cd41b26a7e934e62f96b74a6541c1bb464aa19843c1c227b8d633a6d94a7b235497273b288ca5dc02c8d95a857794b732c5f18a7db8d731cddea789dfbc4419ae03c71bb9ed6dd7abe28f3edbb7b800fdc264a126172c32ca26eaac1ea6469ab58d8b8f14d7b7f7fefde6e075ab4eaa8afdd44d6d6f5956bbd8d5248fe0bd10e344bd118b916d7feaec26a29c84313d7ff011485196e	2026-06-03 00:55:42.082945	-8543253985753202704	1435
838	\\x70726f64756374696f6e3a64617368626f6172645f646174615f33383964366366375f323032362d30312d30315f323032362d31322d33315f7636	\\x001181e6c258dadf87da41ffffffff789c8d56fd6e1b45108f5a64c78e43ecd449a1442504552942896cd78ee33909ce69884868fa91b402e13f4eebbb397bdbbb5bb3bb9762f20cf0223c0c6fc003f014ccde9d9d38b42ef21fbe9df9ed7cfc6676763f5abc7c08552d340b1c37565a842815df8035e66a7e8133b2f514c6c23e538a7982842528a7c20099a77819aaae882e506af43251112a4364811e3aae8823cd73b012701fb3d5029443a185cc9679280b3d4439d5ae652e7d9f079c69547c19eef2e83fc12dc0e7c69d937a575c44ce08a58b916603f48bcdd66eb3057752632311709793a945d8c82412431e87b43b08d0a5d8fd4267ffd1fe2461452a1ea9589262b18e7bb03ac2c8e3d1204b7109aa13c1888d45ac550c2b077c70882e0f59b05edf87da6ebd5e6f365aed766b8f0c54468c7b53b0b5be96405ab556b3b3dfaeb7b005ab596453486665afde2113cdb609a33ac9df1948f1560f8985d524b97126f00b3b2dacc39d497e99b4b8d369eeb6a9c41356aff6af5f15f74a584ea89d2eabd74896b4db2f10bd2d3277317032f7172c8891dffaab04f74311e961307624bab194862389171819f59fb7a142622a524aa480cd27f40fd04dca7b86ae909e738601d3e46b1d96ec507818b88504b5646bd60f5040b92b31007869560528da110bf178ab9898cc41eebb97047d13505676192ab61e8fa87198d228056c5df7442648f73851019cb251cefa2add622c3b8ca8523528d94972eab2004b0a4dbbf48a90e71e941296e8a36002805593ae494d99168415572233a7826928bea516a7c01fce7a9f240af0a3d13f0e58ac3007659bcae771d7747f2f27e0d334dda74485023840fd1631ca53de01fafa1c365375576bc9fbb13698e9771e9665e6c4ae58f5e3ad6b51e5ac87474494e483a116b036e3a41b7939f8d876873cf028a75e5ec0d7ef8bfd458c723cf558b2b6ed7bb09172e6f4d117129d69095e41e190dcf796f802bf2d7f7f407ff4f34b8d46a7439d4e3919e82b38997536b57e8a7a283c0af0250ff16711e1e36967de94514d7b5431c7b968384e6fa1b720a03b6b9570115593f6763d36223cd97d2e941e483c7ff104e0d9f1616a940a1a8e0ab062eae272e38c26c092ad5c16608d3e021e725d23be34817fa3086af0892d88589a5b34ca26c11b68428b7d1f566d278efa34f33cd36a069f124674391ea3fe638a60c2fa26e1d3faf69565a7a4fdfd47469abd6975ed2face39a75626f5b3fd4ac27f636142931ca9b9a6663a69e87a8dc7460e58863fc7524cfad4ede82773745314988af50eb078279e8d5e0ee554f3afd98bac21ca62f67f97c3e411ca480bcf5800ef88d0367d2a52a3293e46272dcca36a3509de4ccd9155a4af483b42e86d3218bbc806ad32bf6f2eee23952afd6e7fba57e91928dbf4f37e6ac337b87b61613a1b07e9a083e7b77430b687ec8fc049a795830d6cf5834c0ff115a82bb115af98029ee3eebbfa6ac05b43f64e21afaba21aa11cd4a1c981269e12493f308eed87eace922a321ace280ba7499f83596956947a6c6917b64462875ed1159504311079e8334c1a4638a5f23a5a98f99836455fd121889666fd09812beaf5093a9b2ed327788ce1b1cd3aa9aadb2a349927b931b29bb0b1c4d63c5eb552e698e2517c6f1d6f2098b361bb5c61ef5204d70169a1701dd83c50e5d83b5cbbcc5097384fd29c67a7d537bcae41c6d77344f7bcac6b3da15a3add30d8dad0c721247b3904a7245b71f35f6f6f0d11414cc8b211eccd19ee3688ef699abe7689f8a8b395a7a99bc4b6baef630e42aa992e3d1682a4065f244123ed77e69a7b1dfd86d74609d9e0e3423cded26b59951668c553321d532156d4339138d91497eeb9ffcbfc5fe6986	2026-06-03 01:07:09.390169	-1114622299311639643	1555
872	\\x70726f64756374696f6e3a64617368626f6172645f646174615f65323830363234635f323032362d30312d30315f323032362d31322d33315f7636	\\x0011816649ac11ed87da41ffffffff789c8d56fd6e1b45108f5a64c78e4becd449a15425045529428d6cc71ff19c04e734442434fd485a81f01fa7f5dd9cbdedddadd9dd4b31790678111e8637e001780a66efce4e1c5a17f90fdfcefc763e7e333bbb1f2d5f3c84aa169a058e1b2b2d42948a6fc13a73353fc739d9460a63e18029c53c41c21294536180cc53bc0c555744e728357a99a8089511b2408f1c57c491e639580db88fd96a09caa1d04266cb3c94851ea19c69d73397becf03ce342abe0a7778f49fe096e073e3ce49bd2b2e22678cd2c548b321fac5666ba7d982dba9b1b108b8cbc9d432dccb2412431e87b43b08d0a5d8fd42776f776f9ab022158f542c49b15cc736ac8d31f27834cc525c81ea54306613116b15c3ea3e1f1ea0cb43166cd4f7a0b6536f779a9dc66eb3dd24039531e3de0c6c6dac279056add5ecee75ea2d6cc15a16d90c925a69d4f76a8d46a3dee99295ea347f6728c55b3d2216d692e42699c02f3e6ab7773a707b9ae04cdc6def34a9c6535a2f0d6c5c56f752584eb89d2dab575896b4db2f10bf2d32773e7432ffe72c8891dff8ab04f74311e951307124bab194862489e71819f59f37a14262aa52caa480cd27f40fd04bea7b8aae909e738a01d3e46b0356ec507818b88504b5626b36085040b92731007869560528da110bf168ab9898cc41eebb97047d13505676192ab69e8ca97398d228056c5df5442648f73851019cb071cefa2add622c3b8ca8523528d94972eaa2002b0a4dbff48b90e71e941296e8a36002803593ae494d991e8455572233c7826928bea51ea7c01fce7b9f260af0a3d13f0e58ac3007659bcae771d7b47f3f27e0d334dda7448502d847fd1631ca53de01fafa0c3653754f6bc907b13698d9771e6ec9cc895db1ea475b57a2ca590f0f8928c987232d607dce492ff272f0b1ed8e78e0514efdbc80afdf17fb8b18e564e6b1646ddb77e15eca9933405f487466257805850372df5fe14bfca6fcfd01fdd1cf2f351add6ebd5da79c0cf4151ccf3b9b593f413d121e05f89287f8b388f0f1ac33afcba8a67daa98e39c371ca7bfd45f12d09bb74ab888aa497b7b1e1b139eec3e174a0f259ebd7802f0ece820354a050dc70558357571b971462360c5562e0bb0461f010fb9ae115f9ac0bf510435f8c416442c0d2e9a65d3e00d34a1c5be0f6bb61347031a7a9e6935834f0923ba1c8f51ff314530617d93f0697dfbcab253d2fefe2323cddeb47af617d651cd3ab6b7ad1f6ad6137b1b8a9418e54d4d736fae9e07a8dc7462e58863fc752ccfac6ede82773745314988266fc90e04f3d0abc19dcb9e7406317585394c5fcef3f97c8ad84f0179eb011df06b07cea44b556426c9e5e4b8956d46a13ac999b32bb494e807695d0ca723167901d5a65fece7dde533a45ead2ff64bfd22259b7c9f6ecc59a7f623da5a4c84c2fa692af8ecdd0d2da0f921f35368e661c9583f65d110ff476809ee5a68e57da6b8fb6cf09ab216d0f990892be8ab86a846342b71684aa485934cce43b86dfbb1a69b8c86b08a03ead25bc4afb1ac4c3b323589dc433342a96b0fc9821a8938f01ca409261d53fc1a294d7dcc1c24abea97c048347b83c694f07d859a4c956d97b92374dee08456d56c951d4d92dc9dde48d95de0681a2b5ebf7241732cb9308eb66e1db368b3516bb4a9076982b3d03c09e8222c76e91eac5de42d4e98431ccc30d6ebebda132617687be345da133699d7ae1a6d9dae686c6590e3389a8754923bbab3db68b77177060a16c5100f1768cf70bc40fbccd50bb44fc5f9022d3d4ddea535577b18729554c9f1683415a0327d23099f6bbff4a8b1d7d8697461839e0e3423cded26b59951668c553321d532156d4339134d90497ee39ffcbfeb106992	2026-06-03 04:52:42.698004	-4384236674628181161	1558
841	\\x70726f64756374696f6e3a64617368626f6172645f646174615f33383964366366375f323032342d30312d30315f323032342d31322d33315f7636	\\x0011812c32e8dbdf87da41ffffffff789c8d56dd6f1b45108f4a65274edcd8f92a940055a28a5688e8ecc45f73129cd31091d0f4236905aa1f4eebbbb1bdedddadd9dd733179e605f1cebfc89fc1ecddd98ea390223ff876e6b7f3f19bd9d9bdbb78f91836b4d02c70bd586911a2547c013699a7f908e7645b298c855da614f345222ca5c200996f961b9e88462835fa535179802cd003d71371a479195603dec36c45fb43a1859c2d851ee06cb999b9ecf578c09946c58b709f473704f79571e7a6de1517913b44e961a4591f49bb9eda198a807b9cac94613b93480c791cd2c620408fc2eeddab369a56a3b9d7aa4f1256a4e7918a2569972b7b8d036cc0da10239f47fd59e213c1908d45ac550cab87bc7f841e0f59b0556982b557a9540eaab546a356c73a94878cfb53b0bdb59642ac56ad728007b09685f75ffa8d49ee6e5f8a0f7a4011ac25d98d6782f5497253c9e694c8996c6b56cf99b094b0395d6e5ce155d2eec4d4a8ef661e472c8891dff9e32d7c198a480f82b12bd18ba5347c481c6194a9cb24a69aa4a40978f88cfe01da4935cfd113d277cf31609afc6cc1b2130a1f036f29412d3b9a750314506a4b0c005e9bd512149c888578b253484ce620f7c36b82be0f28236705ca8e1e0fa94f98d22805ec5cf5442648f73451019cb161ce7e926e31965d4634290b569c243975b904cb0a4d8b740a90e73eac240cd1c7920900d64cba2635653a0e563d89cc1c02a6a1f0813a9a027f3cef7d9228c0cf46ff3460b1c21c941caa9acf3dd3ec9d9c80cfd2749f13150ae010f507c4284f7907d8d317f03055b7b596bc1b6b83997ee7a12833274ed1ae9cec5c892a673f3e26a224ef0fb480cd3927edc8cfc13dc71bf0c0a79c3a7901dffc57ecaf6294e3a9c715fb6b670bb653cedc2ef68444775a8237b07444ee3bcb7c817ff2f79f8fe88f7ebd956ab5d5aad42b949381be81d3796753eb67a807c2a7005ff310df8a089f4ebbf2ba8c6adaa18ab9eea8eaba9d85ce8280f6bc55c245544ddadbf6d990f064f7a550ba2ff1e2d53380172747a9512a68385c825553178f1b677c9998531e0bd0a28f80875c5bc49726f0ef1481059f3a8288a53145936b12bc8126b4380f60cd71e3a84b23ce37ad66f029614497eb33ea3fa60826ecef123eedefdfd84e4adaddbf32d29c6dbbed7c619f58f6a9b36bff64d9cf9c5d285062943735cdf65c3d8f5079e970ca11c7f8db505ed8adbc0d373745214988af52eb0782f9e85b707fd6936e37a6ae308769779ecf9713c4610ac8db8fe8805f3b70265daa2233492e26c7ade4300ad54dce9c53a4a5c45e90d6c5703a60911f506d3a854ede5bbc40ead5caed7ea95fa464e31fd38d39fbdc79425b0b8950d8bf4c049fdfdcd0020e3e667e02cd3c2c18ebe72ceae3ff082dc15d0bad74c814f75e74df51d6021a1f3371057dd510d5886625f64d89b47093c9790ceb4e2fd6746fd1105671405d5a247e8d6565da91a971e41d9b114a5d7b4c16d440c481ef224d30e99ae25ba434f5317390acaa5f0323d1ec3d1a53a2d753a8c954c9f1983740f73d8e69b591adb2a3499207938b28bb0b5c4d63c5ef942f698e2517c6c94ef194450fab56f5807a9026380bcd0380aebd428b6e3deb326f73c21c63778ab1df5dd79e31798bb63dbc4d7bc6c6b7684fe3685e9b5ec6ad4ab55ea9e1c11415dce63feedfa2bdc0e1bc763df1506f5a5663bf89b50cf6c2d337c11afbb5d67eab35853d17a39b60b566a3be4faf97098c1e2737a5556f12b0813573eb87215749115d9f26d7229427af26d1e3ba57fcb65aaf37f7ac266cd1b38266a8b9fda43633cc8cb98d4c48b54e45bb50ca44636492dff927ff2f1d616bdd	2026-06-03 01:07:15.631153	4440607538269884670	1539
844	\\x70726f64756374696f6e3a64617368626f6172645f646174615f63316232343232645f323032362d30312d30315f323032362d31322d33315f7636	\\x001181ab8b92dee087da41ffffffff789c8d56fd72db4410cfb48c1d3b0eb1532785524a08d349192619dbb19d783503721a322434fd48da81c17f68ced2cabe56d299bb538ac933c08bf030bc010fc053b027c94e1c8acbf80feb767fb71fbfdddbbb0f162f1f41550bcd02c78d9516214ac53f8535e66a7e8133b2f514c6c23e538a7982842528a7c20099a77819aaae882e506af43251112a4364811e3aae8823cd73b012701fb3d5029443a185cc9679280b3d4439d5ae652e7d9f079c69547c19eef2e85fc12dc067c69d937a575c44ce08a58b916603f48bcdd64eb3057752632311709793a945b89f4924863c0e697710a04bb1fb85cefeeefe2461452a1ea9589262b18e6d581d61e4f16890a5b804d58960c4c622d62a8695033e384497872c58afef436da7ded8dd6db71a7b8d3619a88c18f7a6606b7d2d81b46aad66677fafdec216ac66914d219995bddd4ebd556f364d18d549fece408ab77a482cac26c98d33815fd86e611dee4cf2cba4c5ed4e73678f4a3c61f56afffa5571af84e584dae9b27a8d6449bbfd02d1db2273170327737fc18218f9ad3f4bf02014911e066347a21b4b69389278819151ff711b2a24a622a5440ad87842ff00dda4bc67e80ae9396718304dbed661c90e8587815b48504bb666fd000594bb12038097665580a21db1108f378b89c91ce4be7d49d03701656597a162ebf1881a87298d52c0e6754f6482748f1315c0291be5ac2fd32dc6b2c3882a5583929d24a72e0bb0a4d0b44baf0879ee412961893e0a26005835e99ad494694158712532732a9886e25b6a710afcd1acf749a2003f18fde380c50a7350b6a97c1e774df7f772023e4ed37d4a54288003d46f11a33ce51da0afcf61235577b596bc1f6b83997ee76159664eec8a553fdebc1655ce7a744444493e186a016b334eba9197830f6d77c8038f72eae5057cf55fb1bf88518ea71e4bd6967d0feea79c397df48544675a8257503824f7bd25bec06fcbdf1ed21ffdfc52a3d1e9d4db75cac9405fc1c9acb3a9f553d443e151802f79883f89081f4f3bf3a68c6adaa38a39ce45c3717a0bbd0501dd59ab848ba89ab4b7ebb111e1c9ee73a1f440e2f98b2700cf8e0f53a354d0705480155317971b673401966ce5b2006bf411f090eb1af1a509fc2b4550838f6c41c4d2dca2513609de40135aec07b06a3b71d4a799e7995633f89430a2cbf118f51f530413d6d7099fd637af2c3b25edafdf33d2ec0dab6b7f6e1dd7ac137bcbfabe663db1b7a0488951ded434f767ea7988ca4d07568e38c65f46f2dceae42d787753149384f80ab57e2098875e0dee5ef5a4d38fa92bcc61fa6296cfe713c4410ac85b0fe980df3870265daa2233492e26c7ad6c330ad549ce9c5da1a5443f48eb62381db2c80ba836bd622fef2e9e23f56a7dbe5fea1729d9f8bb7463ce3ab3b7696b31110aebc789e0937737b480e6fbcc4fa099870563fd8c4503fc1fa125b81ba1950f98e2eeb3fe6bca5ac0defb4c5c435f374435a259890353222d9c64721ec11ddb8f355d643484551c50972e13bfc6b232edc8d438728fcc08a5ae3d220b6a28e2c073902698744cf16ba434f5317390acaa9f0323d1ec0d1a53c2f7156a3255b65de60ed17983635a55b355763449726f7223657781a369ac78bdca25cdb1e4c238de5c3e61d146a3d668530fd20467a17911d03d58ecd03558bbcc5b9c3047d89f62acd737b5a74cced17647f3b4a76c3cab5d31da3addd0d8ca202771340ba92457f4de6ea3ddc6dd29289817433c98a33dc7d11ced3357cfd13e151773b4f4327997d65ced61c8555225c7a3d15480cae489247caefdd27663bfb1d3e8c03a3d1d68469adb4d6a33a3cc18ab6642aa652ada8272261a2393fcd6dff97f0068b2697b	2026-06-03 01:24:30.292808	7850406167242766681	1558
894	\\x70726f64756374696f6e3a64617368626f6172645f646174615f35376133663935335f323032362d30312d30315f323032362d31322d33315f7636	\\x0011819475a59e1988da41ffffffff789c8d56fd72db4410cf14c68e1d97d8a99342e99410a693324c3bb612c7f16a06e434644868fa91b40383ffd09ca5957ded49674e271793678017e16178031e80a7604f929d381497f11fd6edfe6e3f7ebbb7771f2e5f3c80ba969a09d74b622d435431bf0febccd37c8c73b28d0cc6c23e8b63e64b1256a09a0905323fe655a87b321aa3d2e8e7a232d486c8841eba9e4c22cd0bb02a7880f96a09aaa1d452e5cb2254a51ea29a69d7739741c005671a8d8bdb3cfa57704bf09971e766de632e237784cac348b30106e5ddd6a3dd16dcca8c8da4e01e2753cb703797280c7912d26e21d0a3d88352677f677f9a704c2a1ec58922c57213f7606d8491cfa3419ee20ad4a782119bc844c709ac1ef0c1217a3c6462a3b90f8d47cd8ed569b7acceae45066a23c6fd19d8de584f21ad466bb7b3df6eb6b0056b7964334866c5dadd6959ade65eab4d56ead3fcdd81926ff59058584b939be48260f9619bd29ea6371376da54df29a5979b372e2b7b29aca6bcce96f52b0c2bda1d9488db16991b0fdcdcf7988904f98d3f2b702f94911e8a89abd04b943204291c6364d47f7c00351253853216256c3ea17f806e5adb33f4a4f2dd33144c93af0d587142e9a3f04a296ac5d1ac2f5042b5ab5000bc34ab12949d888578bc554e4d16a0f0ed4b82be11949553859aa32723ea1a166b5412b6ae7a2213a47b9caa004ed9a8607f996d31965d4654c50da8386972f14509566234bdd22b4391fb504959a28f920900d64cba26b5d8f41fac7a0a9939124c43f92df53705fe60defb3451801f8cfeb160498c05a83a543c9f7ba6f57b05099f64e93e252a628003d46f11a322e52d30d0e7b099a9bb5a2bde4fb4c1ccbe8b7053e54e9c9add3cdeba1255c17e704444293e186a09eb734eba915f808f1c6fc8854f39f58a12befaafd85f24a826338f157bdbb9037733cedc3e0652a13b2bc12b281d92fbde0a5fe21fa8dfeed31ffd828a65753acdbd26e564a0afe064ded9ccfa29eaa1f429c0973cc49f64848f679d795d4635ed51c55c776cb96e6fa9b724a13b6f9570115593f6767d36223cd97d2e633d5078fee209c0b3e3c3cc2815341c9560d5d4c5e3c6191dff1527f698c0067d081e72dd20be34817fa5081af0b12389581a5a34c7a6c11b684a8b730fd61c3789fa34f07cd36a069f114674b93ea3fe6331c1a4fd75caa7fdcd2bdbc948fbebf79c3467d3ee3a9fdbc70dfbc4d9b6bf6fd84f9c6d285362943735cdddb97a1e62ec65d3aa401ce32f23756e778a36bcbb29ca69427c955a5f48e6a3df80db973de9f613ea0a7398be98e7f3f9147190018af67d3ae0d70e9c4997aac84c92cbe971ab3a8c4275d333e7d468a93010595d0ca74316f9826ad32bf78adef23952af3617fba57e518a4dbecb3616ec33e7216d2da74269ff38157cfaee8696b0fb3ef35368ee61c9583f63d100ff476829ee5a68d5031673ef59ff35652da1fd3e1357d0570d518d6856e2c094484b379d9c4770cb09124db7180de13811d4a537895f633936edc8e249e41d99114a5d7b4416e2a14c84ef224d30e59ae2374869ea63e620598d7f1646a2d91b34a66410c4a8c954d5f1983744f70d4e6855cf57f9d124c99de97d94df05aea6b1e2f76a1734c7d20be378ebe6098b36ad86b5473d48139c85e639409760b9437760e3a26873c21c617f86b15f5fd79e32b540db1d2dd29eb2c9bc76d5689b743d632b879c24d13ca496decfed1d6b6f0f776620b1288664b0407b8ea305da679e5ea07d2ac70bb4f42c7997d65ced61c8e3b44aae4fa3a904b5e9fb48065c079587d6bef5c8eac0063d1d68469adb4d6933a3cc18abe742aa6526da866a2e9a2053fcc6dfc57f003b5c68db	2026-06-03 17:33:02.588404	-7821140429624936724	1553
897	\\x70726f64756374696f6e3a64617368626f6172645f646174615f35376133663935335f323032352d30312d30315f323032352d31322d33315f7636	\\x001181c1c638af1988da41ffffffff789c8d56db6edb461035d256b2653b962f71d2d648021746530431485ad721d0528e6bd46eae768216d503b12247d2262457592e9da87eed63fba1fd8bce921465196a12f8c1dad9b36766cecccef2cbc5cb07b0a5846281eb25b11221ca982fc02de6297e8133b6ed0cc6c21e8b63e68bd458cd8c01325f2fb73c115da054e817a6f521b2400d5d4f2491e255580b781ff35509aaa15042e64ba2136a88d3e5addc65bfcf03ce14c674fe368fe604774fbb7333ef3117913b42e961a4d800697733e31989807b9c58d66127b7480c7912d2c120408fc2eedf3c681a96d5d83f684d128e699f4771226977d9dab74c6cc2c608239f478369e213c3888d45a2e204d60ef9e0083d1eb260db6c81b16fb6ad76b36eb56b1636607dc4b85f80eded4a9b10066ce4615db76f4d72750752bc5743f2b8916633ce0dfdc547561d3627f9e4c6a547adfd261573a2dff4f4f6b48c53633515b1586e5d9153d2e9b42f2e066eeef8820509f21b7f7d80bba188d43018bb12bd444a2d83c40b8cf2ed7532532932ad04dc7f42ff013a6911cfd013d277cf30608afc6cc3b2130a1f036f29452d3b8af5021450ed480c005ee9d512549c888578b25b49294b50faf91541df0694917313d61d351e517bb058a114b07bd51351d0dee3740be0291b95ec1fb2239ad96524536cc08a9326175f2ec1728cba33ba1528731f565285e8c7920e003674ba3ab558371aac791299ee7da6a0f29e1a99027f30eb7d9228c06f7aff71c09218e91a3854399f7bbac7bb25015f67e93e232962804354ef11a332e51d605f9dc3fd6cbba394e4bd44694cf1bb0cab3277e2acd9e6c9ee95a84af68363124af2c15009b835e3a413f925b8e978431ef89453b72ce0e1ffc5fe3241392e3caed8df3b776027d3cced615f48748b12bc86a52372df5de60bfc8baffedea37ff4d75fb1ac76db6c98949386be86d3596705fb535443e15380af78887f88081f175d79dd4635ed52c55cf7c272ddee4277414067969570115593ce767c36223cf1be10b11a483c7ff904e0f9c951464a050d474bb0a6ebe271ed8c2f9372b1c70234e847c043ae0cd24b11f84f8ac0803b8e2061693ad1c09a04afa1a92cce0e6c386e12f568b2f9bad5343e138ce4727d46fdc7628209fbc7544ffba7d7b69389f6ee9f5c34e7aedd71eed927867deaecd9bf1af613670f2a9418e54d4db33353cf238cbd6c26954863fc3092e776bb6cc3fca6a8a409f1356afd40301f7d036e4f7bd2ed25d415fa327d37abe78b09e2300394ed3dbae0d72e9c4e97aac874928be975ab3a8c4275d33be7acd152623fc8eaa2351db2c80fa836dd4ab7ec2d9e23f5aaf971bfd42f52b2f12fd9c1927de63ca4a395d428ecdf27866fe737b480daa7e827d0dcc382663f63d1003f23b414772db4ea218bb9f7bcf786b216d0fc14c515f45522aa11cd4a1ce81229e1a693f318369d7ea2e8b9a2211c270175e92ae9ab9963dd8e2c1e47deb11ea1d4b5c7c4100f4512f82ed20493ae2ebe419bba3e7a0e126bfc2ed016c5dea2a612fd7e8c8aa8aa8ec7bc21ba6f714cabad7c955f4db27c33798cf2b7c0553456fceefa25cdb1f4c138d95d3d65d17dcbb0ead48334c159a8df7d7af536b307d368b7ac8306d62fcb3627f031f60ab0fda680355a8d76bdd62c604f999c8555f51bda349ba659603aa36b98ec9d2d18c61fd93d4da2d9dd8d348cb66935cc3ad60a54f0118e4e3298c7d132ccda41bbe038c7d19c4cac96d9aa15993cf7d43c51daed5aab6d4c137e262ee6895233ac29157dadcc0b597f0784218fd3b2ba3ecdb245589f7c3e893e57fd55d3acd59bfb4d0bb6e94383a6aa7e0fa5d2534d0fbeaddc48d5cf4c7b50cd4d636492dff8b7fc1f6ccd6e2a	2026-06-03 17:34:08.890855	2616734472928749332	1563
900	\\x70726f64756374696f6e3a64617368626f6172645f646174615f30633866646237325f323032362d30312d30315f323032362d31322d33315f7636	\\x001181430e26e91a88da41ffffffff789c8d56fd72db4410cf948e1ddb29b15327a55068264c431920633bb11daf66404e438684a61f493b30f80fcd595ad9d79e74e6747231790678029e8d07e029d89364270eadcbf80feb767ff7dbcfdbbb9bcb170fa1aaa566c271e348cb0055c4b7619db99a8f714eb691c258d06751c43c49c21528a74281cc8b7805aaae0cc7a8347a99a804952132a1878e2be350f31cac0aee63b65a827220b554d97219ca520f51cdb4eb9949dfe782338dc6c41d1efec7b925b86fcc39a9f588cbd019a17231d46c80fe7213eb703ba51a49c15d4e4405b8974914063c0e68af10e892e77ea1b3bfbb3f0d3722150fa3589162b98e2d581b61e8f170300bb03a158cd844c63a8a61f5800f0ed1e501131bf57da8ed346aed56b3dededf6b104165c4b837035b1beb09a4596bee75f6dbf52636612df36c06c9589afb8d5abdd56cb689a53a8dde1928f9460f29076b4970934ce017bf69b576da707b1ae04cdc69ec34a9c2d3a45e126c5cd6f652584e323b5b56afe458d16e3b4754e38193d91e331123bff157013e0b64a88762e2287463a54c82148e3134ea9b05a89098ea936651c2e663fa07e826953d43572acf3943c134d9d980921d480f855b4850255bb3be4009e5ae4201f0c2ac0a50b44316e0f15631a1cc41eefb17047d2d28227b152ab69e8ca86758a45149d8ba6a892848f72851019cb251cefa32dd62981d46698a6ab06227c14517052845687aa557843cf76025c9107d148c03b066c235a145a6fb60d555c8cc81601a8a6fa8bbc9f187f3d6a78102fc64f48f048b23cc41d9a6d279dc358ddfcb49b89b86fb845211011ca07e8318e6296e81be3e87cd54ddd55af17eac0d66f69d875b2a336297adfaf1d615af72d6c3234a94e283a196b03e67a41b7a39f8d076875c7814532f2fe1ab77f9fe3c463599595cb1beb0efc2bd34674e1f7da9d09995e025140ec97cafc497f807ea8f07f4473f7fa5d1e874eaad3ac564a02fe164ded88cfd14f5507ae4e00b1ee02f32c447b3aebc2ea39af6a8628e336e384e6fa9b724a13bcf4ab890aa497bbb1e1b119e789fc9480f149e3f7f0cf0f4f83025a58206a302ac9abab8dc18a3e35fb2239709acd187e001d735ca9726f0efe4410d3eb225259646164db1a9f3069aa4c5fe14d66c270efb34ee3cd36a069f268cd2e5788cfa8f450493d6b7493eadef5e5a769ab4bfffcc9266dfb7baf6a6755cb34eec6debc79af5d8de862205467153d3dc9babe721466e3aad729463fc6da4cead4ede82b73745310988af52eb0bc93cf46a70e7b2279d7e4c5d610ed3e7f3f97c36451ca480bcf5800ef8b50367c2a52a3213e47272dcca3623579de4ccd9655a2af4455a1793d3210b3d41b5e9157b7977f91ca957eb8bed52bf28c5263fa41b73d699fd356d2d264269fd3c157cf2f68696b0f73efa2934b3b064d8cf5838c0ffe15a82bbe65af98045dc7dda7f45514b68bf8fe20afa2a11d58866250e4c89b47492c97904b76d3fd6748bd1108e62415d7a8bf26b9823d38e2c9a84ee9119a1d4b547c4100d652c3c07698229c714bf464a531f33078935fa55188966afd15049df8f501355d976993b44e7354e6855cd56d9d124c9c7d3db28bb0b1c4d63c5eb552e688e2517c6f1d6ad13166e366a8d16f5204d701698c7005d82c50edd81b58bbcc5097384fd19c67a755d7bcad4026d77b4487bca26f3dab2d1365a9dd61e3633cc491cce632ac905ddde6db45ab83b0389454ec48305da731c2dd03e75f502ed13395ea0a577c9dbb4e65e0f021e2565723c9a4d74454f1f48d2e7da2fedb6f7765a6dd8a06703cd4873bb296d66941963d54c48b54c45db50ce4413648adff827ff2fda3a67a3	2026-06-03 17:55:04.597951	-1370451142948692999	1547
905	\\x70726f64756374696f6e3a64617368626f6172645f646174615f37343230663336625f323032362d30312d30315f323032362d31322d33315f7636	\\x001181188c3eca1c88da41ffffffff789c8d56fd6e1b45108f0ab2633b25b6eba4502a0841558a5023dbb11d7b4e82731a22129a7e24ad40f88fd3fa6ecedef6eed6eceea5983c033c0b4fc403f014ccde9d9d381417f90fdfcefc763e7e333bbb1fae5e3e849a169a058e1b2b2d42948aefc0067335bfc005d9660a63e19029c53c41c23528a7c20099a778156aae882e506af432d11a54c6c8023d765c11479ae7603de03e66ab152887420b992d0b50167a8c72aeddc85cfa3e0f38d3a87805eef2e85fc1adc0e7c69d937a575c44ce04a58b916623f48bedbddd6e1beea4c62622e02e275345b89f4924863c0e697710a04bb1fb855e77af3b4b58918a472a96a4586d6007aa138c3c1e8db2144b509b09266c2a62ad62583fe0a3437479c882cd4617eabbcdfa7eafdbd86bb69a64a03261dc9b83adcd8d04d2aeb75bbdee7ea38d6da86691cd21999576b7bdd768f4dafb64a536cbdf1949f1568f89856a92dc3413f8c547edeeee1edc99253817f79abb4daaf18cd62b039b57d5bd1296136ee7cbda359625edf60b865f3277317232ff172c8891dffa330f9f8522d2e360ea487463290d49122f3032ea51012a24a62aa54c0ad87a42ff00fda4be67e80ae9396718304dbe36a16487c2c3c02d24a892add9304001e5bec400e0a55915a068472cc4e3ed62623207b9ef5e12f44d4059d965a8d87a3aa1ce614aa314b07ddd139920dde3440570ca2639ebab748bb1ec30a24ad561cd4e92539705282934fd3228429e7bb096b0441f051300544dba2635657a10d65d89cc1c0ba6a1f8967a9c027fb8e87d9628c08f46ff3860b1c21c946d2a9fc75dd3fe839c804fd2749f12150ae000f55bc4284f7907e8eb73d84ad57dad251fc6da60e6df79b82d332776c56a1c6f5f8b2a673d3c22a2241f8db5808d0527fdc8cbc147b63be68147390df202befeafd85fc428a7738f6bd68e7d0feea79c3943f48544675e8257503824f783125fe11fc8df1fd01ffdfcb566b3d76b741a949381be8293456773eba7a8c7c2a3005ff2107f16113e9e77e64d19d5744015739c8ba6e30c56062b02fa8b5609175135696fdf6313c293dde742e991c4f3174f009e1d1fa646a9a0e1a400eba62e2e37ce6804946ce5b200ebf411f090eb3af1a509fc1b4550878f6d41c4d2e0a259360bde40135aeccfa06a3b7134a4a1e7995633f89430a2cbf118f51f530413d637099fd6b7af2c3b25edaf3f32d2ec2dab6f7f611dd7ad137bc7faa16e3db177a0488951ded434f717ea7988ca4d27568e38c65f27f2dceae52d787753149384f83ab57e2098875e1dee5ef5a4338ca92bcc61fa7291cfe733c4410ac85b0fe880df3870265daa223349ae26c7ad6c330ad549ce9c5da1a5443f48eb62381db3c80ba83683e220efae9e23f56a63b95fea1729d9f4fb7463ce3ab31fd1d6622214d64f33c1a7ef6e6801adf7999f41330f2bc6fa198b46f83f424b7037422b1f30c5dd67c3d794b580fdf799b886be6e886a44b31247a6445a38c9e43c823bb61f6bbac96808ab38a02ebd4dfc1acbcab42353d3c83d322394baf6882ca8b18803cf419a60d231c5af93d2d4c7cc41b2aa7e098c44b337684c09df57a8c954d976993b46e70d4e6955cb56d9d124c9bdd98d94dd058ea6b1e20d2a9734c7920be378fbf6098bb69af566877a9026380bcd93802ec2628feec1fa65dee28439c2e11c63bdbea93d657289b63f59a63d65d3456dd9689b9d5ea785ed0c7312478b986a7249377a8d56a783ad392a5816453c5aa23dc7c912ed33572fd13e15174bb4f4387997d65cee61c8555227c7a3e14477f4ec95247caefdd2de7e6bb7b30f9bf476a02169ae37a9cd903273ac9609a998a96807ca99688a4cf25b7fe7ff0117cd6993	2026-06-03 18:27:08.98364	1496195486983356850	1555
906	\\x70726f64756374696f6e3a64617368626f6172645f66696c7465725f696e646570656e64656e745f323032362d30362d30335f7633	\\x0011813e68619d1c88da41ffffffff789c8d945d4fd35018c74dd4b117c6803188a0a1d90dc41872ce69d7d397abeac095d9b98c0121c42c653bb0c6ed74f605c5257e03aff0ca8498e017f02370c735d7fa05fc169e957640445cd2643dfdfff7fff5397dcef320de9f50661d42c97bb3d368f9a4d1b47dea593165c1214d42bdce51837ce8590e69854a5cc94676d7333ddfedc7f5fc786df088b4624a6cb56edd630faa84b62c7a1053e3752bc6d6ab9721c1fa89b2d0b33b56d322ee653833365cdba60c3b17d1bcb6e536ba3665bff794f90869f77ab6e3f9d4f2d89f993073f9968d286f37d34f2a09efa847f4fc8c617bb6c3e9d4f51d9336c980ada49bbeebd95de2e8f92983ab725bfafa6aa558d302713a88396a50bfbb3770e4440830823c403c0700bb02d778cf215dcbefee272094909268991ed17d2551b7ba24ed7c593cfb2c7d7b1b53121f6d4a403fa9a66f7f157542cfa7b41dadc219c132a3e71f011960007888c42a04a8807954100271723f09450109ea94eeabd3e9778cb2bdb6f433a6664342ae44cc8ed7fe1b91296f1a5a4de334ae16613298e7011021c252183e2e0128acf072184f59fce2c4c9c351e24baf2b15ad5ad5b88d287e16490508212a00c0aa11317e1695800428e090411823f9fbf8cd088c5cb9a66f942a1a676cd6eaa51dae1c91721808859024f110477b358e56902811e11a6aed576f7904d49c567b51d2186a8b11b7d94dbd14c1a6f4e21600084900c86858118f017f0db374311d1b0193bd8ae75e5ed533b3a1d5b6b41260f508acf3e4882230a614529a8cf2e3fec1a72bcabf9a2b5be1b4a25e611f9f359956197efd22db1b19c83ce6c3fc14ebb315510c01550678bcfcf5fcff805c992b3b96dba62657754cd76cdd40f07241167088886380c27c83e59f1fee5e5ce5675f59fbe496d6dab10f88db363963d85ae93216b1284a20da192c80e1a1383d5e3cfb7efaf46410accc8787b4e1904342d95cf3d80869eda6fa634a32982a2c6cdda41c02480c4e75caec0ee69baf649e5b0745d2b4ba6627292b6005f4c7d41c73af91bda15b9df5d5b91baa613a77a85aef2ed5308f6eaa93031589b2289042e859f7e94dcf34949809ca50104522280bd1dc1c4ed6705cff014ce49260	2026-06-03 18:27:09.524466	99552063939393846	1019
920	\\x70726f64756374696f6e3a64617368626f6172645f646174615f63616437316337365f323032352d30312d30315f323032352d31322d33315f7636	\\x001181164f7af54c88da41ffffffff789c8d56db6edb461035d256b2653b962f71d2d648021746530431485ad66508b494e31ab59bab9da045f540acc891b409c955964b25aa5ffbd87e68ffa2b3244559869a047eb076f6ec999933b3b3fc72f1f2016c29a158e07a49ac448832e60b708b798a8f70c6b69dc158d86571cc7c911aab993140e6ebe59627a2114a857e615a1f200bd4c0f54412295e85b580f7305f95a01a0a2564be243aa106385ddeca5df67a3ce04c614ce76ff3684e70f7b43b37f31e7311b943941e468af5917637339ea108b8c789651d76728bc49027211d0c02f428ecdecd83866159f5fd83e624e198f6791427927697ad7dcbc4066c0c31f279d49f263e310cd958242a4e60ed88f78fd1e3210bb6cd2618fb96d16835cd03ab66611dd6878cfb05d8deaeb40861c0461ed675fbd62457b72fc57b35208f1b6936e3dcd05b7c641dc2e6249fdcb8f4a8b9dfa0624ef49b9ede9e96716aaca62216cbad2b724a3a9df6c5a8efe68e472c4890dff8eb03dc0d45a406c1d895e825526a19248e30cab7d7c94ca5c8b41270ff09fd0768a7453c474f48df3dc78029f2b30dcb4e287c0cbca514b5ec28d60d5040b52d310078a5574b50712216e2e96e25a52c41e9e757047d1b5046ce4d5877d47848edc1628552c0ee554f44417b8fd32d80a76c58b27fc88e686697914cb1012b4e9a5c7cb904cb31eacee854a0cc7d584915a21f4b3a00d8d0e9ead462dd68b0e64964baf79982ca7b6a640afcc1acf749a200bfe9fdc7014b62a46be050e57ceee91eef94047c9da5fb8ca488018e50bd478cca9477803d7501f7b3edb652927713a531c5ef32accadc89b3669ba7bb57a22ad90f4e4828c9fb0325e0d68c9376e497e0a6e30d78e0534e9db28087ff17fbcb04e5b8f0b8627fefdc819d4c33b78b3d21d12d4af01a968ec97d67992ff02fbefa7b8ffed15f6fc5b25a2db36e524e1afa1ace669d15ec4f510d844f01bee221fe21227c5c74e5751bd5b4431573dd91e5ba9d85ce8280f62c2be122aa269d6dfb6c4878e27d2162d59778f1f209c0f3d3e38c940a1a0e97604dd7c5e3da195f26e5628f0568d08f80875c19a49722f09f148101771c41c2d274a28135095e4353599c1dd870dc24ead264f375ab697c2618c9e5fa8cfa8fc50413f68fa99ef64faf6d2713eddd3fb968ce5dbbeddcb34f0dfbccd9b37f35ec27ce1e542831ca9b9a6667a69ec7187bd94c2a91c6f861282fec56d986f94d514913e26bd4fa81603efa06dc9ef6a4db4da82bf465fa6e56cf1713c4510628db7b74c1af5d389d2e5591e92417d3eb56751885eaa677ce59a3a5c45e90d5456b3a60911f506d3a954ed95bbc40ea55f3e37ea95fa464e35fb28325fbdc7948472ba951d8bf4f0cdfce6f6801b54fd14fa0b98705cd7ecea23e7e466829ee5a68d5231673ef79f70d652da0f1298a2be8ab4454239a95d8d72552c24d27e7096c3abd44d1734543384e02ead255d25733c7ba1d593c8ebc133d42a96b4f88211e8824f05da409265d5d7c8336757df41c24d6f85da02d8abd454d257abd181551551d8f790374dfe298565bf92abf9a64f966f218e56f81ab68acf89df54b9a63e98371babb7ac6a2fb96611d520fd20467a17ef7e9d5db4c1f4cd36835ad833a1e5e966d4ee013ec1660fb4d01ab37ebadc35aa3803d65721656d56f68c36c986681690faf61b277b660187f64f72c89667737d2305aa655370fb156a0828f70b493fe3c8ea661d60e5a05c7050ee7646235cd66adc8e4b9a7e689d26ad59a2d639af033319a274acdb0a654f4b5322f64fd1d10863c4ecbeafa34cb16617df2f9247a5cf5564db376d8d86f58b04d1f1a3455f57b28959e6a7af06de546aa7e66da836a6e1a2393fcc6bfe5ff00ffa86e1e	2026-06-04 08:09:13.91584	8174695645966171052	1565
923	\\x70726f64756374696f6e3a64617368626f6172645f646174615f63616437316337365f323032342d30312d30315f323032342d31322d33315f7636	\\x00118119d2a5ff4c88da41ffffffff789c8d56dd6f1b45108f4a65274e4c9cc471a104a81255b44254e7af389e93e09c868884a61f492b107e38adefc6f6b677b766772fc5e49137c43bff22ff033c307b77b6e3284d2b3ff876e6b7f3f19bd9d9bdbd78f100ca5a6816b85eacb408512abe009bccd3fc1ce7649514c6c21e538af9221196526180cc37cbb227a273941afda9686d882cd043d71371a4f926ac06bc8fd98af687420b395b0a3dc4d9723373d9eff380338d8a97e00e8fae09ee4be3ce4dbd2b2e227784d2c348b301927623b5331201f73859d984ad4c2231e471481b83003d0abb5f6c58cd46a3fea835c957919a472a96a45cae3fb21ad882f511463e8f06b3bc2782111b8b58ab1856f7f9e0003d1eb2a052dd03eb51cd6ab5f7aaf55aa386bbb03662dc9f82edca7a02a95aed66b5810d58cfa27b97be3c49dd1d48f1560f2982f524b9f14cb031c96d2ad99cf238935566e59c094b0999d365f912ad927627a6ce076ee6f19c0531f25bfff5e08b50447a188c5d895e2ca5e143e2394646fdef1fb046622a494a9a807b4fe81fa09314f3143d217df71403a6c94f05969d50f818784b096ad9d1ac17a08052476200f0d2ac96a0e0442cc4a3ed42623207b9ef5f12f44d4019392bb0e6e8f188da84298d52c0f6654f6482748f1315c0091be5ec87e91663d9654493b260c5499253174bb0acd07448b70079eec34ac2107d2c990060dda46b5253a6e160d593c8cc19601a0a6fa9a129f007f3de278902fc64f48f03162bcc41c9a1aaf9dc33bddecd09f8344df72951a100f651bf458cf29477807d7d06f75275476bc97bb13698e9771e8a3273e214edead1f6a5a872f68343224af2c1500bd89c73d289fc1c7cec78431ef89453372fe0eb77c5fe2246399e7a5cb1bf722ab09572e6f6b02f24bad312bc82a50372df5de60bfca3bfffbc4f7ff4ebafd46aed7675b74a3919e82b389e7736b57e827a287c0af0250ff11711e1e369575e95514dbb5431d73dafb96e77a1bb20a0336f9570115593f6767c36223cd97d2e941e483c7bf104e0d9d1416a940a1a8e9660d5d4c5e3c6195f26e694c702b4e823e021d716f1a509fc3b4560c1278e2062694ad1e09a046fa0092dce5d5877dc38ead184f34dab197c4a18d1e5fa8cfa8f298209fbdb844ffbbb57b6939276fbaf8c3467cbee389fdb47967dececd83f5af61367070a9418e54d4db33557cf03545e3a9c72c431fe369267763b6fc3f54d514812e2abd4fa81603efa16dc99f5a4db8ba92bcc61da99e7f3f904b19f02f2f67d3ae0570e9c4997aac84c928bc9712b398c42759333e7146929b11fa475319c0e59e407549b6ea19bf716cf907ab57ab35fea1729d9f8877463ce3e751ed2d6422214f6cf13c167d737b480c6fbcc4fa099870563fd944503fc80d012dc95d04afb4c71ef59ef35652da0f53e1397d0970d518d6856e2c094480b37999c87b0e1f4634df7160d611507d4a545e2d75856a61d991a47dea119a1d4b58764410d451cf82ed20493ae29be454a531f3307c9aafa353012cddea03125fa7d859a4c951c8f794374dfe09856e56c951d4d92dc9d5c44d95de06a1a2b7e77ed82e65872611c6d178f5974af66d51ad48334c15968ee7fbaf60a6dbaf5ac8bbccd097388bd29c67e7d557bc2e40ddacee826ed091bdfa03d8ea3796d7a19b7abb5dd6a131b53547093ff787083f60c47f3da8dc4c3ee9e65b5ea7bd8cc60cf3c7d1dac556fb6ebedf614f6549c5f076beeb576ebadc614468f937958397d63b49bed66add1a0470addfb61c8555246d7a7d9b5086b936793e873dd2f7e536f5b3562022af4b0a0296aee3fa9cd143383ae9c09a9daa968074a99688c4cf25bffe4ff07310c6d16	2026-06-04 08:09:54.472866	5284157888476262252	1548
916	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30362d3034	\\x00110150e07e24bb88da41ffffffff04085b0d7b093a0e74696d657374616d706c2b071211216a3a106475726174696f6e5f6d73660c323231362e30353a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b07c831216a3b06660b323434352e373b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07aa32216a3b06660b323430322e313b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07d232216a3b06660c323831302e35323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07d232216a3b06660b322e363365333b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07c345216a3b06660c323334362e39393b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b078489216a3b06660c323338302e31313b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b07018d216a3b06660c323839302e30373b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-06-04 05:45:54.409038	-7616580485247073020	668
939	\\x70726f64756374696f6e3a64617368626f6172645f6d6574726963735f323032362d30362d3035	\\x0011014dfd92bbe988da41ffffffff04085b097b093a0e74696d657374616d706c2b070f27226a3a106475726174696f6e5f6d73660c343032352e35323a0e63616368655f686974543a10646174615f736f757263654922196361636865645f66696c74657265645f64617461063a0645547b093b006c2b078740226a3b06660c323539342e36323b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b075e41226a3b06660c313031352e39363b07543b084922196361636865645f66696c74657265645f64617461063b09547b093b006c2b075e47226a3b06660c323636352e36383b07543b084922196361636865645f66696c74657265645f64617461063b0954	2026-06-05 01:31:59.103937	6699707630524439391	455
933	\\x70726f64756374696f6e3a64617368626f6172645f646174615f63616437316337365f323032362d30312d30315f323032362d31322d33315f7636	\\x00118124e3578b6388da41ffffffff789c8d56fd6e1b45108f0ab2633b214eeaa450aa1282aa14a146b6633bf69c04e734442434fd485a81f01fa7f5dd9cbdedddadd9dd7331790678169e8807e02998bd3b3b71286ee53f7c3bf3dbf9f8cdecec7ebc7cf9102a5a6816386eacb408512abe0b9bccd57c8c73b2ad14c6c23e538a798284ab504e8501324ff10da8b8221aa3d4e865a215581f220bf4d071451c699e83b580fb98ad96a01c0a2d64b62c4059e821ca99763373e9fb3ce04ca3e265b8c3a3ff04b7045f18774eea5d71113923942e469a0dd02f36f7f7da4db89d1a1b8980bb9c4c15e15e269118f238a4dd41802ec5ee173aedfdf63461452a1ea9589262b9862dd81861e4f16890a55882ca54306213116b15c3da211f1ca1cb43166cd5da50ddab570f3aedda7ebd512703eb23c6bd19d8dada4c20cd6ab3d1691fd49ad8848d2cb21924b3d26c37f76bb54ef380ac54a6f93b0329deea21b1b0912437c9047ef151b3bdb70fb7a709cec49dfa5e9d6a3ca5f5cac0d65575af84e584dbd9b2728d6549bbfd82e197cc8d074ee67fcc8218f9adbff2703f14911e061347a21b4b69489238c6c8a8070558273155296552c0f613fa07e826f53d475748cf39c78069f2b505253b141e066e2141956ccdfa010a28772506002fcdaa00453b62219eec14139339c87dff92a06f02caca2ec3baad2723ea1ca6344a013bd73d9109d23d4e5400676c94b3be4eb718cb0e23aa541556ec24397559809242d32fbd22e4b9072b094bf4513001c08649d7a4a64c0fc29a2b919963c13414df528f53e00fe7bd4f1305f8c9e81f072c569883b24de5f3b86bdabf9713f0599aee53a242011ca27e8b18e529ef007d7d01dba9baabb5e4fd581bccec3b0fab327362af5bb5939d6b51e5ac87c74494e483a116b039e7a41b7939f8c476873cf028a75e5ec037ff17fb8b18e564e671c5dab5efc2bd9433a78fbe90e8cc4af00a0a47e4be57e24bfc23f9c703faa39fbf52af773ab5568d7232d057703aef6c66fd0cf5507814e04b1ee22f22c2c7b3cebc29a39af6a8628e33ae3b4e6fa9b724a03b6f9570115593f6763d36223cd97d2e941e48bc78f104e0d9c9516a940a1a8e0ab066eae272e38c4640c9562e0bb04a1f010fb9ae125f9ac0bf530455f8d416442c0d2e9a65d3e00d34a1c5be0f1bb613477d1a7a9e6935834f0923ba1c8f51ff314530617d9bf0697df7cab253d2fefe3323cddeb6baf697d649d53ab577ad1fabd6137b178a9418e54d4d736fae9e47a8dc7462e58863fc6d242fac4ede82773745314988af51eb078279e855e1ce554f3afd98bac21ca6afe6f97c3e451ca680bcf5800ef88d0367d2a52a3293e47272dcca36a3509de4ccd9ebb494e807695d0ca743167901d5a657ece5dde50ba45ead2df64bfd22259bfc906ecc59e7f623da5a4c84c2fa792af8fcdd0d2da0f13ef35368e661c9583f67d1003f20b4047723b4f22153dc7dd67f4d590b38789f896be8eb86a846342b71604aa485934cce63b86dfbb1a69b8c86b08a03ead255e2d75856a61d999a44eeb119a1d4b5c764410d451c780ed204938e297e9594a63e660e9255f56b60249abd41634af8be424da6cab6cbdc213a6f7042ab4ab6ca8e2649ee4e6fa4ec2e70348d15afb77e49732cb9304e76564f59b45dafd65bd48334c159689e047411163b740f562ff31627cc31f66718ebf54ded19930bb4ddd122ed199bcc6bcb465b6f755a0d6c6698d3389ac76c249774ad536bb45ad898a1824551c48305da0b1c2dd03e73f502ed53315ea0a5c7c9bbb4e6720f43ae923a391e0d27baa3a7af24e173ed97f60f1a7bad03d8a2b7030d4973bd496d86949963954c48c54c45bb50ce44136492dffa27ff2f183f6993	2026-06-04 14:34:41.374958	-7742796639176336848	1555
\.


--
-- TOC entry 4779 (class 0 OID 20542)
-- Dependencies: 364
-- Data for Name: solid_queue_blocked_executions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.solid_queue_blocked_executions (id, job_id, queue_name, priority, concurrency_key, expires_at, created_at) FROM stdin;
\.


--
-- TOC entry 4781 (class 0 OID 20562)
-- Dependencies: 366
-- Data for Name: solid_queue_claimed_executions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.solid_queue_claimed_executions (id, job_id, process_id, created_at) FROM stdin;
\.


--
-- TOC entry 4783 (class 0 OID 20574)
-- Dependencies: 368
-- Data for Name: solid_queue_failed_executions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.solid_queue_failed_executions (id, job_id, error, created_at) FROM stdin;
\.


--
-- TOC entry 4777 (class 0 OID 20521)
-- Dependencies: 362
-- Data for Name: solid_queue_jobs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.solid_queue_jobs (id, queue_name, class_name, arguments, priority, active_job_id, scheduled_at, finished_at, concurrency_key, created_at, updated_at) FROM stdin;
1	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"b9ed872f-7ad7-40fe-bce3-8f8bfdc126ef","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://drwise-admin/ActiveStorage::Blob/3"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-05-15T05:10:37.426099662Z","scheduled_at":"2026-05-15T05:10:37.425729011Z"}	0	b9ed872f-7ad7-40fe-bce3-8f8bfdc126ef	2026-05-15 05:10:37.425729	\N	\N	2026-05-15 05:10:38.110961	2026-05-15 05:10:38.110961
2	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"aaa7ed28-356a-4bdc-9a12-f9c10a06bcee","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://drwise-admin/ActiveStorage::Blob/4"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-05-15T09:36:59.475652021Z","scheduled_at":"2026-05-15T09:36:59.475207774Z"}	0	aaa7ed28-356a-4bdc-9a12-f9c10a06bcee	2026-05-15 09:36:59.475207	\N	\N	2026-05-15 09:36:59.690551	2026-05-15 09:36:59.690551
3	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"97fcf0de-b5e6-4cb0-9bea-108b826bcd23","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://drwise-admin/ActiveStorage::Blob/5"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-05-15T09:38:00.212020186Z","scheduled_at":"2026-05-15T09:38:00.211638390Z"}	0	97fcf0de-b5e6-4cb0-9bea-108b826bcd23	2026-05-15 09:38:00.211638	\N	\N	2026-05-15 09:38:00.478674	2026-05-15 09:38:00.478674
4	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"690e5e97-d395-4333-b668-00ec5b96b547","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://drwise-admin/ActiveStorage::Blob/6"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-05-26T00:06:23.049630527Z","scheduled_at":"2026-05-26T00:06:23.049276767Z"}	0	690e5e97-d395-4333-b668-00ec5b96b547	2026-05-26 00:06:23.049276	\N	\N	2026-05-26 00:06:23.38099	2026-05-26 00:06:23.38099
5	default	ActiveStorage::PurgeJob	{"job_class":"ActiveStorage::PurgeJob","job_id":"ea9bcd8d-f3b2-4363-abb6-52e343ea8b34","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://drwise-admin/ActiveStorage::Blob/6"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-05-26T00:06:54.676843405Z","scheduled_at":"2026-05-26T00:06:54.676551337Z"}	0	ea9bcd8d-f3b2-4363-abb6-52e343ea8b34	2026-05-26 00:06:54.676551	\N	\N	2026-05-26 00:06:55.317125	2026-05-26 00:06:55.317125
6	default	ActiveStorage::AnalyzeJob	{"job_class":"ActiveStorage::AnalyzeJob","job_id":"3556d9fd-f350-4e39-823a-dd95eb15afb9","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://drwise-admin/ActiveStorage::Blob/7"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-06-02T14:52:38.548626466Z","scheduled_at":"2026-06-02T14:52:38.548301107Z"}	0	3556d9fd-f350-4e39-823a-dd95eb15afb9	2026-06-02 14:52:38.548301	\N	\N	2026-06-02 14:52:39.199762	2026-06-02 14:52:39.199762
7	default	ActiveStorage::PurgeJob	{"job_class":"ActiveStorage::PurgeJob","job_id":"ced943da-b532-4866-94b0-12ecd15652cd","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://drwise-admin/ActiveStorage::Blob/5"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-06-02T22:33:57.875545430Z","scheduled_at":"2026-06-02T22:33:57.875393446Z"}	0	ced943da-b532-4866-94b0-12ecd15652cd	2026-06-02 22:33:57.875393	\N	\N	2026-06-02 22:33:57.876034	2026-06-02 22:33:57.876034
8	default	ActiveStorage::PurgeJob	{"job_class":"ActiveStorage::PurgeJob","job_id":"d82c68d8-4898-4970-a075-e78361606cec","provider_job_id":null,"queue_name":"default","priority":null,"arguments":[{"_aj_globalid":"gid://drwise-admin/ActiveStorage::Blob/4"}],"executions":0,"exception_executions":{},"locale":"en","timezone":"UTC","enqueued_at":"2026-06-02T22:34:18.740738014Z","scheduled_at":"2026-06-02T22:34:18.740594400Z"}	0	d82c68d8-4898-4970-a075-e78361606cec	2026-06-02 22:34:18.740594	\N	\N	2026-06-02 22:34:18.741025	2026-06-02 22:34:18.741025
\.


--
-- TOC entry 4785 (class 0 OID 20587)
-- Dependencies: 370
-- Data for Name: solid_queue_pauses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.solid_queue_pauses (id, queue_name, created_at) FROM stdin;
\.


--
-- TOC entry 4787 (class 0 OID 20600)
-- Dependencies: 372
-- Data for Name: solid_queue_processes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.solid_queue_processes (id, kind, last_heartbeat_at, supervisor_id, pid, hostname, metadata, created_at, name) FROM stdin;
\.


--
-- TOC entry 4789 (class 0 OID 20618)
-- Dependencies: 374
-- Data for Name: solid_queue_ready_executions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.solid_queue_ready_executions (id, job_id, queue_name, priority, created_at) FROM stdin;
1	1	default	0	2026-05-15 05:10:38.203094
2	2	default	0	2026-05-15 09:36:59.782912
3	3	default	0	2026-05-15 09:38:00.516163
4	4	default	0	2026-05-26 00:06:23.430402
5	5	default	0	2026-05-26 00:06:55.574805
6	6	default	0	2026-06-02 14:52:39.283675
7	7	default	0	2026-06-02 22:33:58.090679
8	8	default	0	2026-06-02 22:34:18.748748
\.


--
-- TOC entry 4791 (class 0 OID 20636)
-- Dependencies: 376
-- Data for Name: solid_queue_recurring_executions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.solid_queue_recurring_executions (id, job_id, task_key, run_at, created_at) FROM stdin;
\.


--
-- TOC entry 4793 (class 0 OID 20652)
-- Dependencies: 378
-- Data for Name: solid_queue_recurring_tasks; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.solid_queue_recurring_tasks (id, key, schedule, command, class_name, arguments, queue_name, priority, static, description, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4795 (class 0 OID 20671)
-- Dependencies: 380
-- Data for Name: solid_queue_scheduled_executions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.solid_queue_scheduled_executions (id, job_id, queue_name, priority, scheduled_at, created_at) FROM stdin;
\.


--
-- TOC entry 4797 (class 0 OID 20689)
-- Dependencies: 382
-- Data for Name: solid_queue_semaphores; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.solid_queue_semaphores (id, key, value, expires_at, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4670 (class 0 OID 18228)
-- Dependencies: 255
-- Data for Name: sub_agent_documents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sub_agent_documents (id, sub_agent_id, document_type, created_at, updated_at, r2_file_key, r2_filename, r2_content_type, r2_file_size) FROM stdin;
3	10	Pancard	2026-06-02 14:52:37.60402	2026-06-02 14:52:37.617386	\N	\N	\N	\N
\.


--
-- TOC entry 4668 (class 0 OID 18206)
-- Dependencies: 253
-- Data for Name: sub_agents; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.sub_agents (id, first_name, middle_name, last_name, mobile, email, role_id, state_id, city_id, birth_date, gender, pan_no, gst_no, company_name, address, bank_name, account_no, ifsc_code, account_holder_name, account_type, upi_id, status, created_at, updated_at, password_digest, distributor_id, plain_password, original_password, password_reset_at, deactivated, city, state) FROM stdin;
3	LOKESH		SHIVANNA	9902069391	sirifincorp@gmail.com	2	504	6379	1973-06-27	Male	AVMPS7760C		SPOORTHY VENTURES		STATE BANK OF INDIA	64079368397	SBIN0070242	LOKESH S	Savings		0	2026-05-13 03:19:42.414149	2026-05-13 03:20:56.662408	$2a$12$A2iqu48GvdKHRGoHunsqCeayQF6mSjkogY0TmwfEEGuHbKmr6y4IO	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
4	SUDARSHAN	R	RAO	9880708186	sudarshanrrao@gmail.com	2	504	6379	1977-09-15	Male					HDFC BANK	50100173705850	HDFC0000286	SUDARSHAN RAO	Savings		0	2026-05-13 03:47:12.324472	2026-05-13 03:47:37.276947	$2a$12$owu8jRqXRGZQ0fxBoFvQ0.O0SUU5MmEN72EXP3CRBwTb1hcN3bfaC	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
1	DEVARAJ		J	6361760165	bittideva@gmail.com	2	439	20134	1976-03-04	Male	AERPJ8932K		KRAMA								0	2026-05-11 11:05:19.546733	2026-05-15 07:13:48.144086	$2a$12$6cSESFYyI.myac1rTFpOIOpBLcYN8vxGKA2YE7f5C8W.6xTdwBWZi	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
7	RAVIKUMAR		J	9008829849	ravikumarjblr@gmail.com	2	665	10248	1977-03-14	Male	AJQPR6146M		NANDUS SOLUTIONS		Union Bank of India	520101001517933	UBIN0907464		Savings	RAVIKUMAR J	0	2026-05-19 03:30:30.904353	2026-05-19 03:30:30.904353	$2a$12$NlodDhcPGPJJxmOH5D3NaOvI/yRSlC2j4q1JKp0zdOyItn5L0wjIu	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
6	Murali Krishna		Kasibhatta	8686961074	masterlee311@gmail.com	2	665	10248	1971-12-11	Male	AOGPK1840J										0	2026-05-18 02:23:51.962112	2026-05-23 23:44:51.707073	$2a$12$9AuOVdySCiXcnd0uSUacnuzAMINxPGL8bA4P/XqxTwwOSSK7B7Apu	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
8	SOWMYA		H T	9620455292	vijendramarvin220@gmail.com	2	724	67499	1990-04-29	Female					CANARA BANK	000005994		SOWMYA H T	Savings		0	2026-05-26 00:05:41.930884	2026-05-26 00:05:41.930884	$2a$12$9oV4HkwJB9ScsqjMUwO.L.l8k7ZTvQ/.eCem1bjjvVm1S4co5ZqmO	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
9	H K SRINIVASA		MURTHY	9483507948	insurancemurthy@gmail.com	2	682	2648	1950-04-15	Male	AGVPS4825Q				HDFC BANK	07141140002513	HDFC0000877	H K SRINIVASA MURTHY	Savings		0	2026-06-02 08:28:53.83783	2026-06-02 08:28:53.83783	$2a$12$i22FDOhqcGT3dBFOnC7I2uGPlBZchcUeiZvRzNroJZMT8gMYYzA7q	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
10	N		GOPAL	9845798137	ngopalg77@gmail.com	2	474	7157	1977-07-10	Male	ALHPG4776H				STATE BANK OF INDIA	64038146543	SBIN0040655	N GOPAL	Savings		0	2026-06-02 14:52:37.600321	2026-06-02 14:52:37.600321	$2a$12$bwRiazmF60xPCsV9XiucuOIzyn6EM6dcd7rWFbleCxaaB5.821SCi	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
11	N HARISH		KUMAR	9845393458	sribalajicommunications15@gmail.com	2	474	7157	1972-06-24	Male	ACRPN4891K		SRI BALAJI COMMUNICATIONS		STATE BANK OF INDIA	64035899986	SBIN0040159	N HARISH KUMAR	Savings		0	2026-06-02 15:31:11.592072	2026-06-02 15:31:11.592072	$2a$12$coZMdPy8sSRQ7R1JA/m1/u7zmeENK.ewZQPvEfKFg9H7J1CNPJdRa	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
13	INDIRA		K C	9686337902	indirashivkumar9686@gmail.com	2	474	7157	1989-06-02	Female	AFJPI2055R				CANARA BANK	110066154163	CNRB0003194	INDIRA K C	Savings		0	2026-06-03 00:47:32.713089	2026-06-03 00:47:32.713089	$2a$12$LSik6RuU4Og6t6l3ZK7pJeeUyIjX4/UyWprwBjRUmkAMvnFRSKXZm	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
14	RANGAPPA		R	7892132274	ranga0374@gmail.com	2	474	7157	1974-01-03	Male	CIXPR6790R		RK IMPRESSIONS								0	2026-06-03 01:43:04.88002	2026-06-03 01:43:04.88002	$2a$12$mI1Xy0g9R4EegqFBP96KGuIDG7rUQNhd1oFwcPxbR/X22nkDn93yO	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
15	SATHYANARAYANA		D	9341580411	dsn101171@gmail.com	2	474	7157	1972-06-05	Male	AOEPD0369K										0	2026-06-03 02:19:54.790446	2026-06-03 02:19:54.790446	$2a$12$72O7hfmP0jL55WAPx9F5HeTtbvCbl2mJZTTOV.eIPJqWrdRswGUHS	\N	\N	Ganesha@123	\N	f	Bengaluru Urban	karnataka
2	Samparka		Association	8296348359	samparka.blr@gmail.com	2	439	20134	\N												0	2026-05-11 11:21:29.600006	2026-06-04 05:51:44.354683	$2a$12$DY/C4KOvrjVHfE7TCF7YXuKdJ4AYzG0I3vV9GKykh7ADNhSZ76ECG	\N	\N	Ganesha@123	\N	t	Bengaluru Urban	karnataka
\.


--
-- TOC entry 4696 (class 0 OID 18697)
-- Dependencies: 281
-- Data for Name: system_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.system_settings (id, key, value, description, setting_type, created_at, updated_at, default_main_agent_commission, default_affiliate_commission, default_ambassador_commission, default_company_expenses, terms_and_conditions, investment_amount, company_name, company_phone, company_email, company_address) FROM stdin;
2	company_website	www.dr-wise.in	Company website URL	string	2026-05-21 10:36:13.104838	2026-05-21 10:36:13.104838	\N	\N	\N	\N	\N	0.00	\N	\N	\N	\N
3	support_hours	Monday to Saturday: 10:00 AM - 6:00 PM	Customer support hours	string	2026-05-21 10:36:13.12485	2026-05-24 12:01:44.148237	\N	\N	\N	\N	\N	0.00	\N	\N	\N	\N
1	system_config	system configuration	System configuration settings	configuration	2026-05-20 02:26:20.769897	2026-05-25 23:59:07.191563	\N	\N	\N	\N	\N	0.00	Dr WISE Consulting Services LLP	+918431174477	info@dr-wise.in	402-B-1, Basement Floor, 'Sundara Arcade', ITI HBCS Layout, Mysore Road, Bengaluru-  560 039
\.


--
-- TOC entry 4722 (class 0 OID 19025)
-- Dependencies: 307
-- Data for Name: tax_services; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.tax_services (id, customer_id, service_type, financial_year, filing_date, amount, status, notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4724 (class 0 OID 19044)
-- Dependencies: 309
-- Data for Name: travel_packages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.travel_packages (id, customer_id, travel_type, destination, travel_date, return_date, package_amount, status, notes, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4690 (class 0 OID 18599)
-- Dependencies: 275
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_roles (id, name, description, status, display_order, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4744 (class 0 OID 19292)
-- Dependencies: 329
-- Data for Name: user_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.user_sessions (id, user_id, session_id, ip_address, user_agent, started_at, ended_at, duration, status, location, device_type, browser, created_at, updated_at) FROM stdin;
\.


--
-- TOC entry 4638 (class 0 OID 17917)
-- Dependencies: 223
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
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
36	GAYATRI	K	gurwale.gayatri@gmail.com	9542420736	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	ambassador	\N	t	\N	2026-06-02 08:12:46.681947	2026-06-02 08:12:46.681947	$2a$12$3E5NjuJDQldTvESakEU9aOJEfaXD3BrzJ7wZYvZgN58S5WAtt9v1q	\N	\N	\N	\N	\N	\N	Ganesha@123	\N	\N	\N	\N
37	INDIRA	MURTHY	indiramurthy50@gmail.com	6364407948	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	ambassador	\N	t	\N	2026-06-02 08:25:50.468073	2026-06-02 08:25:50.468073	$2a$12$1dM4b4y9ARJQ2dO9HGVgzeq2xK/aXUck/lGosyDSpWujmxn/pR0W.	\N	\N	\N	\N	\N	\N	Ganesha@123	\N	\N	\N	\N
38	H K SRINIVASA	MURTHY	insurancemurthy@gmail.com	9483507948	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sub_agent	\N	t	\N	2026-06-02 08:28:54.074816	2026-06-02 08:28:54.074816	$2a$12$6I4Wz01WD7OIGtwAwdCWEuuAD8.xy/hoO36kZB6TLVSX7aDUCGEIq	\N	\N	\N	2	\N	\N	\N	\N	\N	\N	\N
39	M	TRIVENI	trivenig1482@gmail.com	6362324189	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	ambassador	\N	t	\N	2026-06-02 15:03:01.044474	2026-06-02 15:03:01.044474	$2a$12$ULnOt4UyfOEX97GWvZQHDuYvB/3ewDe4.jy3PVR2IT9Rdw881L5D6	\N	\N	\N	\N	\N	\N	Ganesha@123	\N	\N	\N	\N
40	N	ADINARAYANAN	nadinarayanan@gmail.com	9035170488	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-02 15:28:44.431602	2026-06-02 15:28:44.431602	$2a$12$R3EYSqsqU9hy5AWyvoX1e.Pi5ClPDDr1KDEDEoxBHSebDwUECxtoO	\N	\N	\N	\N	\N	\N	NXXX@1950	\N	\N	\N	\N
41	VINAY	AMARNATH	vudthavinay@gmail.com	9945561709	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-02 23:44:48.658621	2026-06-02 23:44:48.658621	$2a$12$6mK6lPTQf6EXGuip3xBbsesJntZz97/udEP/tsYT5mK6Ctdx8kxPq	\N	\N	\N	\N	\N	\N	VINA@1983	\N	\N	\N	\N
42	CHETHAN	H K	mahatichetan@gmail.com	8884580160	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-03 00:33:03.470619	2026-06-03 00:33:03.470619	$2a$12$.7f0EAwbHbAsqEDbRC.DZudZfot0qzPZG.RCNWmwuAeACWIN3kcEe	\N	\N	\N	\N	\N	\N	CHET@1986	\N	\N	\N	\N
44	B N	SHIVAKUMARA	kunigalshivakumara@gmail.com	9743228985	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	ambassador	\N	t	\N	2026-06-03 00:45:54.39109	2026-06-03 00:45:54.39109	$2a$12$LZLh9duEXxCuIwnx6tQGWuXLu3Znd7RBLn2BtGVc2jdsyf9xf14vy	\N	\N	\N	\N	\N	\N	Ganesha@123	\N	\N	\N	\N
45	INDIRA	K C	indirashivkumar9686@gmail.com	9686337902	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sub_agent	\N	t	\N	2026-06-03 00:47:32.943508	2026-06-03 00:47:32.943508	$2a$12$DrNYSmt/DKSqh0a39rvkcuIP4zs4EvxCySnJq4ut2WTsyy7FyX9N6	\N	\N	\N	2	\N	\N	\N	\N	\N	\N	\N
46	M N	NAGAVENI	yukthiacharmn@gmail.com	9743901666	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-03 00:52:20.662276	2026-06-03 00:52:20.662276	$2a$12$EfCO0Owm/N1NJCimj0ecp.GOLoW0K9szH8ojj66HCGAUUwgNue1oW	\N	\N	\N	\N	\N	\N	M NX@1982	\N	\N	\N	\N
47	SHIVALINGAIAH	M	halkurkeshivu@gmail.com	9740808135	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-03 01:03:47.305381	2026-06-03 01:03:47.305381	$2a$12$U8A6apl02sJgKxb2aFx7g.RNp5/BYdV4bnIPvLTGoD.uKzzsKM7by	\N	\N	\N	\N	\N	\N	SHIV@1981	\N	\N	\N	\N
48	Praveen	NAGARURU	praveennagaruru@gmail.com	9291909767	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-03 01:13:34.487155	2026-06-03 01:13:34.487155	$2a$12$P86.WcbVAEsNK90MbhqFDu6o8w0gnwFT/7V73vaKHMhje80g8xbxS	\N	\N	\N	\N	\N	\N	PRAV@1985	\N	\N	\N	\N
49	HARSHAVARDHANA	R D	harshavardhanrd@gmail.com	9740044566	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-03 01:29:07.028298	2026-06-03 01:29:07.028298	$2a$12$oubjDrkhtePZPbszWGqsz.HalM85aLRvfW99e5YN4DRxRazlDQNZO	\N	\N	\N	\N	\N	\N	HARS@1980	\N	\N	\N	\N
50	RANGAPPA	R	ranga0374@gmail.com	7892132274	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sub_agent	\N	t	\N	2026-06-03 01:43:05.182847	2026-06-03 01:43:05.182847	$2a$12$EjJkIu7hNND3G2wo8Sr5ZO7HBcRmSlYBOLmqwF3dnKrBzvaqoO8o6	\N	\N	\N	2	\N	\N	\N	\N	\N	\N	\N
51	R	GAYATHRI	rkimpressions@gmail.com	9900094755	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-03 01:47:16.918325	2026-06-03 01:47:16.918325	$2a$12$deS7L/Do1SnFJLt8FRmQUuVVW4KeDHJUdYptZg8/No1MsWQZiF5T2	\N	\N	\N	\N	\N	\N	RXXX@1981	\N	\N	\N	\N
52	SATHYANARAYANA	D	dsn101171@gmail.com	9341580411	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	sub_agent	\N	t	\N	2026-06-03 02:19:55.034787	2026-06-03 02:19:55.034787	$2a$12$L.RBC7ckbssvJ4d1sNurOOyeM9Ob9EUqIJkYG1x5PdaDNrkarlrqS	\N	\N	\N	2	\N	\N	\N	\N	\N	\N	\N
53	VISHAKANTHE	GOWDA	vgowda664@gmail.com	9880322261	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-03 02:23:20.872121	2026-06-03 02:23:20.872121	$2a$12$verPtYmJMcmoLFDL/jrAseT0nKJoFCOYmp1u4OktckspM0VWu8o4q	\N	\N	\N	\N	\N	\N	VISH@1963	\N	\N	\N	\N
54	VISHWANATH	G K	vishytt@yahoo.co.in	9845320335	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-03 03:28:10.45584	2026-06-03 03:28:10.45584	$2a$12$QY1JF6GC740Udq/WG7beneRQXl41c9HIw1qkGQaq600Pq5Ph9/dA2	\N	\N	\N	\N	\N	\N	VISH@1959	\N	\N	\N	\N
55	ARCHANA	VISHWANATH	vishyatt@yahoo.co.in	9845320333	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-03 04:52:34.98443	2026-06-03 04:52:34.98443	$2a$12$lLEofj3cAPxZzGaQBBQSQ.6AceqSzMpCPBU261CUTsxBX/puAKYFG	\N	\N	\N	\N	\N	\N	ARCH@1972	\N	\N	\N	\N
56	KRISHNA	MURTHY K	95krishnamurthy@gmail.com	9945708639	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-03 05:07:25.928675	2026-06-03 05:07:25.928675	$2a$12$062gomOaQTNaNGUpb55PXuvzLqnNgNgsq/ylmi7LEtqzpPjHPsuta	\N	\N	\N	\N	\N	\N	KRIS@1995	\N	\N	\N	\N
57	HONNAPPA	S	honnappaamsh@gmail.com	9743968027	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-03 05:19:37.001511	2026-06-03 05:19:37.001511	$2a$12$bChAPObp1Ocbpmt54wJ0U.4OsSiu0g0tMOBP3S.G2qRKms9OxxfkW	\N	\N	\N	\N	\N	\N	HONN@1983	\N	\N	\N	\N
58	KUMARA	A R	kumarauppi6088@gmail.com	7259887608	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-03 13:58:43.775397	2026-06-03 13:58:43.775397	$2a$12$e7N9U8/Qdpp8mkdlnsHL/uAuRiC3luvMtjJk5mbwxQ6bJGuMkxG7y	\N	\N	\N	\N	\N	\N	KUMA@1988	\N	\N	\N	\N
59	AYAN	M	jravikumar849@gmail.com	8117854975	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-03 17:49:05.508544	2026-06-03 17:49:05.508544	$2a$12$uAN3rqrMIBJpVWPGMXW.VeZMkz.n9LNRl5qezrJGLAGg9EoqVzTLe	\N	\N	\N	\N	\N	\N	AYAN@1977	\N	\N	\N	\N
60	M P	VIJENDRA	vijendra220@gmail.com	9620455292	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	customer	\N	t	\N	2026-06-03 18:23:31.97236	2026-06-03 18:23:31.97236	$2a$12$/Xi3.V/4nxNwJgnnX/We2ORKNjHLSjAw.aJFqKVCyvHLb0Ah6euLG	\N	\N	\N	\N	\N	\N	M PX@1982	\N	\N	\N	\N
\.


--
-- TOC entry 4897 (class 0 OID 0)
-- Dependencies: 244
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.active_storage_attachments_id_seq', 7, true);


--
-- TOC entry 4898 (class 0 OID 0)
-- Dependencies: 242
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.active_storage_blobs_id_seq', 7, true);


--
-- TOC entry 4899 (class 0 OID 0)
-- Dependencies: 246
-- Name: active_storage_variant_records_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.active_storage_variant_records_id_seq', 1, false);


--
-- TOC entry 4900 (class 0 OID 0)
-- Dependencies: 230
-- Name: agency_brokers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.agency_brokers_id_seq', 1, false);


--
-- TOC entry 4901 (class 0 OID 0)
-- Dependencies: 256
-- Name: agency_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.agency_codes_id_seq', 4, true);


--
-- TOC entry 4902 (class 0 OID 0)
-- Dependencies: 332
-- Name: ahoy_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ahoy_events_id_seq', 1, false);


--
-- TOC entry 4903 (class 0 OID 0)
-- Dependencies: 330
-- Name: ahoy_visits_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ahoy_visits_id_seq', 1, false);


--
-- TOC entry 4904 (class 0 OID 0)
-- Dependencies: 320
-- Name: ai_report_histories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.ai_report_histories_id_seq', 1, false);


--
-- TOC entry 4905 (class 0 OID 0)
-- Dependencies: 326
-- Name: all_policy_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.all_policy_reports_id_seq', 1, false);


--
-- TOC entry 4906 (class 0 OID 0)
-- Dependencies: 322
-- Name: analytics_caches_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.analytics_caches_id_seq', 24, true);


--
-- TOC entry 4907 (class 0 OID 0)
-- Dependencies: 387
-- Name: appointments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.appointments_id_seq', 4, true);


--
-- TOC entry 4908 (class 0 OID 0)
-- Dependencies: 351
-- Name: banner_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.banner_documents_id_seq', 1, false);


--
-- TOC entry 4909 (class 0 OID 0)
-- Dependencies: 272
-- Name: banners_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.banners_id_seq', 4, true);


--
-- TOC entry 4910 (class 0 OID 0)
-- Dependencies: 318
-- Name: broker_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.broker_codes_id_seq', 5, true);


--
-- TOC entry 4911 (class 0 OID 0)
-- Dependencies: 258
-- Name: brokers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.brokers_id_seq', 4, true);


--
-- TOC entry 4912 (class 0 OID 0)
-- Dependencies: 264
-- Name: client_requests_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.client_requests_id_seq', 5, true);


--
-- TOC entry 4913 (class 0 OID 0)
-- Dependencies: 389
-- Name: client_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.client_services_id_seq', 1, true);


--
-- TOC entry 4914 (class 0 OID 0)
-- Dependencies: 292
-- Name: commission_payouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.commission_payouts_id_seq', 314, true);


--
-- TOC entry 4915 (class 0 OID 0)
-- Dependencies: 294
-- Name: commission_receipts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.commission_receipts_id_seq', 1, false);


--
-- TOC entry 4916 (class 0 OID 0)
-- Dependencies: 248
-- Name: corporate_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.corporate_members_id_seq', 1, false);


--
-- TOC entry 4917 (class 0 OID 0)
-- Dependencies: 316
-- Name: customer_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.customer_documents_id_seq', 1, true);


--
-- TOC entry 4918 (class 0 OID 0)
-- Dependencies: 224
-- Name: customers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.customers_id_seq', 44, true);


--
-- TOC entry 4919 (class 0 OID 0)
-- Dependencies: 300
-- Name: distributor_assignments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.distributor_assignments_id_seq', 17, true);


--
-- TOC entry 4920 (class 0 OID 0)
-- Dependencies: 278
-- Name: distributor_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.distributor_documents_id_seq', 1, false);


--
-- TOC entry 4921 (class 0 OID 0)
-- Dependencies: 310
-- Name: distributor_payouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.distributor_payouts_id_seq', 1, true);


--
-- TOC entry 4922 (class 0 OID 0)
-- Dependencies: 276
-- Name: distributors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.distributors_id_seq', 9, true);


--
-- TOC entry 4923 (class 0 OID 0)
-- Dependencies: 250
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.documents_id_seq', 1, false);


--
-- TOC entry 4924 (class 0 OID 0)
-- Dependencies: 226
-- Name: family_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.family_members_id_seq', 6, true);


--
-- TOC entry 4925 (class 0 OID 0)
-- Dependencies: 355
-- Name: health_insurance_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.health_insurance_documents_id_seq', 8, true);


--
-- TOC entry 4926 (class 0 OID 0)
-- Dependencies: 260
-- Name: health_insurance_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.health_insurance_members_id_seq', 1, false);


--
-- TOC entry 4927 (class 0 OID 0)
-- Dependencies: 341
-- Name: health_insurance_nominees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.health_insurance_nominees_id_seq', 44, true);


--
-- TOC entry 4928 (class 0 OID 0)
-- Dependencies: 234
-- Name: health_insurances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.health_insurances_id_seq', 68, true);


--
-- TOC entry 4929 (class 0 OID 0)
-- Dependencies: 337
-- Name: helpdesk_tickets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.helpdesk_tickets_id_seq', 1, false);


--
-- TOC entry 4930 (class 0 OID 0)
-- Dependencies: 228
-- Name: insurance_companies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.insurance_companies_id_seq', 58, true);


--
-- TOC entry 4931 (class 0 OID 0)
-- Dependencies: 302
-- Name: investments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.investments_id_seq', 1, false);


--
-- TOC entry 4932 (class 0 OID 0)
-- Dependencies: 284
-- Name: investor_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.investor_documents_id_seq', 1, false);


--
-- TOC entry 4933 (class 0 OID 0)
-- Dependencies: 282
-- Name: investors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.investors_id_seq', 13, true);


--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 339
-- Name: invoice_items_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.invoice_items_id_seq', 1, false);


--
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 314
-- Name: invoices_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.invoices_id_seq', 8, true);


--
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 240
-- Name: leads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.leads_id_seq', 30, true);


--
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 288
-- Name: life_insurance_bank_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.life_insurance_bank_details_id_seq', 1, false);


--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 290
-- Name: life_insurance_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.life_insurance_documents_id_seq', 1, false);


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 286
-- Name: life_insurance_nominees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.life_insurance_nominees_id_seq', 5, true);


--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 262
-- Name: life_insurances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.life_insurances_id_seq', 9, true);


--
-- TOC entry 4941 (class 0 OID 0)
-- Dependencies: 304
-- Name: loans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.loans_id_seq', 1, false);


--
-- TOC entry 4942 (class 0 OID 0)
-- Dependencies: 349
-- Name: motor_insurance_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.motor_insurance_documents_id_seq', 12, true);


--
-- TOC entry 4943 (class 0 OID 0)
-- Dependencies: 345
-- Name: motor_insurance_nominees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.motor_insurance_nominees_id_seq', 17, true);


--
-- TOC entry 4944 (class 0 OID 0)
-- Dependencies: 236
-- Name: motor_insurances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.motor_insurances_id_seq', 20, true);


--
-- TOC entry 4945 (class 0 OID 0)
-- Dependencies: 385
-- Name: mutual_fund_nominees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mutual_fund_nominees_id_seq', 1, true);


--
-- TOC entry 4946 (class 0 OID 0)
-- Dependencies: 383
-- Name: mutual_funds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.mutual_funds_id_seq', 2, true);


--
-- TOC entry 4947 (class 0 OID 0)
-- Dependencies: 357
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.notifications_id_seq', 4, true);


--
-- TOC entry 4948 (class 0 OID 0)
-- Dependencies: 353
-- Name: other_insurance_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.other_insurance_documents_id_seq', 3, true);


--
-- TOC entry 4949 (class 0 OID 0)
-- Dependencies: 343
-- Name: other_insurance_nominees_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.other_insurance_nominees_id_seq', 3, true);


--
-- TOC entry 4950 (class 0 OID 0)
-- Dependencies: 238
-- Name: other_insurances_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.other_insurances_id_seq', 8, true);


--
-- TOC entry 4951 (class 0 OID 0)
-- Dependencies: 298
-- Name: payout_audit_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payout_audit_logs_id_seq', 1, false);


--
-- TOC entry 4952 (class 0 OID 0)
-- Dependencies: 296
-- Name: payout_distributions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payout_distributions_id_seq', 1, false);


--
-- TOC entry 4953 (class 0 OID 0)
-- Dependencies: 312
-- Name: payouts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.payouts_id_seq', 66, true);


--
-- TOC entry 4954 (class 0 OID 0)
-- Dependencies: 268
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.permissions_id_seq', 1, false);


--
-- TOC entry 4955 (class 0 OID 0)
-- Dependencies: 232
-- Name: policies_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.policies_id_seq', 1, false);


--
-- TOC entry 4956 (class 0 OID 0)
-- Dependencies: 347
-- Name: policy_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.policy_documents_id_seq', 2, true);


--
-- TOC entry 4957 (class 0 OID 0)
-- Dependencies: 324
-- Name: reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reports_id_seq', 1, false);


--
-- TOC entry 4958 (class 0 OID 0)
-- Dependencies: 270
-- Name: role_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.role_permissions_id_seq', 1, false);


--
-- TOC entry 4959 (class 0 OID 0)
-- Dependencies: 266
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.roles_id_seq', 2, true);


--
-- TOC entry 4960 (class 0 OID 0)
-- Dependencies: 334
-- Name: session_activities_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.session_activities_id_seq', 110, true);


--
-- TOC entry 4961 (class 0 OID 0)
-- Dependencies: 359
-- Name: solid_cache_entries_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.solid_cache_entries_id_seq', 947, true);


--
-- TOC entry 4962 (class 0 OID 0)
-- Dependencies: 363
-- Name: solid_queue_blocked_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.solid_queue_blocked_executions_id_seq', 1, false);


--
-- TOC entry 4963 (class 0 OID 0)
-- Dependencies: 365
-- Name: solid_queue_claimed_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.solid_queue_claimed_executions_id_seq', 1, false);


--
-- TOC entry 4964 (class 0 OID 0)
-- Dependencies: 367
-- Name: solid_queue_failed_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.solid_queue_failed_executions_id_seq', 1, false);


--
-- TOC entry 4965 (class 0 OID 0)
-- Dependencies: 361
-- Name: solid_queue_jobs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.solid_queue_jobs_id_seq', 8, true);


--
-- TOC entry 4966 (class 0 OID 0)
-- Dependencies: 369
-- Name: solid_queue_pauses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.solid_queue_pauses_id_seq', 1, false);


--
-- TOC entry 4967 (class 0 OID 0)
-- Dependencies: 371
-- Name: solid_queue_processes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.solid_queue_processes_id_seq', 1, false);


--
-- TOC entry 4968 (class 0 OID 0)
-- Dependencies: 373
-- Name: solid_queue_ready_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.solid_queue_ready_executions_id_seq', 8, true);


--
-- TOC entry 4969 (class 0 OID 0)
-- Dependencies: 375
-- Name: solid_queue_recurring_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.solid_queue_recurring_executions_id_seq', 1, false);


--
-- TOC entry 4970 (class 0 OID 0)
-- Dependencies: 377
-- Name: solid_queue_recurring_tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.solid_queue_recurring_tasks_id_seq', 1, false);


--
-- TOC entry 4971 (class 0 OID 0)
-- Dependencies: 379
-- Name: solid_queue_scheduled_executions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.solid_queue_scheduled_executions_id_seq', 1, false);


--
-- TOC entry 4972 (class 0 OID 0)
-- Dependencies: 381
-- Name: solid_queue_semaphores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.solid_queue_semaphores_id_seq', 1, false);


--
-- TOC entry 4973 (class 0 OID 0)
-- Dependencies: 254
-- Name: sub_agent_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sub_agent_documents_id_seq', 3, true);


--
-- TOC entry 4974 (class 0 OID 0)
-- Dependencies: 252
-- Name: sub_agents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.sub_agents_id_seq', 15, true);


--
-- TOC entry 4975 (class 0 OID 0)
-- Dependencies: 280
-- Name: system_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.system_settings_id_seq', 3, true);


--
-- TOC entry 4976 (class 0 OID 0)
-- Dependencies: 306
-- Name: tax_services_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.tax_services_id_seq', 1, false);


--
-- TOC entry 4977 (class 0 OID 0)
-- Dependencies: 308
-- Name: travel_packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.travel_packages_id_seq', 1, false);


--
-- TOC entry 4978 (class 0 OID 0)
-- Dependencies: 274
-- Name: user_roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_roles_id_seq', 1, false);


--
-- TOC entry 4979 (class 0 OID 0)
-- Dependencies: 328
-- Name: user_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_sessions_id_seq', 1, false);


--
-- TOC entry 4980 (class 0 OID 0)
-- Dependencies: 222
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 60, true);


--
-- TOC entry 4051 (class 2606 OID 18141)
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- TOC entry 4048 (class 2606 OID 18125)
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- TOC entry 4055 (class 2606 OID 18160)
-- Name: active_storage_variant_records active_storage_variant_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT active_storage_variant_records_pkey PRIMARY KEY (id);


--
-- TOC entry 3968 (class 2606 OID 17982)
-- Name: agency_brokers agency_brokers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agency_brokers
    ADD CONSTRAINT agency_brokers_pkey PRIMARY KEY (id);


--
-- TOC entry 4077 (class 2606 OID 18259)
-- Name: agency_codes agency_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agency_codes
    ADD CONSTRAINT agency_codes_pkey PRIMARY KEY (id);


--
-- TOC entry 4280 (class 2606 OID 19339)
-- Name: ahoy_events ahoy_events_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_events
    ADD CONSTRAINT ahoy_events_pkey PRIMARY KEY (id);


--
-- TOC entry 4275 (class 2606 OID 19326)
-- Name: ahoy_visits ahoy_visits_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ahoy_visits
    ADD CONSTRAINT ahoy_visits_pkey PRIMARY KEY (id);


--
-- TOC entry 4254 (class 2606 OID 19228)
-- Name: ai_report_histories ai_report_histories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_report_histories
    ADD CONSTRAINT ai_report_histories_pkey PRIMARY KEY (id);


--
-- TOC entry 4266 (class 2606 OID 19290)
-- Name: all_policy_reports all_policy_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.all_policy_reports
    ADD CONSTRAINT all_policy_reports_pkey PRIMARY KEY (id);


--
-- TOC entry 4261 (class 2606 OID 19265)
-- Name: analytics_caches analytics_caches_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.analytics_caches
    ADD CONSTRAINT analytics_caches_pkey PRIMARY KEY (id);


--
-- TOC entry 4392 (class 2606 OID 20857)
-- Name: appointments appointments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT appointments_pkey PRIMARY KEY (id);


--
-- TOC entry 3932 (class 2606 OID 17915)
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- TOC entry 4315 (class 2606 OID 19694)
-- Name: banner_documents banner_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.banner_documents
    ADD CONSTRAINT banner_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4138 (class 2606 OID 18595)
-- Name: banners banners_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.banners
    ADD CONSTRAINT banners_pkey PRIMARY KEY (id);


--
-- TOC entry 4251 (class 2606 OID 19202)
-- Name: broker_codes broker_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broker_codes
    ADD CONSTRAINT broker_codes_pkey PRIMARY KEY (id);


--
-- TOC entry 4080 (class 2606 OID 18273)
-- Name: brokers brokers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brokers
    ADD CONSTRAINT brokers_pkey PRIMARY KEY (id);


--
-- TOC entry 4114 (class 2606 OID 18481)
-- Name: client_requests client_requests_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_requests
    ADD CONSTRAINT client_requests_pkey PRIMARY KEY (id);


--
-- TOC entry 4398 (class 2606 OID 20948)
-- Name: client_services client_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_services
    ADD CONSTRAINT client_services_pkey PRIMARY KEY (id);


--
-- TOC entry 4178 (class 2606 OID 18838)
-- Name: commission_payouts commission_payouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commission_payouts
    ADD CONSTRAINT commission_payouts_pkey PRIMARY KEY (id);


--
-- TOC entry 4191 (class 2606 OID 18855)
-- Name: commission_receipts commission_receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commission_receipts
    ADD CONSTRAINT commission_receipts_pkey PRIMARY KEY (id);


--
-- TOC entry 4058 (class 2606 OID 18183)
-- Name: corporate_members corporate_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.corporate_members
    ADD CONSTRAINT corporate_members_pkey PRIMARY KEY (id);


--
-- TOC entry 4248 (class 2606 OID 19175)
-- Name: customer_documents customer_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_documents
    ADD CONSTRAINT customer_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 3940 (class 2606 OID 17939)
-- Name: customers customers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT customers_pkey PRIMARY KEY (id);


--
-- TOC entry 4207 (class 2606 OID 18930)
-- Name: distributor_assignments distributor_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_assignments
    ADD CONSTRAINT distributor_assignments_pkey PRIMARY KEY (id);


--
-- TOC entry 4154 (class 2606 OID 18689)
-- Name: distributor_documents distributor_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_documents
    ADD CONSTRAINT distributor_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4223 (class 2606 OID 19075)
-- Name: distributor_payouts distributor_payouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_payouts
    ADD CONSTRAINT distributor_payouts_pkey PRIMARY KEY (id);


--
-- TOC entry 4146 (class 2606 OID 18672)
-- Name: distributors distributors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributors
    ADD CONSTRAINT distributors_pkey PRIMARY KEY (id);


--
-- TOC entry 4061 (class 2606 OID 18203)
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- TOC entry 3953 (class 2606 OID 17952)
-- Name: family_members family_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.family_members
    ADD CONSTRAINT family_members_pkey PRIMARY KEY (id);


--
-- TOC entry 4321 (class 2606 OID 19753)
-- Name: health_insurance_documents health_insurance_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurance_documents
    ADD CONSTRAINT health_insurance_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4085 (class 2606 OID 18312)
-- Name: health_insurance_members health_insurance_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurance_members
    ADD CONSTRAINT health_insurance_members_pkey PRIMARY KEY (id);


--
-- TOC entry 4298 (class 2606 OID 19506)
-- Name: health_insurance_nominees health_insurance_nominees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurance_nominees
    ADD CONSTRAINT health_insurance_nominees_pkey PRIMARY KEY (id);


--
-- TOC entry 3981 (class 2606 OID 18054)
-- Name: health_insurances health_insurances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT health_insurances_pkey PRIMARY KEY (id);


--
-- TOC entry 4290 (class 2606 OID 19456)
-- Name: helpdesk_tickets helpdesk_tickets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.helpdesk_tickets
    ADD CONSTRAINT helpdesk_tickets_pkey PRIMARY KEY (id);


--
-- TOC entry 3966 (class 2606 OID 17970)
-- Name: insurance_companies insurance_companies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.insurance_companies
    ADD CONSTRAINT insurance_companies_pkey PRIMARY KEY (id);


--
-- TOC entry 4212 (class 2606 OID 18998)
-- Name: investments investments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investments
    ADD CONSTRAINT investments_pkey PRIMARY KEY (id);


--
-- TOC entry 4167 (class 2606 OID 18744)
-- Name: investor_documents investor_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investor_documents
    ADD CONSTRAINT investor_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4164 (class 2606 OID 18727)
-- Name: investors investors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investors
    ADD CONSTRAINT investors_pkey PRIMARY KEY (id);


--
-- TOC entry 4296 (class 2606 OID 19487)
-- Name: invoice_items invoice_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT invoice_items_pkey PRIMARY KEY (id);


--
-- TOC entry 4246 (class 2606 OID 19156)
-- Name: invoices invoices_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoices
    ADD CONSTRAINT invoices_pkey PRIMARY KEY (id);


--
-- TOC entry 4046 (class 2606 OID 18110)
-- Name: leads leads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT leads_pkey PRIMARY KEY (id);


--
-- TOC entry 4173 (class 2606 OID 18801)
-- Name: life_insurance_bank_details life_insurance_bank_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurance_bank_details
    ADD CONSTRAINT life_insurance_bank_details_pkey PRIMARY KEY (id);


--
-- TOC entry 4176 (class 2606 OID 18820)
-- Name: life_insurance_documents life_insurance_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurance_documents
    ADD CONSTRAINT life_insurance_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4170 (class 2606 OID 18782)
-- Name: life_insurance_nominees life_insurance_nominees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurance_nominees
    ADD CONSTRAINT life_insurance_nominees_pkey PRIMARY KEY (id);


--
-- TOC entry 4112 (class 2606 OID 18431)
-- Name: life_insurances life_insurances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurances
    ADD CONSTRAINT life_insurances_pkey PRIMARY KEY (id);


--
-- TOC entry 4215 (class 2606 OID 19017)
-- Name: loans loans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_pkey PRIMARY KEY (id);


--
-- TOC entry 4313 (class 2606 OID 19675)
-- Name: motor_insurance_documents motor_insurance_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_insurance_documents
    ADD CONSTRAINT motor_insurance_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4305 (class 2606 OID 19544)
-- Name: motor_insurance_nominees motor_insurance_nominees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_insurance_nominees
    ADD CONSTRAINT motor_insurance_nominees_pkey PRIMARY KEY (id);


--
-- TOC entry 4015 (class 2606 OID 18073)
-- Name: motor_insurances motor_insurances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_insurances
    ADD CONSTRAINT motor_insurances_pkey PRIMARY KEY (id);


--
-- TOC entry 4390 (class 2606 OID 20830)
-- Name: mutual_fund_nominees mutual_fund_nominees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mutual_fund_nominees
    ADD CONSTRAINT mutual_fund_nominees_pkey PRIMARY KEY (id);


--
-- TOC entry 4387 (class 2606 OID 20798)
-- Name: mutual_funds mutual_funds_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mutual_funds
    ADD CONSTRAINT mutual_funds_pkey PRIMARY KEY (id);


--
-- TOC entry 4328 (class 2606 OID 19771)
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- TOC entry 4319 (class 2606 OID 19713)
-- Name: other_insurance_documents other_insurance_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.other_insurance_documents
    ADD CONSTRAINT other_insurance_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4302 (class 2606 OID 19525)
-- Name: other_insurance_nominees other_insurance_nominees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.other_insurance_nominees
    ADD CONSTRAINT other_insurance_nominees_pkey PRIMARY KEY (id);


--
-- TOC entry 4026 (class 2606 OID 18092)
-- Name: other_insurances other_insurances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.other_insurances
    ADD CONSTRAINT other_insurances_pkey PRIMARY KEY (id);


--
-- TOC entry 4205 (class 2606 OID 18892)
-- Name: payout_audit_logs payout_audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payout_audit_logs
    ADD CONSTRAINT payout_audit_logs_pkey PRIMARY KEY (id);


--
-- TOC entry 4200 (class 2606 OID 18874)
-- Name: payout_distributions payout_distributions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payout_distributions
    ADD CONSTRAINT payout_distributions_pkey PRIMARY KEY (id);


--
-- TOC entry 4240 (class 2606 OID 19096)
-- Name: payouts payouts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payouts
    ADD CONSTRAINT payouts_pkey PRIMARY KEY (id);


--
-- TOC entry 4129 (class 2606 OID 18546)
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 3979 (class 2606 OID 17998)
-- Name: policies policies_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT policies_pkey PRIMARY KEY (id);


--
-- TOC entry 4310 (class 2606 OID 19659)
-- Name: policy_documents policy_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policy_documents
    ADD CONSTRAINT policy_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4264 (class 2606 OID 19278)
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- TOC entry 4136 (class 2606 OID 18561)
-- Name: role_permissions role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT role_permissions_pkey PRIMARY KEY (id);


--
-- TOC entry 4124 (class 2606 OID 18529)
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- TOC entry 3930 (class 2606 OID 17905)
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- TOC entry 4287 (class 2606 OID 19356)
-- Name: session_activities session_activities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_activities
    ADD CONSTRAINT session_activities_pkey PRIMARY KEY (id);


--
-- TOC entry 4333 (class 2606 OID 19798)
-- Name: solid_cache_entries solid_cache_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_cache_entries
    ADD CONSTRAINT solid_cache_entries_pkey PRIMARY KEY (id);


--
-- TOC entry 4345 (class 2606 OID 20557)
-- Name: solid_queue_blocked_executions solid_queue_blocked_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_blocked_executions
    ADD CONSTRAINT solid_queue_blocked_executions_pkey PRIMARY KEY (id);


--
-- TOC entry 4349 (class 2606 OID 20570)
-- Name: solid_queue_claimed_executions solid_queue_claimed_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_claimed_executions
    ADD CONSTRAINT solid_queue_claimed_executions_pkey PRIMARY KEY (id);


--
-- TOC entry 4352 (class 2606 OID 20584)
-- Name: solid_queue_failed_executions solid_queue_failed_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_failed_executions
    ADD CONSTRAINT solid_queue_failed_executions_pkey PRIMARY KEY (id);


--
-- TOC entry 4340 (class 2606 OID 20535)
-- Name: solid_queue_jobs solid_queue_jobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_jobs
    ADD CONSTRAINT solid_queue_jobs_pkey PRIMARY KEY (id);


--
-- TOC entry 4355 (class 2606 OID 20597)
-- Name: solid_queue_pauses solid_queue_pauses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_pauses
    ADD CONSTRAINT solid_queue_pauses_pkey PRIMARY KEY (id);


--
-- TOC entry 4360 (class 2606 OID 20613)
-- Name: solid_queue_processes solid_queue_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_processes
    ADD CONSTRAINT solid_queue_processes_pkey PRIMARY KEY (id);


--
-- TOC entry 4365 (class 2606 OID 20631)
-- Name: solid_queue_ready_executions solid_queue_ready_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_ready_executions
    ADD CONSTRAINT solid_queue_ready_executions_pkey PRIMARY KEY (id);


--
-- TOC entry 4369 (class 2606 OID 20648)
-- Name: solid_queue_recurring_executions solid_queue_recurring_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_recurring_executions
    ADD CONSTRAINT solid_queue_recurring_executions_pkey PRIMARY KEY (id);


--
-- TOC entry 4373 (class 2606 OID 20667)
-- Name: solid_queue_recurring_tasks solid_queue_recurring_tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_recurring_tasks
    ADD CONSTRAINT solid_queue_recurring_tasks_pkey PRIMARY KEY (id);


--
-- TOC entry 4377 (class 2606 OID 20685)
-- Name: solid_queue_scheduled_executions solid_queue_scheduled_executions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_scheduled_executions
    ADD CONSTRAINT solid_queue_scheduled_executions_pkey PRIMARY KEY (id);


--
-- TOC entry 4382 (class 2606 OID 20703)
-- Name: solid_queue_semaphores solid_queue_semaphores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_semaphores
    ADD CONSTRAINT solid_queue_semaphores_pkey PRIMARY KEY (id);


--
-- TOC entry 4075 (class 2606 OID 18240)
-- Name: sub_agent_documents sub_agent_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_agent_documents
    ADD CONSTRAINT sub_agent_documents_pkey PRIMARY KEY (id);


--
-- TOC entry 4070 (class 2606 OID 18222)
-- Name: sub_agents sub_agents_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_agents
    ADD CONSTRAINT sub_agents_pkey PRIMARY KEY (id);


--
-- TOC entry 4158 (class 2606 OID 18708)
-- Name: system_settings system_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.system_settings
    ADD CONSTRAINT system_settings_pkey PRIMARY KEY (id);


--
-- TOC entry 4218 (class 2606 OID 19036)
-- Name: tax_services tax_services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_services
    ADD CONSTRAINT tax_services_pkey PRIMARY KEY (id);


--
-- TOC entry 4221 (class 2606 OID 19055)
-- Name: travel_packages travel_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.travel_packages
    ADD CONSTRAINT travel_packages_pkey PRIMARY KEY (id);


--
-- TOC entry 4144 (class 2606 OID 18614)
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- TOC entry 4273 (class 2606 OID 19306)
-- Name: user_sessions user_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT user_sessions_pkey PRIMARY KEY (id);


--
-- TOC entry 3938 (class 2606 OID 17927)
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 4179 (class 1259 OID 19116)
-- Name: idx_commission_payouts_payout_to_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_commission_payouts_payout_to_status ON public.commission_payouts USING btree (payout_to, status);


--
-- TOC entry 4180 (class 1259 OID 19108)
-- Name: idx_commission_payouts_policy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_commission_payouts_policy ON public.commission_payouts USING btree (policy_type, policy_id);


--
-- TOC entry 4181 (class 1259 OID 19109)
-- Name: idx_commission_payouts_policy_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_commission_payouts_policy_status ON public.commission_payouts USING btree (policy_type, policy_id, status);


--
-- TOC entry 4182 (class 1259 OID 19110)
-- Name: idx_commission_payouts_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_commission_payouts_status ON public.commission_payouts USING btree (status);


--
-- TOC entry 4288 (class 1259 OID 19430)
-- Name: idx_dashboard_stats_view_calculated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_dashboard_stats_view_calculated_at ON public.dashboard_stats_view USING btree (calculated_at);


--
-- TOC entry 3982 (class 1259 OID 19112)
-- Name: idx_health_insurances_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_health_insurances_created_at ON public.health_insurances USING btree (created_at);


--
-- TOC entry 3955 (class 1259 OID 19554)
-- Name: idx_insurance_companies_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_insurance_companies_code ON public.insurance_companies USING btree (code);


--
-- TOC entry 3956 (class 1259 OID 19637)
-- Name: idx_insurance_companies_code_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_insurance_companies_code_gin ON public.insurance_companies USING gin (code public.gin_trgm_ops);


--
-- TOC entry 3957 (class 1259 OID 19638)
-- Name: idx_insurance_companies_contact_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_insurance_companies_contact_gin ON public.insurance_companies USING gin (contact_person public.gin_trgm_ops);


--
-- TOC entry 3958 (class 1259 OID 19641)
-- Name: idx_insurance_companies_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_insurance_companies_created_at ON public.insurance_companies USING btree (created_at);


--
-- TOC entry 3959 (class 1259 OID 19553)
-- Name: idx_insurance_companies_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_insurance_companies_name ON public.insurance_companies USING btree (name);


--
-- TOC entry 3960 (class 1259 OID 19636)
-- Name: idx_insurance_companies_name_gin; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_insurance_companies_name_gin ON public.insurance_companies USING gin (name public.gin_trgm_ops);


--
-- TOC entry 3961 (class 1259 OID 19640)
-- Name: idx_insurance_companies_name_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_insurance_companies_name_id ON public.insurance_companies USING btree (name, id);


--
-- TOC entry 3962 (class 1259 OID 19639)
-- Name: idx_insurance_companies_search_composite; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_insurance_companies_search_composite ON public.insurance_companies USING btree (name, code, contact_person);


--
-- TOC entry 3963 (class 1259 OID 19552)
-- Name: idx_insurance_companies_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_insurance_companies_status ON public.insurance_companies USING btree (status);


--
-- TOC entry 3964 (class 1259 OID 19642)
-- Name: idx_insurance_companies_updated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_insurance_companies_updated_at ON public.insurance_companies USING btree (updated_at);


--
-- TOC entry 4087 (class 1259 OID 19113)
-- Name: idx_life_insurances_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_life_insurances_created_at ON public.life_insurances USING btree (created_at);


--
-- TOC entry 4000 (class 1259 OID 19114)
-- Name: idx_motor_insurances_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_motor_insurances_created_at ON public.motor_insurances USING btree (created_at);


--
-- TOC entry 3983 (class 1259 OID 19778)
-- Name: idx_on_product_through_dr_total_premium_6bf60d17b1; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_on_product_through_dr_total_premium_6bf60d17b1 ON public.health_insurances USING btree (product_through_dr, total_premium);


--
-- TOC entry 4016 (class 1259 OID 19115)
-- Name: idx_other_insurances_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_other_insurances_created_at ON public.other_insurances USING btree (created_at);


--
-- TOC entry 4230 (class 1259 OID 19111)
-- Name: idx_payouts_policy; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_payouts_policy ON public.payouts USING btree (policy_type, policy_id);


--
-- TOC entry 4130 (class 1259 OID 18576)
-- Name: idx_role_permissions_permission; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_role_permissions_permission ON public.role_permissions USING btree (permission_id);


--
-- TOC entry 4131 (class 1259 OID 18575)
-- Name: idx_role_permissions_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_role_permissions_role ON public.role_permissions USING btree (role_id);


--
-- TOC entry 4132 (class 1259 OID 18574)
-- Name: idx_role_permissions_unique; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_role_permissions_unique ON public.role_permissions USING btree (role_id, permission_id);


--
-- TOC entry 3933 (class 1259 OID 18583)
-- Name: idx_users_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_role_id ON public.users USING btree (role_id);


--
-- TOC entry 4052 (class 1259 OID 18147)
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- TOC entry 4053 (class 1259 OID 18148)
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- TOC entry 4049 (class 1259 OID 18126)
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- TOC entry 4056 (class 1259 OID 18166)
-- Name: index_active_storage_variant_records_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_variant_records_uniqueness ON public.active_storage_variant_records USING btree (blob_id, variation_digest);


--
-- TOC entry 4078 (class 1259 OID 19131)
-- Name: index_agency_codes_on_broker_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_agency_codes_on_broker_id ON public.agency_codes USING btree (broker_id);


--
-- TOC entry 4281 (class 1259 OID 19342)
-- Name: index_ahoy_events_on_name_and_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_events_on_name_and_time ON public.ahoy_events USING btree (name, "time");


--
-- TOC entry 4282 (class 1259 OID 19343)
-- Name: index_ahoy_events_on_properties; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_events_on_properties ON public.ahoy_events USING gin (properties jsonb_path_ops);


--
-- TOC entry 4283 (class 1259 OID 19341)
-- Name: index_ahoy_events_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_events_on_user_id ON public.ahoy_events USING btree (user_id);


--
-- TOC entry 4284 (class 1259 OID 19340)
-- Name: index_ahoy_events_on_visit_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_events_on_visit_id ON public.ahoy_events USING btree (visit_id);


--
-- TOC entry 4276 (class 1259 OID 19327)
-- Name: index_ahoy_visits_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_visits_on_user_id ON public.ahoy_visits USING btree (user_id);


--
-- TOC entry 4277 (class 1259 OID 19328)
-- Name: index_ahoy_visits_on_visit_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_ahoy_visits_on_visit_token ON public.ahoy_visits USING btree (visit_token);


--
-- TOC entry 4278 (class 1259 OID 19329)
-- Name: index_ahoy_visits_on_visitor_token_and_started_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ahoy_visits_on_visitor_token_and_started_at ON public.ahoy_visits USING btree (visitor_token, started_at);


--
-- TOC entry 4255 (class 1259 OID 19237)
-- Name: index_ai_report_histories_on_confidence_score; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ai_report_histories_on_confidence_score ON public.ai_report_histories USING btree (confidence_score);


--
-- TOC entry 4256 (class 1259 OID 19236)
-- Name: index_ai_report_histories_on_generated_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ai_report_histories_on_generated_at ON public.ai_report_histories USING btree (generated_at);


--
-- TOC entry 4257 (class 1259 OID 19238)
-- Name: index_ai_report_histories_on_report_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ai_report_histories_on_report_type ON public.ai_report_histories USING btree (report_type);


--
-- TOC entry 4258 (class 1259 OID 19234)
-- Name: index_ai_report_histories_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ai_report_histories_on_user_id ON public.ai_report_histories USING btree (user_id);


--
-- TOC entry 4259 (class 1259 OID 19235)
-- Name: index_ai_report_histories_on_user_id_and_report_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_ai_report_histories_on_user_id_and_report_type ON public.ai_report_histories USING btree (user_id, report_type);


--
-- TOC entry 4262 (class 1259 OID 19266)
-- Name: index_analytics_caches_on_cache_identifier; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_analytics_caches_on_cache_identifier ON public.analytics_caches USING btree (cache_identifier);


--
-- TOC entry 4393 (class 1259 OID 20870)
-- Name: index_appointments_on_appointment_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_appointment_date ON public.appointments USING btree (appointment_date);


--
-- TOC entry 4394 (class 1259 OID 20869)
-- Name: index_appointments_on_created_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_created_by_id ON public.appointments USING btree (created_by_id);


--
-- TOC entry 4395 (class 1259 OID 20868)
-- Name: index_appointments_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_customer_id ON public.appointments USING btree (customer_id);


--
-- TOC entry 4396 (class 1259 OID 20871)
-- Name: index_appointments_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_appointments_on_status ON public.appointments USING btree (status);


--
-- TOC entry 4316 (class 1259 OID 19700)
-- Name: index_banner_documents_on_banner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_banner_documents_on_banner_id ON public.banner_documents USING btree (banner_id);


--
-- TOC entry 4139 (class 1259 OID 18597)
-- Name: index_banners_on_display_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_banners_on_display_order ON public.banners USING btree (display_order);


--
-- TOC entry 4252 (class 1259 OID 19208)
-- Name: index_broker_codes_on_broker_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_broker_codes_on_broker_id ON public.broker_codes USING btree (broker_id);


--
-- TOC entry 4081 (class 1259 OID 19125)
-- Name: index_brokers_on_insurance_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_brokers_on_insurance_company_id ON public.brokers USING btree (insurance_company_id);


--
-- TOC entry 4082 (class 1259 OID 18274)
-- Name: index_brokers_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_brokers_on_name ON public.brokers USING btree (name);


--
-- TOC entry 4083 (class 1259 OID 18275)
-- Name: index_brokers_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_brokers_on_status ON public.brokers USING btree (status);


--
-- TOC entry 4115 (class 1259 OID 18489)
-- Name: index_client_requests_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_client_requests_on_email ON public.client_requests USING btree (email);


--
-- TOC entry 4116 (class 1259 OID 18487)
-- Name: index_client_requests_on_resolved_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_client_requests_on_resolved_by_id ON public.client_requests USING btree (resolved_by_id);


--
-- TOC entry 4117 (class 1259 OID 18490)
-- Name: index_client_requests_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_client_requests_on_status ON public.client_requests USING btree (status);


--
-- TOC entry 4118 (class 1259 OID 18491)
-- Name: index_client_requests_on_submitted_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_client_requests_on_submitted_at ON public.client_requests USING btree (submitted_at);


--
-- TOC entry 4119 (class 1259 OID 19470)
-- Name: index_client_requests_on_submitter_type_and_submitter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_client_requests_on_submitter_type_and_submitter_id ON public.client_requests USING btree (submitter_type, submitter_id);


--
-- TOC entry 4120 (class 1259 OID 18488)
-- Name: index_client_requests_on_ticket_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_client_requests_on_ticket_number ON public.client_requests USING btree (ticket_number);


--
-- TOC entry 4399 (class 1259 OID 20949)
-- Name: index_client_services_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_client_services_on_customer_id ON public.client_services USING btree (customer_id);


--
-- TOC entry 4400 (class 1259 OID 20951)
-- Name: index_client_services_on_service_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_client_services_on_service_category ON public.client_services USING btree (service_category);


--
-- TOC entry 4401 (class 1259 OID 20950)
-- Name: index_client_services_on_service_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_client_services_on_service_type ON public.client_services USING btree (service_type);


--
-- TOC entry 4402 (class 1259 OID 20952)
-- Name: index_client_services_on_sub_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_client_services_on_sub_agent_id ON public.client_services USING btree (sub_agent_id);


--
-- TOC entry 4183 (class 1259 OID 19399)
-- Name: index_commission_payouts_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commission_payouts_on_created_at ON public.commission_payouts USING btree (created_at);


--
-- TOC entry 4184 (class 1259 OID 19162)
-- Name: index_commission_payouts_on_lead_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commission_payouts_on_lead_id ON public.commission_payouts USING btree (lead_id);


--
-- TOC entry 4185 (class 1259 OID 18895)
-- Name: index_commission_payouts_on_payout_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commission_payouts_on_payout_date ON public.commission_payouts USING btree (payout_date);


--
-- TOC entry 4186 (class 1259 OID 19097)
-- Name: index_commission_payouts_on_payout_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commission_payouts_on_payout_id ON public.commission_payouts USING btree (payout_id);


--
-- TOC entry 4187 (class 1259 OID 18894)
-- Name: index_commission_payouts_on_payout_to_and_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commission_payouts_on_payout_to_and_status ON public.commission_payouts USING btree (payout_to, status);


--
-- TOC entry 4188 (class 1259 OID 18893)
-- Name: index_commission_payouts_on_policy_type_and_policy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commission_payouts_on_policy_type_and_policy_id ON public.commission_payouts USING btree (policy_type, policy_id);


--
-- TOC entry 4189 (class 1259 OID 19400)
-- Name: index_commission_payouts_on_status_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commission_payouts_on_status_and_created_at ON public.commission_payouts USING btree (status, created_at);


--
-- TOC entry 4192 (class 1259 OID 18898)
-- Name: index_commission_receipts_on_auto_distributed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commission_receipts_on_auto_distributed ON public.commission_receipts USING btree (auto_distributed);


--
-- TOC entry 4193 (class 1259 OID 18896)
-- Name: index_commission_receipts_on_policy_type_and_policy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_commission_receipts_on_policy_type_and_policy_id ON public.commission_receipts USING btree (policy_type, policy_id);


--
-- TOC entry 4194 (class 1259 OID 18897)
-- Name: index_commission_receipts_on_received_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_commission_receipts_on_received_date ON public.commission_receipts USING btree (received_date);


--
-- TOC entry 4059 (class 1259 OID 18189)
-- Name: index_corporate_members_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_corporate_members_on_customer_id ON public.corporate_members USING btree (customer_id);


--
-- TOC entry 4249 (class 1259 OID 19181)
-- Name: index_customer_documents_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customer_documents_on_customer_id ON public.customer_documents USING btree (customer_id);


--
-- TOC entry 3941 (class 1259 OID 18508)
-- Name: index_customers_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_created_at ON public.customers USING btree (created_at);


--
-- TOC entry 3942 (class 1259 OID 18505)
-- Name: index_customers_on_customer_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_customer_type ON public.customers USING btree (customer_type);


--
-- TOC entry 3943 (class 1259 OID 18513)
-- Name: index_customers_on_customer_type_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_customer_type_and_created_at ON public.customers USING btree (customer_type, created_at);


--
-- TOC entry 3944 (class 1259 OID 18507)
-- Name: index_customers_on_customer_type_and_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_customer_type_and_status ON public.customers USING btree (customer_type, status);


--
-- TOC entry 3945 (class 1259 OID 18509)
-- Name: index_customers_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_email ON public.customers USING btree (email);


--
-- TOC entry 3946 (class 1259 OID 19161)
-- Name: index_customers_on_lead_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_customers_on_lead_id ON public.customers USING btree (lead_id);


--
-- TOC entry 3947 (class 1259 OID 18510)
-- Name: index_customers_on_mobile; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_mobile ON public.customers USING btree (mobile);


--
-- TOC entry 3948 (class 1259 OID 18511)
-- Name: index_customers_on_pan_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_pan_number ON public.customers USING btree (pan_number);


--
-- TOC entry 3949 (class 1259 OID 18506)
-- Name: index_customers_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_status ON public.customers USING btree (status);


--
-- TOC entry 3950 (class 1259 OID 18512)
-- Name: index_customers_on_status_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_status_and_created_at ON public.customers USING btree (status, created_at);


--
-- TOC entry 3951 (class 1259 OID 19119)
-- Name: index_customers_on_sub_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_customers_on_sub_agent_id ON public.customers USING btree (sub_agent_id);


--
-- TOC entry 4208 (class 1259 OID 18941)
-- Name: index_distributor_assignments_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_distributor_assignments_on_distributor_id ON public.distributor_assignments USING btree (distributor_id);


--
-- TOC entry 4209 (class 1259 OID 18942)
-- Name: index_distributor_assignments_on_sub_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_distributor_assignments_on_sub_agent_id ON public.distributor_assignments USING btree (sub_agent_id);


--
-- TOC entry 4155 (class 1259 OID 18695)
-- Name: index_distributor_documents_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_distributor_documents_on_distributor_id ON public.distributor_documents USING btree (distributor_id);


--
-- TOC entry 4224 (class 1259 OID 19402)
-- Name: index_distributor_payouts_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_distributor_payouts_on_created_at ON public.distributor_payouts USING btree (created_at);


--
-- TOC entry 4225 (class 1259 OID 19081)
-- Name: index_distributor_payouts_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_distributor_payouts_on_distributor_id ON public.distributor_payouts USING btree (distributor_id);


--
-- TOC entry 4226 (class 1259 OID 19083)
-- Name: index_distributor_payouts_on_distributor_id_and_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_distributor_payouts_on_distributor_id_and_status ON public.distributor_payouts USING btree (distributor_id, status);


--
-- TOC entry 4227 (class 1259 OID 19082)
-- Name: index_distributor_payouts_on_policy_type_and_policy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_distributor_payouts_on_policy_type_and_policy_id ON public.distributor_payouts USING btree (policy_type, policy_id);


--
-- TOC entry 4228 (class 1259 OID 19084)
-- Name: index_distributor_payouts_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_distributor_payouts_on_status ON public.distributor_payouts USING btree (status);


--
-- TOC entry 4229 (class 1259 OID 19403)
-- Name: index_distributor_payouts_on_status_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_distributor_payouts_on_status_and_created_at ON public.distributor_payouts USING btree (status, created_at);


--
-- TOC entry 4147 (class 1259 OID 19401)
-- Name: index_distributors_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_distributors_on_created_at ON public.distributors USING btree (created_at);


--
-- TOC entry 4148 (class 1259 OID 18674)
-- Name: index_distributors_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_distributors_on_email ON public.distributors USING btree (email);


--
-- TOC entry 4149 (class 1259 OID 19643)
-- Name: index_distributors_on_investor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_distributors_on_investor_id ON public.distributors USING btree (investor_id);


--
-- TOC entry 4150 (class 1259 OID 18673)
-- Name: index_distributors_on_mobile; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_distributors_on_mobile ON public.distributors USING btree (mobile);


--
-- TOC entry 4151 (class 1259 OID 18675)
-- Name: index_distributors_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_distributors_on_role_id ON public.distributors USING btree (role_id);


--
-- TOC entry 4152 (class 1259 OID 18676)
-- Name: index_distributors_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_distributors_on_status ON public.distributors USING btree (status);


--
-- TOC entry 4062 (class 1259 OID 18204)
-- Name: index_documents_on_documentable; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_documents_on_documentable ON public.documents USING btree (documentable_type, documentable_id);


--
-- TOC entry 3954 (class 1259 OID 17958)
-- Name: index_family_members_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_family_members_on_customer_id ON public.family_members USING btree (customer_id);


--
-- TOC entry 4322 (class 1259 OID 19759)
-- Name: index_health_insurance_documents_on_health_insurance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurance_documents_on_health_insurance_id ON public.health_insurance_documents USING btree (health_insurance_id);


--
-- TOC entry 4086 (class 1259 OID 18318)
-- Name: index_health_insurance_members_on_health_insurance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurance_members_on_health_insurance_id ON public.health_insurance_members USING btree (health_insurance_id);


--
-- TOC entry 4299 (class 1259 OID 19512)
-- Name: index_health_insurance_nominees_on_health_insurance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurance_nominees_on_health_insurance_id ON public.health_insurance_nominees USING btree (health_insurance_id);


--
-- TOC entry 3984 (class 1259 OID 18288)
-- Name: index_health_insurances_on_agency_code_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurances_on_agency_code_id ON public.health_insurances USING btree (agency_code_id);


--
-- TOC entry 3985 (class 1259 OID 18294)
-- Name: index_health_insurances_on_broker_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurances_on_broker_id ON public.health_insurances USING btree (broker_id);


--
-- TOC entry 3986 (class 1259 OID 18276)
-- Name: index_health_insurances_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurances_on_customer_id ON public.health_insurances USING btree (customer_id);


--
-- TOC entry 3987 (class 1259 OID 19390)
-- Name: index_health_insurances_on_customer_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurances_on_customer_id_and_created_at ON public.health_insurances USING btree (customer_id, created_at);


--
-- TOC entry 3988 (class 1259 OID 18950)
-- Name: index_health_insurances_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurances_on_distributor_id ON public.health_insurances USING btree (distributor_id);


--
-- TOC entry 3989 (class 1259 OID 19472)
-- Name: index_health_insurances_on_insurance_company_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurances_on_insurance_company_code ON public.health_insurances USING btree (insurance_company_code);


--
-- TOC entry 3990 (class 1259 OID 18956)
-- Name: index_health_insurances_on_investor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurances_on_investor_id ON public.health_insurances USING btree (investor_id);


--
-- TOC entry 3991 (class 1259 OID 18943)
-- Name: index_health_insurances_on_lead_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_health_insurances_on_lead_id ON public.health_insurances USING btree (lead_id);


--
-- TOC entry 3992 (class 1259 OID 19387)
-- Name: index_health_insurances_on_policy_end_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurances_on_policy_end_date ON public.health_insurances USING btree (policy_end_date);


--
-- TOC entry 3993 (class 1259 OID 19389)
-- Name: index_health_insurances_on_policy_end_date_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurances_on_policy_end_date_and_created_at ON public.health_insurances USING btree (policy_end_date, created_at);


--
-- TOC entry 3994 (class 1259 OID 18060)
-- Name: index_health_insurances_on_policy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurances_on_policy_id ON public.health_insurances USING btree (policy_id);


--
-- TOC entry 3995 (class 1259 OID 19388)
-- Name: index_health_insurances_on_policy_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurances_on_policy_type ON public.health_insurances USING btree (policy_type);


--
-- TOC entry 3996 (class 1259 OID 19776)
-- Name: index_health_insurances_on_product_through_dr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurances_on_product_through_dr ON public.health_insurances USING btree (product_through_dr);


--
-- TOC entry 3997 (class 1259 OID 19777)
-- Name: index_health_insurances_on_product_through_dr_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurances_on_product_through_dr_and_created_at ON public.health_insurances USING btree (product_through_dr, created_at);


--
-- TOC entry 3998 (class 1259 OID 19779)
-- Name: index_health_insurances_on_product_through_dr_and_sum_insured; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurances_on_product_through_dr_and_sum_insured ON public.health_insurances USING btree (product_through_dr, sum_insured);


--
-- TOC entry 3999 (class 1259 OID 18282)
-- Name: index_health_insurances_on_sub_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_health_insurances_on_sub_agent_id ON public.health_insurances USING btree (sub_agent_id);


--
-- TOC entry 4291 (class 1259 OID 19468)
-- Name: index_helpdesk_tickets_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_helpdesk_tickets_on_customer_id ON public.helpdesk_tickets USING btree (customer_id);


--
-- TOC entry 4292 (class 1259 OID 19467)
-- Name: index_helpdesk_tickets_on_sub_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_helpdesk_tickets_on_sub_agent_id ON public.helpdesk_tickets USING btree (sub_agent_id);


--
-- TOC entry 4293 (class 1259 OID 19469)
-- Name: index_helpdesk_tickets_on_ticket_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_helpdesk_tickets_on_ticket_number ON public.helpdesk_tickets USING btree (ticket_number);


--
-- TOC entry 4210 (class 1259 OID 19004)
-- Name: index_investments_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_investments_on_customer_id ON public.investments USING btree (customer_id);


--
-- TOC entry 4165 (class 1259 OID 18750)
-- Name: index_investor_documents_on_investor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_investor_documents_on_investor_id ON public.investor_documents USING btree (investor_id);


--
-- TOC entry 4159 (class 1259 OID 18729)
-- Name: index_investors_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_investors_on_email ON public.investors USING btree (email);


--
-- TOC entry 4160 (class 1259 OID 18728)
-- Name: index_investors_on_mobile; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_investors_on_mobile ON public.investors USING btree (mobile);


--
-- TOC entry 4161 (class 1259 OID 18730)
-- Name: index_investors_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_investors_on_role_id ON public.investors USING btree (role_id);


--
-- TOC entry 4162 (class 1259 OID 18731)
-- Name: index_investors_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_investors_on_status ON public.investors USING btree (status);


--
-- TOC entry 4294 (class 1259 OID 19493)
-- Name: index_invoice_items_on_invoice_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoice_items_on_invoice_id ON public.invoice_items USING btree (invoice_id);


--
-- TOC entry 4241 (class 1259 OID 19160)
-- Name: index_invoices_on_invoice_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoices_on_invoice_date ON public.invoices USING btree (invoice_date);


--
-- TOC entry 4242 (class 1259 OID 19157)
-- Name: index_invoices_on_invoice_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_invoices_on_invoice_number ON public.invoices USING btree (invoice_number);


--
-- TOC entry 4243 (class 1259 OID 19158)
-- Name: index_invoices_on_payout_type_and_payout_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoices_on_payout_type_and_payout_id ON public.invoices USING btree (payout_type, payout_id);


--
-- TOC entry 4244 (class 1259 OID 19159)
-- Name: index_invoices_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_invoices_on_status ON public.invoices USING btree (status);


--
-- TOC entry 4027 (class 1259 OID 19118)
-- Name: index_leads_on_affiliate_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_affiliate_id ON public.leads USING btree (affiliate_id);


--
-- TOC entry 4028 (class 1259 OID 19363)
-- Name: index_leads_on_ambassador_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_ambassador_id ON public.leads USING btree (ambassador_id);


--
-- TOC entry 4029 (class 1259 OID 19435)
-- Name: index_leads_on_company_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_company_name ON public.leads USING btree (company_name);


--
-- TOC entry 4030 (class 1259 OID 19431)
-- Name: index_leads_on_contact_number; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_contact_number ON public.leads USING btree (contact_number);


--
-- TOC entry 4031 (class 1259 OID 18503)
-- Name: index_leads_on_converted_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_converted_customer_id ON public.leads USING btree (converted_customer_id);


--
-- TOC entry 4032 (class 1259 OID 19385)
-- Name: index_leads_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_created_at ON public.leads USING btree (created_at);


--
-- TOC entry 4033 (class 1259 OID 18501)
-- Name: index_leads_on_current_stage; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_current_stage ON public.leads USING btree (current_stage);


--
-- TOC entry 4034 (class 1259 OID 19386)
-- Name: index_leads_on_current_stage_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_current_stage_and_created_at ON public.leads USING btree (current_stage, created_at);


--
-- TOC entry 4035 (class 1259 OID 19432)
-- Name: index_leads_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_email ON public.leads USING btree (email);


--
-- TOC entry 4036 (class 1259 OID 19437)
-- Name: index_leads_on_first_name_and_last_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_first_name_and_last_name ON public.leads USING btree (first_name, last_name);


--
-- TOC entry 4037 (class 1259 OID 19436)
-- Name: index_leads_on_is_direct; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_is_direct ON public.leads USING btree (is_direct);


--
-- TOC entry 4038 (class 1259 OID 18500)
-- Name: index_leads_on_lead_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_leads_on_lead_id ON public.leads USING btree (lead_id);


--
-- TOC entry 4039 (class 1259 OID 18502)
-- Name: index_leads_on_lead_source; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_lead_source ON public.leads USING btree (lead_source);


--
-- TOC entry 4040 (class 1259 OID 19805)
-- Name: index_leads_on_parent_lead_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_parent_lead_id ON public.leads USING btree (parent_lead_id);


--
-- TOC entry 4041 (class 1259 OID 18504)
-- Name: index_leads_on_policy_created_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_policy_created_id ON public.leads USING btree (policy_created_id);


--
-- TOC entry 4042 (class 1259 OID 19433)
-- Name: index_leads_on_product_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_product_category ON public.leads USING btree (product_category);


--
-- TOC entry 4043 (class 1259 OID 19438)
-- Name: index_leads_on_product_category_and_product_subcategory; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_product_category_and_product_subcategory ON public.leads USING btree (product_category, product_subcategory);


--
-- TOC entry 4044 (class 1259 OID 19434)
-- Name: index_leads_on_product_subcategory; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_leads_on_product_subcategory ON public.leads USING btree (product_subcategory);


--
-- TOC entry 4171 (class 1259 OID 18807)
-- Name: index_life_insurance_bank_details_on_life_insurance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurance_bank_details_on_life_insurance_id ON public.life_insurance_bank_details USING btree (life_insurance_id);


--
-- TOC entry 4174 (class 1259 OID 18826)
-- Name: index_life_insurance_documents_on_life_insurance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurance_documents_on_life_insurance_id ON public.life_insurance_documents USING btree (life_insurance_id);


--
-- TOC entry 4168 (class 1259 OID 18788)
-- Name: index_life_insurance_nominees_on_life_insurance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurance_nominees_on_life_insurance_id ON public.life_insurance_nominees USING btree (life_insurance_id);


--
-- TOC entry 4088 (class 1259 OID 18454)
-- Name: index_life_insurances_on_agency_code_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_agency_code_id ON public.life_insurances USING btree (agency_code_id);


--
-- TOC entry 4089 (class 1259 OID 18455)
-- Name: index_life_insurances_on_broker_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_broker_id ON public.life_insurances USING btree (broker_id);


--
-- TOC entry 4090 (class 1259 OID 18452)
-- Name: index_life_insurances_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_customer_id ON public.life_insurances USING btree (customer_id);


--
-- TOC entry 4091 (class 1259 OID 19392)
-- Name: index_life_insurances_on_customer_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_customer_id_and_created_at ON public.life_insurances USING btree (customer_id, created_at);


--
-- TOC entry 4092 (class 1259 OID 18751)
-- Name: index_life_insurances_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_distributor_id ON public.life_insurances USING btree (distributor_id);


--
-- TOC entry 4093 (class 1259 OID 19471)
-- Name: index_life_insurances_on_insurance_company_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_insurance_company_code ON public.life_insurances USING btree (insurance_company_code);


--
-- TOC entry 4094 (class 1259 OID 18457)
-- Name: index_life_insurances_on_insurance_company_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_insurance_company_name ON public.life_insurances USING btree (insurance_company_name);


--
-- TOC entry 4095 (class 1259 OID 18757)
-- Name: index_life_insurances_on_investor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_investor_id ON public.life_insurances USING btree (investor_id);


--
-- TOC entry 4096 (class 1259 OID 19243)
-- Name: index_life_insurances_on_is_renewed; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_is_renewed ON public.life_insurances USING btree (is_renewed);


--
-- TOC entry 4097 (class 1259 OID 18944)
-- Name: index_life_insurances_on_lead_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_life_insurances_on_lead_id ON public.life_insurances USING btree (lead_id);


--
-- TOC entry 4098 (class 1259 OID 19241)
-- Name: index_life_insurances_on_original_policy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_original_policy_id ON public.life_insurances USING btree (original_policy_id);


--
-- TOC entry 4099 (class 1259 OID 18460)
-- Name: index_life_insurances_on_policy_end_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_policy_end_date ON public.life_insurances USING btree (policy_end_date);


--
-- TOC entry 4100 (class 1259 OID 19391)
-- Name: index_life_insurances_on_policy_end_date_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_policy_end_date_and_created_at ON public.life_insurances USING btree (policy_end_date, created_at);


--
-- TOC entry 4101 (class 1259 OID 18456)
-- Name: index_life_insurances_on_policy_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_life_insurances_on_policy_number ON public.life_insurances USING btree (policy_number);


--
-- TOC entry 4102 (class 1259 OID 18459)
-- Name: index_life_insurances_on_policy_start_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_policy_start_date ON public.life_insurances USING btree (policy_start_date);


--
-- TOC entry 4103 (class 1259 OID 18461)
-- Name: index_life_insurances_on_policy_start_date_and_policy_end_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_policy_start_date_and_policy_end_date ON public.life_insurances USING btree (policy_start_date, policy_end_date);


--
-- TOC entry 4104 (class 1259 OID 18458)
-- Name: index_life_insurances_on_policy_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_policy_type ON public.life_insurances USING btree (policy_type);


--
-- TOC entry 4105 (class 1259 OID 19780)
-- Name: index_life_insurances_on_product_through_dr; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_product_through_dr ON public.life_insurances USING btree (product_through_dr);


--
-- TOC entry 4106 (class 1259 OID 19781)
-- Name: index_life_insurances_on_product_through_dr_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_product_through_dr_and_created_at ON public.life_insurances USING btree (product_through_dr, created_at);


--
-- TOC entry 4107 (class 1259 OID 19783)
-- Name: index_life_insurances_on_product_through_dr_and_sum_insured; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_product_through_dr_and_sum_insured ON public.life_insurances USING btree (product_through_dr, sum_insured);


--
-- TOC entry 4108 (class 1259 OID 19782)
-- Name: index_life_insurances_on_product_through_dr_and_total_premium; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_product_through_dr_and_total_premium ON public.life_insurances USING btree (product_through_dr, total_premium);


--
-- TOC entry 4109 (class 1259 OID 19242)
-- Name: index_life_insurances_on_renewal_policy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_renewal_policy_id ON public.life_insurances USING btree (renewal_policy_id);


--
-- TOC entry 4110 (class 1259 OID 18453)
-- Name: index_life_insurances_on_sub_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_life_insurances_on_sub_agent_id ON public.life_insurances USING btree (sub_agent_id);


--
-- TOC entry 4213 (class 1259 OID 19023)
-- Name: index_loans_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_loans_on_customer_id ON public.loans USING btree (customer_id);


--
-- TOC entry 4311 (class 1259 OID 19681)
-- Name: index_motor_insurance_documents_on_motor_insurance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_insurance_documents_on_motor_insurance_id ON public.motor_insurance_documents USING btree (motor_insurance_id);


--
-- TOC entry 4303 (class 1259 OID 19550)
-- Name: index_motor_insurance_nominees_on_motor_insurance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_insurance_nominees_on_motor_insurance_id ON public.motor_insurance_nominees USING btree (motor_insurance_id);


--
-- TOC entry 4001 (class 1259 OID 18641)
-- Name: index_motor_insurances_on_agency_code_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_insurances_on_agency_code_id ON public.motor_insurances USING btree (agency_code_id);


--
-- TOC entry 4002 (class 1259 OID 18647)
-- Name: index_motor_insurances_on_broker_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_insurances_on_broker_id ON public.motor_insurances USING btree (broker_id);


--
-- TOC entry 4003 (class 1259 OID 18629)
-- Name: index_motor_insurances_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_insurances_on_customer_id ON public.motor_insurances USING btree (customer_id);


--
-- TOC entry 4004 (class 1259 OID 19396)
-- Name: index_motor_insurances_on_customer_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_insurances_on_customer_id_and_created_at ON public.motor_insurances USING btree (customer_id, created_at);


--
-- TOC entry 4005 (class 1259 OID 18962)
-- Name: index_motor_insurances_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_insurances_on_distributor_id ON public.motor_insurances USING btree (distributor_id);


--
-- TOC entry 4006 (class 1259 OID 19473)
-- Name: index_motor_insurances_on_insurance_company_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_insurances_on_insurance_company_code ON public.motor_insurances USING btree (insurance_company_code);


--
-- TOC entry 4007 (class 1259 OID 18968)
-- Name: index_motor_insurances_on_investor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_insurances_on_investor_id ON public.motor_insurances USING btree (investor_id);


--
-- TOC entry 4008 (class 1259 OID 18945)
-- Name: index_motor_insurances_on_lead_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_motor_insurances_on_lead_id ON public.motor_insurances USING btree (lead_id);


--
-- TOC entry 4009 (class 1259 OID 19393)
-- Name: index_motor_insurances_on_policy_end_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_insurances_on_policy_end_date ON public.motor_insurances USING btree (policy_end_date);


--
-- TOC entry 4010 (class 1259 OID 19395)
-- Name: index_motor_insurances_on_policy_end_date_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_insurances_on_policy_end_date_and_created_at ON public.motor_insurances USING btree (policy_end_date, created_at);


--
-- TOC entry 4011 (class 1259 OID 18653)
-- Name: index_motor_insurances_on_policy_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_motor_insurances_on_policy_number ON public.motor_insurances USING btree (policy_number);


--
-- TOC entry 4012 (class 1259 OID 19394)
-- Name: index_motor_insurances_on_policy_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_insurances_on_policy_type ON public.motor_insurances USING btree (policy_type);


--
-- TOC entry 4013 (class 1259 OID 18635)
-- Name: index_motor_insurances_on_sub_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_motor_insurances_on_sub_agent_id ON public.motor_insurances USING btree (sub_agent_id);


--
-- TOC entry 4388 (class 1259 OID 20836)
-- Name: index_mutual_fund_nominees_on_mutual_fund_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mutual_fund_nominees_on_mutual_fund_id ON public.mutual_fund_nominees USING btree (mutual_fund_id);


--
-- TOC entry 4383 (class 1259 OID 20814)
-- Name: index_mutual_funds_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mutual_funds_on_customer_id ON public.mutual_funds USING btree (customer_id);


--
-- TOC entry 4384 (class 1259 OID 20816)
-- Name: index_mutual_funds_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mutual_funds_on_distributor_id ON public.mutual_funds USING btree (distributor_id);


--
-- TOC entry 4385 (class 1259 OID 20815)
-- Name: index_mutual_funds_on_sub_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_mutual_funds_on_sub_agent_id ON public.mutual_funds USING btree (sub_agent_id);


--
-- TOC entry 4323 (class 1259 OID 19774)
-- Name: index_notifications_on_is_read; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_is_read ON public.notifications USING btree (is_read);


--
-- TOC entry 4324 (class 1259 OID 19772)
-- Name: index_notifications_on_recipient_type_and_recipient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_recipient_type_and_recipient_id ON public.notifications USING btree (recipient_type, recipient_id);


--
-- TOC entry 4325 (class 1259 OID 19773)
-- Name: index_notifications_on_reference_type_and_reference_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_reference_type_and_reference_id ON public.notifications USING btree (reference_type, reference_id);


--
-- TOC entry 4326 (class 1259 OID 19775)
-- Name: index_notifications_on_sent_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_notifications_on_sent_at ON public.notifications USING btree (sent_at);


--
-- TOC entry 4317 (class 1259 OID 19719)
-- Name: index_other_insurance_documents_on_other_insurance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_other_insurance_documents_on_other_insurance_id ON public.other_insurance_documents USING btree (other_insurance_id);


--
-- TOC entry 4300 (class 1259 OID 19531)
-- Name: index_other_insurance_nominees_on_other_insurance_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_other_insurance_nominees_on_other_insurance_id ON public.other_insurance_nominees USING btree (other_insurance_id);


--
-- TOC entry 4017 (class 1259 OID 19808)
-- Name: index_other_insurances_on_customer_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_other_insurances_on_customer_id_and_created_at ON public.other_insurances USING btree (customer_id, created_at);


--
-- TOC entry 4018 (class 1259 OID 18974)
-- Name: index_other_insurances_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_other_insurances_on_distributor_id ON public.other_insurances USING btree (distributor_id);


--
-- TOC entry 4019 (class 1259 OID 19474)
-- Name: index_other_insurances_on_insurance_company_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_other_insurances_on_insurance_company_code ON public.other_insurances USING btree (insurance_company_code);


--
-- TOC entry 4020 (class 1259 OID 18980)
-- Name: index_other_insurances_on_investor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_other_insurances_on_investor_id ON public.other_insurances USING btree (investor_id);


--
-- TOC entry 4021 (class 1259 OID 18946)
-- Name: index_other_insurances_on_lead_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_other_insurances_on_lead_id ON public.other_insurances USING btree (lead_id);


--
-- TOC entry 4022 (class 1259 OID 19397)
-- Name: index_other_insurances_on_policy_end_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_other_insurances_on_policy_end_date ON public.other_insurances USING btree (policy_end_date);


--
-- TOC entry 4023 (class 1259 OID 19398)
-- Name: index_other_insurances_on_policy_end_date_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_other_insurances_on_policy_end_date_and_created_at ON public.other_insurances USING btree (policy_end_date, created_at);


--
-- TOC entry 4024 (class 1259 OID 18098)
-- Name: index_other_insurances_on_policy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_other_insurances_on_policy_id ON public.other_insurances USING btree (policy_id);


--
-- TOC entry 4201 (class 1259 OID 18902)
-- Name: index_payout_audit_logs_on_auditable_type_and_auditable_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payout_audit_logs_on_auditable_type_and_auditable_id ON public.payout_audit_logs USING btree (auditable_type, auditable_id);


--
-- TOC entry 4202 (class 1259 OID 18904)
-- Name: index_payout_audit_logs_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payout_audit_logs_on_created_at ON public.payout_audit_logs USING btree (created_at);


--
-- TOC entry 4203 (class 1259 OID 18903)
-- Name: index_payout_audit_logs_on_performed_by; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payout_audit_logs_on_performed_by ON public.payout_audit_logs USING btree (performed_by);


--
-- TOC entry 4195 (class 1259 OID 18880)
-- Name: index_payout_distributions_on_commission_receipt_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payout_distributions_on_commission_receipt_id ON public.payout_distributions USING btree (commission_receipt_id);


--
-- TOC entry 4196 (class 1259 OID 18901)
-- Name: index_payout_distributions_on_payment_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payout_distributions_on_payment_date ON public.payout_distributions USING btree (payment_date);


--
-- TOC entry 4197 (class 1259 OID 18899)
-- Name: index_payout_distributions_on_recipient_type_and_recipient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payout_distributions_on_recipient_type_and_recipient_id ON public.payout_distributions USING btree (recipient_type, recipient_id);


--
-- TOC entry 4198 (class 1259 OID 18900)
-- Name: index_payout_distributions_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payout_distributions_on_status ON public.payout_distributions USING btree (status);


--
-- TOC entry 4231 (class 1259 OID 19104)
-- Name: index_payouts_on_affiliate_commission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payouts_on_affiliate_commission_id ON public.payouts USING btree (affiliate_commission_id);


--
-- TOC entry 4232 (class 1259 OID 19105)
-- Name: index_payouts_on_ambassador_commission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payouts_on_ambassador_commission_id ON public.payouts USING btree (ambassador_commission_id);


--
-- TOC entry 4233 (class 1259 OID 19107)
-- Name: index_payouts_on_company_expense_commission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payouts_on_company_expense_commission_id ON public.payouts USING btree (company_expense_commission_id);


--
-- TOC entry 4234 (class 1259 OID 19252)
-- Name: index_payouts_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payouts_on_created_at ON public.payouts USING btree (created_at);


--
-- TOC entry 4235 (class 1259 OID 19106)
-- Name: index_payouts_on_investor_commission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payouts_on_investor_commission_id ON public.payouts USING btree (investor_commission_id);


--
-- TOC entry 4236 (class 1259 OID 19103)
-- Name: index_payouts_on_main_agent_commission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payouts_on_main_agent_commission_id ON public.payouts USING btree (main_agent_commission_id);


--
-- TOC entry 4237 (class 1259 OID 19251)
-- Name: index_payouts_on_policy_type_and_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payouts_on_policy_type_and_id ON public.payouts USING btree (policy_type, policy_id);


--
-- TOC entry 4238 (class 1259 OID 19253)
-- Name: index_payouts_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payouts_on_status ON public.payouts USING btree (status);


--
-- TOC entry 4125 (class 1259 OID 18549)
-- Name: index_permissions_on_action_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_permissions_on_action_type ON public.permissions USING btree (action_type);


--
-- TOC entry 4126 (class 1259 OID 18548)
-- Name: index_permissions_on_module_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_permissions_on_module_name ON public.permissions USING btree (module_name);


--
-- TOC entry 4127 (class 1259 OID 18547)
-- Name: index_permissions_on_module_name_and_action_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_permissions_on_module_name_and_action_type ON public.permissions USING btree (module_name, action_type);


--
-- TOC entry 3969 (class 1259 OID 18022)
-- Name: index_policies_on_agency_broker_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policies_on_agency_broker_id ON public.policies USING btree (agency_broker_id);


--
-- TOC entry 3970 (class 1259 OID 18019)
-- Name: index_policies_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policies_on_customer_id ON public.policies USING btree (customer_id);


--
-- TOC entry 3971 (class 1259 OID 18514)
-- Name: index_policies_on_customer_id_and_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policies_on_customer_id_and_created_at ON public.policies USING btree (customer_id, created_at);


--
-- TOC entry 3972 (class 1259 OID 18021)
-- Name: index_policies_on_insurance_company_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policies_on_insurance_company_id ON public.policies USING btree (insurance_company_id);


--
-- TOC entry 3973 (class 1259 OID 19245)
-- Name: index_policies_on_insurance_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policies_on_insurance_type ON public.policies USING btree (insurance_type);


--
-- TOC entry 3974 (class 1259 OID 19247)
-- Name: index_policies_on_policy_end_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policies_on_policy_end_date ON public.policies USING btree (policy_end_date);


--
-- TOC entry 3975 (class 1259 OID 19246)
-- Name: index_policies_on_policy_start_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policies_on_policy_start_date ON public.policies USING btree (policy_start_date);


--
-- TOC entry 3976 (class 1259 OID 19248)
-- Name: index_policies_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policies_on_status ON public.policies USING btree (status);


--
-- TOC entry 3977 (class 1259 OID 18020)
-- Name: index_policies_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policies_on_user_id ON public.policies USING btree (user_id);


--
-- TOC entry 4306 (class 1259 OID 19662)
-- Name: index_policy_documents_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policy_documents_on_created_at ON public.policy_documents USING btree (created_at);


--
-- TOC entry 4307 (class 1259 OID 19661)
-- Name: index_policy_documents_on_document_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policy_documents_on_document_type ON public.policy_documents USING btree (document_type);


--
-- TOC entry 4308 (class 1259 OID 19660)
-- Name: index_policy_documents_on_policy_type_and_policy_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_policy_documents_on_policy_type_and_policy_id ON public.policy_documents USING btree (policy_type, policy_id);


--
-- TOC entry 4133 (class 1259 OID 18573)
-- Name: index_role_permissions_on_permission_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_role_permissions_on_permission_id ON public.role_permissions USING btree (permission_id);


--
-- TOC entry 4134 (class 1259 OID 18572)
-- Name: index_role_permissions_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_role_permissions_on_role_id ON public.role_permissions USING btree (role_id);


--
-- TOC entry 4121 (class 1259 OID 18530)
-- Name: index_roles_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_roles_on_name ON public.roles USING btree (name);


--
-- TOC entry 4122 (class 1259 OID 18531)
-- Name: index_roles_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_roles_on_status ON public.roles USING btree (status);


--
-- TOC entry 4285 (class 1259 OID 19362)
-- Name: index_session_activities_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_session_activities_on_user_id ON public.session_activities USING btree (user_id);


--
-- TOC entry 4329 (class 1259 OID 19799)
-- Name: index_solid_cache_entries_on_byte_size; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_cache_entries_on_byte_size ON public.solid_cache_entries USING btree (byte_size);


--
-- TOC entry 4330 (class 1259 OID 19801)
-- Name: index_solid_cache_entries_on_key_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_cache_entries_on_key_hash ON public.solid_cache_entries USING btree (key_hash);


--
-- TOC entry 4331 (class 1259 OID 19800)
-- Name: index_solid_cache_entries_on_key_hash_and_byte_size; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_cache_entries_on_key_hash_and_byte_size ON public.solid_cache_entries USING btree (key_hash, byte_size);


--
-- TOC entry 4341 (class 1259 OID 20559)
-- Name: index_solid_queue_blocked_executions_for_maintenance; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_blocked_executions_for_maintenance ON public.solid_queue_blocked_executions USING btree (expires_at, concurrency_key);


--
-- TOC entry 4342 (class 1259 OID 20558)
-- Name: index_solid_queue_blocked_executions_for_release; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_blocked_executions_for_release ON public.solid_queue_blocked_executions USING btree (concurrency_key, priority, job_id);


--
-- TOC entry 4343 (class 1259 OID 20560)
-- Name: index_solid_queue_blocked_executions_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_blocked_executions_on_job_id ON public.solid_queue_blocked_executions USING btree (job_id);


--
-- TOC entry 4346 (class 1259 OID 20571)
-- Name: index_solid_queue_claimed_executions_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_claimed_executions_on_job_id ON public.solid_queue_claimed_executions USING btree (job_id);


--
-- TOC entry 4347 (class 1259 OID 20572)
-- Name: index_solid_queue_claimed_executions_on_process_id_and_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_claimed_executions_on_process_id_and_job_id ON public.solid_queue_claimed_executions USING btree (process_id, job_id);


--
-- TOC entry 4374 (class 1259 OID 20687)
-- Name: index_solid_queue_dispatch_all; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_dispatch_all ON public.solid_queue_scheduled_executions USING btree (scheduled_at, priority, job_id);


--
-- TOC entry 4350 (class 1259 OID 20585)
-- Name: index_solid_queue_failed_executions_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_failed_executions_on_job_id ON public.solid_queue_failed_executions USING btree (job_id);


--
-- TOC entry 4334 (class 1259 OID 20540)
-- Name: index_solid_queue_jobs_for_alerting; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_jobs_for_alerting ON public.solid_queue_jobs USING btree (scheduled_at, finished_at);


--
-- TOC entry 4335 (class 1259 OID 20539)
-- Name: index_solid_queue_jobs_for_filtering; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_jobs_for_filtering ON public.solid_queue_jobs USING btree (queue_name, finished_at);


--
-- TOC entry 4336 (class 1259 OID 20536)
-- Name: index_solid_queue_jobs_on_active_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_jobs_on_active_job_id ON public.solid_queue_jobs USING btree (active_job_id);


--
-- TOC entry 4337 (class 1259 OID 20537)
-- Name: index_solid_queue_jobs_on_class_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_jobs_on_class_name ON public.solid_queue_jobs USING btree (class_name);


--
-- TOC entry 4338 (class 1259 OID 20538)
-- Name: index_solid_queue_jobs_on_finished_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_jobs_on_finished_at ON public.solid_queue_jobs USING btree (finished_at);


--
-- TOC entry 4353 (class 1259 OID 20598)
-- Name: index_solid_queue_pauses_on_queue_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_pauses_on_queue_name ON public.solid_queue_pauses USING btree (queue_name);


--
-- TOC entry 4361 (class 1259 OID 20633)
-- Name: index_solid_queue_poll_all; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_poll_all ON public.solid_queue_ready_executions USING btree (priority, job_id);


--
-- TOC entry 4362 (class 1259 OID 20634)
-- Name: index_solid_queue_poll_by_queue; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_poll_by_queue ON public.solid_queue_ready_executions USING btree (queue_name, priority, job_id);


--
-- TOC entry 4356 (class 1259 OID 20614)
-- Name: index_solid_queue_processes_on_last_heartbeat_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_processes_on_last_heartbeat_at ON public.solid_queue_processes USING btree (last_heartbeat_at);


--
-- TOC entry 4357 (class 1259 OID 20615)
-- Name: index_solid_queue_processes_on_name_and_supervisor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_processes_on_name_and_supervisor_id ON public.solid_queue_processes USING btree (name, supervisor_id);


--
-- TOC entry 4358 (class 1259 OID 20616)
-- Name: index_solid_queue_processes_on_supervisor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_processes_on_supervisor_id ON public.solid_queue_processes USING btree (supervisor_id);


--
-- TOC entry 4363 (class 1259 OID 20632)
-- Name: index_solid_queue_ready_executions_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_ready_executions_on_job_id ON public.solid_queue_ready_executions USING btree (job_id);


--
-- TOC entry 4366 (class 1259 OID 20649)
-- Name: index_solid_queue_recurring_executions_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_recurring_executions_on_job_id ON public.solid_queue_recurring_executions USING btree (job_id);


--
-- TOC entry 4367 (class 1259 OID 20650)
-- Name: index_solid_queue_recurring_executions_on_task_key_and_run_at; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_recurring_executions_on_task_key_and_run_at ON public.solid_queue_recurring_executions USING btree (task_key, run_at);


--
-- TOC entry 4370 (class 1259 OID 20668)
-- Name: index_solid_queue_recurring_tasks_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_recurring_tasks_on_key ON public.solid_queue_recurring_tasks USING btree (key);


--
-- TOC entry 4371 (class 1259 OID 20669)
-- Name: index_solid_queue_recurring_tasks_on_static; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_recurring_tasks_on_static ON public.solid_queue_recurring_tasks USING btree (static);


--
-- TOC entry 4375 (class 1259 OID 20686)
-- Name: index_solid_queue_scheduled_executions_on_job_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_scheduled_executions_on_job_id ON public.solid_queue_scheduled_executions USING btree (job_id);


--
-- TOC entry 4378 (class 1259 OID 20704)
-- Name: index_solid_queue_semaphores_on_expires_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_semaphores_on_expires_at ON public.solid_queue_semaphores USING btree (expires_at);


--
-- TOC entry 4379 (class 1259 OID 20706)
-- Name: index_solid_queue_semaphores_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_solid_queue_semaphores_on_key ON public.solid_queue_semaphores USING btree (key);


--
-- TOC entry 4380 (class 1259 OID 20705)
-- Name: index_solid_queue_semaphores_on_key_and_value; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_solid_queue_semaphores_on_key_and_value ON public.solid_queue_semaphores USING btree (key, value);


--
-- TOC entry 4071 (class 1259 OID 19249)
-- Name: index_sub_agent_documents_on_document_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sub_agent_documents_on_document_type ON public.sub_agent_documents USING btree (document_type);


--
-- TOC entry 4072 (class 1259 OID 18246)
-- Name: index_sub_agent_documents_on_sub_agent_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sub_agent_documents_on_sub_agent_id ON public.sub_agent_documents USING btree (sub_agent_id);


--
-- TOC entry 4073 (class 1259 OID 18247)
-- Name: index_sub_agent_documents_on_sub_agent_id_and_document_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sub_agent_documents_on_sub_agent_id_and_document_type ON public.sub_agent_documents USING btree (sub_agent_id, document_type);


--
-- TOC entry 4063 (class 1259 OID 19384)
-- Name: index_sub_agents_on_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sub_agents_on_created_at ON public.sub_agents USING btree (created_at);


--
-- TOC entry 4064 (class 1259 OID 18913)
-- Name: index_sub_agents_on_distributor_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sub_agents_on_distributor_id ON public.sub_agents USING btree (distributor_id);


--
-- TOC entry 4065 (class 1259 OID 18224)
-- Name: index_sub_agents_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sub_agents_on_email ON public.sub_agents USING btree (email);


--
-- TOC entry 4066 (class 1259 OID 18223)
-- Name: index_sub_agents_on_mobile; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sub_agents_on_mobile ON public.sub_agents USING btree (mobile);


--
-- TOC entry 4067 (class 1259 OID 18225)
-- Name: index_sub_agents_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sub_agents_on_role_id ON public.sub_agents USING btree (role_id);


--
-- TOC entry 4068 (class 1259 OID 18226)
-- Name: index_sub_agents_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_sub_agents_on_status ON public.sub_agents USING btree (status);


--
-- TOC entry 4156 (class 1259 OID 18709)
-- Name: index_system_settings_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_system_settings_on_key ON public.system_settings USING btree (key);


--
-- TOC entry 4216 (class 1259 OID 19042)
-- Name: index_tax_services_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_tax_services_on_customer_id ON public.tax_services USING btree (customer_id);


--
-- TOC entry 4219 (class 1259 OID 19061)
-- Name: index_travel_packages_on_customer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_travel_packages_on_customer_id ON public.travel_packages USING btree (customer_id);


--
-- TOC entry 4140 (class 1259 OID 18616)
-- Name: index_user_roles_on_display_order; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_roles_on_display_order ON public.user_roles USING btree (display_order);


--
-- TOC entry 4141 (class 1259 OID 18615)
-- Name: index_user_roles_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_roles_on_name ON public.user_roles USING btree (name);


--
-- TOC entry 4142 (class 1259 OID 18617)
-- Name: index_user_roles_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_roles_on_status ON public.user_roles USING btree (status);


--
-- TOC entry 4267 (class 1259 OID 19316)
-- Name: index_user_sessions_on_ip_address; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_sessions_on_ip_address ON public.user_sessions USING btree (ip_address);


--
-- TOC entry 4268 (class 1259 OID 19313)
-- Name: index_user_sessions_on_session_id; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_user_sessions_on_session_id ON public.user_sessions USING btree (session_id);


--
-- TOC entry 4269 (class 1259 OID 19314)
-- Name: index_user_sessions_on_started_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_sessions_on_started_at ON public.user_sessions USING btree (started_at);


--
-- TOC entry 4270 (class 1259 OID 19315)
-- Name: index_user_sessions_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_sessions_on_status ON public.user_sessions USING btree (status);


--
-- TOC entry 4271 (class 1259 OID 19312)
-- Name: index_user_sessions_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_user_sessions_on_user_id ON public.user_sessions USING btree (user_id);


--
-- TOC entry 3934 (class 1259 OID 18169)
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- TOC entry 3935 (class 1259 OID 18577)
-- Name: index_users_on_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_role_id ON public.users USING btree (role_id);


--
-- TOC entry 3936 (class 1259 OID 18618)
-- Name: index_users_on_user_role_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_user_role_id ON public.users USING btree (user_role_id);


--
-- TOC entry 4405 (class 2606 OID 19120)
-- Name: customers fk_rails_008db845d0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customers
    ADD CONSTRAINT fk_rails_008db845d0 FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- TOC entry 4443 (class 2606 OID 18482)
-- Name: client_requests fk_rails_01555c239d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.client_requests
    ADD CONSTRAINT fk_rails_01555c239d FOREIGN KEY (resolved_by_id) REFERENCES public.users(id);


--
-- TOC entry 4468 (class 2606 OID 19507)
-- Name: health_insurance_nominees fk_rails_0e6e5acb42; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurance_nominees
    ADD CONSTRAINT fk_rails_0e6e5acb42 FOREIGN KEY (health_insurance_id) REFERENCES public.health_insurances(id);


--
-- TOC entry 4419 (class 2606 OID 18648)
-- Name: motor_insurances fk_rails_1137d0b877; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_insurances
    ADD CONSTRAINT fk_rails_1137d0b877 FOREIGN KEY (broker_id) REFERENCES public.brokers(id);


--
-- TOC entry 4457 (class 2606 OID 19037)
-- Name: tax_services fk_rails_1a1cf777a6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.tax_services
    ADD CONSTRAINT fk_rails_1a1cf777a6 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4461 (class 2606 OID 19203)
-- Name: broker_codes fk_rails_215550e107; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.broker_codes
    ADD CONSTRAINT fk_rails_215550e107 FOREIGN KEY (broker_id) REFERENCES public.brokers(id);


--
-- TOC entry 4464 (class 2606 OID 19357)
-- Name: session_activities fk_rails_216a79c3b1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_activities
    ADD CONSTRAINT fk_rails_216a79c3b1 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4407 (class 2606 OID 18014)
-- Name: policies fk_rails_21e14e2e1d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT fk_rails_21e14e2e1d FOREIGN KEY (agency_broker_id) REFERENCES public.agency_brokers(id);


--
-- TOC entry 4467 (class 2606 OID 19488)
-- Name: invoice_items fk_rails_25bf3d2c5e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invoice_items
    ADD CONSTRAINT fk_rails_25bf3d2c5e FOREIGN KEY (invoice_id) REFERENCES public.invoices(id);


--
-- TOC entry 4420 (class 2606 OID 18963)
-- Name: motor_insurances fk_rails_284d5e7121; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_insurances
    ADD CONSTRAINT fk_rails_284d5e7121 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- TOC entry 4469 (class 2606 OID 19526)
-- Name: other_insurance_nominees fk_rails_2da340b9f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.other_insurance_nominees
    ADD CONSTRAINT fk_rails_2da340b9f8 FOREIGN KEY (other_insurance_id) REFERENCES public.other_insurances(id);


--
-- TOC entry 4408 (class 2606 OID 17999)
-- Name: policies fk_rails_2f51f55afa; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT fk_rails_2f51f55afa FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4479 (class 2606 OID 20727)
-- Name: solid_queue_recurring_executions fk_rails_318a5533ed; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_recurring_executions
    ADD CONSTRAINT fk_rails_318a5533ed FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- TOC entry 4411 (class 2606 OID 18283)
-- Name: health_insurances fk_rails_3212ef8977; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT fk_rails_3212ef8977 FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- TOC entry 4436 (class 2606 OID 18313)
-- Name: health_insurance_members fk_rails_33b646c0a8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurance_members
    ADD CONSTRAINT fk_rails_33b646c0a8 FOREIGN KEY (health_insurance_id) REFERENCES public.health_insurances(id);


--
-- TOC entry 4412 (class 2606 OID 18957)
-- Name: health_insurances fk_rails_341cbe5017; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT fk_rails_341cbe5017 FOREIGN KEY (investor_id) REFERENCES public.investors(id);


--
-- TOC entry 4473 (class 2606 OID 19714)
-- Name: other_insurance_documents fk_rails_3814dd1ef3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.other_insurance_documents
    ADD CONSTRAINT fk_rails_3814dd1ef3 FOREIGN KEY (other_insurance_id) REFERENCES public.other_insurances(id);


--
-- TOC entry 4471 (class 2606 OID 19676)
-- Name: motor_insurance_documents fk_rails_3942837366; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_insurance_documents
    ADD CONSTRAINT fk_rails_3942837366 FOREIGN KEY (motor_insurance_id) REFERENCES public.motor_insurances(id);


--
-- TOC entry 4477 (class 2606 OID 20717)
-- Name: solid_queue_failed_executions fk_rails_39bbc7a631; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_failed_executions
    ADD CONSTRAINT fk_rails_39bbc7a631 FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- TOC entry 4446 (class 2606 OID 18690)
-- Name: distributor_documents fk_rails_3c32118d69; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_documents
    ADD CONSTRAINT fk_rails_3c32118d69 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- TOC entry 4437 (class 2606 OID 18442)
-- Name: life_insurances fk_rails_417a996493; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurances
    ADD CONSTRAINT fk_rails_417a996493 FOREIGN KEY (agency_code_id) REFERENCES public.agency_codes(id);


--
-- TOC entry 4444 (class 2606 OID 18567)
-- Name: role_permissions fk_rails_439e640a3f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT fk_rails_439e640a3f FOREIGN KEY (permission_id) REFERENCES public.permissions(id);


--
-- TOC entry 4481 (class 2606 OID 20799)
-- Name: mutual_funds fk_rails_44f95263a3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mutual_funds
    ADD CONSTRAINT fk_rails_44f95263a3 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4435 (class 2606 OID 19126)
-- Name: brokers fk_rails_456e15ca6a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.brokers
    ADD CONSTRAINT fk_rails_456e15ca6a FOREIGN KEY (insurance_company_id) REFERENCES public.insurance_companies(id);


--
-- TOC entry 4438 (class 2606 OID 18447)
-- Name: life_insurances fk_rails_47498cf3e6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurances
    ADD CONSTRAINT fk_rails_47498cf3e6 FOREIGN KEY (broker_id) REFERENCES public.brokers(id);


--
-- TOC entry 4475 (class 2606 OID 20707)
-- Name: solid_queue_blocked_executions fk_rails_4cd34e2228; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_blocked_executions
    ADD CONSTRAINT fk_rails_4cd34e2228 FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- TOC entry 4409 (class 2606 OID 18004)
-- Name: policies fk_rails_4f6a17c362; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT fk_rails_4f6a17c362 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4421 (class 2606 OID 18636)
-- Name: motor_insurances fk_rails_532422c87b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_insurances
    ADD CONSTRAINT fk_rails_532422c87b FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- TOC entry 4432 (class 2606 OID 18914)
-- Name: sub_agents fk_rails_5638372c18; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_agents
    ADD CONSTRAINT fk_rails_5638372c18 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- TOC entry 4422 (class 2606 OID 18969)
-- Name: motor_insurances fk_rails_58959b2958; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_insurances
    ADD CONSTRAINT fk_rails_58959b2958 FOREIGN KEY (investor_id) REFERENCES public.investors(id);


--
-- TOC entry 4410 (class 2606 OID 18009)
-- Name: policies fk_rails_5cb4dca12a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.policies
    ADD CONSTRAINT fk_rails_5cb4dca12a FOREIGN KEY (insurance_company_id) REFERENCES public.insurance_companies(id);


--
-- TOC entry 4445 (class 2606 OID 18562)
-- Name: role_permissions fk_rails_60126080bd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_permissions
    ADD CONSTRAINT fk_rails_60126080bd FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- TOC entry 4403 (class 2606 OID 18578)
-- Name: users fk_rails_642f17018b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_642f17018b FOREIGN KEY (role_id) REFERENCES public.roles(id);


--
-- TOC entry 4406 (class 2606 OID 17953)
-- Name: family_members fk_rails_66b694a28b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.family_members
    ADD CONSTRAINT fk_rails_66b694a28b FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4449 (class 2606 OID 18802)
-- Name: life_insurance_bank_details fk_rails_6ba08ad855; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurance_bank_details
    ADD CONSTRAINT fk_rails_6ba08ad855 FOREIGN KEY (life_insurance_id) REFERENCES public.life_insurances(id);


--
-- TOC entry 4448 (class 2606 OID 18783)
-- Name: life_insurance_nominees fk_rails_6ba3896177; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurance_nominees
    ADD CONSTRAINT fk_rails_6ba3896177 FOREIGN KEY (life_insurance_id) REFERENCES public.life_insurances(id);


--
-- TOC entry 4458 (class 2606 OID 19056)
-- Name: travel_packages fk_rails_7250d92cb6; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.travel_packages
    ADD CONSTRAINT fk_rails_7250d92cb6 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4451 (class 2606 OID 19098)
-- Name: commission_payouts fk_rails_76f645ffa9; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.commission_payouts
    ADD CONSTRAINT fk_rails_76f645ffa9 FOREIGN KEY (payout_id) REFERENCES public.payouts(id);


--
-- TOC entry 4453 (class 2606 OID 18931)
-- Name: distributor_assignments fk_rails_7be9b91081; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_assignments
    ADD CONSTRAINT fk_rails_7be9b91081 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- TOC entry 4478 (class 2606 OID 20722)
-- Name: solid_queue_ready_executions fk_rails_81fcbd66af; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_ready_executions
    ADD CONSTRAINT fk_rails_81fcbd66af FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- TOC entry 4413 (class 2606 OID 18277)
-- Name: health_insurances fk_rails_87aeeb6937; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT fk_rails_87aeeb6937 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4485 (class 2606 OID 20858)
-- Name: appointments fk_rails_882571afb2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_rails_882571afb2 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4425 (class 2606 OID 18093)
-- Name: other_insurances fk_rails_8e74cde379; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.other_insurances
    ADD CONSTRAINT fk_rails_8e74cde379 FOREIGN KEY (policy_id) REFERENCES public.policies(id);


--
-- TOC entry 4484 (class 2606 OID 20831)
-- Name: mutual_fund_nominees fk_rails_8f42299122; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mutual_fund_nominees
    ADD CONSTRAINT fk_rails_8f42299122 FOREIGN KEY (mutual_fund_id) REFERENCES public.mutual_funds(id);


--
-- TOC entry 4423 (class 2606 OID 18630)
-- Name: motor_insurances fk_rails_97d4be159d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_insurances
    ADD CONSTRAINT fk_rails_97d4be159d FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4430 (class 2606 OID 18161)
-- Name: active_storage_variant_records fk_rails_993965df05; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_variant_records
    ADD CONSTRAINT fk_rails_993965df05 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- TOC entry 4476 (class 2606 OID 20712)
-- Name: solid_queue_claimed_executions fk_rails_9cfe4d4944; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_claimed_executions
    ADD CONSTRAINT fk_rails_9cfe4d4944 FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- TOC entry 4439 (class 2606 OID 18432)
-- Name: life_insurances fk_rails_9f14af9e98; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurances
    ADD CONSTRAINT fk_rails_9f14af9e98 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4463 (class 2606 OID 19307)
-- Name: user_sessions fk_rails_9fa262d742; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_sessions
    ADD CONSTRAINT fk_rails_9fa262d742 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4454 (class 2606 OID 18936)
-- Name: distributor_assignments fk_rails_a3ef0851ec; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_assignments
    ADD CONSTRAINT fk_rails_a3ef0851ec FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- TOC entry 4434 (class 2606 OID 19132)
-- Name: agency_codes fk_rails_a59373839c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.agency_codes
    ADD CONSTRAINT fk_rails_a59373839c FOREIGN KEY (broker_id) REFERENCES public.brokers(id);


--
-- TOC entry 4465 (class 2606 OID 19457)
-- Name: helpdesk_tickets fk_rails_ac69f5f95d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.helpdesk_tickets
    ADD CONSTRAINT fk_rails_ac69f5f95d FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- TOC entry 4414 (class 2606 OID 18951)
-- Name: health_insurances fk_rails_ad2281368f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT fk_rails_ad2281368f FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- TOC entry 4415 (class 2606 OID 18055)
-- Name: health_insurances fk_rails_ade27562ab; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT fk_rails_ade27562ab FOREIGN KEY (policy_id) REFERENCES public.policies(id);


--
-- TOC entry 4428 (class 2606 OID 19364)
-- Name: leads fk_rails_b0973b0601; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.leads
    ADD CONSTRAINT fk_rails_b0973b0601 FOREIGN KEY (ambassador_id) REFERENCES public.distributors(id);


--
-- TOC entry 4452 (class 2606 OID 18875)
-- Name: payout_distributions fk_rails_b0a2f7e932; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payout_distributions
    ADD CONSTRAINT fk_rails_b0a2f7e932 FOREIGN KEY (commission_receipt_id) REFERENCES public.commission_receipts(id);


--
-- TOC entry 4431 (class 2606 OID 18184)
-- Name: corporate_members fk_rails_b43ddda53b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.corporate_members
    ADD CONSTRAINT fk_rails_b43ddda53b FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4466 (class 2606 OID 19462)
-- Name: helpdesk_tickets fk_rails_b5418b7db0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.helpdesk_tickets
    ADD CONSTRAINT fk_rails_b5418b7db0 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4472 (class 2606 OID 19695)
-- Name: banner_documents fk_rails_ba0255e49a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.banner_documents
    ADD CONSTRAINT fk_rails_ba0255e49a FOREIGN KEY (banner_id) REFERENCES public.banners(id);


--
-- TOC entry 4456 (class 2606 OID 19018)
-- Name: loans fk_rails_ba3831bab8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT fk_rails_ba3831bab8 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4470 (class 2606 OID 19545)
-- Name: motor_insurance_nominees fk_rails_bb9aae8592; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_insurance_nominees
    ADD CONSTRAINT fk_rails_bb9aae8592 FOREIGN KEY (motor_insurance_id) REFERENCES public.motor_insurances(id);


--
-- TOC entry 4429 (class 2606 OID 18142)
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- TOC entry 4480 (class 2606 OID 20732)
-- Name: solid_queue_scheduled_executions fk_rails_c4316f352d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.solid_queue_scheduled_executions
    ADD CONSTRAINT fk_rails_c4316f352d FOREIGN KEY (job_id) REFERENCES public.solid_queue_jobs(id) ON DELETE CASCADE;


--
-- TOC entry 4455 (class 2606 OID 18999)
-- Name: investments fk_rails_c8d1342f80; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investments
    ADD CONSTRAINT fk_rails_c8d1342f80 FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4462 (class 2606 OID 19229)
-- Name: ai_report_histories fk_rails_cfaca47ac5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_report_histories
    ADD CONSTRAINT fk_rails_cfaca47ac5 FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- TOC entry 4426 (class 2606 OID 18975)
-- Name: other_insurances fk_rails_d306e08494; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.other_insurances
    ADD CONSTRAINT fk_rails_d306e08494 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- TOC entry 4427 (class 2606 OID 18981)
-- Name: other_insurances fk_rails_d8deac0a99; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.other_insurances
    ADD CONSTRAINT fk_rails_d8deac0a99 FOREIGN KEY (investor_id) REFERENCES public.investors(id);


--
-- TOC entry 4486 (class 2606 OID 20863)
-- Name: appointments fk_rails_dc29d99253; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.appointments
    ADD CONSTRAINT fk_rails_dc29d99253 FOREIGN KEY (created_by_id) REFERENCES public.users(id);


--
-- TOC entry 4440 (class 2606 OID 18752)
-- Name: life_insurances fk_rails_e165c4ce34; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurances
    ADD CONSTRAINT fk_rails_e165c4ce34 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- TOC entry 4441 (class 2606 OID 18758)
-- Name: life_insurances fk_rails_e3b9a67e5b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurances
    ADD CONSTRAINT fk_rails_e3b9a67e5b FOREIGN KEY (investor_id) REFERENCES public.investors(id);


--
-- TOC entry 4416 (class 2606 OID 18295)
-- Name: health_insurances fk_rails_e565a0ca90; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT fk_rails_e565a0ca90 FOREIGN KEY (broker_id) REFERENCES public.brokers(id);


--
-- TOC entry 4474 (class 2606 OID 19754)
-- Name: health_insurance_documents fk_rails_e78edd3464; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurance_documents
    ADD CONSTRAINT fk_rails_e78edd3464 FOREIGN KEY (health_insurance_id) REFERENCES public.health_insurances(id);


--
-- TOC entry 4482 (class 2606 OID 20804)
-- Name: mutual_funds fk_rails_ec7a2f6153; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mutual_funds
    ADD CONSTRAINT fk_rails_ec7a2f6153 FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- TOC entry 4459 (class 2606 OID 19076)
-- Name: distributor_payouts fk_rails_f01b58b380; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.distributor_payouts
    ADD CONSTRAINT fk_rails_f01b58b380 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- TOC entry 4417 (class 2606 OID 18289)
-- Name: health_insurances fk_rails_f1c7cc2f76; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT fk_rails_f1c7cc2f76 FOREIGN KEY (agency_code_id) REFERENCES public.agency_codes(id);


--
-- TOC entry 4460 (class 2606 OID 19176)
-- Name: customer_documents fk_rails_f20817c66a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.customer_documents
    ADD CONSTRAINT fk_rails_f20817c66a FOREIGN KEY (customer_id) REFERENCES public.customers(id);


--
-- TOC entry 4424 (class 2606 OID 18642)
-- Name: motor_insurances fk_rails_f384cbb9a4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.motor_insurances
    ADD CONSTRAINT fk_rails_f384cbb9a4 FOREIGN KEY (agency_code_id) REFERENCES public.agency_codes(id);


--
-- TOC entry 4433 (class 2606 OID 18241)
-- Name: sub_agent_documents fk_rails_f4389f7b34; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sub_agent_documents
    ADD CONSTRAINT fk_rails_f4389f7b34 FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- TOC entry 4447 (class 2606 OID 18745)
-- Name: investor_documents fk_rails_f77eb37bb8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.investor_documents
    ADD CONSTRAINT fk_rails_f77eb37bb8 FOREIGN KEY (investor_id) REFERENCES public.investors(id);


--
-- TOC entry 4442 (class 2606 OID 18437)
-- Name: life_insurances fk_rails_f9ebb4eb0d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurances
    ADD CONSTRAINT fk_rails_f9ebb4eb0d FOREIGN KEY (sub_agent_id) REFERENCES public.sub_agents(id);


--
-- TOC entry 4483 (class 2606 OID 20809)
-- Name: mutual_funds fk_rails_fa6b5a2241; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mutual_funds
    ADD CONSTRAINT fk_rails_fa6b5a2241 FOREIGN KEY (distributor_id) REFERENCES public.distributors(id);


--
-- TOC entry 4404 (class 2606 OID 18619)
-- Name: users fk_rails_fa83e8f093; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT fk_rails_fa83e8f093 FOREIGN KEY (user_role_id) REFERENCES public.user_roles(id);


--
-- TOC entry 4450 (class 2606 OID 18821)
-- Name: life_insurance_documents fk_rails_fe30481887; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.life_insurance_documents
    ADD CONSTRAINT fk_rails_fe30481887 FOREIGN KEY (life_insurance_id) REFERENCES public.life_insurances(id);


--
-- TOC entry 4418 (class 2606 OID 19902)
-- Name: health_insurances health_insurances_original_policy_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.health_insurances
    ADD CONSTRAINT health_insurances_original_policy_id_fkey FOREIGN KEY (original_policy_id) REFERENCES public.health_insurances(id);


--
-- TOC entry 4751 (class 0 OID 19418)
-- Dependencies: 336 4807
-- Name: dashboard_stats_view; Type: MATERIALIZED VIEW DATA; Schema: public; Owner: -
--

REFRESH MATERIALIZED VIEW public.dashboard_stats_view;


-- Completed on 2026-06-05 09:39:19 IST

--
-- PostgreSQL database dump complete
--

\unrestrict 4vPRe6fbNg09O2GWJVhWWPaMnOlorlPY3yIfTfLXOJB8fLMSsPbGbKJrKsqEWIe

