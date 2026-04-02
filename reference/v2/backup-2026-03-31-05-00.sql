--
-- PostgreSQL database dump
--

\restrict 9T95aNWufIGBaTkk4s2wKc4lYzRwOCzMx7a5MDThEWaBJaNGAVOhA7DFt7rmQme

-- Dumped from database version 17.6
-- Dumped by pg_dump version 17.9 (Ubuntu 17.9-1.pgdg24.04+1)

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

DROP EVENT TRIGGER pgrst_drop_watch;
DROP EVENT TRIGGER pgrst_ddl_watch;
DROP EVENT TRIGGER issue_pg_net_access;
DROP EVENT TRIGGER issue_pg_graphql_access;
DROP EVENT TRIGGER issue_pg_cron_access;
DROP EVENT TRIGGER issue_graphql_placeholder;
DROP PUBLICATION supabase_realtime;
DROP POLICY "Users can upload their own avatar" ON storage.objects;
DROP POLICY "Users can update their own avatar" ON storage.objects;
DROP POLICY "Users can delete their own avatar" ON storage.objects;
DROP POLICY "Anyone can view avatars" ON storage.objects;
DROP POLICY weekly_plans_select ON public.weekly_plans;
DROP POLICY weekly_plans_insert ON public.weekly_plans;
DROP POLICY weekly_plan_items_update ON public.weekly_plan_items;
DROP POLICY weekly_plan_items_select ON public.weekly_plan_items;
DROP POLICY weekly_plan_items_insert ON public.weekly_plan_items;
DROP POLICY weekly_challenges_select ON public.weekly_challenges;
DROP POLICY responses_update ON public.responses;
DROP POLICY responses_select ON public.responses;
DROP POLICY responses_insert ON public.responses;
DROP POLICY response_sessions_update ON public.response_sessions;
DROP POLICY response_sessions_select ON public.response_sessions;
DROP POLICY response_sessions_insert ON public.response_sessions;
DROP POLICY questions_select ON public.questions;
DROP POLICY questionnaires_select ON public.questionnaires;
DROP POLICY questionnaire_sections_select ON public.questionnaire_sections;
DROP POLICY question_dimension_map_select ON public.question_dimension_map;
DROP POLICY profiles_update ON public.profiles;
DROP POLICY profiles_select ON public.profiles;
DROP POLICY profiles_insert ON public.profiles;
DROP POLICY profile_vectors_update ON public.profile_vectors;
DROP POLICY profile_vectors_select ON public.profile_vectors;
DROP POLICY profile_vectors_insert ON public.profile_vectors;
DROP POLICY personal_reports_select ON public.personal_reports;
DROP POLICY onboarding_sessions_update ON public.onboarding_sessions;
DROP POLICY onboarding_sessions_select ON public.onboarding_sessions;
DROP POLICY onboarding_sessions_insert ON public.onboarding_sessions;
DROP POLICY onboarding_responses_update ON public.onboarding_responses;
DROP POLICY onboarding_responses_select ON public.onboarding_responses;
DROP POLICY onboarding_responses_insert ON public.onboarding_responses;
DROP POLICY milestones_select ON public.milestones;
DROP POLICY milestones_insert ON public.milestones;
DROP POLICY item_dimensions_select ON public.item_dimensions;
DROP POLICY item_bank_select ON public.item_bank;
DROP POLICY guided_conversations_select ON public.guided_conversations;
DROP POLICY generated_assessments_select ON public.generated_assessments;
DROP POLICY generated_assessment_items_select ON public.generated_assessment_items;
DROP POLICY dimension_scores_select ON public.dimension_scores;
DROP POLICY dimension_keys_select ON public.dimension_keys;
DROP POLICY daily_tips_update ON public.daily_tips;
DROP POLICY daily_tips_select ON public.daily_tips;
DROP POLICY daily_tips_insert ON public.daily_tips;
DROP POLICY couples_update ON public.couples;
DROP POLICY couples_select ON public.couples;
DROP POLICY couples_insert ON public.couples;
DROP POLICY couple_vectors_select ON public.couple_vectors;
DROP POLICY couple_reports_select ON public.couple_reports;
DROP POLICY couple_members_select ON public.couple_members;
DROP POLICY couple_members_insert ON public.couple_members;
DROP POLICY couple_insights_select ON public.couple_insights;
DROP POLICY conocernos_reactions_all ON public.conocernos_reactions;
DROP POLICY conocernos_questions_read ON public.conocernos_questions;
DROP POLICY conocernos_daily_read ON public.conocernos_daily;
DROP POLICY conocernos_daily_insert ON public.conocernos_daily;
DROP POLICY conocernos_answers_read ON public.conocernos_answers;
DROP POLICY conocernos_answers_insert ON public.conocernos_answers;
DROP POLICY challenge_assignments_update ON public.challenge_assignments;
DROP POLICY challenge_assignments_select ON public.challenge_assignments;
DROP POLICY challenge_assignments_insert ON public.challenge_assignments;
DROP POLICY answer_options_select ON public.answer_options;
DROP POLICY ai_insights_select ON public.ai_insights;
DROP POLICY ai_audit_log_select ON public.ai_audit_log;
DROP POLICY "Users can view couple custom evaluations" ON public.custom_evaluations;
DROP POLICY "Users can view couple custom evaluation questions" ON public.custom_evaluation_questions;
DROP POLICY "Users can view couple custom evaluation insights" ON public.custom_evaluation_insights;
DROP POLICY "Users can view couple answers" ON public.custom_evaluation_answers;
DROP POLICY "Users can update their custom evaluations" ON public.custom_evaluations;
DROP POLICY "Users can update own answers" ON public.custom_evaluation_answers;
DROP POLICY "Users can insert own answers" ON public.custom_evaluation_answers;
DROP POLICY "Users can insert couple custom evaluation questions" ON public.custom_evaluation_questions;
DROP POLICY "Users can insert couple custom evaluation insights" ON public.custom_evaluation_insights;
DROP POLICY "Users can create custom evaluations" ON public.custom_evaluations;
DROP POLICY "Service role can update narratives" ON public.nosotros_narratives;
DROP POLICY "Service role can insert narratives" ON public.nosotros_narratives;
DROP POLICY "Service role can delete narratives" ON public.nosotros_narratives;
DROP POLICY "Couple members can view narratives" ON public.nosotros_narratives;
ALTER TABLE ONLY storage.vector_indexes DROP CONSTRAINT vector_indexes_bucket_id_fkey;
ALTER TABLE ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey;
ALTER TABLE ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey;
ALTER TABLE ONLY storage.s3_multipart_uploads DROP CONSTRAINT s3_multipart_uploads_bucket_id_fkey;
ALTER TABLE ONLY storage.objects DROP CONSTRAINT "objects_bucketId_fkey";
ALTER TABLE ONLY public.weekly_plans DROP CONSTRAINT weekly_plans_couple_id_fkey;
ALTER TABLE ONLY public.weekly_plan_items DROP CONSTRAINT weekly_plan_items_plan_id_fkey;
ALTER TABLE ONLY public.weekly_plan_items DROP CONSTRAINT weekly_plan_items_couple_id_fkey;
ALTER TABLE ONLY public.responses DROP CONSTRAINT responses_session_id_fkey;
ALTER TABLE ONLY public.response_sessions DROP CONSTRAINT response_sessions_user_id_fkey;
ALTER TABLE ONLY public.response_sessions DROP CONSTRAINT response_sessions_section_id_fkey;
ALTER TABLE ONLY public.response_sessions DROP CONSTRAINT response_sessions_questionnaire_id_fkey;
ALTER TABLE ONLY public.response_sessions DROP CONSTRAINT response_sessions_generated_assessment_id_fkey;
ALTER TABLE ONLY public.questions DROP CONSTRAINT questions_section_id_fkey;
ALTER TABLE ONLY public.questionnaire_sections DROP CONSTRAINT questionnaire_sections_questionnaire_id_fkey;
ALTER TABLE ONLY public.question_dimension_map DROP CONSTRAINT question_dimension_map_question_id_fkey;
ALTER TABLE ONLY public.question_dimension_map DROP CONSTRAINT question_dimension_map_dimension_id_fkey;
ALTER TABLE ONLY public.profiles DROP CONSTRAINT profiles_id_fkey;
ALTER TABLE ONLY public.profile_vectors DROP CONSTRAINT profile_vectors_user_id_fkey;
ALTER TABLE ONLY public.personal_reports DROP CONSTRAINT personal_reports_user_id_fkey;
ALTER TABLE ONLY public.personal_reports DROP CONSTRAINT personal_reports_session_id_fkey;
ALTER TABLE ONLY public.onboarding_sessions DROP CONSTRAINT onboarding_sessions_user_id_fkey;
ALTER TABLE ONLY public.onboarding_responses DROP CONSTRAINT onboarding_responses_session_id_fkey;
ALTER TABLE ONLY public.nosotros_narratives DROP CONSTRAINT nosotros_narratives_couple_id_fkey;
ALTER TABLE ONLY public.milestones DROP CONSTRAINT milestones_couple_id_fkey;
ALTER TABLE ONLY public.item_dimensions DROP CONSTRAINT item_dimensions_item_id_fkey;
ALTER TABLE ONLY public.generated_assessments DROP CONSTRAINT generated_assessments_couple_id_fkey;
ALTER TABLE ONLY public.generated_assessment_items DROP CONSTRAINT generated_assessment_items_item_bank_id_fkey;
ALTER TABLE ONLY public.generated_assessment_items DROP CONSTRAINT generated_assessment_items_assessment_id_fkey;
ALTER TABLE ONLY public.dimension_scores DROP CONSTRAINT dimension_scores_user_id_fkey;
ALTER TABLE ONLY public.dimension_scores DROP CONSTRAINT dimension_scores_dimension_id_fkey;
ALTER TABLE ONLY public.dimension_scores DROP CONSTRAINT dimension_scores_couple_id_fkey;
ALTER TABLE ONLY public.daily_tips DROP CONSTRAINT daily_tips_couple_id_fkey;
ALTER TABLE ONLY public.custom_evaluations DROP CONSTRAINT custom_evaluations_created_by_fkey;
ALTER TABLE ONLY public.custom_evaluations DROP CONSTRAINT custom_evaluations_couple_id_fkey;
ALTER TABLE ONLY public.custom_evaluation_questions DROP CONSTRAINT custom_evaluation_questions_evaluation_id_fkey;
ALTER TABLE ONLY public.custom_evaluation_insights DROP CONSTRAINT custom_evaluation_insights_evaluation_id_fkey;
ALTER TABLE ONLY public.custom_evaluation_answers DROP CONSTRAINT custom_evaluation_answers_user_id_fkey;
ALTER TABLE ONLY public.custom_evaluation_answers DROP CONSTRAINT custom_evaluation_answers_question_id_fkey;
ALTER TABLE ONLY public.custom_evaluation_answers DROP CONSTRAINT custom_evaluation_answers_evaluation_id_fkey;
ALTER TABLE ONLY public.couples DROP CONSTRAINT couples_created_by_fkey;
ALTER TABLE ONLY public.couple_vectors DROP CONSTRAINT couple_vectors_couple_id_fkey;
ALTER TABLE ONLY public.couple_reports DROP CONSTRAINT couple_reports_session_b_id_fkey;
ALTER TABLE ONLY public.couple_reports DROP CONSTRAINT couple_reports_session_a_id_fkey;
ALTER TABLE ONLY public.couple_reports DROP CONSTRAINT couple_reports_couple_id_fkey;
ALTER TABLE ONLY public.couple_members DROP CONSTRAINT couple_members_user_id_fkey;
ALTER TABLE ONLY public.couple_members DROP CONSTRAINT couple_members_couple_id_fkey;
ALTER TABLE ONLY public.couple_insights DROP CONSTRAINT couple_insights_couple_id_fkey;
ALTER TABLE ONLY public.conocernos_reactions DROP CONSTRAINT conocernos_reactions_user_id_fkey;
ALTER TABLE ONLY public.conocernos_reactions DROP CONSTRAINT conocernos_reactions_target_user_id_fkey;
ALTER TABLE ONLY public.conocernos_reactions DROP CONSTRAINT conocernos_reactions_daily_id_fkey;
ALTER TABLE ONLY public.conocernos_daily DROP CONSTRAINT conocernos_daily_question_id_fkey;
ALTER TABLE ONLY public.conocernos_daily DROP CONSTRAINT conocernos_daily_couple_id_fkey;
ALTER TABLE ONLY public.conocernos_answers DROP CONSTRAINT conocernos_answers_user_id_fkey;
ALTER TABLE ONLY public.conocernos_answers DROP CONSTRAINT conocernos_answers_daily_id_fkey;
ALTER TABLE ONLY public.challenge_assignments DROP CONSTRAINT challenge_assignments_couple_id_fkey;
ALTER TABLE ONLY public.challenge_assignments DROP CONSTRAINT challenge_assignments_challenge_id_fkey;
ALTER TABLE ONLY public.answer_options DROP CONSTRAINT answer_options_question_id_fkey;
ALTER TABLE ONLY public.ai_insights DROP CONSTRAINT ai_insights_user_id_fkey;
ALTER TABLE ONLY public.ai_insights DROP CONSTRAINT ai_insights_couple_id_fkey;
ALTER TABLE ONLY public.ai_audit_log DROP CONSTRAINT ai_audit_log_couple_id_fkey;
ALTER TABLE ONLY auth.webauthn_credentials DROP CONSTRAINT webauthn_credentials_user_id_fkey;
ALTER TABLE ONLY auth.webauthn_challenges DROP CONSTRAINT webauthn_challenges_user_id_fkey;
ALTER TABLE ONLY auth.sso_domains DROP CONSTRAINT sso_domains_sso_provider_id_fkey;
ALTER TABLE ONLY auth.sessions DROP CONSTRAINT sessions_user_id_fkey;
ALTER TABLE ONLY auth.sessions DROP CONSTRAINT sessions_oauth_client_id_fkey;
ALTER TABLE ONLY auth.saml_relay_states DROP CONSTRAINT saml_relay_states_sso_provider_id_fkey;
ALTER TABLE ONLY auth.saml_relay_states DROP CONSTRAINT saml_relay_states_flow_state_id_fkey;
ALTER TABLE ONLY auth.saml_providers DROP CONSTRAINT saml_providers_sso_provider_id_fkey;
ALTER TABLE ONLY auth.refresh_tokens DROP CONSTRAINT refresh_tokens_session_id_fkey;
ALTER TABLE ONLY auth.one_time_tokens DROP CONSTRAINT one_time_tokens_user_id_fkey;
ALTER TABLE ONLY auth.oauth_consents DROP CONSTRAINT oauth_consents_user_id_fkey;
ALTER TABLE ONLY auth.oauth_consents DROP CONSTRAINT oauth_consents_client_id_fkey;
ALTER TABLE ONLY auth.oauth_authorizations DROP CONSTRAINT oauth_authorizations_user_id_fkey;
ALTER TABLE ONLY auth.oauth_authorizations DROP CONSTRAINT oauth_authorizations_client_id_fkey;
ALTER TABLE ONLY auth.mfa_factors DROP CONSTRAINT mfa_factors_user_id_fkey;
ALTER TABLE ONLY auth.mfa_challenges DROP CONSTRAINT mfa_challenges_auth_factor_id_fkey;
ALTER TABLE ONLY auth.mfa_amr_claims DROP CONSTRAINT mfa_amr_claims_session_id_fkey;
ALTER TABLE ONLY auth.identities DROP CONSTRAINT identities_user_id_fkey;
DROP TRIGGER update_objects_updated_at ON storage.objects;
DROP TRIGGER protect_objects_delete ON storage.objects;
DROP TRIGGER protect_buckets_delete ON storage.buckets;
DROP TRIGGER enforce_bucket_name_length_trigger ON storage.buckets;
DROP TRIGGER tr_check_filters ON realtime.subscription;
DROP TRIGGER update_custom_evaluations_modtime ON public.custom_evaluations;
DROP TRIGGER on_auth_user_created ON auth.users;
DROP INDEX storage.vector_indexes_name_bucket_id_idx;
DROP INDEX storage.name_prefix_search;
DROP INDEX storage.idx_objects_bucket_id_name_lower;
DROP INDEX storage.idx_objects_bucket_id_name;
DROP INDEX storage.idx_multipart_uploads_list;
DROP INDEX storage.buckets_analytics_unique_name_idx;
DROP INDEX storage.bucketid_objname;
DROP INDEX storage.bname;
DROP INDEX realtime.subscription_subscription_id_entity_filters_action_filter_key;
DROP INDEX realtime.messages_inserted_at_topic_index;
DROP INDEX realtime.ix_realtime_subscription_entity;
DROP INDEX public.nosotros_narratives_unique_idx;
DROP INDEX public.idx_weekly_plans_couple;
DROP INDEX public.idx_weekly_plan_items_plan;
DROP INDEX public.idx_responses_session;
DROP INDEX public.idx_response_sessions_user;
DROP INDEX public.idx_response_sessions_status;
DROP INDEX public.idx_questions_section;
DROP INDEX public.idx_profile_vectors_user;
DROP INDEX public.idx_onboarding_sessions_user;
DROP INDEX public.idx_onboarding_responses_session;
DROP INDEX public.idx_item_bank_stage;
DROP INDEX public.idx_item_bank_dimension;
DROP INDEX public.idx_dimension_scores_user;
DROP INDEX public.idx_daily_tips_couple_date;
DROP INDEX public.idx_couple_vectors_couple;
DROP INDEX public.idx_couple_members_user;
DROP INDEX public.idx_couple_members_couple;
DROP INDEX public.idx_couple_insights_couple;
DROP INDEX public.idx_conocernos_reactions_daily;
DROP INDEX public.idx_conocernos_daily_couple_date;
DROP INDEX public.idx_conocernos_answers_daily;
DROP INDEX auth.webauthn_credentials_user_id_idx;
DROP INDEX auth.webauthn_credentials_credential_id_key;
DROP INDEX auth.webauthn_challenges_user_id_idx;
DROP INDEX auth.webauthn_challenges_expires_at_idx;
DROP INDEX auth.users_is_anonymous_idx;
DROP INDEX auth.users_instance_id_idx;
DROP INDEX auth.users_instance_id_email_idx;
DROP INDEX auth.users_email_partial_key;
DROP INDEX auth.user_id_created_at_idx;
DROP INDEX auth.unique_phone_factor_per_user;
DROP INDEX auth.sso_providers_resource_id_pattern_idx;
DROP INDEX auth.sso_providers_resource_id_idx;
DROP INDEX auth.sso_domains_sso_provider_id_idx;
DROP INDEX auth.sso_domains_domain_idx;
DROP INDEX auth.sessions_user_id_idx;
DROP INDEX auth.sessions_oauth_client_id_idx;
DROP INDEX auth.sessions_not_after_idx;
DROP INDEX auth.saml_relay_states_sso_provider_id_idx;
DROP INDEX auth.saml_relay_states_for_email_idx;
DROP INDEX auth.saml_relay_states_created_at_idx;
DROP INDEX auth.saml_providers_sso_provider_id_idx;
DROP INDEX auth.refresh_tokens_updated_at_idx;
DROP INDEX auth.refresh_tokens_session_id_revoked_idx;
DROP INDEX auth.refresh_tokens_parent_idx;
DROP INDEX auth.refresh_tokens_instance_id_user_id_idx;
DROP INDEX auth.refresh_tokens_instance_id_idx;
DROP INDEX auth.recovery_token_idx;
DROP INDEX auth.reauthentication_token_idx;
DROP INDEX auth.one_time_tokens_user_id_token_type_key;
DROP INDEX auth.one_time_tokens_token_hash_hash_idx;
DROP INDEX auth.one_time_tokens_relates_to_hash_idx;
DROP INDEX auth.oauth_consents_user_order_idx;
DROP INDEX auth.oauth_consents_active_user_client_idx;
DROP INDEX auth.oauth_consents_active_client_idx;
DROP INDEX auth.oauth_clients_deleted_at_idx;
DROP INDEX auth.oauth_auth_pending_exp_idx;
DROP INDEX auth.mfa_factors_user_id_idx;
DROP INDEX auth.mfa_factors_user_friendly_name_unique;
DROP INDEX auth.mfa_challenge_created_at_idx;
DROP INDEX auth.idx_user_id_auth_method;
DROP INDEX auth.idx_oauth_client_states_created_at;
DROP INDEX auth.idx_auth_code;
DROP INDEX auth.identities_user_id_idx;
DROP INDEX auth.identities_email_idx;
DROP INDEX auth.flow_state_created_at_idx;
DROP INDEX auth.factor_id_created_at_idx;
DROP INDEX auth.email_change_token_new_idx;
DROP INDEX auth.email_change_token_current_idx;
DROP INDEX auth.custom_oauth_providers_provider_type_idx;
DROP INDEX auth.custom_oauth_providers_identifier_idx;
DROP INDEX auth.custom_oauth_providers_enabled_idx;
DROP INDEX auth.custom_oauth_providers_created_at_idx;
DROP INDEX auth.confirmation_token_idx;
DROP INDEX auth.audit_logs_instance_id_idx;
ALTER TABLE ONLY storage.vector_indexes DROP CONSTRAINT vector_indexes_pkey;
ALTER TABLE ONLY storage.s3_multipart_uploads DROP CONSTRAINT s3_multipart_uploads_pkey;
ALTER TABLE ONLY storage.s3_multipart_uploads_parts DROP CONSTRAINT s3_multipart_uploads_parts_pkey;
ALTER TABLE ONLY storage.objects DROP CONSTRAINT objects_pkey;
ALTER TABLE ONLY storage.migrations DROP CONSTRAINT migrations_pkey;
ALTER TABLE ONLY storage.migrations DROP CONSTRAINT migrations_name_key;
ALTER TABLE ONLY storage.buckets_vectors DROP CONSTRAINT buckets_vectors_pkey;
ALTER TABLE ONLY storage.buckets DROP CONSTRAINT buckets_pkey;
ALTER TABLE ONLY storage.buckets_analytics DROP CONSTRAINT buckets_analytics_pkey;
ALTER TABLE ONLY realtime.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
ALTER TABLE ONLY realtime.subscription DROP CONSTRAINT pk_subscription;
ALTER TABLE ONLY realtime.messages DROP CONSTRAINT messages_pkey;
ALTER TABLE ONLY public.weekly_plans DROP CONSTRAINT weekly_plans_pkey;
ALTER TABLE ONLY public.weekly_plans DROP CONSTRAINT weekly_plans_couple_id_week_start_key;
ALTER TABLE ONLY public.weekly_plan_items DROP CONSTRAINT weekly_plan_items_pkey;
ALTER TABLE ONLY public.weekly_challenges DROP CONSTRAINT weekly_challenges_slug_key;
ALTER TABLE ONLY public.weekly_challenges DROP CONSTRAINT weekly_challenges_pkey;
ALTER TABLE ONLY public.responses DROP CONSTRAINT responses_session_id_question_id_key;
ALTER TABLE ONLY public.responses DROP CONSTRAINT responses_pkey;
ALTER TABLE ONLY public.response_sessions DROP CONSTRAINT response_sessions_pkey;
ALTER TABLE ONLY public.questions DROP CONSTRAINT questions_pkey;
ALTER TABLE ONLY public.questionnaires DROP CONSTRAINT questionnaires_slug_key;
ALTER TABLE ONLY public.questionnaires DROP CONSTRAINT questionnaires_pkey;
ALTER TABLE ONLY public.questionnaire_sections DROP CONSTRAINT questionnaire_sections_pkey;
ALTER TABLE ONLY public.question_dimension_map DROP CONSTRAINT question_dimension_map_pkey;
ALTER TABLE ONLY public.profiles DROP CONSTRAINT profiles_pkey;
ALTER TABLE ONLY public.profile_vectors DROP CONSTRAINT profile_vectors_user_id_dimension_slug_key;
ALTER TABLE ONLY public.profile_vectors DROP CONSTRAINT profile_vectors_pkey;
ALTER TABLE ONLY public.personal_reports DROP CONSTRAINT personal_reports_pkey;
ALTER TABLE ONLY public.onboarding_sessions DROP CONSTRAINT onboarding_sessions_user_id_key;
ALTER TABLE ONLY public.onboarding_sessions DROP CONSTRAINT onboarding_sessions_pkey;
ALTER TABLE ONLY public.onboarding_responses DROP CONSTRAINT onboarding_responses_session_id_item_id_key;
ALTER TABLE ONLY public.onboarding_responses DROP CONSTRAINT onboarding_responses_pkey;
ALTER TABLE ONLY public.nosotros_narratives DROP CONSTRAINT nosotros_narratives_pkey;
ALTER TABLE ONLY public.milestones DROP CONSTRAINT milestones_pkey;
ALTER TABLE ONLY public.item_dimensions DROP CONSTRAINT item_dimensions_pkey;
ALTER TABLE ONLY public.item_bank DROP CONSTRAINT item_bank_slug_key;
ALTER TABLE ONLY public.item_bank DROP CONSTRAINT item_bank_pkey;
ALTER TABLE ONLY public.guided_conversations DROP CONSTRAINT guided_conversations_slug_key;
ALTER TABLE ONLY public.guided_conversations DROP CONSTRAINT guided_conversations_pkey;
ALTER TABLE ONLY public.generated_assessments DROP CONSTRAINT generated_assessments_pkey;
ALTER TABLE ONLY public.generated_assessment_items DROP CONSTRAINT generated_assessment_items_pkey;
ALTER TABLE ONLY public.dimension_scores DROP CONSTRAINT dimension_scores_pkey;
ALTER TABLE ONLY public.dimension_keys DROP CONSTRAINT dimension_keys_slug_key;
ALTER TABLE ONLY public.dimension_keys DROP CONSTRAINT dimension_keys_pkey;
ALTER TABLE ONLY public.daily_tips DROP CONSTRAINT daily_tips_pkey;
ALTER TABLE ONLY public.daily_tips DROP CONSTRAINT daily_tips_couple_id_tip_date_key;
ALTER TABLE ONLY public.custom_evaluations DROP CONSTRAINT custom_evaluations_pkey;
ALTER TABLE ONLY public.custom_evaluation_questions DROP CONSTRAINT custom_evaluation_questions_pkey;
ALTER TABLE ONLY public.custom_evaluation_insights DROP CONSTRAINT custom_evaluation_insights_pkey;
ALTER TABLE ONLY public.custom_evaluation_answers DROP CONSTRAINT custom_evaluation_answers_user_id_question_id_key;
ALTER TABLE ONLY public.custom_evaluation_answers DROP CONSTRAINT custom_evaluation_answers_pkey;
ALTER TABLE ONLY public.couples DROP CONSTRAINT couples_pkey;
ALTER TABLE ONLY public.couples DROP CONSTRAINT couples_invite_code_key;
ALTER TABLE ONLY public.couple_vectors DROP CONSTRAINT couple_vectors_pkey;
ALTER TABLE ONLY public.couple_reports DROP CONSTRAINT couple_reports_pkey;
ALTER TABLE ONLY public.couple_members DROP CONSTRAINT couple_members_pkey;
ALTER TABLE ONLY public.couple_members DROP CONSTRAINT couple_members_couple_id_user_id_key;
ALTER TABLE ONLY public.couple_insights DROP CONSTRAINT couple_insights_pkey;
ALTER TABLE ONLY public.conocernos_reactions DROP CONSTRAINT conocernos_reactions_pkey;
ALTER TABLE ONLY public.conocernos_reactions DROP CONSTRAINT conocernos_reactions_daily_id_user_id_target_user_id_key;
ALTER TABLE ONLY public.conocernos_questions DROP CONSTRAINT conocernos_questions_pkey;
ALTER TABLE ONLY public.conocernos_daily DROP CONSTRAINT conocernos_daily_pkey;
ALTER TABLE ONLY public.conocernos_daily DROP CONSTRAINT conocernos_daily_couple_id_question_date_key;
ALTER TABLE ONLY public.conocernos_answers DROP CONSTRAINT conocernos_answers_pkey;
ALTER TABLE ONLY public.conocernos_answers DROP CONSTRAINT conocernos_answers_daily_id_user_id_key;
ALTER TABLE ONLY public.challenge_assignments DROP CONSTRAINT challenge_assignments_pkey;
ALTER TABLE ONLY public.answer_options DROP CONSTRAINT answer_options_pkey;
ALTER TABLE ONLY public.ai_insights DROP CONSTRAINT ai_insights_pkey;
ALTER TABLE ONLY public.ai_audit_log DROP CONSTRAINT ai_audit_log_pkey;
ALTER TABLE ONLY auth.webauthn_credentials DROP CONSTRAINT webauthn_credentials_pkey;
ALTER TABLE ONLY auth.webauthn_challenges DROP CONSTRAINT webauthn_challenges_pkey;
ALTER TABLE ONLY auth.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY auth.users DROP CONSTRAINT users_phone_key;
ALTER TABLE ONLY auth.sso_providers DROP CONSTRAINT sso_providers_pkey;
ALTER TABLE ONLY auth.sso_domains DROP CONSTRAINT sso_domains_pkey;
ALTER TABLE ONLY auth.sessions DROP CONSTRAINT sessions_pkey;
ALTER TABLE ONLY auth.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
ALTER TABLE ONLY auth.saml_relay_states DROP CONSTRAINT saml_relay_states_pkey;
ALTER TABLE ONLY auth.saml_providers DROP CONSTRAINT saml_providers_pkey;
ALTER TABLE ONLY auth.saml_providers DROP CONSTRAINT saml_providers_entity_id_key;
ALTER TABLE ONLY auth.refresh_tokens DROP CONSTRAINT refresh_tokens_token_unique;
ALTER TABLE ONLY auth.refresh_tokens DROP CONSTRAINT refresh_tokens_pkey;
ALTER TABLE ONLY auth.one_time_tokens DROP CONSTRAINT one_time_tokens_pkey;
ALTER TABLE ONLY auth.oauth_consents DROP CONSTRAINT oauth_consents_user_client_unique;
ALTER TABLE ONLY auth.oauth_consents DROP CONSTRAINT oauth_consents_pkey;
ALTER TABLE ONLY auth.oauth_clients DROP CONSTRAINT oauth_clients_pkey;
ALTER TABLE ONLY auth.oauth_client_states DROP CONSTRAINT oauth_client_states_pkey;
ALTER TABLE ONLY auth.oauth_authorizations DROP CONSTRAINT oauth_authorizations_pkey;
ALTER TABLE ONLY auth.oauth_authorizations DROP CONSTRAINT oauth_authorizations_authorization_id_key;
ALTER TABLE ONLY auth.oauth_authorizations DROP CONSTRAINT oauth_authorizations_authorization_code_key;
ALTER TABLE ONLY auth.mfa_factors DROP CONSTRAINT mfa_factors_pkey;
ALTER TABLE ONLY auth.mfa_factors DROP CONSTRAINT mfa_factors_last_challenged_at_key;
ALTER TABLE ONLY auth.mfa_challenges DROP CONSTRAINT mfa_challenges_pkey;
ALTER TABLE ONLY auth.mfa_amr_claims DROP CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey;
ALTER TABLE ONLY auth.instances DROP CONSTRAINT instances_pkey;
ALTER TABLE ONLY auth.identities DROP CONSTRAINT identities_provider_id_provider_unique;
ALTER TABLE ONLY auth.identities DROP CONSTRAINT identities_pkey;
ALTER TABLE ONLY auth.flow_state DROP CONSTRAINT flow_state_pkey;
ALTER TABLE ONLY auth.custom_oauth_providers DROP CONSTRAINT custom_oauth_providers_pkey;
ALTER TABLE ONLY auth.custom_oauth_providers DROP CONSTRAINT custom_oauth_providers_identifier_key;
ALTER TABLE ONLY auth.audit_log_entries DROP CONSTRAINT audit_log_entries_pkey;
ALTER TABLE ONLY auth.mfa_amr_claims DROP CONSTRAINT amr_id_pk;
ALTER TABLE auth.refresh_tokens ALTER COLUMN id DROP DEFAULT;
DROP TABLE storage.vector_indexes;
DROP TABLE storage.s3_multipart_uploads_parts;
DROP TABLE storage.s3_multipart_uploads;
DROP TABLE storage.objects;
DROP TABLE storage.migrations;
DROP TABLE storage.buckets_vectors;
DROP TABLE storage.buckets_analytics;
DROP TABLE storage.buckets;
DROP TABLE realtime.subscription;
DROP TABLE realtime.schema_migrations;
DROP TABLE realtime.messages;
DROP TABLE public.weekly_plans;
DROP TABLE public.weekly_plan_items;
DROP TABLE public.weekly_challenges;
DROP TABLE public.responses;
DROP TABLE public.response_sessions;
DROP TABLE public.questions;
DROP TABLE public.questionnaires;
DROP TABLE public.questionnaire_sections;
DROP TABLE public.question_dimension_map;
DROP TABLE public.profiles;
DROP TABLE public.profile_vectors;
DROP TABLE public.personal_reports;
DROP TABLE public.onboarding_sessions;
DROP TABLE public.onboarding_responses;
DROP TABLE public.nosotros_narratives;
DROP TABLE public.milestones;
DROP TABLE public.item_dimensions;
DROP TABLE public.item_bank;
DROP TABLE public.guided_conversations;
DROP TABLE public.generated_assessments;
DROP TABLE public.generated_assessment_items;
DROP TABLE public.dimension_scores;
DROP TABLE public.dimension_keys;
DROP TABLE public.daily_tips;
DROP TABLE public.custom_evaluations;
DROP TABLE public.custom_evaluation_questions;
DROP TABLE public.custom_evaluation_insights;
DROP TABLE public.custom_evaluation_answers;
DROP TABLE public.couples;
DROP TABLE public.couple_vectors;
DROP TABLE public.couple_reports;
DROP TABLE public.couple_members;
DROP TABLE public.couple_insights;
DROP TABLE public.conocernos_reactions;
DROP TABLE public.conocernos_questions;
DROP TABLE public.conocernos_daily;
DROP TABLE public.conocernos_answers;
DROP TABLE public.challenge_assignments;
DROP TABLE public.answer_options;
DROP TABLE public.ai_insights;
DROP TABLE public.ai_audit_log;
DROP TABLE auth.webauthn_credentials;
DROP TABLE auth.webauthn_challenges;
DROP TABLE auth.users;
DROP TABLE auth.sso_providers;
DROP TABLE auth.sso_domains;
DROP TABLE auth.sessions;
DROP TABLE auth.schema_migrations;
DROP TABLE auth.saml_relay_states;
DROP TABLE auth.saml_providers;
DROP SEQUENCE auth.refresh_tokens_id_seq;
DROP TABLE auth.refresh_tokens;
DROP TABLE auth.one_time_tokens;
DROP TABLE auth.oauth_consents;
DROP TABLE auth.oauth_clients;
DROP TABLE auth.oauth_client_states;
DROP TABLE auth.oauth_authorizations;
DROP TABLE auth.mfa_factors;
DROP TABLE auth.mfa_challenges;
DROP TABLE auth.mfa_amr_claims;
DROP TABLE auth.instances;
DROP TABLE auth.identities;
DROP TABLE auth.flow_state;
DROP TABLE auth.custom_oauth_providers;
DROP TABLE auth.audit_log_entries;
DROP FUNCTION storage.update_updated_at_column();
DROP FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer, levels integer, start_after text, sort_order text, sort_column text, sort_column_after text);
DROP FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text);
DROP FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text);
DROP FUNCTION storage.protect_delete();
DROP FUNCTION storage.operation();
DROP FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer, start_after text, next_token text, sort_order text);
DROP FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer, next_key_token text, next_upload_token text);
DROP FUNCTION storage.get_size_by_bucket();
DROP FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text);
DROP FUNCTION storage.foldername(name text);
DROP FUNCTION storage.filename(name text);
DROP FUNCTION storage.extension(name text);
DROP FUNCTION storage.enforce_bucket_name_length();
DROP FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb);
DROP FUNCTION realtime.topic();
DROP FUNCTION realtime.to_regrole(role_name text);
DROP FUNCTION realtime.subscription_check_filters();
DROP FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean);
DROP FUNCTION realtime.quote_wal2json(entity regclass);
DROP FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer);
DROP FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]);
DROP FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text);
DROP FUNCTION realtime."cast"(val text, type_ regtype);
DROP FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]);
DROP FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text);
DROP FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer);
DROP FUNCTION public.update_updated_at_column();
DROP FUNCTION public.refresh_couple_status_view();
DROP FUNCTION public.is_member_of_couple(target_couple_id uuid);
DROP FUNCTION public.has_couple(user_uuid uuid);
DROP FUNCTION public.handle_new_user();
DROP FUNCTION public.get_my_couple_partner_ids();
DROP FUNCTION public.get_my_couple_ids();
DROP FUNCTION public.get_couple_id_for_user(user_uuid uuid);
DROP FUNCTION public.generate_invite_code();
DROP FUNCTION pgbouncer.get_auth(p_usename text);
DROP FUNCTION extensions.set_graphql_placeholder();
DROP FUNCTION extensions.pgrst_drop_watch();
DROP FUNCTION extensions.pgrst_ddl_watch();
DROP FUNCTION extensions.grant_pg_net_access();
DROP FUNCTION extensions.grant_pg_graphql_access();
DROP FUNCTION extensions.grant_pg_cron_access();
DROP FUNCTION auth.uid();
DROP FUNCTION auth.role();
DROP FUNCTION auth.jwt();
DROP FUNCTION auth.email();
DROP TYPE storage.buckettype;
DROP TYPE realtime.wal_rls;
DROP TYPE realtime.wal_column;
DROP TYPE realtime.user_defined_filter;
DROP TYPE realtime.equality_op;
DROP TYPE realtime.action;
DROP TYPE auth.one_time_token_type;
DROP TYPE auth.oauth_response_type;
DROP TYPE auth.oauth_registration_type;
DROP TYPE auth.oauth_client_type;
DROP TYPE auth.oauth_authorization_status;
DROP TYPE auth.factor_type;
DROP TYPE auth.factor_status;
DROP TYPE auth.code_challenge_method;
DROP TYPE auth.aal_level;
DROP EXTENSION "uuid-ossp";
DROP EXTENSION supabase_vault;
DROP EXTENSION pgcrypto;
DROP EXTENSION pg_stat_statements;
DROP EXTENSION pg_graphql;
DROP SCHEMA vault;
DROP SCHEMA storage;
DROP SCHEMA realtime;
DROP SCHEMA pgbouncer;
DROP SCHEMA graphql_public;
DROP SCHEMA graphql;
DROP SCHEMA extensions;
DROP SCHEMA auth;
--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA auth;


--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA extensions;


--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql;


--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA graphql_public;


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA pgbouncer;


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA realtime;


--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA storage;


--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA vault;


--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


--
-- Name: code_challenge_method; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.code_challenge_method AS ENUM (
    's256',
    'plain'
);


--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn',
    'phone'
);


--
-- Name: oauth_authorization_status; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_authorization_status AS ENUM (
    'pending',
    'approved',
    'denied',
    'expired'
);


--
-- Name: oauth_client_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_client_type AS ENUM (
    'public',
    'confidential'
);


--
-- Name: oauth_registration_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_registration_type AS ENUM (
    'dynamic',
    'manual'
);


--
-- Name: oauth_response_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.oauth_response_type AS ENUM (
    'code'
);


--
-- Name: one_time_token_type; Type: TYPE; Schema: auth; Owner: -
--

CREATE TYPE auth.one_time_token_type AS ENUM (
    'confirmation_token',
    'reauthentication_token',
    'recovery_token',
    'email_change_token_new',
    'email_change_token_current',
    'phone_change_token'
);


--
-- Name: action; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.action AS ENUM (
    'INSERT',
    'UPDATE',
    'DELETE',
    'TRUNCATE',
    'ERROR'
);


--
-- Name: equality_op; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.equality_op AS ENUM (
    'eq',
    'neq',
    'lt',
    'lte',
    'gt',
    'gte',
    'in'
);


--
-- Name: user_defined_filter; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.user_defined_filter AS (
	column_name text,
	op realtime.equality_op,
	value text
);


--
-- Name: wal_column; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_column AS (
	name text,
	type_name text,
	type_oid oid,
	value jsonb,
	is_pkey boolean,
	is_selectable boolean
);


--
-- Name: wal_rls; Type: TYPE; Schema: realtime; Owner: -
--

CREATE TYPE realtime.wal_rls AS (
	wal jsonb,
	is_rls_enabled boolean,
	subscription_ids uuid[],
	errors text[]
);


--
-- Name: buckettype; Type: TYPE; Schema: storage; Owner: -
--

CREATE TYPE storage.buckettype AS ENUM (
    'STANDARD',
    'ANALYTICS',
    'VECTOR'
);


--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: -
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_cron'
  )
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;
    revoke all on table cron.job from postgres;
    grant select on table cron.job to postgres with grant option;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;

        -- Allow postgres role to allow granting usage on graphql and graphql_public schemas to custom roles
        grant usage on schema graphql_public to postgres with grant option;
        grant usage on schema graphql to postgres with grant option;
    END IF;

END;
$_$;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF EXISTS (
    SELECT 1
    FROM pg_event_trigger_ddl_commands() AS ev
    JOIN pg_extension AS ext
    ON ev.objid = ext.oid
    WHERE ext.extname = 'pg_net'
  )
  THEN
    IF NOT EXISTS (
      SELECT 1
      FROM pg_roles
      WHERE rolname = 'supabase_functions_admin'
    )
    THEN
      CREATE USER supabase_functions_admin NOINHERIT CREATEROLE LOGIN NOREPLICATION;
    END IF;

    GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres, anon, authenticated, service_role;

    IF EXISTS (
      SELECT FROM pg_extension
      WHERE extname = 'pg_net'
      -- all versions in use on existing projects as of 2025-02-20
      -- version 0.12.0 onwards don't need these applied
      AND extversion IN ('0.2', '0.6', '0.7', '0.7.1', '0.8', '0.10.0', '0.11.0')
    ) THEN
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;

      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;

      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;

      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres, anon, authenticated, service_role;
    END IF;
  END IF;
END;
$$;


--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: -
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: -
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: -
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO ''
    AS $_$
  BEGIN
      RAISE DEBUG 'PgBouncer auth request: %', p_usename;

      RETURN QUERY
      SELECT
          rolname::text,
          CASE WHEN rolvaliduntil < now()
              THEN null
              ELSE rolpassword::text
          END
      FROM pg_authid
      WHERE rolname=$1 and rolcanlogin;
  END;
  $_$;


--
-- Name: generate_invite_code(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_invite_code() RETURNS text
    LANGUAGE plpgsql
    SET search_path TO 'public'
    AS $$
DECLARE
    chars TEXT := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    result TEXT := '';
    i INT;
BEGIN
    FOR i IN 1..8 LOOP
        result := result || substr(chars, floor(random() * length(chars) + 1)::int, 1);
    END LOOP;
    RETURN result;
END;
$$;


--
-- Name: get_couple_id_for_user(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_couple_id_for_user(user_uuid uuid) RETURNS uuid
    LANGUAGE plpgsql STABLE
    SET search_path TO 'public'
    AS $$
DECLARE
    couple_uuid UUID;
BEGIN
    SELECT cm.couple_id
    INTO couple_uuid
    FROM public.couple_members cm
    WHERE cm.user_id = user_uuid
    LIMIT 1;

    RETURN couple_uuid;
END;
$$;


--
-- Name: get_my_couple_ids(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_my_couple_ids() RETURNS SETOF uuid
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT couple_id FROM couple_members WHERE user_id = auth.uid();
$$;


--
-- Name: get_my_couple_partner_ids(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_my_couple_partner_ids() RETURNS SETOF uuid
    LANGUAGE sql STABLE SECURITY DEFINER
    AS $$
  SELECT cm.user_id 
  FROM couple_members cm 
  WHERE cm.couple_id IN (SELECT get_my_couple_ids())
  AND cm.user_id != auth.uid();
$$;


--
-- Name: handle_new_user(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.handle_new_user() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    INSERT INTO public.profiles (id, full_name, avatar_url, locale, timezone)
    VALUES (
        NEW.id,
        NEW.raw_user_meta_data->>'full_name',
        NEW.raw_user_meta_data->>'avatar_url',
        COALESCE(NEW.raw_user_meta_data->>'locale', 'es-MX'),
        COALESCE(NEW.raw_user_meta_data->>'timezone', 'America/Mexico_City')
    )
    ON CONFLICT (id) DO NOTHING;

    RETURN NEW;
END;
$$;


--
-- Name: has_couple(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.has_couple(user_uuid uuid) RETURNS boolean
    LANGUAGE plpgsql STABLE
    SET search_path TO 'public'
    AS $$
DECLARE
    has_c BOOLEAN;
BEGIN
    SELECT EXISTS(
        SELECT 1
        FROM public.couple_members cm
        WHERE cm.user_id = user_uuid
    )
    INTO has_c;

    RETURN has_c;
END;
$$;


--
-- Name: is_member_of_couple(uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.is_member_of_couple(target_couple_id uuid) RETURNS boolean
    LANGUAGE sql STABLE SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.couple_members
    WHERE couple_id = target_couple_id
      AND user_id = auth.uid()
  );
$$;


--
-- Name: refresh_couple_status_view(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.refresh_couple_status_view() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'public'
    AS $$
BEGIN
    REFRESH MATERIALIZED VIEW public.couple_status_view;
    RETURN NULL;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


--
-- Name: apply_rls(jsonb, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer DEFAULT (1024 * 1024)) RETURNS SETOF realtime.wal_rls
    LANGUAGE plpgsql
    AS $$
declare
-- Regclass of the table e.g. public.notes
entity_ regclass = (quote_ident(wal ->> 'schema') || '.' || quote_ident(wal ->> 'table'))::regclass;

-- I, U, D, T: insert, update ...
action realtime.action = (
    case wal ->> 'action'
        when 'I' then 'INSERT'
        when 'U' then 'UPDATE'
        when 'D' then 'DELETE'
        else 'ERROR'
    end
);

-- Is row level security enabled for the table
is_rls_enabled bool = relrowsecurity from pg_class where oid = entity_;

subscriptions realtime.subscription[] = array_agg(subs)
    from
        realtime.subscription subs
    where
        subs.entity = entity_
        -- Filter by action early - only get subscriptions interested in this action
        -- action_filter column can be: '*' (all), 'INSERT', 'UPDATE', or 'DELETE'
        and (subs.action_filter = '*' or subs.action_filter = action::text);

-- Subscription vars
roles regrole[] = array_agg(distinct us.claims_role::text)
    from
        unnest(subscriptions) us;

working_role regrole;
claimed_role regrole;
claims jsonb;

subscription_id uuid;
subscription_has_access bool;
visible_to_subscription_ids uuid[] = '{}';

-- structured info for wal's columns
columns realtime.wal_column[];
-- previous identity values for update/delete
old_columns realtime.wal_column[];

error_record_exceeds_max_size boolean = octet_length(wal::text) > max_record_bytes;

-- Primary jsonb output for record
output jsonb;

begin
perform set_config('role', null, true);

columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'columns') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

old_columns =
    array_agg(
        (
            x->>'name',
            x->>'type',
            x->>'typeoid',
            realtime.cast(
                (x->'value') #>> '{}',
                coalesce(
                    (x->>'typeoid')::regtype, -- null when wal2json version <= 2.4
                    (x->>'type')::regtype
                )
            ),
            (pks ->> 'name') is not null,
            true
        )::realtime.wal_column
    )
    from
        jsonb_array_elements(wal -> 'identity') x
        left join jsonb_array_elements(wal -> 'pk') pks
            on (x ->> 'name') = (pks ->> 'name');

for working_role in select * from unnest(roles) loop

    -- Update `is_selectable` for columns and old_columns
    columns =
        array_agg(
            (
                c.name,
                c.type_name,
                c.type_oid,
                c.value,
                c.is_pkey,
                pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
            )::realtime.wal_column
        )
        from
            unnest(columns) c;

    old_columns =
            array_agg(
                (
                    c.name,
                    c.type_name,
                    c.type_oid,
                    c.value,
                    c.is_pkey,
                    pg_catalog.has_column_privilege(working_role, entity_, c.name, 'SELECT')
                )::realtime.wal_column
            )
            from
                unnest(old_columns) c;

    if action <> 'DELETE' and count(1) = 0 from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            -- subscriptions is already filtered by entity
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 400: Bad Request, no primary key']
        )::realtime.wal_rls;

    -- The claims role does not have SELECT permission to the primary key of entity
    elsif action <> 'DELETE' and sum(c.is_selectable::int) <> count(1) from unnest(columns) c where c.is_pkey then
        return next (
            jsonb_build_object(
                'schema', wal ->> 'schema',
                'table', wal ->> 'table',
                'type', action
            ),
            is_rls_enabled,
            (select array_agg(s.subscription_id) from unnest(subscriptions) as s where claims_role = working_role),
            array['Error 401: Unauthorized']
        )::realtime.wal_rls;

    else
        output = jsonb_build_object(
            'schema', wal ->> 'schema',
            'table', wal ->> 'table',
            'type', action,
            'commit_timestamp', to_char(
                ((wal ->> 'timestamp')::timestamptz at time zone 'utc'),
                'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"'
            ),
            'columns', (
                select
                    jsonb_agg(
                        jsonb_build_object(
                            'name', pa.attname,
                            'type', pt.typname
                        )
                        order by pa.attnum asc
                    )
                from
                    pg_attribute pa
                    join pg_type pt
                        on pa.atttypid = pt.oid
                where
                    attrelid = entity_
                    and attnum > 0
                    and pg_catalog.has_column_privilege(working_role, entity_, pa.attname, 'SELECT')
            )
        )
        -- Add "record" key for insert and update
        || case
            when action in ('INSERT', 'UPDATE') then
                jsonb_build_object(
                    'record',
                    (
                        select
                            jsonb_object_agg(
                                -- if unchanged toast, get column name and value from old record
                                coalesce((c).name, (oc).name),
                                case
                                    when (c).name is null then (oc).value
                                    else (c).value
                                end
                            )
                        from
                            unnest(columns) c
                            full outer join unnest(old_columns) oc
                                on (c).name = (oc).name
                        where
                            coalesce((c).is_selectable, (oc).is_selectable)
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                    )
                )
            else '{}'::jsonb
        end
        -- Add "old_record" key for update and delete
        || case
            when action = 'UPDATE' then
                jsonb_build_object(
                        'old_record',
                        (
                            select jsonb_object_agg((c).name, (c).value)
                            from unnest(old_columns) c
                            where
                                (c).is_selectable
                                and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                        )
                    )
            when action = 'DELETE' then
                jsonb_build_object(
                    'old_record',
                    (
                        select jsonb_object_agg((c).name, (c).value)
                        from unnest(old_columns) c
                        where
                            (c).is_selectable
                            and ( not error_record_exceeds_max_size or (octet_length((c).value::text) <= 64))
                            and ( not is_rls_enabled or (c).is_pkey ) -- if RLS enabled, we can't secure deletes so filter to pkey
                    )
                )
            else '{}'::jsonb
        end;

        -- Create the prepared statement
        if is_rls_enabled and action <> 'DELETE' then
            if (select 1 from pg_prepared_statements where name = 'walrus_rls_stmt' limit 1) > 0 then
                deallocate walrus_rls_stmt;
            end if;
            execute realtime.build_prepared_statement_sql('walrus_rls_stmt', entity_, columns);
        end if;

        visible_to_subscription_ids = '{}';

        for subscription_id, claims in (
                select
                    subs.subscription_id,
                    subs.claims
                from
                    unnest(subscriptions) subs
                where
                    subs.entity = entity_
                    and subs.claims_role = working_role
                    and (
                        realtime.is_visible_through_filters(columns, subs.filters)
                        or (
                          action = 'DELETE'
                          and realtime.is_visible_through_filters(old_columns, subs.filters)
                        )
                    )
        ) loop

            if not is_rls_enabled or action = 'DELETE' then
                visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
            else
                -- Check if RLS allows the role to see the record
                perform
                    -- Trim leading and trailing quotes from working_role because set_config
                    -- doesn't recognize the role as valid if they are included
                    set_config('role', trim(both '"' from working_role::text), true),
                    set_config('request.jwt.claims', claims::text, true);

                execute 'execute walrus_rls_stmt' into subscription_has_access;

                if subscription_has_access then
                    visible_to_subscription_ids = visible_to_subscription_ids || subscription_id;
                end if;
            end if;
        end loop;

        perform set_config('role', null, true);

        return next (
            output,
            is_rls_enabled,
            visible_to_subscription_ids,
            case
                when error_record_exceeds_max_size then array['Error 413: Payload Too Large']
                else '{}'
            end
        )::realtime.wal_rls;

    end if;
end loop;

perform set_config('role', null, true);
end;
$$;


--
-- Name: broadcast_changes(text, text, text, text, text, record, record, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text DEFAULT 'ROW'::text) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
    -- Declare a variable to hold the JSONB representation of the row
    row_data jsonb := '{}'::jsonb;
BEGIN
    IF level = 'STATEMENT' THEN
        RAISE EXCEPTION 'function can only be triggered for each row, not for each statement';
    END IF;
    -- Check the operation type and handle accordingly
    IF operation = 'INSERT' OR operation = 'UPDATE' OR operation = 'DELETE' THEN
        row_data := jsonb_build_object('old_record', OLD, 'record', NEW, 'operation', operation, 'table', table_name, 'schema', table_schema);
        PERFORM realtime.send (row_data, event_name, topic_name);
    ELSE
        RAISE EXCEPTION 'Unexpected operation type: %', operation;
    END IF;
EXCEPTION
    WHEN OTHERS THEN
        RAISE EXCEPTION 'Failed to process the row: %', SQLERRM;
END;

$$;


--
-- Name: build_prepared_statement_sql(text, regclass, realtime.wal_column[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) RETURNS text
    LANGUAGE sql
    AS $$
      /*
      Builds a sql string that, if executed, creates a prepared statement to
      tests retrive a row from *entity* by its primary key columns.
      Example
          select realtime.build_prepared_statement_sql('public.notes', '{"id"}'::text[], '{"bigint"}'::text[])
      */
          select
      'prepare ' || prepared_statement_name || ' as
          select
              exists(
                  select
                      1
                  from
                      ' || entity || '
                  where
                      ' || string_agg(quote_ident(pkc.name) || '=' || quote_nullable(pkc.value #>> '{}') , ' and ') || '
              )'
          from
              unnest(columns) pkc
          where
              pkc.is_pkey
          group by
              entity
      $$;


--
-- Name: cast(text, regtype); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime."cast"(val text, type_ regtype) RETURNS jsonb
    LANGUAGE plpgsql IMMUTABLE
    AS $$
declare
  res jsonb;
begin
  if type_::text = 'bytea' then
    return to_jsonb(val);
  end if;
  execute format('select to_jsonb(%L::'|| type_::text || ')', val) into res;
  return res;
end
$$;


--
-- Name: check_equality_op(realtime.equality_op, regtype, text, text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) RETURNS boolean
    LANGUAGE plpgsql IMMUTABLE
    AS $$
      /*
      Casts *val_1* and *val_2* as type *type_* and check the *op* condition for truthiness
      */
      declare
          op_symbol text = (
              case
                  when op = 'eq' then '='
                  when op = 'neq' then '!='
                  when op = 'lt' then '<'
                  when op = 'lte' then '<='
                  when op = 'gt' then '>'
                  when op = 'gte' then '>='
                  when op = 'in' then '= any'
                  else 'UNKNOWN OP'
              end
          );
          res boolean;
      begin
          execute format(
              'select %L::'|| type_::text || ' ' || op_symbol
              || ' ( %L::'
              || (
                  case
                      when op = 'in' then type_::text || '[]'
                      else type_::text end
              )
              || ')', val_1, val_2) into res;
          return res;
      end;
      $$;


--
-- Name: is_visible_through_filters(realtime.wal_column[], realtime.user_defined_filter[]); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) RETURNS boolean
    LANGUAGE sql IMMUTABLE
    AS $_$
    /*
    Should the record be visible (true) or filtered out (false) after *filters* are applied
    */
        select
            -- Default to allowed when no filters present
            $2 is null -- no filters. this should not happen because subscriptions has a default
            or array_length($2, 1) is null -- array length of an empty array is null
            or bool_and(
                coalesce(
                    realtime.check_equality_op(
                        op:=f.op,
                        type_:=coalesce(
                            col.type_oid::regtype, -- null when wal2json version <= 2.4
                            col.type_name::regtype
                        ),
                        -- cast jsonb to text
                        val_1:=col.value #>> '{}',
                        val_2:=f.value
                    ),
                    false -- if null, filter does not match
                )
            )
        from
            unnest(filters) f
            join unnest(columns) col
                on f.column_name = col.name;
    $_$;


--
-- Name: list_changes(name, name, integer, integer); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) RETURNS SETOF realtime.wal_rls
    LANGUAGE sql
    SET log_min_messages TO 'fatal'
    AS $$
      with pub as (
        select
          concat_ws(
            ',',
            case when bool_or(pubinsert) then 'insert' else null end,
            case when bool_or(pubupdate) then 'update' else null end,
            case when bool_or(pubdelete) then 'delete' else null end
          ) as w2j_actions,
          coalesce(
            string_agg(
              realtime.quote_wal2json(format('%I.%I', schemaname, tablename)::regclass),
              ','
            ) filter (where ppt.tablename is not null and ppt.tablename not like '% %'),
            ''
          ) w2j_add_tables
        from
          pg_publication pp
          left join pg_publication_tables ppt
            on pp.pubname = ppt.pubname
        where
          pp.pubname = publication
        group by
          pp.pubname
        limit 1
      ),
      w2j as (
        select
          x.*, pub.w2j_add_tables
        from
          pub,
          pg_logical_slot_get_changes(
            slot_name, null, max_changes,
            'include-pk', 'true',
            'include-transaction', 'false',
            'include-timestamp', 'true',
            'include-type-oids', 'true',
            'format-version', '2',
            'actions', pub.w2j_actions,
            'add-tables', pub.w2j_add_tables
          ) x
      )
      select
        xyz.wal,
        xyz.is_rls_enabled,
        xyz.subscription_ids,
        xyz.errors
      from
        w2j,
        realtime.apply_rls(
          wal := w2j.data::jsonb,
          max_record_bytes := max_record_bytes
        ) xyz(wal, is_rls_enabled, subscription_ids, errors)
      where
        w2j.w2j_add_tables <> ''
        and xyz.subscription_ids[1] is not null
    $$;


--
-- Name: quote_wal2json(regclass); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.quote_wal2json(entity regclass) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $$
      select
        (
          select string_agg('' || ch,'')
          from unnest(string_to_array(nsp.nspname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
        )
        || '.'
        || (
          select string_agg('' || ch,'')
          from unnest(string_to_array(pc.relname::text, null)) with ordinality x(ch, idx)
          where
            not (x.idx = 1 and x.ch = '"')
            and not (
              x.idx = array_length(string_to_array(nsp.nspname::text, null), 1)
              and x.ch = '"'
            )
          )
      from
        pg_class pc
        join pg_namespace nsp
          on pc.relnamespace = nsp.oid
      where
        pc.oid = entity
    $$;


--
-- Name: send(jsonb, text, text, boolean); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean DEFAULT true) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE
  generated_id uuid;
  final_payload jsonb;
BEGIN
  BEGIN
    -- Generate a new UUID for the id
    generated_id := gen_random_uuid();

    -- Check if payload has an 'id' key, if not, add the generated UUID
    IF payload ? 'id' THEN
      final_payload := payload;
    ELSE
      final_payload := jsonb_set(payload, '{id}', to_jsonb(generated_id));
    END IF;

    -- Set the topic configuration
    EXECUTE format('SET LOCAL realtime.topic TO %L', topic);

    -- Attempt to insert the message
    INSERT INTO realtime.messages (id, payload, event, topic, private, extension)
    VALUES (generated_id, final_payload, event, topic, private, 'broadcast');
  EXCEPTION
    WHEN OTHERS THEN
      -- Capture and notify the error
      RAISE WARNING 'ErrorSendingBroadcastMessage: %', SQLERRM;
  END;
END;
$$;


--
-- Name: subscription_check_filters(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.subscription_check_filters() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    /*
    Validates that the user defined filters for a subscription:
    - refer to valid columns that the claimed role may access
    - values are coercable to the correct column type
    */
    declare
        col_names text[] = coalesce(
                array_agg(c.column_name order by c.ordinal_position),
                '{}'::text[]
            )
            from
                information_schema.columns c
            where
                format('%I.%I', c.table_schema, c.table_name)::regclass = new.entity
                and pg_catalog.has_column_privilege(
                    (new.claims ->> 'role'),
                    format('%I.%I', c.table_schema, c.table_name)::regclass,
                    c.column_name,
                    'SELECT'
                );
        filter realtime.user_defined_filter;
        col_type regtype;

        in_val jsonb;
    begin
        for filter in select * from unnest(new.filters) loop
            -- Filtered column is valid
            if not filter.column_name = any(col_names) then
                raise exception 'invalid column for filter %', filter.column_name;
            end if;

            -- Type is sanitized and safe for string interpolation
            col_type = (
                select atttypid::regtype
                from pg_catalog.pg_attribute
                where attrelid = new.entity
                      and attname = filter.column_name
            );
            if col_type is null then
                raise exception 'failed to lookup type for column %', filter.column_name;
            end if;

            -- Set maximum number of entries for in filter
            if filter.op = 'in'::realtime.equality_op then
                in_val = realtime.cast(filter.value, (col_type::text || '[]')::regtype);
                if coalesce(jsonb_array_length(in_val), 0) > 100 then
                    raise exception 'too many values for `in` filter. Maximum 100';
                end if;
            else
                -- raises an exception if value is not coercable to type
                perform realtime.cast(filter.value, col_type);
            end if;

        end loop;

        -- Apply consistent order to filters so the unique constraint on
        -- (subscription_id, entity, filters) can't be tricked by a different filter order
        new.filters = coalesce(
            array_agg(f order by f.column_name, f.op, f.value),
            '{}'
        ) from unnest(new.filters) f;

        return new;
    end;
    $$;


--
-- Name: to_regrole(text); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.to_regrole(role_name text) RETURNS regrole
    LANGUAGE sql IMMUTABLE
    AS $$ select role_name::regrole $$;


--
-- Name: topic(); Type: FUNCTION; Schema: realtime; Owner: -
--

CREATE FUNCTION realtime.topic() RETURNS text
    LANGUAGE sql STABLE
    AS $$
select nullif(current_setting('realtime.topic', true), '')::text;
$$;


--
-- Name: can_insert_object(text, text, uuid, jsonb); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.can_insert_object(bucketid text, name text, owner uuid, metadata jsonb) RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
  INSERT INTO "storage"."objects" ("bucket_id", "name", "owner", "metadata") VALUES (bucketid, name, owner, metadata);
  -- hack to rollback the successful insert
  RAISE sqlstate 'PT200' using
  message = 'ROLLBACK',
  detail = 'rollback successful insert';
END
$$;


--
-- Name: enforce_bucket_name_length(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.enforce_bucket_name_length() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    if length(new.name) > 100 then
        raise exception 'bucket name "%" is too long (% characters). Max is 100.', new.name, length(new.name);
    end if;
    return new;
end;
$$;


--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
	select string_to_array(name, '/') into _parts;
	select _parts[array_length(_parts,1)] into _filename;
	-- @todo return the last part instead of 2
	return reverse(split_part(reverse(_filename), '.', 1));
END
$$;


--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[array_length(_parts,1)];
END
$$;


--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
	select string_to_array(name, '/') into _parts;
	return _parts[1:array_length(_parts,1)-1];
END
$$;


--
-- Name: get_common_prefix(text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_common_prefix(p_key text, p_prefix text, p_delimiter text) RETURNS text
    LANGUAGE sql IMMUTABLE
    AS $$
SELECT CASE
    WHEN position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)) > 0
    THEN left(p_key, length(p_prefix) + position(p_delimiter IN substring(p_key FROM length(p_prefix) + 1)))
    ELSE NULL
END;
$$;


--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


--
-- Name: list_multipart_uploads_with_delimiter(text, text, text, integer, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_multipart_uploads_with_delimiter(bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, next_key_token text DEFAULT ''::text, next_upload_token text DEFAULT ''::text) RETURNS TABLE(key text, id text, created_at timestamp with time zone)
    LANGUAGE plpgsql
    AS $_$
BEGIN
    RETURN QUERY EXECUTE
        'SELECT DISTINCT ON(key COLLATE "C") * from (
            SELECT
                CASE
                    WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                        substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1)))
                    ELSE
                        key
                END AS key, id, created_at
            FROM
                storage.s3_multipart_uploads
            WHERE
                bucket_id = $5 AND
                key ILIKE $1 || ''%'' AND
                CASE
                    WHEN $4 != '''' AND $6 = '''' THEN
                        CASE
                            WHEN position($2 IN substring(key from length($1) + 1)) > 0 THEN
                                substring(key from 1 for length($1) + position($2 IN substring(key from length($1) + 1))) COLLATE "C" > $4
                            ELSE
                                key COLLATE "C" > $4
                            END
                    ELSE
                        true
                END AND
                CASE
                    WHEN $6 != '''' THEN
                        id COLLATE "C" > $6
                    ELSE
                        true
                    END
            ORDER BY
                key COLLATE "C" ASC, created_at ASC) as e order by key COLLATE "C" LIMIT $3'
        USING prefix_param, delimiter_param, max_keys, next_key_token, bucket_id, next_upload_token;
END;
$_$;


--
-- Name: list_objects_with_delimiter(text, text, text, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.list_objects_with_delimiter(_bucket_id text, prefix_param text, delimiter_param text, max_keys integer DEFAULT 100, start_after text DEFAULT ''::text, next_token text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, metadata jsonb, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;

    -- Configuration
    v_is_asc BOOLEAN;
    v_prefix TEXT;
    v_start TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_is_asc := lower(coalesce(sort_order, 'asc')) = 'asc';
    v_prefix := coalesce(prefix_param, '');
    v_start := CASE WHEN coalesce(next_token, '') <> '' THEN next_token ELSE coalesce(start_after, '') END;
    v_file_batch_size := LEAST(GREATEST(max_keys * 2, 100), 1000);

    -- Calculate upper bound for prefix filtering (bytewise, using COLLATE "C")
    IF v_prefix = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix, 1) = delimiter_param THEN
        v_upper_bound := left(v_prefix, -1) || chr(ascii(delimiter_param) + 1);
    ELSE
        v_upper_bound := left(v_prefix, -1) || chr(ascii(right(v_prefix, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'AND o.name COLLATE "C" < $3 ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" >= $2 ' ||
                'ORDER BY o.name COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'AND o.name COLLATE "C" >= $3 ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND o.name COLLATE "C" < $2 ' ||
                'ORDER BY o.name COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- ========================================================================
    -- SEEK INITIALIZATION: Determine starting position
    -- ========================================================================
    IF v_start = '' THEN
        IF v_is_asc THEN
            v_next_seek := v_prefix;
        ELSE
            -- DESC without cursor: find the last item in range
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_next_seek FROM storage.objects o
                WHERE o.bucket_id = _bucket_id
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;

            IF v_next_seek IS NOT NULL THEN
                v_next_seek := v_next_seek || delimiter_param;
            ELSE
                RETURN;
            END IF;
        END IF;
    ELSE
        -- Cursor provided: determine if it refers to a folder or leaf
        IF EXISTS (
            SELECT 1 FROM storage.objects o
            WHERE o.bucket_id = _bucket_id
              AND o.name COLLATE "C" LIKE v_start || delimiter_param || '%'
            LIMIT 1
        ) THEN
            -- Cursor refers to a folder
            IF v_is_asc THEN
                v_next_seek := v_start || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_start || delimiter_param;
            END IF;
        ELSE
            -- Cursor refers to a leaf object
            IF v_is_asc THEN
                v_next_seek := v_start || delimiter_param;
            ELSE
                v_next_seek := v_start;
            END IF;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= max_keys;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek AND o.name COLLATE "C" < v_upper_bound
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" >= v_next_seek
                ORDER BY o.name COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek AND o.name COLLATE "C" >= v_prefix
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = _bucket_id AND o.name COLLATE "C" < v_next_seek
                ORDER BY o.name COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(v_peek_name, v_prefix, delimiter_param);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Emit and skip to next folder (no heap access needed)
            name := rtrim(v_common_prefix, delimiter_param);
            id := NULL;
            updated_at := NULL;
            created_at := NULL;
            last_accessed_at := NULL;
            metadata := NULL;
            RETURN NEXT;
            v_count := v_count + 1;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := left(v_common_prefix, -1) || chr(ascii(delimiter_param) + 1);
            ELSE
                v_next_seek := v_common_prefix;
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query USING _bucket_id, v_next_seek,
                CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix) ELSE v_prefix END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(v_current.name, v_prefix, delimiter_param);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := v_current.name;
                    EXIT;
                END IF;

                -- Emit file
                name := v_current.name;
                id := v_current.id;
                updated_at := v_current.updated_at;
                created_at := v_current.created_at;
                last_accessed_at := v_current.last_accessed_at;
                metadata := v_current.metadata;
                RETURN NEXT;
                v_count := v_count + 1;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := v_current.name || delimiter_param;
                ELSE
                    v_next_seek := v_current.name;
                END IF;

                EXIT WHEN v_count >= max_keys;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: operation(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.operation() RETURNS text
    LANGUAGE plpgsql STABLE
    AS $$
BEGIN
    RETURN current_setting('storage.operation', true);
END;
$$;


--
-- Name: protect_delete(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.protect_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    -- Check if storage.allow_delete_query is set to 'true'
    IF COALESCE(current_setting('storage.allow_delete_query', true), 'false') != 'true' THEN
        RAISE EXCEPTION 'Direct deletion from storage tables is not allowed. Use the Storage API instead.'
            USING HINT = 'This prevents accidental data loss from orphaned objects.',
                  ERRCODE = '42501';
    END IF;
    RETURN NULL;
END;
$$;


--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_peek_name TEXT;
    v_current RECORD;
    v_common_prefix TEXT;
    v_delimiter CONSTANT TEXT := '/';

    -- Configuration
    v_limit INT;
    v_prefix TEXT;
    v_prefix_lower TEXT;
    v_is_asc BOOLEAN;
    v_order_by TEXT;
    v_sort_order TEXT;
    v_upper_bound TEXT;
    v_file_batch_size INT;

    -- Dynamic SQL for batch query only
    v_batch_query TEXT;

    -- Seek state
    v_next_seek TEXT;
    v_count INT := 0;
    v_skipped INT := 0;
BEGIN
    -- ========================================================================
    -- INITIALIZATION
    -- ========================================================================
    v_limit := LEAST(coalesce(limits, 100), 1500);
    v_prefix := coalesce(prefix, '') || coalesce(search, '');
    v_prefix_lower := lower(v_prefix);
    v_is_asc := lower(coalesce(sortorder, 'asc')) = 'asc';
    v_file_batch_size := LEAST(GREATEST(v_limit * 2, 100), 1000);

    -- Validate sort column
    CASE lower(coalesce(sortcolumn, 'name'))
        WHEN 'name' THEN v_order_by := 'name';
        WHEN 'updated_at' THEN v_order_by := 'updated_at';
        WHEN 'created_at' THEN v_order_by := 'created_at';
        WHEN 'last_accessed_at' THEN v_order_by := 'last_accessed_at';
        ELSE v_order_by := 'name';
    END CASE;

    v_sort_order := CASE WHEN v_is_asc THEN 'asc' ELSE 'desc' END;

    -- ========================================================================
    -- NON-NAME SORTING: Use path_tokens approach (unchanged)
    -- ========================================================================
    IF v_order_by != 'name' THEN
        RETURN QUERY EXECUTE format(
            $sql$
            WITH folders AS (
                SELECT path_tokens[$1] AS folder
                FROM storage.objects
                WHERE objects.name ILIKE $2 || '%%'
                  AND bucket_id = $3
                  AND array_length(objects.path_tokens, 1) <> $1
                GROUP BY folder
                ORDER BY folder %s
            )
            (SELECT folder AS "name",
                   NULL::uuid AS id,
                   NULL::timestamptz AS updated_at,
                   NULL::timestamptz AS created_at,
                   NULL::timestamptz AS last_accessed_at,
                   NULL::jsonb AS metadata FROM folders)
            UNION ALL
            (SELECT path_tokens[$1] AS "name",
                   id, updated_at, created_at, last_accessed_at, metadata
             FROM storage.objects
             WHERE objects.name ILIKE $2 || '%%'
               AND bucket_id = $3
               AND array_length(objects.path_tokens, 1) = $1
             ORDER BY %I %s)
            LIMIT $4 OFFSET $5
            $sql$, v_sort_order, v_order_by, v_sort_order
        ) USING levels, v_prefix, bucketname, v_limit, offsets;
        RETURN;
    END IF;

    -- ========================================================================
    -- NAME SORTING: Hybrid skip-scan with batch optimization
    -- ========================================================================

    -- Calculate upper bound for prefix filtering
    IF v_prefix_lower = '' THEN
        v_upper_bound := NULL;
    ELSIF right(v_prefix_lower, 1) = v_delimiter THEN
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(v_delimiter) + 1);
    ELSE
        v_upper_bound := left(v_prefix_lower, -1) || chr(ascii(right(v_prefix_lower, 1)) + 1);
    END IF;

    -- Build batch query (dynamic SQL - called infrequently, amortized over many rows)
    IF v_is_asc THEN
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'AND lower(o.name) COLLATE "C" < $3 ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" >= $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" ASC LIMIT $4';
        END IF;
    ELSE
        IF v_upper_bound IS NOT NULL THEN
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'AND lower(o.name) COLLATE "C" >= $3 ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        ELSE
            v_batch_query := 'SELECT o.name, o.id, o.updated_at, o.created_at, o.last_accessed_at, o.metadata ' ||
                'FROM storage.objects o WHERE o.bucket_id = $1 AND lower(o.name) COLLATE "C" < $2 ' ||
                'ORDER BY lower(o.name) COLLATE "C" DESC LIMIT $4';
        END IF;
    END IF;

    -- Initialize seek position
    IF v_is_asc THEN
        v_next_seek := v_prefix_lower;
    ELSE
        -- DESC: find the last item in range first (static SQL)
        IF v_upper_bound IS NOT NULL THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower AND lower(o.name) COLLATE "C" < v_upper_bound
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSIF v_prefix_lower <> '' THEN
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_prefix_lower
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        ELSE
            SELECT o.name INTO v_peek_name FROM storage.objects o
            WHERE o.bucket_id = bucketname
            ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
        END IF;

        IF v_peek_name IS NOT NULL THEN
            v_next_seek := lower(v_peek_name) || v_delimiter;
        ELSE
            RETURN;
        END IF;
    END IF;

    -- ========================================================================
    -- MAIN LOOP: Hybrid peek-then-batch algorithm
    -- Uses STATIC SQL for peek (hot path) and DYNAMIC SQL for batch
    -- ========================================================================
    LOOP
        EXIT WHEN v_count >= v_limit;

        -- STEP 1: PEEK using STATIC SQL (plan cached, very fast)
        IF v_is_asc THEN
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek AND lower(o.name) COLLATE "C" < v_upper_bound
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" >= v_next_seek
                ORDER BY lower(o.name) COLLATE "C" ASC LIMIT 1;
            END IF;
        ELSE
            IF v_upper_bound IS NOT NULL THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSIF v_prefix_lower <> '' THEN
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek AND lower(o.name) COLLATE "C" >= v_prefix_lower
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            ELSE
                SELECT o.name INTO v_peek_name FROM storage.objects o
                WHERE o.bucket_id = bucketname AND lower(o.name) COLLATE "C" < v_next_seek
                ORDER BY lower(o.name) COLLATE "C" DESC LIMIT 1;
            END IF;
        END IF;

        EXIT WHEN v_peek_name IS NULL;

        -- STEP 2: Check if this is a FOLDER or FILE
        v_common_prefix := storage.get_common_prefix(lower(v_peek_name), v_prefix_lower, v_delimiter);

        IF v_common_prefix IS NOT NULL THEN
            -- FOLDER: Handle offset, emit if needed, skip to next folder
            IF v_skipped < offsets THEN
                v_skipped := v_skipped + 1;
            ELSE
                name := split_part(rtrim(storage.get_common_prefix(v_peek_name, v_prefix, v_delimiter), v_delimiter), v_delimiter, levels);
                id := NULL;
                updated_at := NULL;
                created_at := NULL;
                last_accessed_at := NULL;
                metadata := NULL;
                RETURN NEXT;
                v_count := v_count + 1;
            END IF;

            -- Advance seek past the folder range
            IF v_is_asc THEN
                v_next_seek := lower(left(v_common_prefix, -1)) || chr(ascii(v_delimiter) + 1);
            ELSE
                v_next_seek := lower(v_common_prefix);
            END IF;
        ELSE
            -- FILE: Batch fetch using DYNAMIC SQL (overhead amortized over many rows)
            -- For ASC: upper_bound is the exclusive upper limit (< condition)
            -- For DESC: prefix_lower is the inclusive lower limit (>= condition)
            FOR v_current IN EXECUTE v_batch_query
                USING bucketname, v_next_seek,
                    CASE WHEN v_is_asc THEN COALESCE(v_upper_bound, v_prefix_lower) ELSE v_prefix_lower END, v_file_batch_size
            LOOP
                v_common_prefix := storage.get_common_prefix(lower(v_current.name), v_prefix_lower, v_delimiter);

                IF v_common_prefix IS NOT NULL THEN
                    -- Hit a folder: exit batch, let peek handle it
                    v_next_seek := lower(v_current.name);
                    EXIT;
                END IF;

                -- Handle offset skipping
                IF v_skipped < offsets THEN
                    v_skipped := v_skipped + 1;
                ELSE
                    -- Emit file
                    name := split_part(v_current.name, v_delimiter, levels);
                    id := v_current.id;
                    updated_at := v_current.updated_at;
                    created_at := v_current.created_at;
                    last_accessed_at := v_current.last_accessed_at;
                    metadata := v_current.metadata;
                    RETURN NEXT;
                    v_count := v_count + 1;
                END IF;

                -- Advance seek past this file
                IF v_is_asc THEN
                    v_next_seek := lower(v_current.name) || v_delimiter;
                ELSE
                    v_next_seek := lower(v_current.name);
                END IF;

                EXIT WHEN v_count >= v_limit;
            END LOOP;
        END IF;
    END LOOP;
END;
$_$;


--
-- Name: search_by_timestamp(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_by_timestamp(p_prefix text, p_bucket_id text, p_limit integer, p_level integer, p_start_after text, p_sort_order text, p_sort_column text, p_sort_column_after text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
DECLARE
    v_cursor_op text;
    v_query text;
    v_prefix text;
BEGIN
    v_prefix := coalesce(p_prefix, '');

    IF p_sort_order = 'asc' THEN
        v_cursor_op := '>';
    ELSE
        v_cursor_op := '<';
    END IF;

    v_query := format($sql$
        WITH raw_objects AS (
            SELECT
                o.name AS obj_name,
                o.id AS obj_id,
                o.updated_at AS obj_updated_at,
                o.created_at AS obj_created_at,
                o.last_accessed_at AS obj_last_accessed_at,
                o.metadata AS obj_metadata,
                storage.get_common_prefix(o.name, $1, '/') AS common_prefix
            FROM storage.objects o
            WHERE o.bucket_id = $2
              AND o.name COLLATE "C" LIKE $1 || '%%'
        ),
        -- Aggregate common prefixes (folders)
        -- Both created_at and updated_at use MIN(obj_created_at) to match the old prefixes table behavior
        aggregated_prefixes AS (
            SELECT
                rtrim(common_prefix, '/') AS name,
                NULL::uuid AS id,
                MIN(obj_created_at) AS updated_at,
                MIN(obj_created_at) AS created_at,
                NULL::timestamptz AS last_accessed_at,
                NULL::jsonb AS metadata,
                TRUE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NOT NULL
            GROUP BY common_prefix
        ),
        leaf_objects AS (
            SELECT
                obj_name AS name,
                obj_id AS id,
                obj_updated_at AS updated_at,
                obj_created_at AS created_at,
                obj_last_accessed_at AS last_accessed_at,
                obj_metadata AS metadata,
                FALSE AS is_prefix
            FROM raw_objects
            WHERE common_prefix IS NULL
        ),
        combined AS (
            SELECT * FROM aggregated_prefixes
            UNION ALL
            SELECT * FROM leaf_objects
        ),
        filtered AS (
            SELECT *
            FROM combined
            WHERE (
                $5 = ''
                OR ROW(
                    date_trunc('milliseconds', %I),
                    name COLLATE "C"
                ) %s ROW(
                    COALESCE(NULLIF($6, '')::timestamptz, 'epoch'::timestamptz),
                    $5
                )
            )
        )
        SELECT
            split_part(name, '/', $3) AS key,
            name,
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
        FROM filtered
        ORDER BY
            COALESCE(date_trunc('milliseconds', %I), 'epoch'::timestamptz) %s,
            name COLLATE "C" %s
        LIMIT $4
    $sql$,
        p_sort_column,
        v_cursor_op,
        p_sort_column,
        p_sort_order,
        p_sort_order
    );

    RETURN QUERY EXECUTE v_query
    USING v_prefix, p_bucket_id, p_level, p_limit, p_start_after, p_sort_column_after;
END;
$_$;


--
-- Name: search_v2(text, text, integer, integer, text, text, text, text); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.search_v2(prefix text, bucket_name text, limits integer DEFAULT 100, levels integer DEFAULT 1, start_after text DEFAULT ''::text, sort_order text DEFAULT 'asc'::text, sort_column text DEFAULT 'name'::text, sort_column_after text DEFAULT ''::text) RETURNS TABLE(key text, name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $$
DECLARE
    v_sort_col text;
    v_sort_ord text;
    v_limit int;
BEGIN
    -- Cap limit to maximum of 1500 records
    v_limit := LEAST(coalesce(limits, 100), 1500);

    -- Validate and normalize sort_order
    v_sort_ord := lower(coalesce(sort_order, 'asc'));
    IF v_sort_ord NOT IN ('asc', 'desc') THEN
        v_sort_ord := 'asc';
    END IF;

    -- Validate and normalize sort_column
    v_sort_col := lower(coalesce(sort_column, 'name'));
    IF v_sort_col NOT IN ('name', 'updated_at', 'created_at') THEN
        v_sort_col := 'name';
    END IF;

    -- Route to appropriate implementation
    IF v_sort_col = 'name' THEN
        -- Use list_objects_with_delimiter for name sorting (most efficient: O(k * log n))
        RETURN QUERY
        SELECT
            split_part(l.name, '/', levels) AS key,
            l.name AS name,
            l.id,
            l.updated_at,
            l.created_at,
            l.last_accessed_at,
            l.metadata
        FROM storage.list_objects_with_delimiter(
            bucket_name,
            coalesce(prefix, ''),
            '/',
            v_limit,
            start_after,
            '',
            v_sort_ord
        ) l;
    ELSE
        -- Use aggregation approach for timestamp sorting
        -- Not efficient for large datasets but supports correct pagination
        RETURN QUERY SELECT * FROM storage.search_by_timestamp(
            prefix, bucket_name, v_limit, levels, start_after,
            v_sort_ord, v_sort_col, sort_column_after
        );
    END IF;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: -
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: custom_oauth_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.custom_oauth_providers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    provider_type text NOT NULL,
    identifier text NOT NULL,
    name text NOT NULL,
    client_id text NOT NULL,
    client_secret text NOT NULL,
    acceptable_client_ids text[] DEFAULT '{}'::text[] NOT NULL,
    scopes text[] DEFAULT '{}'::text[] NOT NULL,
    pkce_enabled boolean DEFAULT true NOT NULL,
    attribute_mapping jsonb DEFAULT '{}'::jsonb NOT NULL,
    authorization_params jsonb DEFAULT '{}'::jsonb NOT NULL,
    enabled boolean DEFAULT true NOT NULL,
    email_optional boolean DEFAULT false NOT NULL,
    issuer text,
    discovery_url text,
    skip_nonce_check boolean DEFAULT false NOT NULL,
    cached_discovery jsonb,
    discovery_cached_at timestamp with time zone,
    authorization_url text,
    token_url text,
    userinfo_url text,
    jwks_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT custom_oauth_providers_authorization_url_https CHECK (((authorization_url IS NULL) OR (authorization_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_authorization_url_length CHECK (((authorization_url IS NULL) OR (char_length(authorization_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_client_id_length CHECK (((char_length(client_id) >= 1) AND (char_length(client_id) <= 512))),
    CONSTRAINT custom_oauth_providers_discovery_url_length CHECK (((discovery_url IS NULL) OR (char_length(discovery_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_identifier_format CHECK ((identifier ~ '^[a-z0-9][a-z0-9:-]{0,48}[a-z0-9]$'::text)),
    CONSTRAINT custom_oauth_providers_issuer_length CHECK (((issuer IS NULL) OR ((char_length(issuer) >= 1) AND (char_length(issuer) <= 2048)))),
    CONSTRAINT custom_oauth_providers_jwks_uri_https CHECK (((jwks_uri IS NULL) OR (jwks_uri ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_jwks_uri_length CHECK (((jwks_uri IS NULL) OR (char_length(jwks_uri) <= 2048))),
    CONSTRAINT custom_oauth_providers_name_length CHECK (((char_length(name) >= 1) AND (char_length(name) <= 100))),
    CONSTRAINT custom_oauth_providers_oauth2_requires_endpoints CHECK (((provider_type <> 'oauth2'::text) OR ((authorization_url IS NOT NULL) AND (token_url IS NOT NULL) AND (userinfo_url IS NOT NULL)))),
    CONSTRAINT custom_oauth_providers_oidc_discovery_url_https CHECK (((provider_type <> 'oidc'::text) OR (discovery_url IS NULL) OR (discovery_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_issuer_https CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NULL) OR (issuer ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_oidc_requires_issuer CHECK (((provider_type <> 'oidc'::text) OR (issuer IS NOT NULL))),
    CONSTRAINT custom_oauth_providers_provider_type_check CHECK ((provider_type = ANY (ARRAY['oauth2'::text, 'oidc'::text]))),
    CONSTRAINT custom_oauth_providers_token_url_https CHECK (((token_url IS NULL) OR (token_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_token_url_length CHECK (((token_url IS NULL) OR (char_length(token_url) <= 2048))),
    CONSTRAINT custom_oauth_providers_userinfo_url_https CHECK (((userinfo_url IS NULL) OR (userinfo_url ~~ 'https://%'::text))),
    CONSTRAINT custom_oauth_providers_userinfo_url_length CHECK (((userinfo_url IS NULL) OR (char_length(userinfo_url) <= 2048)))
);


--
-- Name: flow_state; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.flow_state (
    id uuid NOT NULL,
    user_id uuid,
    auth_code text,
    code_challenge_method auth.code_challenge_method,
    code_challenge text,
    provider_type text NOT NULL,
    provider_access_token text,
    provider_refresh_token text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    authentication_method text NOT NULL,
    auth_code_issued_at timestamp with time zone,
    invite_token text,
    referrer text,
    oauth_client_state_id uuid,
    linking_target_id uuid,
    email_optional boolean DEFAULT false NOT NULL
);


--
-- Name: TABLE flow_state; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.flow_state IS 'Stores metadata for all OAuth/SSO login flows';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.identities (
    provider_id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED,
    id uuid DEFAULT gen_random_uuid() NOT NULL
);


--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL,
    otp_code text,
    web_authn_session_data jsonb
);


--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text,
    phone text,
    last_challenged_at timestamp with time zone,
    web_authn_credential jsonb,
    web_authn_aaguid uuid,
    last_webauthn_challenge_data jsonb
);


--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: COLUMN mfa_factors.last_webauthn_challenge_data; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.mfa_factors.last_webauthn_challenge_data IS 'Stores the latest WebAuthn challenge data including attestation/assertion for customer verification';


--
-- Name: oauth_authorizations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_authorizations (
    id uuid NOT NULL,
    authorization_id text NOT NULL,
    client_id uuid NOT NULL,
    user_id uuid,
    redirect_uri text NOT NULL,
    scope text NOT NULL,
    state text,
    resource text,
    code_challenge text,
    code_challenge_method auth.code_challenge_method,
    response_type auth.oauth_response_type DEFAULT 'code'::auth.oauth_response_type NOT NULL,
    status auth.oauth_authorization_status DEFAULT 'pending'::auth.oauth_authorization_status NOT NULL,
    authorization_code text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone DEFAULT (now() + '00:03:00'::interval) NOT NULL,
    approved_at timestamp with time zone,
    nonce text,
    CONSTRAINT oauth_authorizations_authorization_code_length CHECK ((char_length(authorization_code) <= 255)),
    CONSTRAINT oauth_authorizations_code_challenge_length CHECK ((char_length(code_challenge) <= 128)),
    CONSTRAINT oauth_authorizations_expires_at_future CHECK ((expires_at > created_at)),
    CONSTRAINT oauth_authorizations_nonce_length CHECK ((char_length(nonce) <= 255)),
    CONSTRAINT oauth_authorizations_redirect_uri_length CHECK ((char_length(redirect_uri) <= 2048)),
    CONSTRAINT oauth_authorizations_resource_length CHECK ((char_length(resource) <= 2048)),
    CONSTRAINT oauth_authorizations_scope_length CHECK ((char_length(scope) <= 4096)),
    CONSTRAINT oauth_authorizations_state_length CHECK ((char_length(state) <= 4096))
);


--
-- Name: oauth_client_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_client_states (
    id uuid NOT NULL,
    provider_type text NOT NULL,
    code_verifier text,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: TABLE oauth_client_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.oauth_client_states IS 'Stores OAuth states for third-party provider authentication flows where Supabase acts as the OAuth client.';


--
-- Name: oauth_clients; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_clients (
    id uuid NOT NULL,
    client_secret_hash text,
    registration_type auth.oauth_registration_type NOT NULL,
    redirect_uris text NOT NULL,
    grant_types text NOT NULL,
    client_name text,
    client_uri text,
    logo_uri text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    deleted_at timestamp with time zone,
    client_type auth.oauth_client_type DEFAULT 'confidential'::auth.oauth_client_type NOT NULL,
    token_endpoint_auth_method text NOT NULL,
    CONSTRAINT oauth_clients_client_name_length CHECK ((char_length(client_name) <= 1024)),
    CONSTRAINT oauth_clients_client_uri_length CHECK ((char_length(client_uri) <= 2048)),
    CONSTRAINT oauth_clients_logo_uri_length CHECK ((char_length(logo_uri) <= 2048)),
    CONSTRAINT oauth_clients_token_endpoint_auth_method_check CHECK ((token_endpoint_auth_method = ANY (ARRAY['client_secret_basic'::text, 'client_secret_post'::text, 'none'::text])))
);


--
-- Name: oauth_consents; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.oauth_consents (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    client_id uuid NOT NULL,
    scopes text NOT NULL,
    granted_at timestamp with time zone DEFAULT now() NOT NULL,
    revoked_at timestamp with time zone,
    CONSTRAINT oauth_consents_revoked_after_granted CHECK (((revoked_at IS NULL) OR (revoked_at >= granted_at))),
    CONSTRAINT oauth_consents_scopes_length CHECK ((char_length(scopes) <= 2048)),
    CONSTRAINT oauth_consents_scopes_not_empty CHECK ((char_length(TRIM(BOTH FROM scopes)) > 0))
);


--
-- Name: one_time_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.one_time_tokens (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    token_type auth.one_time_token_type NOT NULL,
    token_hash text NOT NULL,
    relates_to text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT one_time_tokens_token_hash_check CHECK ((char_length(token_hash) > 0))
);


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: -
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: -
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    name_id_format text,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    flow_state_id uuid,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone,
    refreshed_at timestamp without time zone,
    user_agent text,
    ip inet,
    tag text,
    oauth_client_id uuid,
    refresh_token_hmac_key text,
    refresh_token_counter bigint,
    scopes text,
    CONSTRAINT sessions_scopes_length CHECK ((char_length(scopes) <= 4096))
);


--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: COLUMN sessions.refresh_token_hmac_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_hmac_key IS 'Holds a HMAC-SHA256 key used to sign refresh tokens for this session.';


--
-- Name: COLUMN sessions.refresh_token_counter; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sessions.refresh_token_counter IS 'Holds the ID (counter) of the last issued refresh token.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    disabled boolean,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    is_anonymous boolean DEFAULT false NOT NULL,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: webauthn_challenges; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.webauthn_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    challenge_type text NOT NULL,
    session_data jsonb NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    CONSTRAINT webauthn_challenges_challenge_type_check CHECK ((challenge_type = ANY (ARRAY['signup'::text, 'registration'::text, 'authentication'::text])))
);


--
-- Name: webauthn_credentials; Type: TABLE; Schema: auth; Owner: -
--

CREATE TABLE auth.webauthn_credentials (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    credential_id bytea NOT NULL,
    public_key bytea NOT NULL,
    attestation_type text DEFAULT ''::text NOT NULL,
    aaguid uuid,
    sign_count bigint DEFAULT 0 NOT NULL,
    transports jsonb DEFAULT '[]'::jsonb NOT NULL,
    backup_eligible boolean DEFAULT false NOT NULL,
    backed_up boolean DEFAULT false NOT NULL,
    friendly_name text DEFAULT ''::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    last_used_at timestamp with time zone
);


--
-- Name: ai_audit_log; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_audit_log (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    couple_id uuid,
    model text NOT NULL,
    prompt_version text NOT NULL,
    input_tokens integer,
    output_tokens integer,
    total_tokens integer,
    latency_ms integer,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: ai_insights; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ai_insights (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    couple_id uuid,
    dimension_slug text NOT NULL,
    insight_text text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: answer_options; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.answer_options (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    question_id uuid NOT NULL,
    option_value text NOT NULL,
    option_label text NOT NULL,
    option_order integer NOT NULL,
    weight jsonb DEFAULT '{}'::jsonb
);


--
-- Name: challenge_assignments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.challenge_assignments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    couple_id uuid NOT NULL,
    challenge_id uuid NOT NULL,
    started_at timestamp with time zone DEFAULT now(),
    completed_at timestamp with time zone,
    status text DEFAULT 'active'::text,
    progress jsonb DEFAULT '{}'::jsonb,
    CONSTRAINT challenge_assignments_status_check CHECK ((status = ANY (ARRAY['active'::text, 'completed'::text, 'abandoned'::text])))
);


--
-- Name: conocernos_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conocernos_answers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    daily_id uuid NOT NULL,
    user_id uuid NOT NULL,
    answer_text text NOT NULL,
    answered_at timestamp with time zone DEFAULT now()
);


--
-- Name: conocernos_daily; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conocernos_daily (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    couple_id uuid NOT NULL,
    question_id uuid NOT NULL,
    question_date date DEFAULT CURRENT_DATE NOT NULL,
    reveal_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: conocernos_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conocernos_questions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    question_text text NOT NULL,
    dimension text DEFAULT 'general'::text NOT NULL,
    tone text DEFAULT 'light'::text NOT NULL,
    author text DEFAULT 'seed'::text,
    active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT conocernos_questions_dimension_check CHECK ((dimension = ANY (ARRAY['conexion'::text, 'cuidado'::text, 'choque'::text, 'camino'::text, 'general'::text]))),
    CONSTRAINT conocernos_questions_tone_check CHECK ((tone = ANY (ARRAY['light'::text, 'reflective'::text, 'visionary'::text, 'playful'::text])))
);


--
-- Name: conocernos_reactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conocernos_reactions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    daily_id uuid NOT NULL,
    user_id uuid NOT NULL,
    target_user_id uuid NOT NULL,
    emoji text,
    comment text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT conocernos_reactions_comment_check CHECK ((char_length(comment) <= 280))
);


--
-- Name: couple_insights; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.couple_insights (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    couple_id uuid NOT NULL,
    insight_type text NOT NULL,
    dimension_slug text,
    title text NOT NULL,
    body text NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb,
    generated_by text DEFAULT 'gemini-2.5-flash'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT couple_insights_insight_type_check CHECK ((insight_type = ANY (ARRAY['comparative_summary'::text, 'dimension_insight'::text, 'action_item'::text])))
);


--
-- Name: couple_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.couple_members (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    couple_id uuid NOT NULL,
    user_id uuid NOT NULL,
    role text NOT NULL,
    joined_at timestamp with time zone DEFAULT now(),
    CONSTRAINT couple_members_role_check CHECK ((role = ANY (ARRAY['self'::text, 'partner'::text])))
);


--
-- Name: couple_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.couple_reports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    couple_id uuid NOT NULL,
    session_a_id uuid,
    session_b_id uuid,
    summary text,
    dimensions jsonb DEFAULT '[]'::jsonb,
    frictions jsonb DEFAULT '[]'::jsonb,
    strengths jsonb DEFAULT '[]'::jsonb,
    recommendations jsonb DEFAULT '[]'::jsonb,
    couple_archetype text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: couple_vectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.couple_vectors (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    couple_id uuid NOT NULL,
    dimension_slug text NOT NULL,
    mismatch_delta numeric NOT NULL,
    risk_flag boolean DEFAULT false,
    opportunity_flag boolean DEFAULT false,
    calculated_at timestamp with time zone DEFAULT now()
);


--
-- Name: couples; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.couples (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    invite_code text NOT NULL,
    status text DEFAULT 'active'::text,
    created_by uuid DEFAULT auth.uid() NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    shared_nickname text,
    nickname_consent jsonb DEFAULT '{}'::jsonb,
    reveal_time time without time zone DEFAULT '20:00:00'::time without time zone,
    CONSTRAINT couples_status_check CHECK ((status = ANY (ARRAY['active'::text, 'archived'::text, 'dissolved'::text])))
);


--
-- Name: custom_evaluation_answers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_evaluation_answers (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    evaluation_id uuid NOT NULL,
    question_id uuid NOT NULL,
    user_id uuid NOT NULL,
    answer_value jsonb NOT NULL,
    answered_at timestamp with time zone DEFAULT now()
);


--
-- Name: custom_evaluation_insights; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_evaluation_insights (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    evaluation_id uuid NOT NULL,
    ai_summary text NOT NULL,
    ai_actions jsonb,
    generated_at timestamp with time zone DEFAULT now()
);


--
-- Name: custom_evaluation_questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_evaluation_questions (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    evaluation_id uuid NOT NULL,
    question_text text NOT NULL,
    question_type text NOT NULL,
    response_scale jsonb,
    sort_order integer DEFAULT 0 NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT custom_evaluation_questions_question_type_check CHECK ((question_type = ANY (ARRAY['LIKERT-5'::text, 'LIKERT-7'::text, 'OPEN'::text, 'BOOLEAN'::text])))
);


--
-- Name: custom_evaluations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.custom_evaluations (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    couple_id uuid NOT NULL,
    created_by uuid NOT NULL,
    topic text NOT NULL,
    title text NOT NULL,
    description text,
    status text DEFAULT 'active'::text,
    gemini_prompt_version text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT custom_evaluations_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'active'::text, 'completed'::text, 'archived'::text])))
);


--
-- Name: daily_tips; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.daily_tips (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    couple_id uuid NOT NULL,
    tip_date date DEFAULT CURRENT_DATE NOT NULL,
    tip_text text NOT NULL,
    dimension text,
    generated_by text DEFAULT 'gemini-2.5-flash'::text,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: dimension_keys; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dimension_keys (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    slug text NOT NULL,
    name text NOT NULL,
    description text,
    layer text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT dimension_keys_layer_check CHECK ((layer = ANY (ARRAY['conexion'::text, 'cuidado'::text, 'choque'::text, 'camino'::text])))
);


--
-- Name: dimension_scores; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dimension_scores (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    couple_id uuid,
    dimension_id uuid NOT NULL,
    raw_score numeric,
    normalized_score numeric,
    calculated_at timestamp with time zone DEFAULT now()
);


--
-- Name: generated_assessment_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.generated_assessment_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    assessment_id uuid NOT NULL,
    item_bank_id uuid,
    category text NOT NULL,
    question_text text NOT NULL,
    question_type text NOT NULL,
    response_scale jsonb,
    sort_order integer NOT NULL,
    target_dimension text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT generated_assessment_items_category_check CHECK ((category = ANY (ARRAY['core'::text, 'insight'::text, 'adaptive'::text])))
);


--
-- Name: generated_assessments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.generated_assessments (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    couple_id uuid NOT NULL,
    title text NOT NULL,
    description text,
    gemini_prompt_version text,
    status text DEFAULT 'draft'::text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT generated_assessments_status_check CHECK ((status = ANY (ARRAY['draft'::text, 'published'::text, 'archived'::text])))
);


--
-- Name: guided_conversations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.guided_conversations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    slug text NOT NULL,
    title text NOT NULL,
    description text,
    dimension text NOT NULL,
    difficulty text DEFAULT 'medium'::text,
    duration_minutes integer DEFAULT 20,
    prompt jsonb NOT NULL,
    opening_card_id text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT guided_conversations_difficulty_check CHECK ((difficulty = ANY (ARRAY['easy'::text, 'medium'::text, 'deep'::text])))
);


--
-- Name: item_bank; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_bank (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    slug text NOT NULL,
    stage text NOT NULL,
    dimension_slug text,
    construct_slug text,
    question_text text NOT NULL,
    question_type text NOT NULL,
    response_scale jsonb,
    reverse_scored boolean DEFAULT false,
    sensitivity_level text DEFAULT 'normal'::text,
    requires_opt_in boolean DEFAULT false,
    scoring_strategy text DEFAULT 'direct'::text,
    sort_order integer DEFAULT 0 NOT NULL,
    active boolean DEFAULT true,
    version text DEFAULT '1.0'::text,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT item_bank_question_type_check CHECK ((question_type = ANY (ARRAY['LIKERT-5'::text, 'LIKERT-7'::text, 'SCENARIO'::text, 'RANK'::text, 'OPEN'::text, 'FC'::text, 'ESCENARIO'::text, 'SEMAFORO'::text, 'ABIERTA'::text, 'SLIDER'::text]))),
    CONSTRAINT item_bank_sensitivity_level_check CHECK ((sensitivity_level = ANY (ARRAY['normal'::text, 'high'::text, 'opt-in'::text]))),
    CONSTRAINT item_bank_stage_check CHECK ((stage = ANY (ARRAY['onboarding'::text, 'core'::text, 'adaptive'::text, 'deep_dive'::text])))
);


--
-- Name: item_dimensions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.item_dimensions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    item_id uuid NOT NULL,
    dimension_slug text NOT NULL,
    weight numeric(4,3) DEFAULT 1.000,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: milestones; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.milestones (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    couple_id uuid NOT NULL,
    title text NOT NULL,
    milestone_type text NOT NULL,
    date date NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT milestones_milestone_type_check CHECK ((milestone_type = ANY (ARRAY['anniversary'::text, 'achievement'::text, 'milestone'::text, 'special_date'::text])))
);


--
-- Name: nosotros_narratives; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.nosotros_narratives (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    couple_id uuid NOT NULL,
    narrative_type text NOT NULL,
    dimension_slug text,
    title text NOT NULL,
    body text NOT NULL,
    metadata jsonb DEFAULT '{}'::jsonb,
    generated_by text DEFAULT 'gemini-2.5-flash'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT nosotros_narratives_narrative_type_check CHECK ((narrative_type = ANY (ARRAY['relationship_story'::text, 'layer_summary'::text, 'growth_tip'::text])))
);


--
-- Name: onboarding_responses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.onboarding_responses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    session_id uuid NOT NULL,
    item_id text NOT NULL,
    answer_value jsonb NOT NULL,
    answered_at timestamp with time zone DEFAULT now()
);


--
-- Name: onboarding_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.onboarding_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    status text DEFAULT 'not_started'::text NOT NULL,
    current_question_index integer DEFAULT 0,
    progress_pct integer DEFAULT 0,
    responses jsonb DEFAULT '{}'::jsonb,
    started_at timestamp with time zone DEFAULT now(),
    completed_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT onboarding_sessions_status_check CHECK ((status = ANY (ARRAY['not_started'::text, 'in_progress'::text, 'completed'::text])))
);


--
-- Name: personal_reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.personal_reports (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    session_id uuid,
    archetype text,
    summary jsonb DEFAULT '{}'::jsonb,
    strengths jsonb DEFAULT '[]'::jsonb,
    growth_areas jsonb DEFAULT '[]'::jsonb,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: profile_vectors; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profile_vectors (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    dimension_slug text NOT NULL,
    raw_score numeric(6,2) NOT NULL,
    normalized_score numeric(6,2) NOT NULL,
    item_count integer DEFAULT 0,
    version integer DEFAULT 1,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: profiles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.profiles (
    id uuid NOT NULL,
    full_name text,
    avatar_url text,
    locale text DEFAULT 'es-MX'::text,
    timezone text DEFAULT 'America/Mexico_City'::text,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    birthdate date,
    gender text,
    bio text,
    nickname text,
    CONSTRAINT profiles_gender_check CHECK (((gender IS NULL) OR (gender = ANY (ARRAY['male'::text, 'female'::text]))))
);


--
-- Name: question_dimension_map; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.question_dimension_map (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    question_id uuid NOT NULL,
    dimension_id uuid NOT NULL,
    weight numeric DEFAULT 1.00
);


--
-- Name: questionnaire_sections; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questionnaire_sections (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    questionnaire_id uuid NOT NULL,
    slug text NOT NULL,
    name text NOT NULL,
    description text,
    sort_order integer NOT NULL,
    estimated_questions integer,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: questionnaires; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questionnaires (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    slug text NOT NULL,
    name text NOT NULL,
    description text,
    version text NOT NULL,
    is_active boolean DEFAULT true,
    estimated_duration_minutes integer,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: questions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.questions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    section_id uuid NOT NULL,
    question_number integer NOT NULL,
    question_text text NOT NULL,
    question_type text NOT NULL,
    is_sensitive boolean DEFAULT false,
    is_required boolean DEFAULT true,
    is_opt_in boolean DEFAULT false,
    metadata jsonb DEFAULT '{}'::jsonb,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT questions_question_type_check CHECK ((question_type = ANY (ARRAY['LIKERT-5'::text, 'LIKERT-7'::text, 'FC'::text, 'ESCENARIO'::text, 'RANK'::text, 'SEMAFORO'::text, 'ABIERTA'::text, 'SLIDER'::text])))
);


--
-- Name: response_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.response_sessions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    questionnaire_id uuid NOT NULL,
    section_id uuid,
    status text DEFAULT 'started'::text,
    started_at timestamp with time zone DEFAULT now(),
    completed_at timestamp with time zone,
    progress_pct integer DEFAULT 0,
    current_section text,
    current_question_index integer DEFAULT 0,
    stage text DEFAULT 'legacy'::text,
    generated_assessment_id uuid,
    CONSTRAINT response_sessions_stage_check CHECK ((stage = ANY (ARRAY['legacy'::text, 'onboarding'::text, 'couple_v2'::text, 'deep_dive'::text]))),
    CONSTRAINT response_sessions_status_check CHECK ((status = ANY (ARRAY['started'::text, 'in_progress'::text, 'completed'::text, 'abandoned'::text])))
);


--
-- Name: responses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.responses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    session_id uuid NOT NULL,
    question_id uuid NOT NULL,
    answer_value jsonb NOT NULL,
    answered_at timestamp with time zone DEFAULT now()
);


--
-- Name: weekly_challenges; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.weekly_challenges (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    slug text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    dimension text NOT NULL,
    difficulty text DEFAULT 'medium'::text,
    duration_days integer DEFAULT 7,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: weekly_plan_items; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.weekly_plan_items (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    plan_id uuid NOT NULL,
    couple_id uuid NOT NULL,
    day_of_week integer NOT NULL,
    day_label text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    dimension text NOT NULL,
    activity_type text NOT NULL,
    duration_minutes integer NOT NULL,
    difficulty text DEFAULT 'medium'::text,
    requires_both boolean DEFAULT true,
    assigned_to text,
    status text DEFAULT 'pending'::text,
    completed_at timestamp with time zone,
    notes text,
    CONSTRAINT weekly_plan_items_activity_type_check CHECK ((activity_type = ANY (ARRAY['conversacion'::text, 'ritual'::text, 'reto'::text, 'reflexion'::text, 'microaccion'::text, 'check_in'::text]))),
    CONSTRAINT weekly_plan_items_day_of_week_check CHECK (((day_of_week >= 1) AND (day_of_week <= 7))),
    CONSTRAINT weekly_plan_items_difficulty_check CHECK ((difficulty = ANY (ARRAY['easy'::text, 'medium'::text, 'deep'::text]))),
    CONSTRAINT weekly_plan_items_status_check CHECK ((status = ANY (ARRAY['pending'::text, 'completed'::text, 'skipped'::text])))
);


--
-- Name: weekly_plans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.weekly_plans (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    couple_id uuid NOT NULL,
    week_start date NOT NULL,
    week_end date NOT NULL,
    generated_at timestamp with time zone DEFAULT now(),
    couple_status_snapshot jsonb NOT NULL,
    plan jsonb NOT NULL,
    status text DEFAULT 'active'::text,
    completion_rate numeric DEFAULT 0,
    couple_feedback jsonb,
    ai_model_used text NOT NULL,
    prompt_version text NOT NULL,
    CONSTRAINT weekly_plans_status_check CHECK ((status = ANY (ARRAY['active'::text, 'completed'::text, 'skipped'::text, 'archived'::text])))
);


--
-- Name: messages; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.messages (
    topic text NOT NULL,
    extension text NOT NULL,
    payload jsonb,
    event text,
    private boolean DEFAULT false,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    inserted_at timestamp without time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL
)
PARTITION BY RANGE (inserted_at);


--
-- Name: schema_migrations; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


--
-- Name: subscription; Type: TABLE; Schema: realtime; Owner: -
--

CREATE TABLE realtime.subscription (
    id bigint NOT NULL,
    subscription_id uuid NOT NULL,
    entity regclass NOT NULL,
    filters realtime.user_defined_filter[] DEFAULT '{}'::realtime.user_defined_filter[] NOT NULL,
    claims jsonb NOT NULL,
    claims_role regrole GENERATED ALWAYS AS (realtime.to_regrole((claims ->> 'role'::text))) STORED NOT NULL,
    created_at timestamp without time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    action_filter text DEFAULT '*'::text,
    CONSTRAINT subscription_action_filter_check CHECK ((action_filter = ANY (ARRAY['*'::text, 'INSERT'::text, 'UPDATE'::text, 'DELETE'::text])))
);


--
-- Name: subscription_id_seq; Type: SEQUENCE; Schema: realtime; Owner: -
--

ALTER TABLE realtime.subscription ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME realtime.subscription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false,
    avif_autodetection boolean DEFAULT false,
    file_size_limit bigint,
    allowed_mime_types text[],
    owner_id text,
    type storage.buckettype DEFAULT 'STANDARD'::storage.buckettype NOT NULL
);


--
-- Name: COLUMN buckets.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.buckets.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: buckets_analytics; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_analytics (
    name text NOT NULL,
    type storage.buckettype DEFAULT 'ANALYTICS'::storage.buckettype NOT NULL,
    format text DEFAULT 'ICEBERG'::text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    deleted_at timestamp with time zone
);


--
-- Name: buckets_vectors; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.buckets_vectors (
    id text NOT NULL,
    type storage.buckettype DEFAULT 'VECTOR'::storage.buckettype NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: objects; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.objects (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED,
    version text,
    owner_id text,
    user_metadata jsonb
);


--
-- Name: COLUMN objects.owner; Type: COMMENT; Schema: storage; Owner: -
--

COMMENT ON COLUMN storage.objects.owner IS 'Field is deprecated, use owner_id instead';


--
-- Name: s3_multipart_uploads; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads (
    id text NOT NULL,
    in_progress_size bigint DEFAULT 0 NOT NULL,
    upload_signature text NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    version text NOT NULL,
    owner_id text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_metadata jsonb
);


--
-- Name: s3_multipart_uploads_parts; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.s3_multipart_uploads_parts (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    upload_id text NOT NULL,
    size bigint DEFAULT 0 NOT NULL,
    part_number integer NOT NULL,
    bucket_id text NOT NULL,
    key text NOT NULL COLLATE pg_catalog."C",
    etag text NOT NULL,
    owner_id text,
    version text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: vector_indexes; Type: TABLE; Schema: storage; Owner: -
--

CREATE TABLE storage.vector_indexes (
    id text DEFAULT gen_random_uuid() NOT NULL,
    name text NOT NULL COLLATE pg_catalog."C",
    bucket_id text NOT NULL,
    data_type text NOT NULL,
    dimension integer NOT NULL,
    distance_metric text NOT NULL,
    metadata_configuration jsonb,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
\.


--
-- Data for Name: custom_oauth_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.custom_oauth_providers (id, provider_type, identifier, name, client_id, client_secret, acceptable_client_ids, scopes, pkce_enabled, attribute_mapping, authorization_params, enabled, email_optional, issuer, discovery_url, skip_nonce_check, cached_discovery, discovery_cached_at, authorization_url, token_url, userinfo_url, jwks_uri, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: flow_state; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.flow_state (id, user_id, auth_code, code_challenge_method, code_challenge, provider_type, provider_access_token, provider_refresh_token, created_at, updated_at, authentication_method, auth_code_issued_at, invite_token, referrer, oauth_client_state_id, linking_target_id, email_optional) FROM stdin;
eebc1ad8-48a0-4853-bde1-a9754d38e60d	dd72728f-f8ee-483b-849d-7f5375ae2107	0093b82d-b5dc-4fd3-b0c8-d59335909a11	s256	rK14sfzEli5gWr2nh4NaV3mrbLHfOnoxJ-NU7ahnL0M	magiclink			2026-03-27 16:18:24.9164+00	2026-03-27 16:18:24.9164+00	magiclink	\N	\N	\N	\N	\N	f
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.identities (provider_id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at, id) FROM stdin;
0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	{"sub": "0c8670a1-b6df-46f8-a9a5-b62247c5ddc2", "email": "tsxr1ck@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-03-30 02:37:08.867911+00	2026-03-30 02:37:08.867963+00	2026-03-30 02:37:08.867963+00	c31df15c-1c7b-4eac-a57c-9a42d7c054d6
10f86299-e9f4-4731-8089-657b202866b2	10f86299-e9f4-4731-8089-657b202866b2	{"sub": "10f86299-e9f4-4731-8089-657b202866b2", "email": "acmeladt@gmail.com", "email_verified": false, "phone_verified": false}	email	2026-03-30 02:37:23.57123+00	2026-03-30 02:37:23.571281+00	2026-03-30 02:37:23.571281+00	41247717-15a2-4905-be72-58dcc1e561bb
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
3426bc5b-c92b-44f0-be6f-26e6f3e5f941	2026-03-30 03:08:53.267268+00	2026-03-30 03:08:53.267268+00	password	c3c4c848-b9f3-455e-9bf6-1f8381477369
74fcfa86-0911-49f3-a39d-5f5d646f73cb	2026-03-30 05:25:44.379313+00	2026-03-30 05:25:44.379313+00	password	8999aec3-c30a-4338-8114-4837eb99139a
43b233db-b127-4ed7-8f85-c9319cd3dc0a	2026-03-30 06:28:05.86656+00	2026-03-30 06:28:05.86656+00	password	61f62081-e278-49e8-b6ff-7b6f7077595e
007d818b-99a6-4c04-b4a4-71e23ac76b53	2026-03-31 04:13:12.613772+00	2026-03-31 04:13:12.613772+00	password	2c35613a-a49f-4073-aced-0a6da27848c3
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address, otp_code, web_authn_session_data) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret, phone, last_challenged_at, web_authn_credential, web_authn_aaguid, last_webauthn_challenge_data) FROM stdin;
\.


--
-- Data for Name: oauth_authorizations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_authorizations (id, authorization_id, client_id, user_id, redirect_uri, scope, state, resource, code_challenge, code_challenge_method, response_type, status, authorization_code, created_at, expires_at, approved_at, nonce) FROM stdin;
\.


--
-- Data for Name: oauth_client_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_client_states (id, provider_type, code_verifier, created_at) FROM stdin;
\.


--
-- Data for Name: oauth_clients; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_clients (id, client_secret_hash, registration_type, redirect_uris, grant_types, client_name, client_uri, logo_uri, created_at, updated_at, deleted_at, client_type, token_endpoint_auth_method) FROM stdin;
\.


--
-- Data for Name: oauth_consents; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.oauth_consents (id, user_id, client_id, scopes, granted_at, revoked_at) FROM stdin;
\.


--
-- Data for Name: one_time_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.one_time_tokens (id, user_id, token_type, token_hash, relates_to, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	48	y7tysg6jnlax	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	t	2026-03-30 05:25:44.343148+00	2026-03-30 06:28:19.066843+00	\N	74fcfa86-0911-49f3-a39d-5f5d646f73cb
00000000-0000-0000-0000-000000000000	50	tmzpq5qub2xx	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	t	2026-03-30 06:28:19.071794+00	2026-03-30 07:26:49.30011+00	y7tysg6jnlax	74fcfa86-0911-49f3-a39d-5f5d646f73cb
00000000-0000-0000-0000-000000000000	49	j2pd44wt34ey	10f86299-e9f4-4731-8089-657b202866b2	t	2026-03-30 06:28:05.844553+00	2026-03-30 07:28:08.500519+00	\N	43b233db-b127-4ed7-8f85-c9319cd3dc0a
00000000-0000-0000-0000-000000000000	52	wqg2ei2tyltv	10f86299-e9f4-4731-8089-657b202866b2	f	2026-03-30 07:28:08.515195+00	2026-03-30 07:28:08.515195+00	j2pd44wt34ey	43b233db-b127-4ed7-8f85-c9319cd3dc0a
00000000-0000-0000-0000-000000000000	51	h4zoegzhf4qe	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	t	2026-03-30 07:26:49.32562+00	2026-03-30 10:06:22.589586+00	tmzpq5qub2xx	74fcfa86-0911-49f3-a39d-5f5d646f73cb
00000000-0000-0000-0000-000000000000	53	cbxf7ainpe4t	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	t	2026-03-30 10:06:22.610622+00	2026-03-31 02:35:10.875686+00	h4zoegzhf4qe	74fcfa86-0911-49f3-a39d-5f5d646f73cb
00000000-0000-0000-0000-000000000000	54	jr7ruhkqzebk	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	t	2026-03-31 02:35:10.89542+00	2026-03-31 03:49:41.451656+00	cbxf7ainpe4t	74fcfa86-0911-49f3-a39d-5f5d646f73cb
00000000-0000-0000-0000-000000000000	55	gda7z77zzjh5	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	f	2026-03-31 03:49:41.474496+00	2026-03-31 03:49:41.474496+00	jr7ruhkqzebk	74fcfa86-0911-49f3-a39d-5f5d646f73cb
00000000-0000-0000-0000-000000000000	47	ok3avfe53qpn	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	t	2026-03-30 03:08:53.249764+00	2026-03-31 04:03:15.838323+00	\N	3426bc5b-c92b-44f0-be6f-26e6f3e5f941
00000000-0000-0000-0000-000000000000	56	hkbiaj4s473e	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	f	2026-03-31 04:03:15.856211+00	2026-03-31 04:03:15.856211+00	ok3avfe53qpn	3426bc5b-c92b-44f0-be6f-26e6f3e5f941
00000000-0000-0000-0000-000000000000	57	d5cdc63wivo7	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	f	2026-03-31 04:13:12.500459+00	2026-03-31 04:13:12.500459+00	\N	007d818b-99a6-4c04-b4a4-71e23ac76b53
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at, name_id_format) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, created_at, updated_at, flow_state_id) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
20230322519590
20230402418590
20230411005111
20230508135423
20230523124323
20230818113222
20230914180801
20231027141322
20231114161723
20231117164230
20240115144230
20240214120130
20240306115329
20240314092811
20240427152123
20240612123726
20240729123726
20240802193726
20240806073726
20241009103726
20250717082212
20250731150234
20250804100000
20250901200500
20250903112500
20250904133000
20250925093508
20251007112900
20251104100000
20251111201300
20251201000000
20260115000000
20260121000000
20260219120000
20260302000000
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after, refreshed_at, user_agent, ip, tag, oauth_client_id, refresh_token_hmac_key, refresh_token_counter, scopes) FROM stdin;
43b233db-b127-4ed7-8f85-c9319cd3dc0a	10f86299-e9f4-4731-8089-657b202866b2	2026-03-30 06:28:05.820475+00	2026-03-30 07:28:08.52611+00	\N	aal1	\N	2026-03-30 07:28:08.52601	Mozilla/5.0 (iPhone; CPU iPhone OS 18_7 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/26.2 Mobile/15E148 Safari/604.1	177.245.100.81	\N	\N	\N	\N	\N
74fcfa86-0911-49f3-a39d-5f5d646f73cb	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	2026-03-30 05:25:44.314419+00	2026-03-31 03:49:41.493578+00	\N	aal1	\N	2026-03-31 03:49:41.493478	Next.js Middleware	74.208.127.10	\N	\N	\N	\N	\N
3426bc5b-c92b-44f0-be6f-26e6f3e5f941	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	2026-03-30 03:08:53.236959+00	2026-03-31 04:03:16.132191+00	\N	aal1	\N	2026-03-31 04:03:16.132087	Next.js Middleware	74.208.127.10	\N	\N	\N	\N	\N
007d818b-99a6-4c04-b4a4-71e23ac76b53	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	2026-03-31 04:13:12.256923+00	2026-03-31 04:13:12.256923+00	\N	aal1	\N	\N	Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/146.0.0.0 Safari/537.36	177.245.97.174	\N	\N	\N	\N	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at, disabled) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at, is_anonymous) FROM stdin;
00000000-0000-0000-0000-000000000000	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	authenticated	authenticated	tsxr1ck@gmail.com	$2a$10$Ni62Il11bODQQgpDYM1EdeVOGNIv9YRkaHd.QHFvppQm0DRX5h886	2026-03-30 02:37:08.871485+00	\N		\N		\N			\N	2026-03-31 04:13:12.256789+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-03-30 02:37:08.856482+00	2026-03-31 04:13:12.586132+00	\N	\N			\N		0	\N		\N	f	\N	f
00000000-0000-0000-0000-000000000000	10f86299-e9f4-4731-8089-657b202866b2	authenticated	authenticated	acmeladt@gmail.com	$2a$10$ljLMXa/Lg9gYMw7Whoq0Ze2OMqgGPR8E4OlVZDUxjX.WQyEMrWik.	2026-03-30 02:37:23.573458+00	\N		\N		\N			\N	2026-03-30 06:28:05.82003+00	{"provider": "email", "providers": ["email"]}	{"email_verified": true}	\N	2026-03-30 02:37:23.568476+00	2026-03-30 07:28:08.522396+00	\N	\N			\N		0	\N		\N	f	\N	f
\.


--
-- Data for Name: webauthn_challenges; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.webauthn_challenges (id, user_id, challenge_type, session_data, created_at, expires_at) FROM stdin;
\.


--
-- Data for Name: webauthn_credentials; Type: TABLE DATA; Schema: auth; Owner: -
--

COPY auth.webauthn_credentials (id, user_id, credential_id, public_key, attestation_type, aaguid, sign_count, transports, backup_eligible, backed_up, friendly_name, created_at, updated_at, last_used_at) FROM stdin;
\.


--
-- Data for Name: ai_audit_log; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ai_audit_log (id, couple_id, model, prompt_version, input_tokens, output_tokens, total_tokens, latency_ms, created_at) FROM stdin;
\.


--
-- Data for Name: ai_insights; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.ai_insights (id, user_id, couple_id, dimension_slug, insight_text, created_at, updated_at) FROM stdin;
758ad18b-b6db-4e78-9495-81f02b8abddd	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	\N	_profile_coaching	Ricardo, es genial ver cómo tu compromiso con la consistencia y tu clara visión de futuro nutren profundamente tus relaciones. Con esa base sólida, te invito a explorar cómo tu estilo de conflicto puede ser una poderosa oportunidad para profundizar aún más la conexión. Imagina cómo al navegar las diferencias de forma más consciente, puedes fortalecer la seguridad y el afecto que tanto valoras. Hoy mismo, elige una pequeña situación de desacuerdo reciente y reflexiona: ¿qué sentiste y qué necesitabas comunicar en ese momento?	2026-03-30 07:07:08.382928+00	2026-03-30 07:07:08.382928+00
84779f10-beae-44b6-ac19-48b40b9c9d15	10f86299-e9f4-4731-8089-657b202866b2	\N	_profile_coaching	¡Hola, Melanie! Qué padre ver cómo tu fortaleza en rituales y consistencia te permite construir una base súper sólida en tus relaciones. Al mismo tiempo, tu expresión emocional es un área de curiosidad que podemos explorar para que te sientas aún más conectada. Imagina qué poderoso sería si pudieras compartir tus sentimientos más abiertamente, permitiendo una intimidad más profunda. Para empezar hoy, intenta nombrar una emoción que sientas en voz alta para ti misma, sin juzgarla.	2026-03-30 07:07:33.878339+00	2026-03-30 07:07:33.878339+00
29592564-ccde-407f-916d-84deaffe4067	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	b0f53c25-5fae-445c-8261-e06d1716b4d3	_summary	Ricardo, es claro que has puesto mucho corazón y esfuerzo en tu relación, y eso se refleja en lo bien que se sienten en varias áreas. Hoy vamos a explorar juntos cómo puedes seguir fortaleciendo esos puntos positivos y también encontrar nuevas avenidas para crecer, siempre desde tu propia trinchera.	2026-03-31 02:35:43.628944+00	2026-03-31 02:35:43.628944+00
54aead03-fc36-4e50-b87f-a547c428ea6a	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	b0f53c25-5fae-445c-8261-e06d1716b4d3	conexion	Tu conexión emocional es un pilar sólido, y es un regalo que ambos valoran. Sigue buscando maneras de nutrir esa intimidad, quizá compartiendo más tus emociones profundas o tus sueños más íntimos.	2026-03-31 02:35:43.628944+00	2026-03-31 02:35:43.628944+00
06c033c2-0925-4318-a15e-d579dbe0f04f	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	b0f53c25-5fae-445c-8261-e06d1716b4d3	cuidado	El cuidado mutuo es una de tus grandes fortalezas, lo cual habla muy bien de cómo se apoyan. Continúa siendo proactivo en mostrar tu aprecio y en ofrecer tu apoyo de formas que sabes que tu pareja valora genuinamente.	2026-03-31 02:35:43.628944+00	2026-03-31 02:35:43.628944+00
a87f2abb-fcb0-4fd6-b7ef-02213d0a50d6	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	b0f53c25-5fae-445c-8261-e06d1716b4d3	choque	En el manejo de conflictos, existe una valiosa oportunidad para que desarrolles aún más tus herramientas. Intenta abordar los desacuerdos con una curiosidad genuina por la perspectiva de tu pareja, buscando entender antes de buscar soluciones.	2026-03-31 02:35:43.628944+00	2026-03-31 02:35:43.628944+00
3429a49a-cbaf-4f30-8124-56ad7e2e6f95	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	b0f53c25-5fae-445c-8261-e06d1716b4d3	camino	Tu visión para el futuro es un gran motor en la relación, y es hermoso que pienses en ello. Parece haber espacio para que te alinees aún más con tu pareja en esa visión compartida, asegurándote de que ambos se sientan plenamente parte de ese proyecto de vida.	2026-03-31 02:35:43.628944+00	2026-03-31 02:35:43.628944+00
0a888154-6c9e-425f-9493-e46a737e1c19	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	b0f53c25-5fae-445c-8261-e06d1716b4d3	_practice	Esta semana, elige un momento para escuchar atentamente a tu pareja sobre un tema importante para ella, sin interrumpir ni ofrecer soluciones, solo para comprender su sentir.	2026-03-31 02:35:43.628944+00	2026-03-31 02:35:43.628944+00
791a83eb-2c71-488a-b671-24d4f75d0052	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	b0f53c25-5fae-445c-8261-e06d1716b4d3	_practice	Piensa en una acción pequeña pero significativa de cariño o apoyo que sabes que tu pareja apreciaría y hazla de forma espontánea, sin que te lo pida.	2026-03-31 02:35:43.628944+00	2026-03-31 02:35:43.628944+00
5e84ea53-4cb1-4cc5-a9ce-4753d983e31a	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	b0f53c25-5fae-445c-8261-e06d1716b4d3	_practice	Dedica unos minutos a reflexionar sobre un logro o un momento feliz que hayan compartido recientemente y anota qué fue lo que más disfrutaste de esa experiencia juntos.	2026-03-31 02:35:43.628944+00	2026-03-31 02:35:43.628944+00
\.


--
-- Data for Name: answer_options; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.answer_options (id, question_id, option_value, option_label, option_order, weight) FROM stdin;
\.


--
-- Data for Name: challenge_assignments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.challenge_assignments (id, couple_id, challenge_id, started_at, completed_at, status, progress) FROM stdin;
\.


--
-- Data for Name: conocernos_answers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.conocernos_answers (id, daily_id, user_id, answer_text, answered_at) FROM stdin;
\.


--
-- Data for Name: conocernos_daily; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.conocernos_daily (id, couple_id, question_id, question_date, reveal_at, created_at) FROM stdin;
063e8ae8-8211-442b-9f86-4c2a3899e853	b0f53c25-5fae-445c-8261-e06d1716b4d3	d209af3d-49c1-403c-a330-d8e55fa02622	2026-03-31	2026-04-01 03:00:00+00	2026-03-31 04:57:14.840485+00
\.


--
-- Data for Name: conocernos_questions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.conocernos_questions (id, question_text, dimension, tone, author, active, created_at) FROM stdin;
d209af3d-49c1-403c-a330-d8e55fa02622	¿Cuál sería tu cena perfecta esta noche?	general	light	seed	t	2026-03-31 04:52:38.768812+00
b66f3857-0ca3-4202-b650-f9f3473c640a	¿Qué canción te describe esta semana?	general	light	seed	t	2026-03-31 04:52:38.768812+00
7751ab88-87ce-409f-979b-e0c313a84dec	¿Qué harías si tuvieras un día completamente para ti?	general	light	seed	t	2026-03-31 04:52:38.768812+00
81b9b6d0-2082-4bcf-b456-2643d1d0d4da	¿Cuál es tu lugar favorito en el mundo hasta ahora?	general	light	seed	t	2026-03-31 04:52:38.768812+00
e26d377c-6c82-4781-9fe1-8f7d22832f63	¿Qué película podrías ver en bucle sin cansarte?	general	light	seed	t	2026-03-31 04:52:38.768812+00
3af97704-75f3-4641-bdbc-64601a0c9ce2	¿Cuál es tu comfort food favorito?	general	light	seed	t	2026-03-31 04:52:38.768812+00
6f58868f-265f-4017-932c-3f5093475834	¿Qué haces cuando no puedes dormir?	general	light	seed	t	2026-03-31 04:52:38.768812+00
05abc040-296e-4b71-b91d-6d58bbca8af8	¿Cuál es tu forma favorita de perder el tiempo?	general	light	seed	t	2026-03-31 04:52:38.768812+00
5525911f-90fd-4ac9-978b-f65a2efc596b	¿Qué serie o película has visto más veces?	general	light	seed	t	2026-03-31 04:52:38.768812+00
101a71bf-845b-496c-81a7-c14893fb2069	¿Cuál es tu snack favorito para cine?	general	light	seed	t	2026-03-31 04:52:38.768812+00
0d64c686-4fab-49ec-b56e-587de35c0adf	¿Qué harías si ganaras la lotería mañana?	general	light	seed	t	2026-03-31 04:52:38.768812+00
3de333f8-a2db-4f1c-ad7e-a4b4b0a87e99	¿Cuál es tu desayuno perfecto?	general	light	seed	t	2026-03-31 04:52:38.768812+00
9d4a3341-3eb1-4965-ae3f-f8431f9611fb	¿Cuál es tu momento favorito de nosotros?	conexion	light	seed	t	2026-03-31 04:52:38.768812+00
f26fe45f-01ae-4182-b349-f775d80205b5	¿Qué cosa pequeña de mí te hace sonreír?	conexion	light	seed	t	2026-03-31 04:52:38.768812+00
5c05cf5c-871b-47d4-97a7-2e0733a1cdea	¿Cuál es tu recuerdo nosso más funny?	conexion	light	seed	t	2026-03-31 04:52:38.768812+00
3db5089e-0cb4-498b-8998-faa667578fcf	¿Qué nos diferencia que te gusta?	conexion	light	seed	t	2026-03-31 04:52:38.768812+00
53ba022e-b433-44a4-a9e2-f8bffcf9d320	¿Cuál ha sido nuestra mejor aventura juntos?	conexion	light	seed	t	2026-03-31 04:52:38.768812+00
d2196408-aedf-4d7e-9fbf-9cf360757304	¿Cómo te gusta que te cuiden cuando estás enfermo?	cuidado	light	seed	t	2026-03-31 04:52:38.768812+00
e9e3046b-db82-4ba6-b7b9-d6ebe24deba9	¿Qué pequeño gesto de mi parte te hace sentir amado/a?	cuidado	light	seed	t	2026-03-31 04:52:38.768812+00
fec51312-5d26-4d58-a70a-277841a0e3ca	¿Cuál es tu lengua de amor favorita recibir?	cuidado	light	seed	t	2026-03-31 04:52:38.768812+00
18c8d80c-5f95-4343-832b-865e6fe160fc	¿Qué te hace sentir más seguro/a de nuestra relación?	cuidado	light	seed	t	2026-03-31 04:52:38.768812+00
708ea4b8-c518-4da8-a8bd-18ff225b2fda	¿Qué cosa hago por ti que más valoras?	cuidado	light	seed	t	2026-03-31 04:52:38.768812+00
78689ba1-ca12-4dd9-815a-fcf25eaf3b9a	¿A dónde te gustaría ir de viaje juntos?	camino	light	seed	t	2026-03-31 04:52:38.768812+00
0ed2eecd-715a-49c0-a448-355c344d5632	¿Qué meta quieres alcanzar este año?	camino	light	seed	t	2026-03-31 04:52:38.768812+00
4cf7854b-5ead-4125-aa3a-29d84534b302	¿Cómo te imaginas dentro de 5 años?	camino	light	seed	t	2026-03-31 04:52:38.768812+00
c73cbed9-b5d5-4fb2-81ca-de2be0bb649b	¿Cuál es tu plan perfecto de fin de semana?	camino	light	seed	t	2026-03-31 04:52:38.768812+00
bc32625b-bfc1-4988-b165-7cec09a181c2	¿Qué quieres aprender este año?	camino	light	seed	t	2026-03-31 04:52:38.768812+00
2d45286b-f594-4537-8ed8-10c6e774384e	¿Qué momento de esta semana no quisieras olvidar?	conexion	reflective	seed	t	2026-03-31 04:52:38.768812+00
c4e56c05-cc0b-41fa-9ebb-205b26e6cb7e	¿Qué es algo que te cuesta trabajo pedir, aunque lo necesitas?	conexion	reflective	seed	t	2026-03-31 04:52:38.768812+00
3a268405-1df1-445d-a73c-95f00d90cdbf	¿Qué te hace sentir más visto/a?	conexion	reflective	seed	t	2026-03-31 04:52:38.768812+00
9f574d89-f9fe-4837-aab9-23b8c8608698	¿Qué momento de nuestra historia te ha sorprendido?	conexion	reflective	seed	t	2026-03-31 04:52:38.768812+00
0c770e77-0fc6-4824-bd6f-2c4cbc647469	¿Cómo describirías nuestra conexión en una palabra?	conexion	reflective	seed	t	2026-03-31 04:52:38.768812+00
fd53da02-8478-4e1d-ba9f-17e2e86f38eb	¿Cuándo fue la última vez que te sentiste realmente cuidado/a por mí?	cuidado	reflective	seed	t	2026-03-31 04:52:38.768812+00
9c9b1bfc-488b-4c0c-8bdd-67ca33b0c5d1	¿Qué necesidad tienes que no siempre expresas?	cuidado	reflective	seed	t	2026-03-31 04:52:38.768812+00
26c51b70-c95c-43de-9052-599f7d873f0a	¿Qué te hace sentir que te entiendo?	cuidado	reflective	seed	t	2026-03-31 04:52:38.768812+00
52de7327-3388-4d4e-a115-820b3474770e	¿Cómo ha cambiado tu forma de recibir amor con el tiempo?	cuidado	reflective	seed	t	2026-03-31 04:52:38.768812+00
e091d5df-788d-4e53-802e-fcf2a422fdce	¿Qué es lo que más valoras de cómo nos cuidamos mutuamente?	cuidado	reflective	seed	t	2026-03-31 04:52:38.768812+00
d5f43d0b-98a7-49ce-b992-f76ff9599bf8	¿Hay algo que te frustra de cómo manejamos los conflictos?	choque	reflective	seed	t	2026-03-31 04:52:38.768812+00
2da60347-2973-43d4-8c8b-416b94c067c2	¿Qué harías diferente si pudieras manejar una discusión pasada?	choque	reflective	seed	t	2026-03-31 04:52:38.768812+00
84c8f1ed-9576-4a37-88f3-f0083f7990e9	¿Cómo te sientes después de una discusión conmigo?	choque	reflective	seed	t	2026-03-31 04:52:38.768812+00
b08e8424-b610-4d46-8e35-e279578c83d8	¿Qué tema es más difícil para ti abordar?	choque	reflective	seed	t	2026-03-31 04:52:38.768812+00
b035b8da-fdd3-4ede-afd7-1ec5d1f463b9	¿Qué necesitas cuando estamos en desacuerdo?	choque	reflective	seed	t	2026-03-31 04:52:38.768812+00
2601df7b-7ff5-4e55-bf76-282ddbeb4b31	¿Qué te preocupa del futuro de nosotros?	camino	reflective	seed	t	2026-03-31 04:52:38.768812+00
29e1e1bd-ef74-4c4b-bf86-3574b9904ff8	¿Cómo te sientes respecto a nuestras metas compartidas?	camino	reflective	seed	t	2026-03-31 04:52:38.768812+00
3e39c6e1-fc5a-4f73-981d-152ce64c0554	¿Qué cambio pequeño harías en nuestra vida diaria?	camino	reflective	seed	t	2026-03-31 04:52:38.768812+00
274f6868-f7df-45db-9b46-38c4cc63b715	¿Hay algo que quieras construir conmigo que aún no hemos hablado?	camino	reflective	seed	t	2026-03-31 04:52:38.768812+00
f2f526ff-0a0b-493e-a87b-775624918e68	¿Qué te da más miedo del futuro?	camino	reflective	seed	t	2026-03-31 04:52:38.768812+00
220df5a5-40ec-46f9-a728-2dc3402c0a6e	¿Cómo te imaginas nuestra relación en 10 años?	conexion	visionary	seed	t	2026-03-31 04:52:38.768812+00
0e045b04-bd12-48d5-94ed-e27fc71ba53d	¿Qué nuevo nivel de intimidad quieres alcanzar?	conexion	visionary	seed	t	2026-03-31 04:52:38.768812+00
c8bdf6b6-6069-4c2d-b4a8-9ab2d86a0b9a	¿Cómo quieres que sea nuestra dinámica de pareja cuando seamos viejos?	conexion	visionary	seed	t	2026-03-31 04:52:38.768812+00
bded62b6-f244-4d12-9d21-54429577c61e	¿Qué aspecto de nuestra conexión quieres profundizar?	conexion	visionary	seed	t	2026-03-31 04:52:38.768812+00
64e1ba8d-ac51-4de3-bf32-be88b6dbcaba	¿Cómo te gustaría crecer juntos en el próximo año?	conexion	visionary	seed	t	2026-03-31 04:52:38.768812+00
2a50345a-66b1-42d4-bc36-8f54b6c18f46	¿A dónde te gustaría viajar antes de los 40?	camino	visionary	seed	t	2026-03-31 04:52:38.768812+00
5d43c92f-a16a-459b-9b68-c2666644943f	¿Cómo imaginas un martes cualquiera en 10 años?	camino	visionary	seed	t	2026-03-31 04:52:38.768812+00
d12614f3-e010-4aeb-9f5e-88b185f8219c	¿Qué proyecto personal tienes guardado en la cabeza?	camino	visionary	seed	t	2026-03-31 04:52:38.768812+00
4093864f-301b-4cbd-b05a-edffa4a1b2aa	¿Cuál es tu sueño más grande que quieres realizar conmigo?	camino	visionary	seed	t	2026-03-31 04:52:38.768812+00
4aa61dbf-e46f-42dc-8846-780ec552b24e	¿Qué lugar del mundo te gustaría visitar antes de morir?	camino	visionary	seed	t	2026-03-31 04:52:38.768812+00
c4483f9b-45bd-4bd9-b304-55bf95173478	¿Cuál sería tu superpoder ideal?	general	playful	seed	t	2026-03-31 04:52:38.768812+00
41d8cabc-e710-4a6c-b252-aa4b2963ef64	Si fueras un personaje de serie, ¿quién serías?	general	playful	seed	t	2026-03-31 04:52:38.768812+00
2bd48fcb-736d-4778-bd67-5d3db5a67b01	¿Cuál es tu orden de tacos perfecta?	general	playful	seed	t	2026-03-31 04:52:38.768812+00
6e4150ff-b17e-4ef3-b5fd-c9efb019299d	Si pudieras ser cualquier animal, ¿cuál serías?	general	playful	seed	t	2026-03-31 04:52:38.768812+00
7f245dba-d838-499e-bb43-9ee4fa039ef2	¿Cuál sería tu nombre de drag queen?	general	playful	seed	t	2026-03-31 04:52:38.768812+00
820b85f0-a410-4ac6-b7ba-e20ab2f24d65	Si fueras un food, ¿cuál serías y por qué?	general	playful	seed	t	2026-03-31 04:52:38.768812+00
415cea86-6438-4f4c-928b-4a67927dbe6a	¿Qué carrera hätte tenido si no trabajaras en lo que trabajas?	general	playful	seed	t	2026-03-31 04:52:38.768812+00
c595448a-dab9-4c38-a09f-94f858709bf6	¿Cuál es el chiste más malo que conoces y aun así te hace reír?	general	playful	seed	t	2026-03-31 04:52:38.768812+00
22ac282f-7356-4d43-a230-15a9c9b6eaea	¿Cuál sería la cancióntheme de nuestra relación?	conexion	playful	seed	t	2026-03-31 04:52:38.768812+00
0cf8e71e-d601-4896-b830-6f6d154de335	Si nosotros fuéramos una dupla de ladrones, ¿cuál sería nuestro nombre?	conexion	playful	seed	t	2026-03-31 04:52:38.768812+00
a4ccfb46-6fb5-4821-bbab-338312eec01e	¿Cómo nos llamarían en un programa de chismes?	conexion	playful	seed	t	2026-03-31 04:52:38.768812+00
\.


--
-- Data for Name: conocernos_reactions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.conocernos_reactions (id, daily_id, user_id, target_user_id, emoji, comment, created_at) FROM stdin;
\.


--
-- Data for Name: couple_insights; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.couple_insights (id, couple_id, insight_type, dimension_slug, title, body, metadata, generated_by, created_at, updated_at) FROM stdin;
42aea921-eeaf-4d3f-83d3-8feed65225f3	b0f53c25-5fae-445c-8261-e06d1716b4d3	comparative_summary	\N	Resumen Comparativo	La relación de Ricardo y Melanie muestra fortalezas significativas en la conexión emocional y en la visión de un proyecto de vida compartido, lo cual es una base muy valiosa. Sin embargo, hay un área clara de oportunidad en la gestión del conflicto, donde ambos, y especialmente Melanie, perciben que hay espacio para mejorar. Es importante abordar estas diferencias para que ambos se sientan plenamente apoyados y escuchados.	{"myScores": {"camino": 0.77, "choque": 0.54, "cuidado": 0.69, "conexion": 0.71}, "partnerScores": {"camino": 0.56, "choque": 0.4, "cuidado": 0.6, "conexion": 0.63}}	gemini-2.5-flash	2026-03-31 02:35:51.972679+00	2026-03-31 02:35:51.972679+00
6f16b5ba-32c8-406d-8eb6-8f433bb7e01a	b0f53c25-5fae-445c-8261-e06d1716b4d3	dimension_insight	conexion	Conexión Emocional	Ricardo percibe una conexión emocional ligeramente más fuerte que Melanie. Aunque ambos tienen una base sólida, es valioso explorar qué podría hacer que Melanie se sienta aún más profundamente conectada y comprendida en la relación.	{"myScore": 0.71, "partnerScore": 0.63}	gemini-2.5-flash	2026-03-31 02:35:51.972679+00	2026-03-31 02:35:51.972679+00
819adeeb-337b-4f24-9c8c-38283ad7321e	b0f53c25-5fae-445c-8261-e06d1716b4d3	dimension_insight	cuidado	Cuidado Mutuo	En el cuidado mutuo, existe una pequeña brecha donde Ricardo se siente un poco más cuidado que Melanie. Esto sugiere la oportunidad de que ambos exploren conscientemente las formas en que pueden nutrirse y apoyarse el uno al otro, asegurándose de que las necesidades de Melanie sean plenamente satisfechas.	{"myScore": 0.69, "partnerScore": 0.6}	gemini-2.5-flash	2026-03-31 02:35:51.972679+00	2026-03-31 02:35:51.972679+00
5084a286-0f7c-402a-a41e-dd0de61feecb	b0f53c25-5fae-445c-8261-e06d1716b4d3	dimension_insight	choque	Gestión del Conflicto	La gestión del conflicto es el área con mayor disparidad y la puntuación más baja para ambos, especialmente para Melanie. Esto indica que los desacuerdos pueden ser una fuente de tensión, y hay una necesidad de desarrollar estrategias más efectivas para comunicarse y resolver diferencias de manera constructiva, donde Melanie se sienta más segura.	{"myScore": 0.54, "partnerScore": 0.4}	gemini-2.5-flash	2026-03-31 02:35:51.972679+00	2026-03-31 02:35:51.972679+00
69846fbd-355e-43ee-be71-60179c339619	b0f53c25-5fae-445c-8261-e06d1716b4d3	dimension_insight	camino	Proyecto de Vida	Ricardo se siente más alineado y comprometido con el proyecto de vida compartido que Melanie. Es importante que ambos dialoguen sobre sus aspiraciones individuales y conjuntas, asegurándose de que Melanie también se sienta plenamente integrada y entusiasmada con el camino que construyen juntos.	{"myScore": 0.77, "partnerScore": 0.56}	gemini-2.5-flash	2026-03-31 02:35:51.972679+00	2026-03-31 02:35:51.972679+00
a981a3f1-a66d-4b04-b13b-7dc7db021c67	b0f53c25-5fae-445c-8261-e06d1716b4d3	action_item	\N	Acción Sugerida	Dediquen 15 minutos al día a una 'charla de conexión' donde cada uno comparta algo que le haya pasado y cómo se sintió al respecto, sin interrupciones ni juicios, empezando por Melanie para que se sienta escuchada.	{}	gemini-2.5-flash	2026-03-31 02:35:51.972679+00	2026-03-31 02:35:51.972679+00
f77aaa24-2456-42ef-9b8d-fb47bfe238cb	b0f53c25-5fae-445c-8261-e06d1716b4d3	action_item	\N	Acción Sugerida	Elijan un tema de desacuerdo reciente y practiquen la 'escucha activa': uno habla por 5 minutos expresando su punto de vista y sus sentimientos, mientras el otro solo escucha y luego parafrasea lo que oyó, sin defenderse, y luego intercambian roles.	{}	gemini-2.5-flash	2026-03-31 02:35:51.972679+00	2026-03-31 02:35:51.972679+00
860abdae-5d7c-4dff-8c86-37a1568baa67	b0f53c25-5fae-445c-8261-e06d1716b4d3	action_item	\N	Acción Sugerida	Organicen una 'cita de sueños' donde cada uno comparta tres metas o deseos personales y tres metas o deseos de pareja para el próximo año, escribiéndolos en una hoja y conversando sobre cómo pueden apoyarse para alcanzarlos.	{}	gemini-2.5-flash	2026-03-31 02:35:51.972679+00	2026-03-31 02:35:51.972679+00
\.


--
-- Data for Name: couple_members; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.couple_members (id, couple_id, user_id, role, joined_at) FROM stdin;
001f0473-6574-44ba-9288-0079650e12ee	b0f53c25-5fae-445c-8261-e06d1716b4d3	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	self	2026-03-30 06:32:22.259356+00
706097ed-3f94-41be-bb7d-2d221fb64fc8	b0f53c25-5fae-445c-8261-e06d1716b4d3	10f86299-e9f4-4731-8089-657b202866b2	partner	2026-03-30 06:35:41.990391+00
\.


--
-- Data for Name: couple_reports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.couple_reports (id, couple_id, session_a_id, session_b_id, summary, dimensions, frictions, strengths, recommendations, couple_archetype, created_at) FROM stdin;
\.


--
-- Data for Name: couple_vectors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.couple_vectors (id, couple_id, dimension_slug, mismatch_delta, risk_flag, opportunity_flag, calculated_at) FROM stdin;
\.


--
-- Data for Name: couples; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.couples (id, invite_code, status, created_by, created_at, updated_at, shared_nickname, nickname_consent, reveal_time) FROM stdin;
b0f53c25-5fae-445c-8261-e06d1716b4d3	75D3B389	active	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	2026-03-30 06:32:22.17197+00	2026-03-30 06:32:22.17197+00	\N	{}	20:00:00
\.


--
-- Data for Name: custom_evaluation_answers; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.custom_evaluation_answers (id, evaluation_id, question_id, user_id, answer_value, answered_at) FROM stdin;
3ddcffd3-2442-4805-8067-cc6de33a0b26	27963945-f5e8-4396-b6a8-e20009dd2862	3f0f92b8-1a00-4ee3-b1a9-9a637c1eb61b	10f86299-e9f4-4731-8089-657b202866b2	5	2026-03-30 07:11:48.76406+00
fe4fd0c9-c08e-4edd-97b2-9aabbdb1de3b	27963945-f5e8-4396-b6a8-e20009dd2862	2bb34984-76cc-4c72-8a70-e2938be134ad	10f86299-e9f4-4731-8089-657b202866b2	5	2026-03-30 07:11:48.76406+00
ebebcd26-776f-496d-9a0f-0a31e17472a3	27963945-f5e8-4396-b6a8-e20009dd2862	9088a7ed-c5ce-4fdd-82a9-ab5024f59e5f	10f86299-e9f4-4731-8089-657b202866b2	5	2026-03-30 07:11:48.76406+00
f22e4743-a176-4dde-9ea9-d9bfc9baf869	27963945-f5e8-4396-b6a8-e20009dd2862	c921ea7d-af89-45a6-af2e-3a221e46ce65	10f86299-e9f4-4731-8089-657b202866b2	5	2026-03-30 07:11:48.76406+00
58c6cbf3-05c5-4952-836d-6fd408c43fbb	27963945-f5e8-4396-b6a8-e20009dd2862	6376a2f7-4cef-4626-b3fd-3703aaa63c24	10f86299-e9f4-4731-8089-657b202866b2	5	2026-03-30 07:11:48.76406+00
3fd6731a-d3ae-4091-a5c9-927015745ba1	27963945-f5e8-4396-b6a8-e20009dd2862	bc9ce4db-8598-4f11-b486-4ceba916f47b	10f86299-e9f4-4731-8089-657b202866b2	"que tenía y me brindaba todo lo que buscaba en ese momento "	2026-03-30 07:11:48.76406+00
bfd0cf09-ad49-4ea1-ba0e-ce2f0919094a	27963945-f5e8-4396-b6a8-e20009dd2862	0b439f61-2f1e-452d-8b86-7be7398f3b0a	10f86299-e9f4-4731-8089-657b202866b2	"sintonía "	2026-03-30 07:11:48.76406+00
2766ae7c-8193-4c12-b73c-67df14a4bbea	27963945-f5e8-4396-b6a8-e20009dd2862	3f0f92b8-1a00-4ee3-b1a9-9a637c1eb61b	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	5	2026-03-30 07:11:53.491188+00
4ce3de4a-87a8-45e8-b3dd-243c73055b73	27963945-f5e8-4396-b6a8-e20009dd2862	2bb34984-76cc-4c72-8a70-e2938be134ad	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	4	2026-03-30 07:11:53.491188+00
77195d98-f6bc-4378-8b50-6af5c0a07331	27963945-f5e8-4396-b6a8-e20009dd2862	9088a7ed-c5ce-4fdd-82a9-ab5024f59e5f	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	4	2026-03-30 07:11:53.491188+00
b70b16f0-a897-47c1-aa74-024b0b794657	27963945-f5e8-4396-b6a8-e20009dd2862	c921ea7d-af89-45a6-af2e-3a221e46ce65	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	5	2026-03-30 07:11:53.491188+00
d148c0f9-96ce-495c-82c3-e5ed8a0db590	27963945-f5e8-4396-b6a8-e20009dd2862	6376a2f7-4cef-4626-b3fd-3703aaa63c24	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	4	2026-03-30 07:11:53.491188+00
78f132b1-7dcb-423f-8e91-313ec7dcc332	27963945-f5e8-4396-b6a8-e20009dd2862	bc9ce4db-8598-4f11-b486-4ceba916f47b	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	"Me pareció muy hermosa, me enamoré al verla. Conectamos en un instante"	2026-03-30 07:11:53.491188+00
e3f698c3-8e9c-4b8b-88da-27bff5284cf1	27963945-f5e8-4396-b6a8-e20009dd2862	0b439f61-2f1e-452d-8b86-7be7398f3b0a	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	"Amor, fuegos artificiales"	2026-03-30 07:11:53.491188+00
f92e2d5e-5557-44ff-bbbd-dbfb7a7045b3	f46377c1-75d6-421e-a77c-6118437899b7	ef8104c5-2bde-487c-ab2e-3aabb776a357	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	5	2026-03-30 07:33:03.496132+00
79837ba4-12b7-457b-aef3-4b0294deaa5c	f46377c1-75d6-421e-a77c-6118437899b7	36f1efb0-3e49-4bb0-8270-e1f0782080b5	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	5	2026-03-30 07:33:03.496132+00
a60eed8d-91ec-4ec0-bd70-59654abc45ea	f46377c1-75d6-421e-a77c-6118437899b7	c1615073-0a4e-401d-ab58-f8fd45086bb6	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	5	2026-03-30 07:33:03.496132+00
3289ae4a-0780-4b8c-8fb3-5ca87dc215f4	f46377c1-75d6-421e-a77c-6118437899b7	67ffd6a4-55ec-4f74-bfb6-63198623b452	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	5	2026-03-30 07:33:03.496132+00
fe286e6b-4071-4dfa-a672-11897602968a	f46377c1-75d6-421e-a77c-6118437899b7	ed03a07d-61a5-4fa2-b141-59ac9a23b042	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	"Que sea algo que ambos disfrutemos y siempre pensando en ambos, que a ambos nos guste y nos dé placer mutuo"	2026-03-30 07:33:03.496132+00
65acd251-5a86-4a16-a6ba-8413f693d8f5	f46377c1-75d6-421e-a77c-6118437899b7	adcab765-1fba-43c4-8da9-61745838b902	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	"Role play jaja estaría bueno"	2026-03-30 07:33:03.496132+00
796ff75d-1656-43ab-850f-0ddc273a8062	f46377c1-75d6-421e-a77c-6118437899b7	ef8104c5-2bde-487c-ab2e-3aabb776a357	10f86299-e9f4-4731-8089-657b202866b2	5	2026-03-30 07:35:41.418964+00
8aab0d5d-492c-4e5f-beb3-dc25e848a2bb	f46377c1-75d6-421e-a77c-6118437899b7	36f1efb0-3e49-4bb0-8270-e1f0782080b5	10f86299-e9f4-4731-8089-657b202866b2	5	2026-03-30 07:35:41.418964+00
3a4b7201-b26b-4806-b635-f6770570ed05	f46377c1-75d6-421e-a77c-6118437899b7	c1615073-0a4e-401d-ab58-f8fd45086bb6	10f86299-e9f4-4731-8089-657b202866b2	5	2026-03-30 07:35:41.418964+00
7acaa132-8f42-4b09-bd80-4ada16fd5306	f46377c1-75d6-421e-a77c-6118437899b7	67ffd6a4-55ec-4f74-bfb6-63198623b452	10f86299-e9f4-4731-8089-657b202866b2	5	2026-03-30 07:35:41.418964+00
cff041fe-aa38-47ac-8314-bdb40955e502	f46377c1-75d6-421e-a77c-6118437899b7	ed03a07d-61a5-4fa2-b141-59ac9a23b042	10f86299-e9f4-4731-8089-657b202866b2	"espero que ambos lo disfrutemos y nos enfoquemos en nosotros mismos, haciéndolo algo único "	2026-03-30 07:35:41.418964+00
151c1646-c68b-410e-a0bb-b5714a9eb255	f46377c1-75d6-421e-a77c-6118437899b7	adcab765-1fba-43c4-8da9-61745838b902	10f86299-e9f4-4731-8089-657b202866b2	"que lo hagamos enojados, que lo hagamos violento y hacerlo en rol obligado, como si no quisiera aún cuando si quiero"	2026-03-30 07:35:41.418964+00
7311b214-6654-4d24-ad3d-7ad690a62348	8dc4df53-4274-4df4-8872-c56f72531ae0	46718b74-0d5f-4c59-b7b1-53eb48b3c2ea	10f86299-e9f4-4731-8089-657b202866b2	5	2026-03-30 07:47:45.18728+00
0e4f721a-e366-436e-a731-6c369d4d688b	8dc4df53-4274-4df4-8872-c56f72531ae0	b17fdd86-938c-4855-b352-dd5c68ee4b85	10f86299-e9f4-4731-8089-657b202866b2	5	2026-03-30 07:47:45.18728+00
8f05bf56-7231-4618-9d8f-696782d3efe8	8dc4df53-4274-4df4-8872-c56f72531ae0	643707b7-f01a-4469-9c88-5d85fe869391	10f86299-e9f4-4731-8089-657b202866b2	1	2026-03-30 07:47:45.18728+00
bc73bb87-5193-47b8-92f3-ccce32d4bf99	8dc4df53-4274-4df4-8872-c56f72531ae0	2b50d3c0-b5ce-4cd9-93ae-41117bb018b1	10f86299-e9f4-4731-8089-657b202866b2	5	2026-03-30 07:47:45.18728+00
ae5299db-4439-41e9-9637-f3b5cd04419f	8dc4df53-4274-4df4-8872-c56f72531ae0	36141e9a-3bd2-405b-a706-b9db229e6b9f	10f86299-e9f4-4731-8089-657b202866b2	5	2026-03-30 07:47:45.18728+00
a432fe1d-3ad0-4b57-baa4-ebaee95dde47	8dc4df53-4274-4df4-8872-c56f72531ae0	d1eacc0a-2188-4a23-9da8-b99c1e097885	10f86299-e9f4-4731-8089-657b202866b2	"mi gusto oculto si sería que él tenga el control en el acto, ósea llevar a cabo el rol violento/obligado y todo lo que conlleva a que él pueda tener el control y yo la satisfacción, pero no se lo hagas saber porque me da pena"	2026-03-30 07:47:45.18728+00
d28c4364-6138-418f-8209-287538132f2f	8dc4df53-4274-4df4-8872-c56f72531ae0	46718b74-0d5f-4c59-b7b1-53eb48b3c2ea	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	4	2026-03-30 07:50:07.384026+00
a2ebb4ab-8e01-48fd-9d3f-63426a336131	8dc4df53-4274-4df4-8872-c56f72531ae0	b17fdd86-938c-4855-b352-dd5c68ee4b85	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	4	2026-03-30 07:50:07.384026+00
c458dc3c-cb59-4f27-a01e-3b88bc6f2c24	8dc4df53-4274-4df4-8872-c56f72531ae0	643707b7-f01a-4469-9c88-5d85fe869391	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	2	2026-03-30 07:50:07.384026+00
7fdfb6e1-7ea5-4810-ad46-189a0ff79d13	8dc4df53-4274-4df4-8872-c56f72531ae0	2b50d3c0-b5ce-4cd9-93ae-41117bb018b1	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	5	2026-03-30 07:50:07.384026+00
43544109-5579-41f0-a2c0-8bf68be27d70	8dc4df53-4274-4df4-8872-c56f72531ae0	36141e9a-3bd2-405b-a706-b9db229e6b9f	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	5	2026-03-30 07:50:07.384026+00
05729b76-32b8-4ff5-95ce-334e9ec43837	8dc4df53-4274-4df4-8872-c56f72531ae0	d1eacc0a-2188-4a23-9da8-b99c1e097885	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	"Honestamente me cuesta pensar en algo porque trato de ser muy transparente con ella, pero si tuviera que elegir diría que me gusta ver porno role play y quizás es importante porque lo mencioné en el quizz anterior "	2026-03-30 07:50:07.384026+00
\.


--
-- Data for Name: custom_evaluation_insights; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.custom_evaluation_insights (id, evaluation_id, ai_summary, ai_actions, generated_at) FROM stdin;
7241379e-d881-4068-846c-6e2637804547	27963945-f5e8-4396-b6a8-e20009dd2862	Melanie y Ricardo han tenido una primera impresión extraordinariamente positiva, marcada por una profunda conexión y una curiosidad mutua palpable. Las respuestas en las escalas numéricas muestran una fuerte alineación, con ambos expresando consistentemente puntuaciones altas. Esto sugiere que ambos percibieron un potencial significativo y una química instantánea desde el primer momento, sentando una base muy prometedora para su relación.\n\nSi bien ambos compartieron una experiencia inicial muy positiva, se observan matices interesantes. Melanie percibió un nivel de comodidad, positividad y potencial de conexión en el grado más alto (5 en todas las preguntas de Likert), sintiendo que la otra persona le brindaba "todo lo que buscaba en ese momento". Por su parte, Ricardo también tuvo una impresión muy positiva (puntuaciones de 4 y 5), pero sus respuestas abiertas revelan una intensidad emocional aún más pronunciada, describiendo un "enamoramiento al verla" y capturando la esencia de la interacción como "Amor, fuegos artificiales".\n\nEsta combinación de "sintonía" por parte de Melanie y los "fuegos artificiales" de Ricardo subraya una poderosa atracción y un encuentro que superó las expectativas de ambos. La fuerte curiosidad mutua, evidenciada por sus puntuaciones de 5 en esa pregunta, indica un deseo compartido de explorar más a fondo esta conexión tan prometedora. Es un comienzo vibrante y lleno de entusiasmo que merece ser cultivado con atención.	["Tómense un momento para recordar y celebrar la magia de ese primer encuentro. Conversen sobre qué elementos específicos, gestos o palabras crearon esa \\"sintonía\\" para Melanie y esos \\"fuegos artificiales\\" para Ricardo. ¿Cómo pueden recrear o mantener esa chispa?", "Ricardo, reflexiona sobre lo que te llevó a puntuar con un 4 en comodidad y percepción positiva, en contraste con el 5 de Melanie. Compartan abiertamente si hubo algo que sintieron que podría haber sido diferente o si simplemente fue un nivel inicial de cautela. Melanie, comparte qué te hizo sentir tan plenamente tú misma.", "Dado el fuerte deseo mutuo de conocerse más a fondo, planifiquen una actividad o una conversación específica donde puedan explorar en profundidad qué significa para Melanie haber encontrado 'todo lo que buscaba' y para Ricardo esa sensación de 'enamoramiento al verla'. Esto les ayudará a construir sobre esa poderosa base."]	2026-03-30 07:12:17.39961+00
947583a1-1aeb-4bb1-87ac-8edc8a6c9844	27963945-f5e8-4396-b6a8-e20009dd2862	Melanie y Ricardo, los resultados de su micro-evaluación sobre las "Primeras Impresiones" revelan una base inicial sumamente prometedora y llena de entusiasmo. Ambos coinciden plenamente en haber sentido una conexión especial y una fuerte curiosidad por conocerse más a fondo, lo cual es un indicador fantástico de un inicio de relación vibrante y con potencial. Ricardo, tu expresión de "enamorarse al verla" y "fuegos artificiales" resuena con la "sintonía" que Melanie sintió, sugiriendo que la chispa fue mutua y poderosa.\n\nSi bien la alineación es notablemente alta, se observan algunas ligeras divergencias que son naturales y ofrecen oportunidades de crecimiento. Melanie percibió un nivel máximo de comodidad, una impresión muy positiva y un gran potencial para una conexión significativa (todas con puntuación de 5), mientras que Ricardo puntuó estas mismas áreas con un 4. Esto no indica una brecha significativa, sino más bien una sutil diferencia en la intensidad de la experiencia inicial en cuanto a comodidad y la percepción del potencial.\n\nLas respuestas abiertas complementan maravillosamente estas percepciones. Melanie encontró sorprendente haber hallado en Ricardo "todo lo que buscaba en ese momento", lo que sugiere una profunda resonancia y un sentido de plenitud. Por su parte, Ricardo se sintió inmediatamente cautivado por la belleza de Melanie y experimentó un "amor" instantáneo y una conexión inmediata, describiéndola con "fuegos artificiales". Estas descripciones, aunque distintas en su enfoque (uno en la plenitud y otro en la pasión y el impacto visual), pintan un cuadro de una primera interacción profundamente impactante para ambos.\n\nEn resumen, la primera impresión entre Melanie y Ricardo fue abrumadoramente positiva y cargada de una energía única. Existe una fuerte sintonía emocional y una curiosidad mutua que sienta una base excelente para explorar la profundidad de su conexión. Las pequeñas diferencias en la percepción de comodidad o potencial son matices que pueden ser explorados con cariño para fortalecer aún más su vínculo.	["Compartan en detalle qué significó para cada uno esa 'conexión especial' y qué aspectos de la otra persona despertaron esa 'fuerte curiosidad'. Permítanse revivir esos primeros momentos y la magia que sintieron.", "Ricardo, reflexiona sobre qué te hizo sentir un 4 en comodidad y potencial, en lugar de un 5. Comparte esto con Melanie, y Melanie, escucha con atención. Esto puede abrir una conversación sobre cómo pueden seguir construyendo un espacio de máxima autenticidad y seguridad para ambos.", "Dediquen un momento para escribir (o dibujar) qué esperan que evolucione de esa 'sintonía' o esos 'fuegos artificiales' iniciales en el futuro. Luego, compartan y discutan sus visiones, buscando puntos en común y emocionándose con el camino que tienen por delante."]	2026-03-30 07:12:17.812657+00
82c157db-60d6-4733-90e9-5afa702a0693	f46377c1-75d6-421e-a77c-6118437899b7	Ricardo y Melanie demuestran una alineación excepcional y un alto nivel de comodidad y apertura en su comunicación sexual. Las respuestas a las preguntas de escala Likert revelan que ambos se sienten muy a gusto hablando de sus deseos y límites, expresando lo que les gusta y lo que no, y consideran la sexualidad un pilar fundamental para su conexión profunda. La disposición de ambos a explorar nuevas experiencias con consentimiento mutuo es un testimonio de la solidez de su intimidad.\n\nEn cuanto a sus expectativas sobre la vida sexual, Ricardo y Melanie comparten una visión muy similar, centrada en el disfrute y el placer mutuo. Ambos desean una intimidad placentera que beneficie a los dos, con Melanie añadiendo el deseo de que sea "algo único". Esta convergencia en sus expectativas subraya una base de respeto y consideración mutua que es fundamental para construir una vida sexual satisfactoria.\n\nSin embargo, en la exploración de fantasías específicas, surge un área interesante para una conversación más profunda. Ricardo expresa interés en el "Role play" de manera general y con un tono ligero. Melanie, por su parte, detalla una fantasía más intensa y específica que involucra elementos de "violencia" y "rol obligado", donde la apariencia de no querer es parte del juego, pero con consentimiento real. Esta diferencia en la especificidad y la intensidad de las fantasías sugiere una oportunidad crucial para una discusión detallada, asegurándose de que ambos comprendan completamente y estén cómodos con los límites y las expectativas de cada uno, especialmente en el caso de la fantasía de Melanie, que requiere una comunicación muy clara sobre el consentimiento y las palabras de seguridad para garantizar una exploración segura y placentera.	["Celebren la increíble alineación y la apertura que ambos demuestran en su sexualidad. Dediquen un momento para reconocer lo valioso que es sentirse tan cómodos y en sintonía en este aspecto de su relación.", "Tengan una conversación abierta y sin juicios sobre las fantasías que surgieron, especialmente la de Melanie. Es crucial que Melanie explique en detalle lo que significa para ella 'hacerlo violento' o 'en rol obligado', y que Ricardo escuche activamente para comprender la naturaleza consensual de estas exploraciones, estableciendo juntos límites claros y palabras de seguridad si deciden explorar.", "Planifiquen una 'noche de exploración sexual' donde ambos puedan traer ideas, fantasías o deseos que les gustaría probar. Utilicen este espacio para hablar sobre cómo podrían incorporar el 'role play' de Ricardo y las fantasías de Melanie de una manera segura, consensuada y emocionante para ambos, quizás empezando con pasos pequeños y cómodos."]	2026-03-30 07:36:02.757153+00
1bdaf552-9a7c-4a2b-aa83-c5040d03517a	f46377c1-75d6-421e-a77c-6118437899b7	Ricardo y Melanie demuestran una base excepcionalmente sólida en la comunicación y conexión sexual. Ambos reportan sentirse muy cómodos hablando abiertamente sobre deseos y límites, expresando lo que les gusta y lo que no, y consideran la sexualidad un pilar fundamental para una conexión profunda. Esta alineación perfecta en todos los aspectos evaluados en la escala Likert es un testimonio de la confianza y apertura que han construido en su relación.\n\nEn cuanto a sus expectativas sobre la vida sexual, Ricardo y Melanie comparten un deseo claro de disfrute mutuo y de que la intimidad sea placentera para ambos. Ricardo enfatiza el placer mutuo, mientras que Melanie busca que sea "algo único" y enfocado en ellos mismos, complementando la visión de una sexualidad personalizada y profundamente conectada.\n\nLa exploración de fantasías revela un área emocionante y con potencial para una conexión aún más profunda. Ricardo expresa un interés en el "Role play" de manera general, lo que abre la puerta a la experimentación. Por su parte, Melanie comparte una fantasía más específica e intensa que involucra dinámicas de poder y simulación de no-consentimiento ("como si no quisiera aún cuando si quiero"). Es crucial abordar esta fantasía con la misma apertura y confianza que ya demuestran, asegurando que ambos comprendan los límites y el consentimiento explícito de cualquier escenario de juego de roles.\n\nSu excelente comunicación y mutua disposición a explorar son activos invaluables que les permitirán navegar estas discusiones con empatía y respeto. Esta etapa es una oportunidad para profundizar su intimidad al explorar juntos estas nuevas dimensiones de su sexualidad de manera segura y consensuada.	["Melanie, te animamos a compartir con Ricardo los detalles de tu fantasía de 'rol obligado', explicando qué te atrae de ella y qué emociones te gustaría explorar. Ricardo, acoge esta revelación con curiosidad y sin juicios, validando sus sentimientos y expresando tus propias reflexiones al respecto.", "Dediquen un momento juntos para reflexionar sobre las motivaciones subyacentes de sus fantasías, tanto el interés general de Ricardo en el 'Role play' como la fantasía específica de Melanie. Pregúntense: ¿Qué aspectos de nosotros o de nuestra relación buscamos explorar o expresar a través de estas experiencias?", "Antes de cualquier exploración de juego de roles, establezcan de manera conjunta y explícita los límites, las palabras de seguridad y las señales de parada. Asegúrense de que el consentimiento sea entusiasta y continuo, creando un espacio seguro donde ambos se sientan completamente cómodos para experimentar y detenerse en cualquier momento."]	2026-03-30 07:36:32.670239+00
998431d1-648d-4d1b-8539-6d1a5356c654	8dc4df53-4274-4df4-8872-c56f72531ae0	Esta micro-evaluación sobre "Nuestros Gustos Ocultos" revela una base sólida de apertura y entusiasmo mutuo para la pareja. Melanie y Ricardo muestran una fuerte alineación en su deseo de compartir y descubrir los gustos inusuales del otro, con puntuaciones perfectas en el entusiasmo por la exploración (Q4) y la disposición a probar nuevas actividades por la pasión del otro (Q5). Además, ambos expresan que no disfrutan de mantener gustos solo para sí mismos (Q3), lo que indica una predisposición a la vulnerabilidad compartida.\n\nAunque ambos se sienten cómodos compartiendo (Q1) y creen que sorprenderían (Q2), Melanie muestra una ligera mayor intensidad en estas áreas. Sin embargo, la brecha más significativa y, a la vez, la mayor oportunidad de conexión, reside en la respuesta abierta de Melanie. Ella revela un deseo íntimo muy específico relacionado con el control y el rol en el acto sexual, pero confiesa una profunda vergüenza que le impide compartirlo directamente con Ricardo.\n\nPor su parte, Ricardo se presenta como alguien muy transparente, aunque menciona su gusto por el "porno role play" como un gusto oculto. Esta revelación, junto con su apertura general, podría ser una clave para desbloquear la vulnerabilidad de Melanie. La combinación de la disposición de Ricardo a la transparencia y el deseo no expresado de Melanie crea un terreno fértil para una exploración íntima profunda, pero requiere un enfoque empático y seguro.\n\nEn resumen, la pareja tiene una excelente base de curiosidad y apertura mutua. El desafío principal es crear el ambiente de seguridad y confianza necesario para que Melanie pueda expresar su deseo más profundo sin sentir vergüenza, lo que podría enriquecer enormemente su conexión íntima.	["Ricardo, crea un espacio de seguridad emocional: Inicia una conversación cálida y sin presiones con Melanie sobre la intimidad. Puedes preguntarle qué fantasías o deseos *nunca* se ha atrevido a compartir, asegurándole que cualquier cosa es bienvenida y segura entre ustedes, y que su vulnerabilidad es un regalo.", "Melanie, considera la posibilidad de dar un pequeño paso: Reflexiona sobre tu deseo íntimo y la vergüenza que sientes. Piensa en la posibilidad de expresarlo de alguna manera, quizás no directamente al principio, sino como una fantasía abstracta o un \\"qué pasaría si\\", para empezar a explorar este terreno en un entorno seguro y de confianza con Ricardo.", "Ambos, exploren el \\"role play\\" como puente: Dado el interés de Ricardo en el \\"porno role play\\" y la naturaleza del deseo de Melanie, exploren juntos la idea del juego de roles o la fantasía. Podrían ver una película o leer un libro que explore dinámicas similares para abrir el diálogo de manera indirecta y cómoda, permitiendo que las ideas fluyan sin presión."]	2026-03-30 07:51:23.612242+00
\.


--
-- Data for Name: custom_evaluation_questions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.custom_evaluation_questions (id, evaluation_id, question_text, question_type, response_scale, sort_order, created_at) FROM stdin;
3f0f92b8-1a00-4ee3-b1a9-9a637c1eb61b	27963945-f5e8-4396-b6a8-e20009dd2862	Cuando conocí a la otra persona, sentí una conexión especial.	LIKERT-5	\N	0	2026-03-30 07:05:55.838251+00
2bb34984-76cc-4c72-8a70-e2938be134ad	27963945-f5e8-4396-b6a8-e20009dd2862	Me sentí cómodo/a y pude ser yo mismo/a en nuestra primera interacción.	LIKERT-5	\N	1	2026-03-30 07:05:55.838251+00
9088a7ed-c5ce-4fdd-82a9-ab5024f59e5f	27963945-f5e8-4396-b6a8-e20009dd2862	Mi primera impresión de la otra persona fue muy positiva.	LIKERT-5	\N	2	2026-03-30 07:05:55.838251+00
c921ea7d-af89-45a6-af2e-3a221e46ce65	27963945-f5e8-4396-b6a8-e20009dd2862	Siento una fuerte curiosidad por conocer más a fondo a la persona que conocí inicialmente.	LIKERT-5	\N	3	2026-03-30 07:05:55.838251+00
6376a2f7-4cef-4626-b3fd-3703aaa63c24	27963945-f5e8-4396-b6a8-e20009dd2862	Percibí que teníamos potencial para una conexión significativa desde el principio.	LIKERT-5	\N	4	2026-03-30 07:05:55.838251+00
bc9ce4db-8598-4f11-b486-4ceba916f47b	27963945-f5e8-4396-b6a8-e20009dd2862	¿Qué fue lo más sorprendente o inesperado de tu primera impresión de la otra persona?	OPEN	\N	5	2026-03-30 07:05:55.838251+00
0b439f61-2f1e-452d-8b86-7be7398f3b0a	27963945-f5e8-4396-b6a8-e20009dd2862	Si pudieras capturar la esencia de tu primera interacción con una palabra o una imagen, ¿cuál sería?	OPEN	\N	6	2026-03-30 07:05:55.838251+00
ef8104c5-2bde-487c-ab2e-3aabb776a357	f46377c1-75d6-421e-a77c-6118437899b7	Yo siento comodidad al hablar abiertamente sobre mis deseos y límites sexuales con mi pareja.	LIKERT-5	\N	0	2026-03-30 07:30:36.961731+00
36f1efb0-3e49-4bb0-8270-e1f0782080b5	f46377c1-75d6-421e-a77c-6118437899b7	Me es fácil expresar lo que me gusta y lo que no me gusta durante la intimidad sexual.	LIKERT-5	\N	1	2026-03-30 07:30:36.961731+00
c1615073-0a4e-401d-ab58-f8fd45086bb6	f46377c1-75d6-421e-a77c-6118437899b7	Considero que la sexualidad es un aspecto importante para construir una conexión profunda en nuestra relación.	LIKERT-5	\N	2	2026-03-30 07:30:36.961731+00
67ffd6a4-55ec-4f74-bfb6-63198623b452	f46377c1-75d6-421e-a77c-6118437899b7	Estoy dispuesto/a a explorar y probar nuevas experiencias sexuales con mi pareja, siempre que haya consentimiento mutuo.	LIKERT-5	\N	3	2026-03-30 07:30:36.961731+00
ed03a07d-61a5-4fa2-b141-59ac9a23b042	f46377c1-75d6-421e-a77c-6118437899b7	¿Qué esperas de nuestra vida sexual como pareja y cómo crees que podemos construir una intimidad placentera para ambos?	OPEN	\N	4	2026-03-30 07:30:36.961731+00
adcab765-1fba-43c4-8da9-61745838b902	f46377c1-75d6-421e-a77c-6118437899b7	¿Hay algún tema o fantasía sexual específica que te gustaría discutir o explorar con tu pareja en el futuro cercano?	OPEN	\N	5	2026-03-30 07:30:36.961731+00
46718b74-0d5f-4c59-b7b1-53eb48b3c2ea	8dc4df53-4274-4df4-8872-c56f72531ae0	Siento que me sería fácil compartir contigo un gusto o afición que he mantenido en secreto hasta ahora.	LIKERT-5	\N	0	2026-03-30 07:41:48.571648+00
b17fdd86-938c-4855-b352-dd5c68ee4b85	8dc4df53-4274-4df4-8872-c56f72531ae0	Creo que te sorprendería (para bien) algún gusto o afición que tengo y que aún no conoces.	LIKERT-5	\N	1	2026-03-30 07:41:48.571648+00
643707b7-f01a-4469-9c88-5d85fe869391	8dc4df53-4274-4df4-8872-c56f72531ae0	Disfruto mucho de tener algunos 'gustos ocultos' que son solo para mí y no siento la necesidad de compartirlos.	LIKERT-5	\N	2	2026-03-30 07:41:48.571648+00
2b50d3c0-b5ce-4cd9-93ae-41117bb018b1	8dc4df53-4274-4df4-8872-c56f72531ae0	Me entusiasma la idea de descubrir tus gustos o aficiones más inusuales o inesperados.	LIKERT-5	\N	3	2026-03-30 07:41:48.571648+00
36141e9a-3bd2-405b-a706-b9db229e6b9f	8dc4df53-4274-4df4-8872-c56f72531ae0	Estoy abierto/a a probar una actividad o experiencia completamente nueva si es algo que te apasiona, aunque no sea mi estilo habitual.	LIKERT-5	\N	4	2026-03-30 07:41:48.571648+00
d1eacc0a-2188-4a23-9da8-b99c1e097885	8dc4df53-4274-4df4-8872-c56f72531ae0	Si tuvieras que compartir un 'gusto oculto' hoy, ¿cuál sería y por qué crees que es importante que tu pareja lo sepa?	OPEN	\N	5	2026-03-30 07:41:48.571648+00
\.


--
-- Data for Name: custom_evaluations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.custom_evaluations (id, couple_id, created_by, topic, title, description, status, gemini_prompt_version, created_at, updated_at) FROM stdin;
27963945-f5e8-4396-b6a8-e20009dd2862	b0f53c25-5fae-445c-8261-e06d1716b4d3	10f86299-e9f4-4731-8089-657b202866b2	Primeras Impresiones	Descubriendo Nuestras Primeras Impresiones	Esta micro-evaluación te invita a reflexionar sobre los momentos iniciales de vuestra conexión. Explorarán qué sintieron y percibieron el uno del otro desde el principio, sentando las bases para entender vuestro camino juntos.	completed	2.5-flash	2026-03-30 07:05:55.68421+00	2026-03-30 07:12:17.868545+00
f46377c1-75d6-421e-a77c-6118437899b7	b0f53c25-5fae-445c-8261-e06d1716b4d3	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	Podemos hacer un quizz sobre sexualidad, sabes que nos gusta y comó mejorar en nuestra sexualidad comó pareja. Si puedes haz 15 preguntas	Descubriendo Nuestra Intimidad Sexual	Esta micro-evaluación les ofrece un espacio seguro para explorar sus expectativas y deseos en el ámbito sexual. Les permitirá sentar las bases para una intimidad plena y comunicativa en su nueva relación.	completed	2.5-flash	2026-03-30 07:30:36.770773+00	2026-03-30 07:36:32.728577+00
8dc4df53-4274-4df4-8872-c56f72531ae0	b0f53c25-5fae-445c-8261-e06d1716b4d3	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	Nuestros Gustos Ocultos	Descubriendo Nuestros Gustos Ocultos	Esta micro-evaluación les invita a un viaje divertido para desvelar esos pequeños placeres y gustos que quizás aún no han compartido. Descubrirán nuevas facetas el uno del otro, fomentando una conexión más profunda y emocionante desde el inicio de su relación.	completed	2.5-flash	2026-03-30 07:41:48.448974+00	2026-03-30 07:51:23.825085+00
\.


--
-- Data for Name: daily_tips; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.daily_tips (id, couple_id, tip_date, tip_text, dimension, generated_by, created_at) FROM stdin;
8ea232b9-bf35-46ca-96f4-b921c3aa7e32	b0f53c25-5fae-445c-8261-e06d1716b4d3	2026-03-30	Melanie, hoy cuando sientas un choque con Ricardo, hazle saber que, a pesar de la diferencia, valoras su esfuerzo. Este reconocimiento mutuo puede suavizar cualquier aspereza en segundos.	choque	gemini-2.5-flash	2026-03-30 06:51:37.236358+00
f915794c-60f0-48f6-ade3-14b91918d523	b0f53c25-5fae-445c-8261-e06d1716b4d3	2026-03-31	Ricardo, hoy dile a Melanie algo que aprecias profundamente de cómo ella te cuida. Este reconocimiento sincero reafirma el valor de su ternura compartida.	cuidado	gemini-2.5-flash	2026-03-31 02:35:38.98525+00
\.


--
-- Data for Name: dimension_keys; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dimension_keys (id, slug, name, description, layer, created_at) FROM stdin;
40b08dad-a103-4b4c-a74d-1e100b108ec6	intimidad_emocional	Intimidad Emocional	Vulnerabilidad, profundidad, cercanía sentida	conexion	2026-03-29 04:32:21.030761+00
e4b9c869-6e0d-4a28-b0d7-ea8ef2b7f424	rituales	Rituales y Presencia	Pequeños hábitos, atención, conexión recurrente	conexion	2026-03-29 04:32:21.030761+00
9a24df2f-dfcc-495c-ae63-3784e06cab2c	curiosidad_mutua	Curiosidad Mutua	Sentirse conocido/a y conocer al otro	conexion	2026-03-29 04:32:21.030761+00
d3fb89ae-f606-433c-8a63-88f6edee9b89	apoyo_emocional	Estilo de Apoyo	Si el cuidado ofrecido coincide con el necesitado	cuidado	2026-03-29 04:32:21.030761+00
ea550a0c-d6eb-45d1-b2e3-fd049aad7fef	validacion	Validación Emocional	Sentirse comprendido/a y reconocido/a	cuidado	2026-03-29 04:32:21.030761+00
f230a90e-1e95-4d07-b13e-61d6607b0eea	lenguajes_afecto	Encaje Afectivo	Coincidencia entre afecto deseado y recibido	cuidado	2026-03-29 04:32:21.030761+00
3a7c1dc4-b798-45f9-b0ce-157966d7c88a	estilo_conflicto	Inicio del Conflicto	Disposición y habilidad para empezar conversaciones difíciles	choque	2026-03-29 04:32:21.030761+00
c01b4f63-10a8-4ae9-a37f-4f6331fbf6fb	reactividad	Reactividad y Regulación	Activación emocional y auto-regulación	choque	2026-03-29 04:32:21.030761+00
e555fdeb-63e3-4b9f-a17f-5e15b2e2c12c	reparacion	Reparación y Reconexión	Capacidad de recuperarse y cerrar ciclos después de fricciones	choque	2026-03-29 04:32:21.030761+00
6d9dd0d9-b328-4ba2-8668-3480c01031f0	metas	Planificación Compartida	Alineación alrededor del futuro y metas a largo plazo	camino	2026-03-29 04:32:21.030761+00
cbd615f5-c4f1-4dbb-a8e9-b1991fc60d8e	dinero	Justicia y Acuerdos	Dinero, responsabilidades, límites, sistemas familiares	camino	2026-03-29 04:32:21.030761+00
2c6af04c-80d3-4527-9d79-55962735a694	identidad	Integración de Autonomía	Espacio para la individualidad dentro del compromiso	camino	2026-03-29 04:32:21.030761+00
\.


--
-- Data for Name: dimension_scores; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.dimension_scores (id, user_id, couple_id, dimension_id, raw_score, normalized_score, calculated_at) FROM stdin;
\.


--
-- Data for Name: generated_assessment_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.generated_assessment_items (id, assessment_id, item_bank_id, category, question_text, question_type, response_scale, sort_order, target_dimension, created_at) FROM stdin;
fe483f80-c4c0-4bcd-a8c8-d8097bb796ed	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	1c5049b0-deff-4ae4-b0b3-da1bc1980632	core	Siento que mi pareja realmente entiende mis emociones y me valora tal como soy.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	1	conexion	2026-03-30 06:36:39.562803+00
23846fca-1328-44f9-8cf4-f44445711da8	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	4651de3e-1801-4615-ad0d-a552eede880a	core	Disfrutamos genuinamente del tiempo que pasamos juntos, incluso sin hacer nada especial.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	2	conexion	2026-03-30 06:36:39.562803+00
4a2ee2df-3173-43ba-952b-2578b2c4f9bf	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	a964335d-d875-4148-a173-7deb2a1af63d	core	Estoy satisfecho/a con la cantidad y la calidad de afecto físico en nuestra relación.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	3	conexion	2026-03-30 06:36:39.562803+00
a82c0238-a746-451c-9cfa-924a32cdb6c3	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	ba5f53f0-d61b-4e1a-9844-03ea78368c73	core	Nuestra intimidad sexual es satisfactoria y ambos nos sentimos cómodos expresando nuestros deseos.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	4	conexion	2026-03-30 06:36:39.562803+00
68bfd09a-3ad7-4a5f-b1ec-593b2f9232af	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	751c864f-651f-4594-81fe-c5b802c4467d	core	A menudo le expreso a mi pareja mi aprecio y admiración por las cosas que hace.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	5	conexion	2026-03-30 06:36:39.562803+00
80e468f9-d040-4be7-b29f-f7813eae7e02	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	9d579de8-e22c-4d92-bde8-061cd5acbd9b	core	Me siento completamente seguro/a mostrándome vulnerable y compartiendo mis mayores miedos con mi pareja.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	6	conexion	2026-03-30 06:36:39.562803+00
0d35609e-0e41-427d-b864-b6f4f34dd73e	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	8d3e191f-ea87-4fa3-b0ae-e59bd7aef1d5	core	Cuando hablo sobre mi día, siento que mi pareja escucha con atención y responde con empatía.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	7	conexion	2026-03-30 06:36:39.562803+00
8efd4207-111b-4a07-b205-c679a9dab937	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	4025046d-4dd8-4b0c-a4f2-a174337819e7	core	Cuando comparto una preocupación, mi pareja valida mis sentimientos antes de intentar "solucionar" el problema.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	8	conexion	2026-03-30 06:36:39.562803+00
a3b0bd13-d33b-47cf-81d7-48a5b8240877	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	c64c953c-7999-410c-96d7-063aa684d804	core	Confío plenamente en la integridad de mi pareja y en su compromiso con nuestra relación.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	9	cuidado	2026-03-30 06:36:39.562803+00
fe437433-3c9e-4ccd-85ac-854df4f7e7a7	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	8777a793-dad9-4881-8547-2c267562e97b	core	Sé que mi pareja me apoyará incondicionalmente en mis peores momentos.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	10	cuidado	2026-03-30 06:36:39.562803+00
e99dd5b6-6951-4e47-8ba3-f2c854f7942b	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	577d218a-6018-426f-89e6-20063927cdfd	core	Respetamos los límites personales de cada uno (espacio, tiempo a solas, privacidad).	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	11	cuidado	2026-03-30 06:36:39.562803+00
7e113591-e418-41bf-9a6f-3e5c3cddc87b	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	01b08855-ffd1-4b08-a441-888f26e3c970	core	Yo siento que compartimos la carga mental de planificar y administrar nuestra vida juntos.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	12	cuidado	2026-03-30 06:36:39.562803+00
ecc0605e-d0f0-4250-9f7a-e6cd4fc4227d	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	4013a181-b713-4ec1-ae83-93ab363d9816	core	Somos un refugio seguro cuando el otro enfrenta un alto nivel de estrés externo (trabajo, familia).	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	13	cuidado	2026-03-30 06:36:39.562803+00
ee7f94f6-f92b-42f3-9186-dd58da51cd58	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	ce109e5b-fb7f-41e4-adb8-72579a5031c2	core	Siento que tengo espacio suficiente para fomentar mis propias amistades e individualidad.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	14	cuidado	2026-03-30 06:36:39.562803+00
dc5cf273-ae44-4d03-af27-988ff2291d99	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	3b271b8f-db66-49ad-9628-98d47af2e6d7	core	Hablamos transparentemente sobre el dinero y manejamos nuestra economía como un equipo.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	15	cuidado	2026-03-30 06:36:39.562803+00
77c9a7ac-a2fb-41f6-a20b-80a78cee887e	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	01cc175d-43ae-455c-b666-367370728ac7	core	Nuestras discusiones normalmente terminan en acuerdos y resoluciones en lugar de quedar en el aire.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	16	choque	2026-03-30 06:36:39.562803+00
874cb3b1-3569-4ba1-aff7-9d6dc6b3d6ff	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	5165b173-6956-4de8-851d-30a6f05fb454	core	Durante una pelea, ambos evitamos insultos, sarcasmo hiriente o menosprecios.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	17	choque	2026-03-30 06:36:39.562803+00
9bce6c87-41f3-449d-8bf5-794981b7ba6f	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	2cca3653-084f-47c8-8fbb-1bf8cfea1796	core	Si una discusión empieza a salirse de control, uno de los dos interviene para calmar la situación.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	18	choque	2026-03-30 06:36:39.562803+00
04d0d779-6641-483a-acd2-db540a91208c	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	d0d174f7-6cee-40b7-a4a6-5857550f64a8	core	Siento que mi pareja se pone constantemente a la defensiva cuando presento una pequeña queja.	LIKERT-5	[{"label": "Siempre", "order": 1, "value": "1"}, {"label": "Frecuentemente", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Rara vez", "order": 4, "value": "4"}, {"label": "Nunca", "order": 5, "value": "5"}]	19	choque	2026-03-30 06:36:39.562803+00
35bc7a0c-4958-4828-949d-c2e4655f1e8c	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	e5b417dd-104e-48d7-b291-8e9741d32afd	core	A veces, durante los conflictos, mi pareja (o yo) "apaga" la comunicación y se aleja sin resolver nada.	LIKERT-5	[{"label": "Siempre", "order": 1, "value": "1"}, {"label": "Frecuentemente", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Rara vez", "order": 4, "value": "4"}, {"label": "Nunca", "order": 5, "value": "5"}]	20	choque	2026-03-30 06:36:39.562803+00
15d61dde-1c55-4881-aae9-c91c64a9b781	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	7ea507f8-9820-41e7-808f-feac53b868fe	core	Siento que seguimos teniendo exactamente la misma discusión una y otra vez sin progreso.	LIKERT-5	[{"label": "Siempre", "order": 1, "value": "1"}, {"label": "Frecuentemente", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Rara vez", "order": 4, "value": "4"}, {"label": "Nunca", "order": 5, "value": "5"}]	21	choque	2026-03-30 06:36:39.562803+00
b0a29919-bb56-41a6-846f-190fa967a9ae	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	99d50eda-0d8f-47bb-a54e-4eeb202d47ed	core	Ambos sabemos cómo pedir disculpas sinceras cuando nos damos cuenta de que el otro salió lastimado.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	22	choque	2026-03-30 06:36:39.562803+00
8436468a-1abf-4d30-9234-38cd8f16073e	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	3514cc73-b9bb-4482-9e1c-6f8841919971	core	Después de una pelea, nos reconectamos y sanamos rápidamente en lugar de mantenernos distantes por días.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	23	choque	2026-03-30 06:36:39.562803+00
29056887-f504-4495-bd0c-74f8d633e631	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	f08eeffd-45c5-4a58-acce-54cea3cdfa39	core	Siento que nuestros grandes planes a futuro (donde vivir, estilo de vida) están alineados.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	24	camino	2026-03-30 06:36:39.562803+00
69dd92bd-3bb9-4705-9327-6d9246c776d8	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	75f2014b-1939-456a-9cd1-f5b93be67874	core	Compartimos valores fundamentales y una ética similar sobre cómo vivir y relacionarnos.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	25	camino	2026-03-30 06:36:39.562803+00
4300a5a2-2eed-4249-8064-554661e546d6	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	c98453c9-0bcf-45a3-99ea-a7d8b41fe194	core	Siento que mi pareja realmente apoya e invierte en mis sueños profesionales o ambiciones personales.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	26	camino	2026-03-30 06:36:39.562803+00
95ebccef-f79d-44b1-b450-f3a2e5982e16	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	3e808329-afea-43d4-94cd-f5a9cf4da7ea	core	Ambos estamos activamente buscando crecer y evolucionar como personas dentro de la relación.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	27	camino	2026-03-30 06:36:39.562803+00
78b52abd-ba3d-4e41-b562-696275345765	bc4faaf6-eb5a-463c-ad09-d855d6b0a145	c4d7c07d-5603-42d6-87a9-1aebcc473a1d	core	Tenemos expectativas compatibles sobre qué es una "buena vida" en el día a día.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	28	camino	2026-03-30 06:36:39.562803+00
8aabf258-54b9-4ca5-a15b-4829911b3a79	553f5084-abf0-4a92-ad32-52f528d61c24	1c5049b0-deff-4ae4-b0b3-da1bc1980632	core	Siento que mi pareja realmente entiende mis emociones y me valora tal como soy.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	1	conexion	2026-03-30 06:36:48.648006+00
cc7d2f28-9b0e-41c4-ac86-5c638ec2aa11	553f5084-abf0-4a92-ad32-52f528d61c24	4651de3e-1801-4615-ad0d-a552eede880a	core	Disfrutamos genuinamente del tiempo que pasamos juntos, incluso sin hacer nada especial.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	2	conexion	2026-03-30 06:36:48.648006+00
a97b2c60-d0f5-4bec-8096-567c733bc4a3	553f5084-abf0-4a92-ad32-52f528d61c24	a964335d-d875-4148-a173-7deb2a1af63d	core	Estoy satisfecho/a con la cantidad y la calidad de afecto físico en nuestra relación.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	3	conexion	2026-03-30 06:36:48.648006+00
68086df3-2a85-4849-a73f-e06816c062d8	553f5084-abf0-4a92-ad32-52f528d61c24	ba5f53f0-d61b-4e1a-9844-03ea78368c73	core	Nuestra intimidad sexual es satisfactoria y ambos nos sentimos cómodos expresando nuestros deseos.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	4	conexion	2026-03-30 06:36:48.648006+00
054a8f52-5194-4c63-87ca-a92edb8b6d01	553f5084-abf0-4a92-ad32-52f528d61c24	751c864f-651f-4594-81fe-c5b802c4467d	core	A menudo le expreso a mi pareja mi aprecio y admiración por las cosas que hace.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	5	conexion	2026-03-30 06:36:48.648006+00
0668b4f1-0dca-402a-a909-a102d586df84	553f5084-abf0-4a92-ad32-52f528d61c24	bbbd3ce9-d98b-450a-9567-b8414b2dabdc	core	Pasamos tiempo de calidad juntos sin distracciones de la tecnología o el trabajo.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	6	conexion	2026-03-30 06:36:48.648006+00
45095f78-cc0a-4013-b1bd-3f725d1418e3	553f5084-abf0-4a92-ad32-52f528d61c24	8d3e191f-ea87-4fa3-b0ae-e59bd7aef1d5	core	Cuando hablo sobre mi día, siento que mi pareja escucha con atención y responde con empatía.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	7	conexion	2026-03-30 06:36:48.648006+00
55e01772-35d5-47ef-8d47-348a932d3285	553f5084-abf0-4a92-ad32-52f528d61c24	8777a793-dad9-4881-8547-2c267562e97b	core	Sé que mi pareja me apoyará incondicionalmente en mis peores momentos.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	8	cuidado	2026-03-30 06:36:48.648006+00
ed35a586-2cc0-4c83-9d93-a7e56d55019f	553f5084-abf0-4a92-ad32-52f528d61c24	d76a6541-fe07-4d5a-96d0-8433f75a11e6	core	La distribución de las tareas domésticas y responsabilidades diarias se siente justa para ambos.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	9	cuidado	2026-03-30 06:36:48.648006+00
857f1531-d659-4e99-85db-d1b58569c2b5	553f5084-abf0-4a92-ad32-52f528d61c24	01b08855-ffd1-4b08-a441-888f26e3c970	core	Yo siento que compartimos la carga mental de planificar y administrar nuestra vida juntos.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	10	cuidado	2026-03-30 06:36:48.648006+00
baa77b1f-c272-4985-9b51-3951720215e4	553f5084-abf0-4a92-ad32-52f528d61c24	ccae8116-03d4-40f3-b688-10a13cb69767	core	Cuando mi pareja dice que hará algo importante, sé que lo cumplirá.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	11	cuidado	2026-03-30 06:36:48.648006+00
206e74fd-4db6-4989-b94f-f76e6ad8c731	553f5084-abf0-4a92-ad32-52f528d61c24	4013a181-b713-4ec1-ae83-93ab363d9816	core	Somos un refugio seguro cuando el otro enfrenta un alto nivel de estrés externo (trabajo, familia).	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	12	cuidado	2026-03-30 06:36:48.648006+00
aacd5652-306e-4956-811e-d8de339c1a71	553f5084-abf0-4a92-ad32-52f528d61c24	ce109e5b-fb7f-41e4-adb8-72579a5031c2	core	Siento que tengo espacio suficiente para fomentar mis propias amistades e individualidad.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	13	cuidado	2026-03-30 06:36:48.648006+00
25c86408-0ee1-4048-97fc-94cc85524707	553f5084-abf0-4a92-ad32-52f528d61c24	95cee713-49ac-40ff-8100-4d91d4d868d7	core	No ocultamos información importante ni tomamos decisiones significativas de manera unilateral.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	14	cuidado	2026-03-30 06:36:48.648006+00
72993da0-f084-41db-b3fa-5db37749aed7	553f5084-abf0-4a92-ad32-52f528d61c24	01cc175d-43ae-455c-b666-367370728ac7	core	Nuestras discusiones normalmente terminan en acuerdos y resoluciones en lugar de quedar en el aire.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	15	choque	2026-03-30 06:36:48.648006+00
1136a124-dbc2-4f06-8640-7eb68f5c17b4	553f5084-abf0-4a92-ad32-52f528d61c24	5165b173-6956-4de8-851d-30a6f05fb454	core	Durante una pelea, ambos evitamos insultos, sarcasmo hiriente o menosprecios.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	16	choque	2026-03-30 06:36:48.648006+00
72f8b88e-4749-4e8d-9da4-bf92ee77f5c3	553f5084-abf0-4a92-ad32-52f528d61c24	2cca3653-084f-47c8-8fbb-1bf8cfea1796	core	Si una discusión empieza a salirse de control, uno de los dos interviene para calmar la situación.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	17	choque	2026-03-30 06:36:48.648006+00
bd510427-31d8-48cd-a6cb-60aefcbfae6d	553f5084-abf0-4a92-ad32-52f528d61c24	d0d174f7-6cee-40b7-a4a6-5857550f64a8	core	Siento que mi pareja se pone constantemente a la defensiva cuando presento una pequeña queja.	LIKERT-5	[{"label": "Siempre", "order": 1, "value": "1"}, {"label": "Frecuentemente", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Rara vez", "order": 4, "value": "4"}, {"label": "Nunca", "order": 5, "value": "5"}]	18	choque	2026-03-30 06:36:48.648006+00
a930f8e3-a88d-40ec-85e1-a6c32d037bfb	553f5084-abf0-4a92-ad32-52f528d61c24	e5b417dd-104e-48d7-b291-8e9741d32afd	core	A veces, durante los conflictos, mi pareja (o yo) "apaga" la comunicación y se aleja sin resolver nada.	LIKERT-5	[{"label": "Siempre", "order": 1, "value": "1"}, {"label": "Frecuentemente", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Rara vez", "order": 4, "value": "4"}, {"label": "Nunca", "order": 5, "value": "5"}]	19	choque	2026-03-30 06:36:48.648006+00
9fe9820e-b4d1-487a-b674-da31906f4af2	553f5084-abf0-4a92-ad32-52f528d61c24	7ea507f8-9820-41e7-808f-feac53b868fe	core	Siento que seguimos teniendo exactamente la misma discusión una y otra vez sin progreso.	LIKERT-5	[{"label": "Siempre", "order": 1, "value": "1"}, {"label": "Frecuentemente", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Rara vez", "order": 4, "value": "4"}, {"label": "Nunca", "order": 5, "value": "5"}]	20	choque	2026-03-30 06:36:48.648006+00
14e4e605-e4eb-4c73-9626-c974fd312f84	553f5084-abf0-4a92-ad32-52f528d61c24	99d50eda-0d8f-47bb-a54e-4eeb202d47ed	core	Ambos sabemos cómo pedir disculpas sinceras cuando nos damos cuenta de que el otro salió lastimado.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	21	choque	2026-03-30 06:36:48.648006+00
be224f9f-2066-4700-8bbb-114b25da8b0a	553f5084-abf0-4a92-ad32-52f528d61c24	f08eeffd-45c5-4a58-acce-54cea3cdfa39	core	Siento que nuestros grandes planes a futuro (donde vivir, estilo de vida) están alineados.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	22	camino	2026-03-30 06:36:48.648006+00
cddcfb46-769d-43b1-adf6-93c6bbc6d3ab	553f5084-abf0-4a92-ad32-52f528d61c24	75f2014b-1939-456a-9cd1-f5b93be67874	core	Compartimos valores fundamentales y una ética similar sobre cómo vivir y relacionarnos.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	23	camino	2026-03-30 06:36:48.648006+00
ccd7eb82-d657-40c2-9132-f5cd60c6947d	553f5084-abf0-4a92-ad32-52f528d61c24	c98453c9-0bcf-45a3-99ea-a7d8b41fe194	core	Siento que mi pareja realmente apoya e invierte en mis sueños profesionales o ambiciones personales.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	24	camino	2026-03-30 06:36:48.648006+00
78daf4b5-896e-4929-96e4-704cbf60513c	553f5084-abf0-4a92-ad32-52f528d61c24	c07655da-5952-4dc9-92c7-509a970727ea	core	Trabajamos juntos efectivamente para alcanzar nuestras metas financieras a largo plazo.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	25	camino	2026-03-30 06:36:48.648006+00
82c1e9e6-b6a7-45e8-ba16-fac9f3b10e96	553f5084-abf0-4a92-ad32-52f528d61c24	cdc6973c-643b-4c5a-9fb1-bb3911b4611f	core	A menudo hablamos sobre lo que queremos lograr juntos a largo plazo (el legado e impacto).	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	26	camino	2026-03-30 06:36:48.648006+00
b169c538-0032-46d6-8b6b-4df467bdada4	553f5084-abf0-4a92-ad32-52f528d61c24	3e808329-afea-43d4-94cd-f5a9cf4da7ea	core	Ambos estamos activamente buscando crecer y evolucionar como personas dentro de la relación.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	27	camino	2026-03-30 06:36:48.648006+00
b03422e2-306b-4bab-bd86-afeec6e20352	553f5084-abf0-4a92-ad32-52f528d61c24	c4d7c07d-5603-42d6-87a9-1aebcc473a1d	core	Tenemos expectativas compatibles sobre qué es una "buena vida" en el día a día.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	28	camino	2026-03-30 06:36:48.648006+00
\.


--
-- Data for Name: generated_assessments; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.generated_assessments (id, couple_id, title, description, gemini_prompt_version, status, created_at) FROM stdin;
bc4faaf6-eb5a-463c-ad09-d855d6b0a145	b0f53c25-5fae-445c-8261-e06d1716b4d3	Evaluación Dinámica de Pareja	Generada éticamente por IA en base a sus perfiles de Onboarding	v1	published	2026-03-30 06:36:39.462996+00
553f5084-abf0-4a92-ad32-52f528d61c24	b0f53c25-5fae-445c-8261-e06d1716b4d3	Evaluación Dinámica de Pareja	Generada éticamente por IA en base a sus perfiles de Onboarding	v1	published	2026-03-30 06:36:48.573435+00
\.


--
-- Data for Name: guided_conversations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.guided_conversations (id, slug, title, description, dimension, difficulty, duration_minutes, prompt, opening_card_id, created_at) FROM stdin;
\.


--
-- Data for Name: item_bank; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.item_bank (id, slug, stage, dimension_slug, construct_slug, question_text, question_type, response_scale, reverse_scored, sensitivity_level, requires_opt_in, scoring_strategy, sort_order, active, version, metadata, created_at, updated_at) FROM stdin;
16d6e03c-e92e-43d8-862a-a9dee9390050	onb-01	onboarding	autonomy	personal_space	Cuando me siento abrumado/a, primero necesito espacio antes de hablar.	LIKERT-5	{"options": [{"label": "Muy en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Muy de acuerdo", "order": 5, "value": "5"}]}	f	normal	f	direct	1	t	1.0	{}	2026-03-29 04:32:21.030761+00	2026-03-29 04:32:21.030761+00
dea3715f-46f9-4b79-8e00-8925c6dcbd6f	onb-02	onboarding	autonomy	independence	Para mí es importante mantener espacios propios dentro de la relación.	LIKERT-5	{"options": [{"label": "Muy en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Muy de acuerdo", "order": 5, "value": "5"}]}	f	normal	f	direct	2	t	1.0	{}	2026-03-29 04:32:21.030761+00	2026-03-29 04:32:21.030761+00
01d56775-795f-4f7a-b035-ca970c5aef27	onb-03	onboarding	reassurance	affection_actions	Me siento querido/a principalmente a través de acciones concretas.	LIKERT-5	{"options": [{"label": "Muy en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Muy de acuerdo", "order": 5, "value": "5"}]}	f	normal	f	direct	3	t	1.0	{}	2026-03-29 04:32:21.030761+00	2026-03-29 04:32:21.030761+00
0a5b4e20-6e7c-40c4-ac7d-a3b3dbcb8283	onb-04	onboarding	reassurance	verbal_reassurance	Necesito escuchar palabras claras de cariño o reconocimiento para sentirme seguro/a.	LIKERT-5	{"options": [{"label": "Muy en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Muy de acuerdo", "order": 5, "value": "5"}]}	f	normal	f	direct	4	t	1.0	{}	2026-03-29 04:32:21.030761+00	2026-03-29 04:32:21.030761+00
1825d649-67e0-41b5-bc30-e8f46beea55a	onb-05	onboarding	conflict	conflict_initiation	Prefiero resolver tensiones pronto, aunque la conversación sea incómoda.	LIKERT-5	{"options": [{"label": "Muy en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Muy de acuerdo", "order": 5, "value": "5"}]}	f	normal	f	direct	5	t	1.0	{}	2026-03-29 04:32:21.030761+00	2026-03-29 04:32:21.030761+00
c50e9d56-7ba8-4cd5-b9b8-26e148b52456	onb-06	onboarding	conflict	conflict_avoidance	Cuando hay conflicto, me cuesta iniciar la conversación.	LIKERT-5	{"options": [{"label": "Muy en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Muy de acuerdo", "order": 5, "value": "5"}]}	f	normal	f	direct	6	t	1.0	{"reverse_scored": true}	2026-03-29 04:32:21.030761+00	2026-03-29 04:32:21.030761+00
637c2d6c-4da6-48e4-9596-b32abb028598	onb-07	onboarding	conflict	repair_speed	Después de una discusión, suelo recuperar la calma con rapidez.	LIKERT-5	{"options": [{"label": "Muy en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Muy de acuerdo", "order": 5, "value": "5"}]}	f	normal	f	direct	7	t	1.0	{}	2026-03-29 04:32:21.030761+00	2026-03-29 04:32:21.030761+00
aaab699c-4b05-4c99-8c81-dc87a11442c2	onb-08	onboarding	stress_coping	bad_day_response	Si tengo un mal día, prefiero que mi pareja:	ESCENARIO	{"options": [{"label": "Me escuche sin dar consejos", "order": 1, "value": "A"}, {"label": "Me ayude a resolver lo que pasó", "order": 2, "value": "B"}, {"label": "Me dé espacio y tiempo", "order": 3, "value": "C"}, {"label": "Me pregunte qué necesito en ese momento", "order": 4, "value": "D"}]}	f	normal	f	direct	8	t	1.0	{"scenario": "Imagina que llegas a casa después de un día difícil..."}	2026-03-29 04:32:21.030761+00	2026-03-29 04:32:21.030761+00
aa969efb-0b7f-44b9-9600-5941c6408352	onb-09	onboarding	stress_coping	difficult_talk_timing	Si mi pareja quiere hablar de algo difícil cuando yo no estoy regulado/a, prefiero:	ESCENARIO	{"options": [{"label": "Hablar de una vez para no dejarlo pendiente", "order": 1, "value": "A"}, {"label": "Pedir una pausa corta y retomar después", "order": 2, "value": "B"}, {"label": "Dejarlo para otro momento más tranquilo", "order": 3, "value": "C"}, {"label": "Evitarlo si no es urgente", "order": 4, "value": "D"}]}	f	normal	f	direct	9	t	1.0	{"scenario": "Tu pareja necesita hablar de algo importante, pero tú no te sientes listo/a..."}	2026-03-29 04:32:21.030761+00	2026-03-29 04:32:21.030761+00
2d2f78b9-e938-4092-be5a-f3908b0096b8	onb-10	onboarding	emotional_expression	asking_comfort	Me resulta fácil pedir consuelo o apoyo emocional.	LIKERT-5	{"options": [{"label": "Muy en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Muy de acuerdo", "order": 5, "value": "5"}]}	f	normal	f	direct	10	t	1.0	{}	2026-03-29 04:32:21.030761+00	2026-03-29 04:32:21.030761+00
9652f29e-8dab-4236-b0fc-e5b00ad99022	onb-11	onboarding	emotional_expression	expressing_needs	Me resulta fácil decir claramente lo que necesito.	LIKERT-5	{"options": [{"label": "Muy en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Muy de acuerdo", "order": 5, "value": "5"}]}	f	normal	f	direct	11	t	1.0	{}	2026-03-29 04:32:21.030761+00	2026-03-29 04:32:21.030761+00
d99723bb-ed2d-4be6-8737-07346133243c	onb-12	onboarding	rituals	daily_rituals	Los pequeños rituales cotidianos me ayudan a sentir conexión.	LIKERT-5	{"options": [{"label": "Muy en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Muy de acuerdo", "order": 5, "value": "5"}]}	f	normal	f	direct	12	t	1.0	{}	2026-03-29 04:32:21.030761+00	2026-03-29 04:32:21.030761+00
336395c7-eab0-4462-be3e-58e2ab5de197	onb-13	onboarding	rituals	quality_time	Me gusta saber cuándo tendremos tiempo de calidad juntos.	LIKERT-5	{"options": [{"label": "Muy en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Muy de acuerdo", "order": 5, "value": "5"}]}	f	normal	f	direct	13	t	1.0	{}	2026-03-29 04:32:21.030761+00	2026-03-29 04:32:21.030761+00
9a07d5d6-e513-4c89-a97d-345a4ca8f89a	onb-14	onboarding	future_orientation	future_talks	Hablar del futuro como pareja es importante para mí.	LIKERT-5	{"options": [{"label": "Muy en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Muy de acuerdo", "order": 5, "value": "5"}]}	f	normal	f	direct	14	t	1.0	{}	2026-03-29 04:32:21.030761+00	2026-03-29 04:32:21.030761+00
a49cdbde-ecfa-4b2a-bdb6-6c07e425dc65	onb-15	onboarding	future_orientation	building_together	Me tranquiliza sentir que estamos construyendo algo juntos.	LIKERT-5	{"options": [{"label": "Muy en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Muy de acuerdo", "order": 5, "value": "5"}]}	f	normal	f	direct	15	t	1.0	{}	2026-03-29 04:32:21.030761+00	2026-03-29 04:32:21.030761+00
1c5049b0-deff-4ae4-b0b3-da1bc1980632	con_1	core	conexion	emotional_intimacy	Siento que mi pareja realmente entiende mis emociones y me valora tal como soy.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
4651de3e-1801-4615-ad0d-a552eede880a	con_2	core	conexion	friendship	Disfrutamos genuinamente del tiempo que pasamos juntos, incluso sin hacer nada especial.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
a964335d-d875-4148-a173-7deb2a1af63d	con_3	core	conexion	physical_affection	Estoy satisfecho/a con la cantidad y la calidad de afecto físico en nuestra relación.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
ba5f53f0-d61b-4e1a-9844-03ea78368c73	con_4	core	conexion	sexual_connection	Nuestra intimidad sexual es satisfactoria y ambos nos sentimos cómodos expresando nuestros deseos.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
751c864f-651f-4594-81fe-c5b802c4467d	con_5	core	conexion	appreciation	A menudo le expreso a mi pareja mi aprecio y admiración por las cosas que hace.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
9d579de8-e22c-4d92-bde8-061cd5acbd9b	con_6	core	conexion	vulnerability	Me siento completamente seguro/a mostrándome vulnerable y compartiendo mis mayores miedos con mi pareja.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
ce87e173-4557-4f72-8e84-53a9abbdb00b	con_7	core	conexion	fun_play	Todavía nos reímos juntos y encontramos momentos para ser juguetones y divertidos en la relación.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
bbbd3ce9-d98b-450a-9567-b8414b2dabdc	con_8	core	conexion	quality_time	Pasamos tiempo de calidad juntos sin distracciones de la tecnología o el trabajo.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
8d3e191f-ea87-4fa3-b0ae-e59bd7aef1d5	con_9	core	conexion	active_listening	Cuando hablo sobre mi día, siento que mi pareja escucha con atención y responde con empatía.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
94c85a6a-ccb6-4ac1-9d52-a24a48de175f	con_10	core	conexion	romantic_gestures	Aún tenemos detalles románticos o pequeñas sorpresas que nos demuestran interés continuo.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
045384fb-fef1-4b63-84cc-2d3cc99a02bd	con_11	core	conexion	shared_hobbies	Tenemos intereses o pasatiempos en común que disfrutamos explorar como equipo.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
4025046d-4dd8-4b0c-a4f2-a174337819e7	con_12	core	conexion	emotional_validation	Cuando comparto una preocupación, mi pareja valida mis sentimientos antes de intentar "solucionar" el problema.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
f7b72114-92bc-4d98-b28b-f43fd4a42f2d	con_13	core	conexion	presence	Estando juntos, siento que la atención de mi pareja está realmente allí, en el presente.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
c64c953c-7999-410c-96d7-063aa684d804	cui_1	core	cuidado	trust	Confío plenamente en la integridad de mi pareja y en su compromiso con nuestra relación.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
8777a793-dad9-4881-8547-2c267562e97b	cui_2	core	cuidado	support	Sé que mi pareja me apoyará incondicionalmente en mis peores momentos.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
d76a6541-fe07-4d5a-96d0-8433f75a11e6	cui_3	core	cuidado	chores	La distribución de las tareas domésticas y responsabilidades diarias se siente justa para ambos.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
577d218a-6018-426f-89e6-20063927cdfd	cui_4	core	cuidado	boundaries	Respetamos los límites personales de cada uno (espacio, tiempo a solas, privacidad).	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
01b08855-ffd1-4b08-a441-888f26e3c970	cui_5	core	cuidado	mental_load	Yo siento que compartimos la carga mental de planificar y administrar nuestra vida juntos.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
ccae8116-03d4-40f3-b688-10a13cb69767	cui_6	core	cuidado	reliability	Cuando mi pareja dice que hará algo importante, sé que lo cumplirá.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
3d30d148-c5ec-4276-835e-51db884d0854	cui_7	core	cuidado	forgiveness	Podemos perdonarnos genuinamente por errores del pasado sin volver a utilizarlos como armas.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
4013a181-b713-4ec1-ae83-93ab363d9816	cui_8	core	cuidado	external_stress	Somos un refugio seguro cuando el otro enfrenta un alto nivel de estrés externo (trabajo, familia).	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
d47a82f6-b6ca-4bba-a149-31d5eb76d9e8	cui_9	core	cuidado	respect	Nuestra comunicación cotidiana se mantiene en un tono de respeto, incluso si estamos cansados.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
ce109e5b-fb7f-41e4-adb8-72579a5031c2	cui_10	core	cuidado	independence	Siento que tengo espacio suficiente para fomentar mis propias amistades e individualidad.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
c25c2c5b-9e9d-4e6d-94cf-1ed2d468e5ec	cui_11	core	cuidado	health	Nos apoyamos y nos motivamos mutuamente a mantener estilos de vida saludables.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
3b271b8f-db66-49ad-9628-98d47af2e6d7	cui_12	core	cuidado	financial_safety	Hablamos transparentemente sobre el dinero y manejamos nuestra economía como un equipo.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
95cee713-49ac-40ff-8100-4d91d4d868d7	cui_13	core	cuidado	transparency	No ocultamos información importante ni tomamos decisiones significativas de manera unilateral.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
01cc175d-43ae-455c-b666-367370728ac7	cho_1	core	choque	conflict_resolution	Nuestras discusiones normalmente terminan en acuerdos y resoluciones en lugar de quedar en el aire.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
5165b173-6956-4de8-851d-30a6f05fb454	cho_2	core	choque	communication_style	Durante una pelea, ambos evitamos insultos, sarcasmo hiriente o menosprecios.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
2cca3653-084f-47c8-8fbb-1bf8cfea1796	cho_3	core	choque	deescalation	Si una discusión empieza a salirse de control, uno de los dos interviene para calmar la situación.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
d0d174f7-6cee-40b7-a4a6-5857550f64a8	cho_4	core	choque	defensiveness	Siento que mi pareja se pone constantemente a la defensiva cuando presento una pequeña queja.	LIKERT-5	[{"label": "Siempre", "order": 1, "value": "1"}, {"label": "Frecuentemente", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Rara vez", "order": 4, "value": "4"}, {"label": "Nunca", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
ca537df6-2be9-4c75-843f-be5dd5304901	cho_5	core	choque	repair_attempts	Mi pareja es buena notando y aceptando mis intentos por arreglar las cosas durante un enojo.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
e5b417dd-104e-48d7-b291-8e9741d32afd	cho_6	core	choque	stonewalling	A veces, durante los conflictos, mi pareja (o yo) "apaga" la comunicación y se aleja sin resolver nada.	LIKERT-5	[{"label": "Siempre", "order": 1, "value": "1"}, {"label": "Frecuentemente", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Rara vez", "order": 4, "value": "4"}, {"label": "Nunca", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
7ea507f8-9820-41e7-808f-feac53b868fe	cho_7	core	choque	grudges	Siento que seguimos teniendo exactamente la misma discusión una y otra vez sin progreso.	LIKERT-5	[{"label": "Siempre", "order": 1, "value": "1"}, {"label": "Frecuentemente", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Rara vez", "order": 4, "value": "4"}, {"label": "Nunca", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
9252dd8d-1dce-43b1-98f2-7f0e57300294	cho_8	core	choque	criticism	A menudo siento que recibo críticas sobre "quién soy", más que sobre lo que hago.	LIKERT-5	[{"label": "Siempre", "order": 1, "value": "1"}, {"label": "Frecuentemente", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Rara vez", "order": 4, "value": "4"}, {"label": "Nunca", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
99d50eda-0d8f-47bb-a54e-4eeb202d47ed	cho_9	core	choque	apologies	Ambos sabemos cómo pedir disculpas sinceras cuando nos damos cuenta de que el otro salió lastimado.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
57f313ce-c7be-40a6-bfe0-8e7c657a6211	cho_10	core	choque	compromise	Soy capaz de ceder y modificar mi punto de vista frente a argumentos válidos de mi pareja.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
bff44086-1273-4c1a-8a3e-011514966412	cho_11	core	choque	temper	El mal humor de mi pareja, o mi propio mal humor, a menudo dicta la energía emocional de la casa.	LIKERT-5	[{"label": "Siempre", "order": 1, "value": "1"}, {"label": "Frecuentemente", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Rara vez", "order": 4, "value": "4"}, {"label": "Nunca", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
3514cc73-b9bb-4482-9e1c-6f8841919971	cho_12	core	choque	post_conflict	Después de una pelea, nos reconectamos y sanamos rápidamente en lugar de mantenernos distantes por días.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
366bcb73-4ce8-4cdd-a70b-757241e32e6e	cho_13	core	choque	trigger_awareness	Conocemos los "botones" emocionales del otro y evitamos presionarlos intencionadamente.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
f08eeffd-45c5-4a58-acce-54cea3cdfa39	cam_1	core	camino	life_goals	Siento que nuestros grandes planes a futuro (donde vivir, estilo de vida) están alineados.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
75f2014b-1939-456a-9cd1-f5b93be67874	cam_2	core	camino	values	Compartimos valores fundamentales y una ética similar sobre cómo vivir y relacionarnos.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
aa77428f-51ca-4f6c-a595-0f3f25c45557	cam_3	core	camino	parenting	Estamos de acuerdo en nuestros deseos hacia formar una familia y los estilos de crianza.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
c98453c9-0bcf-45a3-99ea-a7d8b41fe194	cam_4	core	camino	career_support	Siento que mi pareja realmente apoya e invierte en mis sueños profesionales o ambiciones personales.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
c07655da-5952-4dc9-92c7-509a970727ea	cam_5	core	camino	financial_goals	Trabajamos juntos efectivamente para alcanzar nuestras metas financieras a largo plazo.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
28de9f60-797d-4875-b48c-be3bc55d966b	cam_6	core	camino	spirituality	Nuestras creencias filosóficas o espirituales coexisten de manera armoniosa.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
588048b0-f2ed-46b8-b500-938bdd67b4a6	cam_7	core	camino	traditions	Disfrutamos construyendo nuestras propias tradiciones como pareja o familia.	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
cdc6973c-643b-4c5a-9fb1-bb3911b4611f	cam_8	core	camino	legacy	A menudo hablamos sobre lo que queremos lograr juntos a largo plazo (el legado e impacto).	LIKERT-5	[{"label": "Nunca", "order": 1, "value": "1"}, {"label": "Rara vez", "order": 2, "value": "2"}, {"label": "A veces", "order": 3, "value": "3"}, {"label": "Frecuentemente", "order": 4, "value": "4"}, {"label": "Siempre", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
72869f53-a7a7-4a17-9a94-eed08c35a8c6	cam_9	core	camino	adaptability	Hemos demostrado que podemos adaptarnos exitosamente frente a grandes cambios de vida juntos.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
3e808329-afea-43d4-94cd-f5a9cf4da7ea	cam_10	core	camino	growth	Ambos estamos activamente buscando crecer y evolucionar como personas dentro de la relación.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
5662bce0-f445-4503-95a6-42bfe2e425ce	cam_11	core	camino	extended_family	Estamos de acuerdo en cómo manejar a nuestra familia extendida y sus influencias.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
c4d7c07d-5603-42d6-87a9-1aebcc473a1d	cam_12	core	camino	lifestyle	Tenemos expectativas compatibles sobre qué es una "buena vida" en el día a día.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
69a8bd84-763a-4c96-8f33-9e7ce9926478	cam_13	core	camino	partnership	Por encima de todo, nos consideramos genuinos compañeros de vida listos para la siguiente etapa.	LIKERT-5	[{"label": "Totalmente en desacuerdo", "order": 1, "value": "1"}, {"label": "En desacuerdo", "order": 2, "value": "2"}, {"label": "Neutral", "order": 3, "value": "3"}, {"label": "De acuerdo", "order": 4, "value": "4"}, {"label": "Totalmente de acuerdo", "order": 5, "value": "5"}]	f	normal	f	direct	0	t	1.0	{}	2026-03-29 21:56:27.153944+00	2026-03-29 21:56:27.153944+00
\.


--
-- Data for Name: item_dimensions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.item_dimensions (id, item_id, dimension_slug, weight, created_at) FROM stdin;
ab92ca59-0cd6-4149-a90d-6faefabc2124	16d6e03c-e92e-43d8-862a-a9dee9390050	autonomy	1.000	2026-03-29 04:32:21.030761+00
54be5749-4a77-4588-a00f-06e1b288ed89	dea3715f-46f9-4b79-8e00-8925c6dcbd6f	autonomy	1.000	2026-03-29 04:32:21.030761+00
a242da58-f363-4434-a758-428a18a4210a	01d56775-795f-4f7a-b035-ca970c5aef27	reassurance	1.000	2026-03-29 04:32:21.030761+00
9c570e7a-ca8f-444c-9935-4444323af40a	0a5b4e20-6e7c-40c4-ac7d-a3b3dbcb8283	reassurance	1.000	2026-03-29 04:32:21.030761+00
3001e331-bfcb-4d93-8c9a-46e0efff242a	1825d649-67e0-41b5-bc30-e8f46beea55a	conflict	1.000	2026-03-29 04:32:21.030761+00
5f688d9f-bf8a-4d96-929b-5bd03a71fbdd	c50e9d56-7ba8-4cd5-b9b8-26e148b52456	conflict	1.000	2026-03-29 04:32:21.030761+00
8f4af385-0f81-4ede-9a04-c537d39f621a	637c2d6c-4da6-48e4-9596-b32abb028598	conflict	1.000	2026-03-29 04:32:21.030761+00
2e039be6-d0c2-44e7-909e-ba621ddc563f	aaab699c-4b05-4c99-8c81-dc87a11442c2	stress_coping	1.000	2026-03-29 04:32:21.030761+00
fe6efb3d-cdd0-44d0-b2d4-f4ad4516371a	aa969efb-0b7f-44b9-9600-5941c6408352	stress_coping	1.000	2026-03-29 04:32:21.030761+00
5ecd589f-71c9-4d2c-8a26-1b31c91b39b5	2d2f78b9-e938-4092-be5a-f3908b0096b8	emotional_expression	1.000	2026-03-29 04:32:21.030761+00
40dcbdb5-ba03-49b0-a410-c941f15d86ad	9652f29e-8dab-4236-b0fc-e5b00ad99022	emotional_expression	1.000	2026-03-29 04:32:21.030761+00
255ba4e3-2ba7-481d-b541-ef0cc6e7eda8	d99723bb-ed2d-4be6-8737-07346133243c	rituals	1.000	2026-03-29 04:32:21.030761+00
03afde20-f0c8-4b66-bacc-6cc2c3515898	336395c7-eab0-4462-be3e-58e2ab5de197	rituals	1.000	2026-03-29 04:32:21.030761+00
4d698ef1-0397-4b02-9b72-575a4ad6bf3c	9a07d5d6-e513-4c89-a97d-345a4ca8f89a	future_orientation	1.000	2026-03-29 04:32:21.030761+00
d31b8cab-594a-46aa-aa6f-d4427b49a76f	a49cdbde-ecfa-4b2a-bdb6-6c07e425dc65	future_orientation	1.000	2026-03-29 04:32:21.030761+00
\.


--
-- Data for Name: milestones; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.milestones (id, couple_id, title, milestone_type, date, created_at) FROM stdin;
\.


--
-- Data for Name: nosotros_narratives; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.nosotros_narratives (id, couple_id, narrative_type, dimension_slug, title, body, metadata, generated_by, created_at, updated_at) FROM stdin;
f04003aa-72e6-4832-ab53-61b88310512e	b0f53c25-5fae-445c-8261-e06d1716b4d3	relationship_story	\N	Nuestra Historia	Melanie y Ricardo construyen su historia con la mirada puesta en un futuro compartido, donde el "Camino" que trazan juntos es su brújula más fuerte. Son una pareja que encuentra belleza en la dirección y el propósito, aunque a veces las corrientes de la "Conexión" y el "Cuidado" necesiten una caricia extra. Su magia reside en la promesa de avanzar, un paso a la vez, hacia los sueños que los definen.	{"my4C": {"camino": 73, "choque": 63, "cuidado": 63, "conexion": 63}, "partner4C": {"camino": 73, "choque": 53, "cuidado": 60, "conexion": 68}}	gemini-2.5-flash	2026-03-30 06:55:36.406761+00	2026-03-30 06:55:36.406761+00
08da5e0a-34c9-4393-82f2-b98ce38eb678	b0f53c25-5fae-445c-8261-e06d1716b4d3	layer_summary	conexion	Conexión	La Conexión entre Melanie y Ricardo es un tejido que se va creando día a día, con hilos que a veces se sienten más apretados y otras un poco más sueltos. Ricardo parece percibir un lazo ligeramente más firme, un llamado a la cercanía emocional que ambos buscan nutrir. Es un espacio donde sus corazones se buscan, anhelando esa sintonía que los hace sentir plenamente entendidos.	{}	gemini-2.5-flash	2026-03-30 06:55:36.406761+00	2026-03-30 06:55:36.406761+00
b59b05cc-49ee-4869-93d7-70d868b24f66	b0f53c25-5fae-445c-8261-e06d1716b4d3	layer_summary	cuidado	Cuidado	El Cuidado en su relación se manifiesta en esas pequeñas y grandes atenciones que se brindan mutuamente. Melanie parece sentir y ofrecer un poco más de este abrigo, creando un ambiente de apoyo, mientras que Ricardo también contribuye a esa red de soporte. Es una danza de generosidad donde ambos procuran ser el refugio amable del otro.	{}	gemini-2.5-flash	2026-03-30 06:55:36.406761+00	2026-03-30 06:55:36.406761+00
e164b9dd-0329-4e83-bcef-eaf2f8683325	b0f53c25-5fae-445c-8261-e06d1716b4d3	layer_summary	choque	Conflicto	En el terreno del Choque, Melanie y Ricardo encuentran un área importante para seguir creciendo. Ricardo siente que manejar las tensiones o los desacuerdos puede ser un reto, un espacio donde a veces la comunicación se enreda. Es una oportunidad para explorar nuevas formas de dialogar, transformando los momentos difíciles en puentes hacia una mayor comprensión.	{}	gemini-2.5-flash	2026-03-30 06:55:36.406761+00	2026-03-30 06:55:36.406761+00
e72834e4-4045-42d6-89de-333393cb3547	b0f53c25-5fae-445c-8261-e06d1716b4d3	layer_summary	camino	Camino	El Camino es una de las grandes fortalezas que unen a Melanie y Ricardo, un faro que ilumina su andar. Comparten una visión clara y un entusiasmo genuino por los sueños y proyectos de vida que construyen hombro a hombro. Esta alineación en sus metas les brinda una base sólida y un sentido de propósito que los impulsa con alegría hacia adelante.	{}	gemini-2.5-flash	2026-03-30 06:55:36.406761+00	2026-03-30 06:55:36.406761+00
10abc908-1f2f-4ecc-96c6-5e7208101736	b0f53c25-5fae-445c-8261-e06d1716b4d3	growth_tip	tip_1	Consejo 1	Esta semana, cuando surja un pequeño desacuerdo, Melanie y Ricardo pueden intentar una 'pausa de curiosidad'. En lugar de buscar una solución inmediata, cada uno expresará: 'Me da curiosidad entender mejor tu punto de vista sobre esto'. Luego, dedicarán 5 minutos a escuchar al otro sin interrumpir, solo para entender, antes de intentar responder o resolver.	{}	gemini-2.5-flash	2026-03-30 06:55:36.406761+00	2026-03-30 06:55:36.406761+00
a9a59cf1-cdc0-4f97-a212-502a74e83707	b0f53c25-5fae-445c-8261-e06d1716b4d3	growth_tip	tip_2	Consejo 2	Cada día, al menos una vez, Melanie y Ricardo se darán un 'mini-abrazo' de 10 segundos. La intención es sentir la presencia física del otro y recargar la conexión emocional sin necesidad de palabras. Es un gesto simple pero poderoso para nutrir el cuidado mutuo.	{}	gemini-2.5-flash	2026-03-30 06:55:36.406761+00	2026-03-30 06:55:36.406761+00
4ca0bcb2-86d1-4a66-9229-99520118e94d	b0f53c25-5fae-445c-8261-e06d1716b4d3	growth_tip	tip_3	Consejo 3	Dediquen una noche esta semana a planear juntos una pequeña actividad divertida para el fin de semana que ambos disfruten, sin que sea una obligación. Puede ser ver una película, salir a caminar o preparar una comida especial. El objetivo es crear un momento de ocio y disfrute compartido que refuerce su camino de vida juntos y su conexión alegre.	{}	gemini-2.5-flash	2026-03-30 06:55:36.406761+00	2026-03-30 06:55:36.406761+00
\.


--
-- Data for Name: onboarding_responses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.onboarding_responses (id, session_id, item_id, answer_value, answered_at) FROM stdin;
fecbfa48-ba5a-4a36-8ab9-607afe7d195e	477ff6ab-7473-48ac-827a-9c80d8c41731	onb-01	{"value": "5"}	2026-03-30 06:28:42.032+00
f6901131-0cf3-4342-a9d2-e480af58eea3	477ff6ab-7473-48ac-827a-9c80d8c41731	onb-02	{"value": "3"}	2026-03-30 06:29:02.577+00
224c184c-3f8c-48ce-b034-cd1b400d1cb5	477ff6ab-7473-48ac-827a-9c80d8c41731	onb-03	{"value": "3"}	2026-03-30 06:29:10.961+00
b9f290f1-46ea-4a3f-a9fb-fbec90a8fb84	477ff6ab-7473-48ac-827a-9c80d8c41731	onb-04	{"value": "5"}	2026-03-30 06:29:16.063+00
906b994a-7d8e-4cb8-9ce3-e1f7d3aabc93	477ff6ab-7473-48ac-827a-9c80d8c41731	onb-05	{"value": "4"}	2026-03-30 06:30:12.023+00
5a589a44-40c6-48a9-8f11-15bca74ab227	477ff6ab-7473-48ac-827a-9c80d8c41731	onb-06	{"value": "3"}	2026-03-30 06:30:20.448+00
588ddd44-306f-48bb-bb70-70bce11bf3c3	477ff6ab-7473-48ac-827a-9c80d8c41731	onb-07	{"value": "2"}	2026-03-30 06:30:28.565+00
f74f98df-4990-43c2-9b6f-4cab960542d0	477ff6ab-7473-48ac-827a-9c80d8c41731	onb-08	{"value": "D"}	2026-03-30 06:30:35.258+00
8c493d78-53fb-4992-ae31-216253410369	4861462f-de2b-4d3d-a13a-cccd972a457a	onb-01	{"value": "5"}	2026-03-30 06:30:35.541+00
795c4b25-86f7-4f75-b1d1-7d82a2f00f9a	4861462f-de2b-4d3d-a13a-cccd972a457a	onb-02	{"value": "5"}	2026-03-30 06:30:40.996+00
00e99a23-a5c4-4193-b55c-fbfcc5380c00	477ff6ab-7473-48ac-827a-9c80d8c41731	onb-09	{"value": "C"}	2026-03-30 06:30:45.592+00
57a3b898-4a04-4efd-ad3e-bdca52d82031	477ff6ab-7473-48ac-827a-9c80d8c41731	onb-10	{"value": "4"}	2026-03-30 06:30:52.317+00
0be51a4b-0d21-4f61-aa13-d5710284c049	4861462f-de2b-4d3d-a13a-cccd972a457a	onb-03	{"value": "5"}	2026-03-30 06:30:54.076+00
eda7e02a-a7c8-44dd-a81d-10d7561f8156	477ff6ab-7473-48ac-827a-9c80d8c41731	onb-11	{"value": "4"}	2026-03-30 06:30:56.177+00
1042e941-3cfa-4e28-9ddf-c8761ad5fc03	477ff6ab-7473-48ac-827a-9c80d8c41731	onb-12	{"value": "5"}	2026-03-30 06:31:02.332+00
91eb1855-94b7-4985-afc8-618d0d1aa6a4	477ff6ab-7473-48ac-827a-9c80d8c41731	onb-13	{"value": "4"}	2026-03-30 06:31:05.995+00
ab1ffb8a-e5b6-4121-ad8e-47d5536c17ee	477ff6ab-7473-48ac-827a-9c80d8c41731	onb-14	{"value": "5"}	2026-03-30 06:31:09.34+00
8e27fc66-de50-4c4e-8f3e-177aa46e89fc	477ff6ab-7473-48ac-827a-9c80d8c41731	onb-15	{"value": "4"}	2026-03-30 06:31:12.645+00
ec60c6cc-b248-4684-a9c9-32665dd7bc41	4861462f-de2b-4d3d-a13a-cccd972a457a	onb-04	{"value": "4"}	2026-03-30 06:31:15.898+00
f7a4cc54-ada3-4230-a733-48f8cdbc96fe	4861462f-de2b-4d3d-a13a-cccd972a457a	onb-05	{"value": "3"}	2026-03-30 06:31:54.909+00
24b85d0f-2ca5-482a-b941-bbe0b12b225d	4861462f-de2b-4d3d-a13a-cccd972a457a	onb-06	{"value": "2"}	2026-03-30 06:32:17.22+00
764155d9-e520-47a4-9df7-63bc447a0c1a	4861462f-de2b-4d3d-a13a-cccd972a457a	onb-07	{"value": "3"}	2026-03-30 06:32:27.937+00
4223481b-eed0-428c-92c8-6bfeb06e38c8	4861462f-de2b-4d3d-a13a-cccd972a457a	onb-08	{"value": "B"}	2026-03-30 06:32:55.615+00
0f5f250f-335c-4822-a429-7b4615d6eabb	4861462f-de2b-4d3d-a13a-cccd972a457a	onb-09	{"value": "A"}	2026-03-30 06:33:47.697+00
9b898392-c78f-4c36-8c9f-e2aa1cdb99e6	4861462f-de2b-4d3d-a13a-cccd972a457a	onb-10	{"value": "1"}	2026-03-30 06:34:02.22+00
e896653c-f0a4-4b5a-8df1-f7d5cf1b6123	4861462f-de2b-4d3d-a13a-cccd972a457a	onb-11	{"value": "4"}	2026-03-30 06:34:13.064+00
874fc14a-0e87-483e-92a2-aca7dbfdd572	4861462f-de2b-4d3d-a13a-cccd972a457a	onb-12	{"value": "5"}	2026-03-30 06:34:18.743+00
82554cb1-d7d5-4f60-82e2-0799338e44c4	4861462f-de2b-4d3d-a13a-cccd972a457a	onb-13	{"value": "5"}	2026-03-30 06:34:24.272+00
ffcd7cbc-7f89-4bcf-913c-111b576c10e2	4861462f-de2b-4d3d-a13a-cccd972a457a	onb-14	{"value": "4"}	2026-03-30 06:34:35.694+00
b0df73eb-330f-4614-b6cd-62465a907a21	4861462f-de2b-4d3d-a13a-cccd972a457a	onb-15	{"value": "5"}	2026-03-30 06:34:43.473+00
\.


--
-- Data for Name: onboarding_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.onboarding_sessions (id, user_id, status, current_question_index, progress_pct, responses, started_at, completed_at, created_at, updated_at) FROM stdin;
477ff6ab-7473-48ac-827a-9c80d8c41731	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	completed	14	100	{"onb-01": "5", "onb-02": "3", "onb-03": "3", "onb-04": "5", "onb-05": "4", "onb-06": "3", "onb-07": "2", "onb-08": "D", "onb-09": "C", "onb-10": "4", "onb-11": "4", "onb-12": "5", "onb-13": "4", "onb-14": "5", "onb-15": "4"}	2026-03-30 06:28:29.762433+00	2026-03-30 06:31:13.421+00	2026-03-30 06:28:29.762433+00	2026-03-30 06:31:13.421+00
4861462f-de2b-4d3d-a13a-cccd972a457a	10f86299-e9f4-4731-8089-657b202866b2	completed	14	100	{"onb-01": "5", "onb-02": "5", "onb-03": "5", "onb-04": "4", "onb-05": "3", "onb-06": "2", "onb-07": "3", "onb-08": "B", "onb-09": "A", "onb-10": "1", "onb-11": "4", "onb-12": "5", "onb-13": "5", "onb-14": "4", "onb-15": "5"}	2026-03-30 06:28:30.60658+00	2026-03-30 06:34:44.452+00	2026-03-30 06:28:30.60658+00	2026-03-30 06:34:44.452+00
\.


--
-- Data for Name: personal_reports; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.personal_reports (id, user_id, session_id, archetype, summary, strengths, growth_areas, created_at) FROM stdin;
\.


--
-- Data for Name: profile_vectors; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.profile_vectors (id, user_id, dimension_slug, raw_score, normalized_score, item_count, version, created_at, updated_at) FROM stdin;
dc4e9f83-1a21-4163-82e8-b523095d2c68	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	autonomy	4.00	80.00	3	1	2026-03-30 06:31:13.077756+00	2026-03-30 06:31:13.027+00
07c5ea02-3f0d-4a07-a998-3f81dcb27327	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	reassurance	4.00	80.00	3	1	2026-03-30 06:31:13.157883+00	2026-03-30 06:31:13.125+00
30a4fd2f-a4f4-4fd4-b178-56ecc3855094	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	conflict	2.75	55.00	4	1	2026-03-30 06:31:13.220178+00	2026-03-30 06:31:13.181+00
6729acc6-277c-4124-8d34-df0318b1e5bd	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	emotional_expression	4.00	80.00	3	1	2026-03-30 06:31:13.275999+00	2026-03-30 06:31:13.242+00
e7f88277-887d-4231-ba83-b4008e72aa9f	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	rituals	4.50	90.00	2	1	2026-03-30 06:31:13.338882+00	2026-03-30 06:31:13.298+00
673ca600-fbf2-4f92-b03b-40def15b93f9	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	future_orientation	4.50	90.00	2	1	2026-03-30 06:31:13.398798+00	2026-03-30 06:31:13.365+00
d011fdf4-7381-4347-b9d7-c3693e029278	10f86299-e9f4-4731-8089-657b202866b2	autonomy	4.00	80.00	3	1	2026-03-30 06:34:43.944125+00	2026-03-30 06:34:43.886+00
627d64d8-a093-4ea3-bd9b-6fa518d1d3d0	10f86299-e9f4-4731-8089-657b202866b2	reassurance	4.50	90.00	2	1	2026-03-30 06:34:44.053985+00	2026-03-30 06:34:44.004+00
588061f5-4299-46a3-bfd8-a405f8b09cf7	10f86299-e9f4-4731-8089-657b202866b2	conflict	3.80	76.00	5	1	2026-03-30 06:34:44.142171+00	2026-03-30 06:34:44.094+00
bd002a41-66c1-473e-81f2-a2e510f06e4b	10f86299-e9f4-4731-8089-657b202866b2	emotional_expression	2.67	53.00	3	1	2026-03-30 06:34:44.234732+00	2026-03-30 06:34:44.181+00
da85c693-5500-4908-a8ad-f582f33be292	10f86299-e9f4-4731-8089-657b202866b2	rituals	5.00	100.00	2	1	2026-03-30 06:34:44.325758+00	2026-03-30 06:34:44.279+00
4964d90e-edc1-40e1-8973-dd2187749e7f	10f86299-e9f4-4731-8089-657b202866b2	future_orientation	4.50	90.00	2	1	2026-03-30 06:34:44.411992+00	2026-03-30 06:34:44.365+00
\.


--
-- Data for Name: profiles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.profiles (id, full_name, avatar_url, locale, timezone, created_at, updated_at, birthdate, gender, bio, nickname) FROM stdin;
0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	Ricardo	https://dnjqznvhetmemojhlvao.supabase.co/storage/v1/object/public/avatars/0c8670a1-b6df-46f8-a9a5-b62247c5ddc2/avatar.jpeg	es-MX	America/Mexico_City	2026-03-30 02:37:08.855191+00	2026-03-30 07:08:03.334+00	\N	\N	\N	\N
10f86299-e9f4-4731-8089-657b202866b2	Melanie	https://dnjqznvhetmemojhlvao.supabase.co/storage/v1/object/public/avatars/0c8670a1-b6df-46f8-a9a5-b62247c5ddc2/avatar.jpeg	es-MX	America/Mexico_City	2026-03-30 02:37:23.568156+00	2026-03-30 06:28:21.765+00	\N	\N	\N	\N
\.


--
-- Data for Name: question_dimension_map; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.question_dimension_map (id, question_id, dimension_id, weight) FROM stdin;
\.


--
-- Data for Name: questionnaire_sections; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.questionnaire_sections (id, questionnaire_id, slug, name, description, sort_order, estimated_questions, created_at) FROM stdin;
0a79d06f-20fc-4718-aca8-b092cbc29235	b6361e38-b098-4262-bca3-2d42e7a5cb19	section-a	Conexión	Intimidad emocional, rituales, humor, curiosidad, tiempo juntos	1	13	2026-03-29 04:32:21.030761+00
6f55738d-90a1-41a0-beb1-7a4fc004ef58	b6361e38-b098-4262-bca3-2d42e7a5cb19	section-b	Cuidado	Lenguajes del afecto, apoyo, validación, atención, reparación	2	13	2026-03-29 04:32:21.030761+00
02b23cf5-a7ee-4e8d-a59b-392769b9cf09	b6361e38-b098-4262-bca3-2d42e7a5cb19	section-c	Choque	Conflicto, límites, reactividad, evasión, cierre	3	13	2026-03-29 04:32:21.030761+00
be2cbb5a-e766-4c0b-ac0e-bf4fa9559082	b6361e38-b098-4262-bca3-2d42e7a5cb19	section-d	Camino	Metas, dinero, familia, hogar, identidad	4	13	2026-03-29 04:32:21.030761+00
\.


--
-- Data for Name: questionnaires; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.questionnaires (id, slug, name, description, version, is_active, estimated_duration_minutes, created_at) FROM stdin;
b6361e38-b098-4262-bca3-2d42e7a5cb19	relacion-v2	Evaluación de Pareja V2	Evaluación personalizada de relación construida a partir de perfiles individuales.	2.0	t	20	2026-03-29 04:32:21.030761+00
\.


--
-- Data for Name: questions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.questions (id, section_id, question_number, question_text, question_type, is_sensitive, is_required, is_opt_in, metadata, created_at) FROM stdin;
\.


--
-- Data for Name: response_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.response_sessions (id, user_id, questionnaire_id, section_id, status, started_at, completed_at, progress_pct, current_section, current_question_index, stage, generated_assessment_id) FROM stdin;
f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	10f86299-e9f4-4731-8089-657b202866b2	b6361e38-b098-4262-bca3-2d42e7a5cb19	\N	completed	2026-03-30 06:36:41.08663+00	2026-03-30 06:51:11.743+00	100	\N	0	couple_v2	bc4faaf6-eb5a-463c-ad09-d855d6b0a145
45201d83-446b-4077-bcd5-78ff905e53d2	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	b6361e38-b098-4262-bca3-2d42e7a5cb19	\N	completed	2026-03-30 06:36:49.700303+00	2026-03-30 06:43:06.554+00	100	\N	0	couple_v2	553f5084-abf0-4a92-ad32-52f528d61c24
\.


--
-- Data for Name: responses; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.responses (id, session_id, question_id, answer_value, answered_at) FROM stdin;
2e15aba1-3594-4b56-8495-c39f284b0b08	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	1c5049b0-deff-4ae4-b0b3-da1bc1980632	{"value": "2"}	2026-03-30 06:37:00.333+00
1da00638-18c4-493d-996b-b48daa7f72e0	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	4651de3e-1801-4615-ad0d-a552eede880a	{"value": "4"}	2026-03-30 06:37:32.067+00
f945d39e-b4ae-4f9b-85c2-0866f4600794	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	a964335d-d875-4148-a173-7deb2a1af63d	{"value": "3"}	2026-03-30 06:37:56.098+00
f6f66790-9061-461a-8ca2-3f24a4c3185e	45201d83-446b-4077-bcd5-78ff905e53d2	1c5049b0-deff-4ae4-b0b3-da1bc1980632	{"value": "3"}	2026-03-30 06:37:56.211+00
fba67bef-ef18-488f-bc64-0e5663bc73fc	45201d83-446b-4077-bcd5-78ff905e53d2	4651de3e-1801-4615-ad0d-a552eede880a	{"value": "4"}	2026-03-30 06:38:00.416+00
4efec8ef-a104-4c1d-8692-61c093f5dcd5	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	ba5f53f0-d61b-4e1a-9844-03ea78368c73	{"value": "4"}	2026-03-30 06:38:05.538+00
5e382a63-56ea-41b8-a8df-62c4b6d29e82	45201d83-446b-4077-bcd5-78ff905e53d2	a964335d-d875-4148-a173-7deb2a1af63d	{"value": "5"}	2026-03-30 06:38:06.352+00
98ba1f0f-33b3-4f59-8ea5-1f48ee7fbb13	45201d83-446b-4077-bcd5-78ff905e53d2	ba5f53f0-d61b-4e1a-9844-03ea78368c73	{"value": "5"}	2026-03-30 06:38:09.49+00
4738acd8-7b8a-4f28-9df9-28e6f5abb886	45201d83-446b-4077-bcd5-78ff905e53d2	751c864f-651f-4594-81fe-c5b802c4467d	{"value": "3"}	2026-03-30 06:38:13.779+00
2a2176f2-f0d9-4c04-8c77-518e94e11e68	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	751c864f-651f-4594-81fe-c5b802c4467d	{"value": "3"}	2026-03-30 06:38:15.763+00
37942329-f9fd-41e9-8636-0c0c4f60022f	45201d83-446b-4077-bcd5-78ff905e53d2	bbbd3ce9-d98b-450a-9567-b8414b2dabdc	{"value": "2"}	2026-03-30 06:38:20.747+00
b094232c-2abd-47dd-beab-44aa057bec90	45201d83-446b-4077-bcd5-78ff905e53d2	8d3e191f-ea87-4fa3-b0ae-e59bd7aef1d5	{"value": "3"}	2026-03-30 06:38:26.1+00
a8edf29b-4d67-4018-92b1-4f1d0a3e0813	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	9d579de8-e22c-4d92-bde8-061cd5acbd9b	{"value": "1"}	2026-03-30 06:38:29.908+00
cbe2a6d6-93b5-440e-844b-06968804ae2e	45201d83-446b-4077-bcd5-78ff905e53d2	8777a793-dad9-4881-8547-2c267562e97b	{"value": "5"}	2026-03-30 06:38:33.232+00
d2d72793-032c-4460-9c52-bb250af271f7	45201d83-446b-4077-bcd5-78ff905e53d2	d76a6541-fe07-4d5a-96d0-8433f75a11e6	{"value": "3"}	2026-03-30 06:38:39.856+00
e634be49-52ba-43c1-a17e-1fc7df71c9f2	45201d83-446b-4077-bcd5-78ff905e53d2	01b08855-ffd1-4b08-a441-888f26e3c970	{"value": "2"}	2026-03-30 06:38:45.638+00
828a6f94-f7ec-4229-93af-a7f90b430730	45201d83-446b-4077-bcd5-78ff905e53d2	ccae8116-03d4-40f3-b688-10a13cb69767	{"value": "5"}	2026-03-30 06:38:49.4+00
21a9d05c-c7f0-4dd7-9262-a14ac7aba4d6	45201d83-446b-4077-bcd5-78ff905e53d2	4013a181-b713-4ec1-ae83-93ab363d9816	{"value": "4"}	2026-03-30 06:38:53.46+00
0020904a-ab36-4323-80d1-a7b7532f2727	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	8d3e191f-ea87-4fa3-b0ae-e59bd7aef1d5	{"value": "3"}	2026-03-30 06:38:57.893+00
b7a505ad-4afc-4fdf-8708-0a50a7ac6cd4	45201d83-446b-4077-bcd5-78ff905e53d2	ce109e5b-fb7f-41e4-adb8-72579a5031c2	{"value": "3"}	2026-03-30 06:39:01.188+00
31f4393b-d2ce-4aa4-aef3-f6b212ede67e	45201d83-446b-4077-bcd5-78ff905e53d2	95cee713-49ac-40ff-8100-4d91d4d868d7	{"value": "2"}	2026-03-30 06:39:05.509+00
b7b17e96-5d37-4dc6-a3a1-eef04ad19a7a	45201d83-446b-4077-bcd5-78ff905e53d2	01cc175d-43ae-455c-b666-367370728ac7	{"value": "3"}	2026-03-30 06:39:10.478+00
54cb3bb3-5401-4742-b485-1df4d800b84d	45201d83-446b-4077-bcd5-78ff905e53d2	5165b173-6956-4de8-851d-30a6f05fb454	{"value": "2"}	2026-03-30 06:39:14.889+00
80f34653-b679-4538-9c7e-c360d9725b79	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	4025046d-4dd8-4b0c-a4f2-a174337819e7	{"value": "3"}	2026-03-30 06:39:18.571+00
901576ef-18d7-4b88-8300-4f1e57d60573	45201d83-446b-4077-bcd5-78ff905e53d2	2cca3653-084f-47c8-8fbb-1bf8cfea1796	{"value": "2"}	2026-03-30 06:41:38.827+00
43369970-9f5a-4d43-8a31-9da38f5ae81c	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	c64c953c-7999-410c-96d7-063aa684d804	{"value": "3"}	2026-03-30 06:41:40.865+00
0ba42d30-2272-46ad-824e-6948a944cb87	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	8777a793-dad9-4881-8547-2c267562e97b	{"value": "5"}	2026-03-30 06:41:53.074+00
522f4f7f-488c-4214-856f-2e2790083197	45201d83-446b-4077-bcd5-78ff905e53d2	d0d174f7-6cee-40b7-a4a6-5857550f64a8	{"value": "2"}	2026-03-30 06:41:54.315+00
9fec2041-fc96-4317-ab57-d759a15827e0	45201d83-446b-4077-bcd5-78ff905e53d2	e5b417dd-104e-48d7-b291-8e9741d32afd	{"value": "3"}	2026-03-30 06:42:16.24+00
f95f3372-4f50-4cbe-9e2d-0393a3209779	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	577d218a-6018-426f-89e6-20063927cdfd	{"value": "3"}	2026-03-30 06:42:17.493+00
19ef1668-a113-433f-9881-b115a8cfe6a4	45201d83-446b-4077-bcd5-78ff905e53d2	7ea507f8-9820-41e7-808f-feac53b868fe	{"value": "2"}	2026-03-30 06:42:23.076+00
0c89624b-4f8a-4de7-9d8b-ceec7d3d451a	45201d83-446b-4077-bcd5-78ff905e53d2	99d50eda-0d8f-47bb-a54e-4eeb202d47ed	{"value": "5"}	2026-03-30 06:42:28.377+00
46a72ca4-156e-4425-a912-842353eca80b	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	01b08855-ffd1-4b08-a441-888f26e3c970	{"value": "2"}	2026-03-30 06:42:31.664+00
8b53e2d9-cf00-4097-9f9b-0b612eb400c7	45201d83-446b-4077-bcd5-78ff905e53d2	f08eeffd-45c5-4a58-acce-54cea3cdfa39	{"value": "4"}	2026-03-30 06:42:35.818+00
20d63e26-0595-475e-bd15-6a797a67033b	45201d83-446b-4077-bcd5-78ff905e53d2	75f2014b-1939-456a-9cd1-f5b93be67874	{"value": "5"}	2026-03-30 06:42:38.769+00
203ca247-519c-49d0-a071-d29f8d8f6e9f	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	4013a181-b713-4ec1-ae83-93ab363d9816	{"value": "2"}	2026-03-30 06:42:40.422+00
54e85420-2869-478b-86ff-dc394de6c1c8	45201d83-446b-4077-bcd5-78ff905e53d2	c98453c9-0bcf-45a3-99ea-a7d8b41fe194	{"value": "2"}	2026-03-30 06:42:43.176+00
fb5448e8-5c23-4c1b-adb6-b3f46dea0407	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	ce109e5b-fb7f-41e4-adb8-72579a5031c2	{"value": "3"}	2026-03-30 06:42:45.857+00
6110a188-3bcf-4bb2-8588-7c7e1ed034cd	45201d83-446b-4077-bcd5-78ff905e53d2	c07655da-5952-4dc9-92c7-509a970727ea	{"value": "3"}	2026-03-30 06:42:51.417+00
a339788f-d565-4fb5-9471-2c376658e163	45201d83-446b-4077-bcd5-78ff905e53d2	cdc6973c-643b-4c5a-9fb1-bb3911b4611f	{"value": "4"}	2026-03-30 06:42:55.768+00
9996ca15-e08c-4294-90be-f12121265627	45201d83-446b-4077-bcd5-78ff905e53d2	3e808329-afea-43d4-94cd-f5a9cf4da7ea	{"value": "4"}	2026-03-30 06:42:59.531+00
54208220-c936-4553-ad49-91cac3df42cc	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	3b271b8f-db66-49ad-9628-98d47af2e6d7	{"value": "4"}	2026-03-30 06:43:05.431+00
557efa34-f561-40d5-a173-fd5d18e2d62d	45201d83-446b-4077-bcd5-78ff905e53d2	c4d7c07d-5603-42d6-87a9-1aebcc473a1d	{"value": "5"}	2026-03-30 06:43:06.147+00
fce063f4-f1ce-45f4-a78b-7ff4c09316e3	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	01cc175d-43ae-455c-b666-367370728ac7	{"value": "2"}	2026-03-30 06:44:24.099+00
cca130fd-1cd5-4c3f-b5c4-515a8abbb1db	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	5165b173-6956-4de8-851d-30a6f05fb454	{"value": "2"}	2026-03-30 06:44:36.177+00
a4cb2c35-100b-4bd3-b31e-18fe9a2fd799	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	2cca3653-084f-47c8-8fbb-1bf8cfea1796	{"value": "3"}	2026-03-30 06:45:26.907+00
e0954f4f-bbe9-4462-ab2a-2334fa1a40ac	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	d0d174f7-6cee-40b7-a4a6-5857550f64a8	{"value": "2"}	2026-03-30 06:45:36.382+00
3f3513f2-66b1-491a-94b4-e9459c165ae7	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	e5b417dd-104e-48d7-b291-8e9741d32afd	{"value": "1"}	2026-03-30 06:47:39.817+00
a617db1f-d3cd-493d-a96c-be2a0e461070	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	7ea507f8-9820-41e7-808f-feac53b868fe	{"value": "1"}	2026-03-30 06:47:45.416+00
dbb3f4b5-cf34-4add-80da-de2af82e2ddb	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	99d50eda-0d8f-47bb-a54e-4eeb202d47ed	{"value": "3"}	2026-03-30 06:49:33.184+00
6cb3b119-8646-4cf6-937f-e511aff0c50b	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	3514cc73-b9bb-4482-9e1c-6f8841919971	{"value": "3"}	2026-03-30 06:49:47.471+00
46c5ac84-931a-4b17-be02-594d742287be	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	f08eeffd-45c5-4a58-acce-54cea3cdfa39	{"value": "1"}	2026-03-30 06:49:57.233+00
9293194d-32a2-456d-8ca8-1dbf6f462c88	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	75f2014b-1939-456a-9cd1-f5b93be67874	{"value": "4"}	2026-03-30 06:50:15.477+00
bca7ab65-9996-487e-a4d3-1b96ed8c462e	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	c98453c9-0bcf-45a3-99ea-a7d8b41fe194	{"value": "4"}	2026-03-30 06:50:33.155+00
1d84e10b-b450-4c8a-aaac-c15f51700c65	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	3e808329-afea-43d4-94cd-f5a9cf4da7ea	{"value": "3"}	2026-03-30 06:50:51.183+00
fd05f147-fdf2-4b0b-b3ba-a18013d62a85	f65c9ab0-a470-4da5-9fac-39f0e0e3d61a	c4d7c07d-5603-42d6-87a9-1aebcc473a1d	{"value": "2"}	2026-03-30 06:51:11.2+00
\.


--
-- Data for Name: weekly_challenges; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.weekly_challenges (id, slug, title, description, dimension, difficulty, duration_days, created_at) FROM stdin;
b30d857a-a34f-4873-8b4c-26d964aebb0b	conexion-sin-pantallas	48 horas sin pantallas juntos	Pasen 48 horas priorizando la presencia: sin redes sociales, sin TV de fondo. Solo ustedes. Conversen, cocinen, salgan a caminar.	conexion	deep	7	2026-03-29 23:05:50.554947+00
57ba2a74-ec65-4b23-b1a8-2ccfa8cd13ca	ritual-matutino	Crea un ritual matutino de pareja	Durante 7 días, empiecen el día con un pequeño ritual juntos: café, un abrazo de 20 segundos, o compartir una intención para el día.	conexion	easy	7	2026-03-29 23:05:50.554947+00
0e55b465-f7db-4386-8403-e44370948284	preguntas-profundas	7 preguntas que nunca se han hecho	Cada día, háganse una pregunta profunda que nunca se han hecho. Sin juzgar, solo escuchar. Descúbranse de nuevo.	conexion	medium	7	2026-03-29 23:05:50.554947+00
422a4f43-e515-47d0-94f0-27cc74c9a6ad	actos-servicio	Semana de actos de servicio	Esta semana, cada uno hace un acto de servicio diario para el otro sin que lo pida: preparar algo, resolver un pendiente, un detalle inesperado.	cuidado	easy	7	2026-03-29 23:05:50.554947+00
aa8dc7c8-8a1a-4004-8207-93255d7c735a	carta-honesta	Carta honesta de apreciación	Cada uno escribe una carta de al menos una página sobre lo que aprecia del otro. Léanla en voz alta al final de la semana.	cuidado	medium	5	2026-03-29 23:05:50.554947+00
ba55f86e-0843-4030-b803-958c1d8cb6e0	lenguaje-amor	Habla en su idioma de amor	Identifiquen el lenguaje de amor principal de cada uno. Esta semana, expresen amor SOLO en el idioma del otro, no en el propio.	cuidado	medium	7	2026-03-29 23:05:50.554947+00
b6d42f7f-cdc1-434e-af6a-5dd5e4bd53f3	conflicto-constructivo	Laboratorio de conflicto	Elijan un tema pendiente y practiquen la técnica de los 15 minutos: 5 min habla uno, 5 min el otro, 5 min buscan un acuerdo. Sin interrumpirse.	choque	deep	5	2026-03-29 23:05:50.554947+00
934d3dec-2dc5-4b36-abd3-8b8d4d025087	pausas-conscientes	Instala el botón de pausa	Acuerden una palabra o señal para pausar cualquier discusión que se caliente. Practíquenla 3 veces esta semana, incluso en situaciones leves.	choque	easy	7	2026-03-29 23:05:50.554947+00
ed6998f5-3d42-49b3-a342-40a3611b12f1	bitacora-tension	Bitácora de tensiones	Cada uno lleva un registro diario de momentos de tensión: qué pasó, qué sentiste, qué necesitabas. Al final de la semana, compartan sin culpar.	choque	medium	7	2026-03-29 23:05:50.554947+00
117934c8-62bc-4fcf-bc81-906898715638	vision-compartida	Diseña tu mapa del futuro	Dediquen 2 sesiones esta semana a crear un tablero visual (físico o digital) de su visión compartida a 1, 3 y 5 años.	camino	medium	7	2026-03-29 23:05:50.554947+00
f6ec3e52-cfcb-4e24-a6b7-5ab53c17a42b	finanzas-abiertas	Transparencia financiera total	Esta semana, compartan sus números reales: ingresos, gastos, deudas, ahorros. Sin juicios. Busquen un acuerdo para el próximo mes.	camino	deep	5	2026-03-29 23:05:50.554947+00
7034e966-1706-4173-95e3-43b066daae47	proyecto-juntos	Proyecto de equipo	Elijan un mini proyecto para hacer juntos esta semana: reorganizar un espacio, planear un viaje, cocinar un menú semanal. Trabajen como equipo.	camino	easy	7	2026-03-29 23:05:50.554947+00
\.


--
-- Data for Name: weekly_plan_items; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.weekly_plan_items (id, plan_id, couple_id, day_of_week, day_label, title, description, dimension, activity_type, duration_minutes, difficulty, requires_both, assigned_to, status, completed_at, notes) FROM stdin;
cb2397aa-c039-4502-8399-a2c49f24c752	82a4aedd-2afe-4696-a0e4-ce410d0b748a	b0f53c25-5fae-445c-8261-e06d1716b4d3	1	Lunes	Mañanas de 5 minutos	Al despertar, Melanie y Ricardo, tómense 5 minutos para hablar de algo que les emocione del día o para darse un cumplido genuino. La idea es empezar el día conectados y con buena vibra.	conexion	conversacion	10	easy	t	\N	pending	\N	\N
ff8053af-a04a-496c-98d2-2a286f242340	82a4aedd-2afe-4696-a0e4-ce410d0b748a	b0f53c25-5fae-445c-8261-e06d1716b4d3	2	Martes	Un detalle sorpresa	Uno de ustedes, Melanie o Ricardo, elija un pequeño detalle o favor para el otro y realícelo discretamente hoy. Puede ser su café favorito, una nota linda o ayudar con una tarea. El objetivo es sorprender con cariño.	cuidado	microaccion	5	easy	f	\N	pending	\N	\N
0b69e153-17b9-4d28-aeb0-649ca68086f1	82a4aedd-2afe-4696-a0e4-ce410d0b748a	b0f53c25-5fae-445c-8261-e06d1716b4d3	3	Miércoles	Hablemos de lo que nos molesta	Melanie y Ricardo, elijan un tema pequeño que les haya causado fricción esta semana. Hablen de cómo se sintieron usando 'yo siento...' sin culpar. El objetivo es escucharse y entenderse, no resolver de inmediato.	conflicto	conversacion	20	medium	t	\N	pending	\N	\N
f5290545-d028-4fd9-a915-f6eb9e2b700d	82a4aedd-2afe-4696-a0e4-ce410d0b748a	b0f53c25-5fae-445c-8261-e06d1716b4d3	4	Jueves	Nuestros logros y metas	Melanie y Ricardo, celebren 3 logros recientes que hayan conseguido juntos. Después, compartan una meta personal que tengan y cómo pueden apoyarse mutuamente para alcanzarla. ¡A seguir creciendo en su camino!	camino	ritual	25	medium	t	\N	pending	\N	\N
975577c7-342a-4bc9-ae20-febe14e9f7b9	82a4aedd-2afe-4696-a0e4-ce410d0b748a	b0f53c25-5fae-445c-8261-e06d1716b4d3	5	Viernes	Mi gratitud por ti	Melanie, tómate 10 minutos para escribir o pensar en 3 cosas específicas por las que agradeces a Ricardo esta semana. Ricardo, haz lo mismo por Melanie. No es necesario compartirlo, solo sentir la gratitud que tienen el uno por el otro.	conexion	reflexion	10	easy	t	\N	pending	\N	\N
14b5ec4f-4930-4d8a-a1c4-39c6266fdcda	82a4aedd-2afe-4696-a0e4-ce410d0b748a	b0f53c25-5fae-445c-8261-e06d1716b4d3	6	Sábado	Cita 'Sin Distracciones'	Melanie y Ricardo, organicen una cita de al menos 30 minutos (puede ser en casa o fuera). Dejen los celulares en modo avión y concéntrense solo en ustedes. Hablen de sus sueños, miedos o simplemente ríanse y disfruten su compañía.	conexion	reto	35	deep	t	\N	pending	\N	\N
dac703f1-dc01-481a-98b5-4c2fe6c92dc6	82a4aedd-2afe-4696-a0e4-ce410d0b748a	b0f53c25-5fae-445c-8261-e06d1716b4d3	7	Domingo	Check-in semanal de pareja	Melanie y Ricardo, siéntense y evalúen cómo se sintieron esta semana en su relación. ¿Qué funcionó bien? ¿Qué podrían mejorar? Compartan sus sentimientos y planes para la siguiente semana con honestidad y cariño.	conexion	check_in	15	easy	t	\N	pending	\N	\N
\.


--
-- Data for Name: weekly_plans; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.weekly_plans (id, couple_id, week_start, week_end, generated_at, couple_status_snapshot, plan, status, completion_rate, couple_feedback, ai_model_used, prompt_version) FROM stdin;
82a4aedd-2afe-4696-a0e4-ce410d0b748a	b0f53c25-5fae-445c-8261-e06d1716b4d3	2026-03-30	2026-04-05	2026-03-30 06:58:39.754028+00	{"scores4C": {"camino": 73, "choque": 63, "cuidado": 63, "conexion": 63}, "generated_at": "2026-03-30T06:58:39.725Z", "generated_for": ["melanie", "Ricardo"]}	{"type": "ai-generated", "version": "2.0"}	active	0	\N	gemini-2.5-flash	2.0
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.schema_migrations (version, inserted_at) FROM stdin;
20211116024918	2026-03-27 15:15:20
20211116045059	2026-03-27 15:15:20
20211116050929	2026-03-27 15:15:20
20211116051442	2026-03-27 15:15:20
20211116212300	2026-03-27 15:15:20
20211116213355	2026-03-27 15:15:20
20211116213934	2026-03-27 15:15:20
20211116214523	2026-03-27 15:15:20
20211122062447	2026-03-27 15:15:20
20211124070109	2026-03-27 15:15:20
20211202204204	2026-03-27 15:15:20
20211202204605	2026-03-27 15:15:20
20211210212804	2026-03-27 15:15:20
20211228014915	2026-03-27 15:15:20
20220107221237	2026-03-27 15:15:20
20220228202821	2026-03-27 15:15:20
20220312004840	2026-03-27 15:15:20
20220603231003	2026-03-27 15:15:21
20220603232444	2026-03-27 15:15:21
20220615214548	2026-03-27 15:15:21
20220712093339	2026-03-27 15:15:21
20220908172859	2026-03-27 15:15:21
20220916233421	2026-03-27 15:15:21
20230119133233	2026-03-27 15:15:21
20230128025114	2026-03-27 15:15:21
20230128025212	2026-03-27 15:15:21
20230227211149	2026-03-27 15:15:21
20230228184745	2026-03-27 15:15:21
20230308225145	2026-03-27 15:15:21
20230328144023	2026-03-27 15:15:21
20231018144023	2026-03-27 15:15:21
20231204144023	2026-03-27 15:15:21
20231204144024	2026-03-27 15:15:21
20231204144025	2026-03-27 15:15:21
20240108234812	2026-03-27 15:15:21
20240109165339	2026-03-27 15:15:21
20240227174441	2026-03-27 15:15:21
20240311171622	2026-03-27 15:15:21
20240321100241	2026-03-27 15:15:21
20240401105812	2026-03-27 15:15:21
20240418121054	2026-03-27 15:15:21
20240523004032	2026-03-27 15:15:21
20240618124746	2026-03-27 15:15:21
20240801235015	2026-03-27 15:15:21
20240805133720	2026-03-27 15:15:21
20240827160934	2026-03-27 15:15:22
20240919163303	2026-03-27 15:15:22
20240919163305	2026-03-27 15:15:22
20241019105805	2026-03-27 15:15:22
20241030150047	2026-03-27 15:15:22
20241108114728	2026-03-27 15:15:22
20241121104152	2026-03-27 15:15:22
20241130184212	2026-03-27 15:15:22
20241220035512	2026-03-27 15:15:22
20241220123912	2026-03-27 15:15:22
20241224161212	2026-03-27 15:15:22
20250107150512	2026-03-27 15:15:22
20250110162412	2026-03-27 15:15:22
20250123174212	2026-03-27 15:15:22
20250128220012	2026-03-27 15:15:22
20250506224012	2026-03-27 15:15:22
20250523164012	2026-03-27 15:15:22
20250714121412	2026-03-27 15:15:22
20250905041441	2026-03-27 15:15:22
20251103001201	2026-03-27 15:15:22
20251120212548	2026-03-27 15:50:16
20251120215549	2026-03-27 15:50:16
20260218120000	2026-03-27 15:50:16
\.


--
-- Data for Name: subscription; Type: TABLE DATA; Schema: realtime; Owner: -
--

COPY realtime.subscription (id, subscription_id, entity, filters, claims, created_at, action_filter) FROM stdin;
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public, avif_autodetection, file_size_limit, allowed_mime_types, owner_id, type) FROM stdin;
avatars	avatars	\N	2026-03-29 23:23:48.848974+00	2026-03-29 23:23:48.848974+00	t	f	5242880	{image/jpeg,image/png,image/webp,image/gif}	\N	STANDARD
\.


--
-- Data for Name: buckets_analytics; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_analytics (name, type, format, created_at, updated_at, id, deleted_at) FROM stdin;
\.


--
-- Data for Name: buckets_vectors; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.buckets_vectors (id, type, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2026-03-27 15:16:01.352843
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2026-03-27 15:16:01.427072
2	storage-schema	f6a1fa2c93cbcd16d4e487b362e45fca157a8dbd	2026-03-27 15:16:01.430759
3	pathtoken-column	2cb1b0004b817b29d5b0a971af16bafeede4b70d	2026-03-27 15:16:01.466892
4	add-migrations-rls	427c5b63fe1c5937495d9c635c263ee7a5905058	2026-03-27 15:16:01.517496
5	add-size-functions	79e081a1455b63666c1294a440f8ad4b1e6a7f84	2026-03-27 15:16:01.557973
6	change-column-name-in-get-size	ded78e2f1b5d7e616117897e6443a925965b30d2	2026-03-27 15:16:01.5786
7	add-rls-to-buckets	e7e7f86adbc51049f341dfe8d30256c1abca17aa	2026-03-27 15:16:01.596264
8	add-public-to-buckets	fd670db39ed65f9d08b01db09d6202503ca2bab3	2026-03-27 15:16:01.60289
9	fix-search-function	af597a1b590c70519b464a4ab3be54490712796b	2026-03-27 15:16:01.618681
10	search-files-search-function	b595f05e92f7e91211af1bbfe9c6a13bb3391e16	2026-03-27 15:16:01.636697
11	add-trigger-to-auto-update-updated_at-column	7425bdb14366d1739fa8a18c83100636d74dcaa2	2026-03-27 15:16:01.644916
12	add-automatic-avif-detection-flag	8e92e1266eb29518b6a4c5313ab8f29dd0d08df9	2026-03-27 15:16:01.657794
13	add-bucket-custom-limits	cce962054138135cd9a8c4bcd531598684b25e7d	2026-03-27 15:16:01.662519
14	use-bytes-for-max-size	941c41b346f9802b411f06f30e972ad4744dad27	2026-03-27 15:16:01.676345
15	add-can-insert-object-function	934146bc38ead475f4ef4b555c524ee5d66799e5	2026-03-27 15:16:01.70439
16	add-version	76debf38d3fd07dcfc747ca49096457d95b1221b	2026-03-27 15:16:01.709534
17	drop-owner-foreign-key	f1cbb288f1b7a4c1eb8c38504b80ae2a0153d101	2026-03-27 15:16:01.725634
18	add_owner_id_column_deprecate_owner	e7a511b379110b08e2f214be852c35414749fe66	2026-03-27 15:16:01.7489
19	alter-default-value-objects-id	02e5e22a78626187e00d173dc45f58fa66a4f043	2026-03-27 15:16:01.755646
20	list-objects-with-delimiter	cd694ae708e51ba82bf012bba00caf4f3b6393b7	2026-03-27 15:16:01.770595
21	s3-multipart-uploads	8c804d4a566c40cd1e4cc5b3725a664a9303657f	2026-03-27 15:16:01.776221
22	s3-multipart-uploads-big-ints	9737dc258d2397953c9953d9b86920b8be0cdb73	2026-03-27 15:16:01.811424
23	optimize-search-function	9d7e604cddc4b56a5422dc68c9313f4a1b6f132c	2026-03-27 15:16:01.830245
24	operation-function	8312e37c2bf9e76bbe841aa5fda889206d2bf8aa	2026-03-27 15:16:01.846404
25	custom-metadata	d974c6057c3db1c1f847afa0e291e6165693b990	2026-03-27 15:16:01.868248
26	objects-prefixes	215cabcb7f78121892a5a2037a09fedf9a1ae322	2026-03-27 15:16:01.880538
27	search-v2	859ba38092ac96eb3964d83bf53ccc0b141663a6	2026-03-27 15:16:01.884333
28	object-bucket-name-sorting	c73a2b5b5d4041e39705814fd3a1b95502d38ce4	2026-03-27 15:16:01.895779
29	create-prefixes	ad2c1207f76703d11a9f9007f821620017a66c21	2026-03-27 15:16:01.89977
30	update-object-levels	2be814ff05c8252fdfdc7cfb4b7f5c7e17f0bed6	2026-03-27 15:16:01.903534
31	objects-level-index	b40367c14c3440ec75f19bbce2d71e914ddd3da0	2026-03-27 15:16:01.907576
32	backward-compatible-index-on-objects	e0c37182b0f7aee3efd823298fb3c76f1042c0f7	2026-03-27 15:16:01.912063
33	backward-compatible-index-on-prefixes	b480e99ed951e0900f033ec4eb34b5bdcb4e3d49	2026-03-27 15:16:01.916054
34	optimize-search-function-v1	ca80a3dc7bfef894df17108785ce29a7fc8ee456	2026-03-27 15:16:01.919609
35	add-insert-trigger-prefixes	458fe0ffd07ec53f5e3ce9df51bfdf4861929ccc	2026-03-27 15:16:01.923229
36	optimise-existing-functions	6ae5fca6af5c55abe95369cd4f93985d1814ca8f	2026-03-27 15:16:01.927082
37	add-bucket-name-length-trigger	3944135b4e3e8b22d6d4cbb568fe3b0b51df15c1	2026-03-27 15:16:01.930702
38	iceberg-catalog-flag-on-buckets	02716b81ceec9705aed84aa1501657095b32e5c5	2026-03-27 15:16:01.935607
39	add-search-v2-sort-support	6706c5f2928846abee18461279799ad12b279b78	2026-03-27 15:16:01.948341
40	fix-prefix-race-conditions-optimized	7ad69982ae2d372b21f48fc4829ae9752c518f6b	2026-03-27 15:16:01.951884
41	add-object-level-update-trigger	07fcf1a22165849b7a029deed059ffcde08d1ae0	2026-03-27 15:16:01.956046
42	rollback-prefix-triggers	771479077764adc09e2ea2043eb627503c034cd4	2026-03-27 15:16:01.959811
43	fix-object-level	84b35d6caca9d937478ad8a797491f38b8c2979f	2026-03-27 15:16:01.963587
44	vector-bucket-type	99c20c0ffd52bb1ff1f32fb992f3b351e3ef8fb3	2026-03-27 15:16:01.967447
45	vector-buckets	049e27196d77a7cb76497a85afae669d8b230953	2026-03-27 15:16:01.97347
46	buckets-objects-grants	fedeb96d60fefd8e02ab3ded9fbde05632f84aed	2026-03-27 15:16:01.994274
47	iceberg-table-metadata	649df56855c24d8b36dd4cc1aeb8251aa9ad42c2	2026-03-27 15:16:01.998785
48	iceberg-catalog-ids	e0e8b460c609b9999ccd0df9ad14294613eed939	2026-03-27 15:16:02.002727
49	buckets-objects-grants-postgres	072b1195d0d5a2f888af6b2302a1938dd94b8b3d	2026-03-27 15:16:02.017651
50	search-v2-optimised	6323ac4f850aa14e7387eb32102869578b5bd478	2026-03-27 15:16:02.023267
51	index-backward-compatible-search	2ee395d433f76e38bcd3856debaf6e0e5b674011	2026-03-27 15:16:02.126433
52	drop-not-used-indexes-and-functions	5cc44c8696749ac11dd0dc37f2a3802075f3a171	2026-03-27 15:16:02.128284
53	drop-index-lower-name	d0cb18777d9e2a98ebe0bc5cc7a42e57ebe41854	2026-03-27 15:16:02.138373
54	drop-index-object-level	6289e048b1472da17c31a7eba1ded625a6457e67	2026-03-27 15:16:02.140878
55	prevent-direct-deletes	262a4798d5e0f2e7c8970232e03ce8be695d5819	2026-03-27 15:16:02.14264
56	fix-optimized-search-function	cb58526ebc23048049fd5bf2fd148d18b04a2073	2026-03-27 15:16:02.147922
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata, version, owner_id, user_metadata) FROM stdin;
3d35ddf4-5c84-42cf-a0f0-223e8fa7c292	avatars	fee9e226-585d-4d87-9267-c904fbe020d0/avatar.jpeg	fee9e226-585d-4d87-9267-c904fbe020d0	2026-03-29 23:42:40.937389+00	2026-03-29 23:42:40.937389+00	2026-03-29 23:42:40.937389+00	{"eTag": "\\"4be5aafbe99b2369f522295d78b240f7\\"", "size": 2409730, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-29T23:42:41.000Z", "contentLength": 2409730, "httpStatusCode": 200}	abab9cae-f49d-4a10-a76e-db3830e2bf4f	fee9e226-585d-4d87-9267-c904fbe020d0	{}
65ec7713-8fce-4b5a-8df9-03795f6fba30	avatars	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2/avatar.jpeg	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	2026-03-30 07:08:03.261428+00	2026-03-30 07:08:03.261428+00	2026-03-30 07:08:03.261428+00	{"eTag": "\\"ced4124958e53a29f5422e5d8e075f55\\"", "size": 215161, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2026-03-30T07:08:04.000Z", "contentLength": 215161, "httpStatusCode": 200}	95c83bbd-43e3-4636-a4e7-a1fc939645ca	0c8670a1-b6df-46f8-a9a5-b62247c5ddc2	{}
\.


--
-- Data for Name: s3_multipart_uploads; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads (id, in_progress_size, upload_signature, bucket_id, key, version, owner_id, created_at, user_metadata) FROM stdin;
\.


--
-- Data for Name: s3_multipart_uploads_parts; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.s3_multipart_uploads_parts (id, upload_id, size, part_number, bucket_id, key, etag, owner_id, version, created_at) FROM stdin;
\.


--
-- Data for Name: vector_indexes; Type: TABLE DATA; Schema: storage; Owner: -
--

COPY storage.vector_indexes (id, name, bucket_id, data_type, dimension, distance_metric, metadata_configuration, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: -
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: -
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 57, true);


--
-- Name: subscription_id_seq; Type: SEQUENCE SET; Schema: realtime; Owner: -
--

SELECT pg_catalog.setval('realtime.subscription_id_seq', 1, false);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: custom_oauth_providers custom_oauth_providers_identifier_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_identifier_key UNIQUE (identifier);


--
-- Name: custom_oauth_providers custom_oauth_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.custom_oauth_providers
    ADD CONSTRAINT custom_oauth_providers_pkey PRIMARY KEY (id);


--
-- Name: flow_state flow_state_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.flow_state
    ADD CONSTRAINT flow_state_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: identities identities_provider_id_provider_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_provider_id_provider_unique UNIQUE (provider_id, provider);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_last_challenged_at_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_last_challenged_at_key UNIQUE (last_challenged_at);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_code_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_code_key UNIQUE (authorization_code);


--
-- Name: oauth_authorizations oauth_authorizations_authorization_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_authorization_id_key UNIQUE (authorization_id);


--
-- Name: oauth_authorizations oauth_authorizations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_pkey PRIMARY KEY (id);


--
-- Name: oauth_client_states oauth_client_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_client_states
    ADD CONSTRAINT oauth_client_states_pkey PRIMARY KEY (id);


--
-- Name: oauth_clients oauth_clients_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_clients
    ADD CONSTRAINT oauth_clients_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_pkey PRIMARY KEY (id);


--
-- Name: oauth_consents oauth_consents_user_client_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_client_unique UNIQUE (user_id, client_id);


--
-- Name: one_time_tokens one_time_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: webauthn_challenges webauthn_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_pkey PRIMARY KEY (id);


--
-- Name: webauthn_credentials webauthn_credentials_pkey; Type: CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_pkey PRIMARY KEY (id);


--
-- Name: ai_audit_log ai_audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_audit_log
    ADD CONSTRAINT ai_audit_log_pkey PRIMARY KEY (id);


--
-- Name: ai_insights ai_insights_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_insights
    ADD CONSTRAINT ai_insights_pkey PRIMARY KEY (id);


--
-- Name: answer_options answer_options_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answer_options
    ADD CONSTRAINT answer_options_pkey PRIMARY KEY (id);


--
-- Name: challenge_assignments challenge_assignments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.challenge_assignments
    ADD CONSTRAINT challenge_assignments_pkey PRIMARY KEY (id);


--
-- Name: conocernos_answers conocernos_answers_daily_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conocernos_answers
    ADD CONSTRAINT conocernos_answers_daily_id_user_id_key UNIQUE (daily_id, user_id);


--
-- Name: conocernos_answers conocernos_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conocernos_answers
    ADD CONSTRAINT conocernos_answers_pkey PRIMARY KEY (id);


--
-- Name: conocernos_daily conocernos_daily_couple_id_question_date_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conocernos_daily
    ADD CONSTRAINT conocernos_daily_couple_id_question_date_key UNIQUE (couple_id, question_date);


--
-- Name: conocernos_daily conocernos_daily_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conocernos_daily
    ADD CONSTRAINT conocernos_daily_pkey PRIMARY KEY (id);


--
-- Name: conocernos_questions conocernos_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conocernos_questions
    ADD CONSTRAINT conocernos_questions_pkey PRIMARY KEY (id);


--
-- Name: conocernos_reactions conocernos_reactions_daily_id_user_id_target_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conocernos_reactions
    ADD CONSTRAINT conocernos_reactions_daily_id_user_id_target_user_id_key UNIQUE (daily_id, user_id, target_user_id);


--
-- Name: conocernos_reactions conocernos_reactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conocernos_reactions
    ADD CONSTRAINT conocernos_reactions_pkey PRIMARY KEY (id);


--
-- Name: couple_insights couple_insights_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couple_insights
    ADD CONSTRAINT couple_insights_pkey PRIMARY KEY (id);


--
-- Name: couple_members couple_members_couple_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couple_members
    ADD CONSTRAINT couple_members_couple_id_user_id_key UNIQUE (couple_id, user_id);


--
-- Name: couple_members couple_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couple_members
    ADD CONSTRAINT couple_members_pkey PRIMARY KEY (id);


--
-- Name: couple_reports couple_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couple_reports
    ADD CONSTRAINT couple_reports_pkey PRIMARY KEY (id);


--
-- Name: couple_vectors couple_vectors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couple_vectors
    ADD CONSTRAINT couple_vectors_pkey PRIMARY KEY (id);


--
-- Name: couples couples_invite_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couples
    ADD CONSTRAINT couples_invite_code_key UNIQUE (invite_code);


--
-- Name: couples couples_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couples
    ADD CONSTRAINT couples_pkey PRIMARY KEY (id);


--
-- Name: custom_evaluation_answers custom_evaluation_answers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_evaluation_answers
    ADD CONSTRAINT custom_evaluation_answers_pkey PRIMARY KEY (id);


--
-- Name: custom_evaluation_answers custom_evaluation_answers_user_id_question_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_evaluation_answers
    ADD CONSTRAINT custom_evaluation_answers_user_id_question_id_key UNIQUE (user_id, question_id);


--
-- Name: custom_evaluation_insights custom_evaluation_insights_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_evaluation_insights
    ADD CONSTRAINT custom_evaluation_insights_pkey PRIMARY KEY (id);


--
-- Name: custom_evaluation_questions custom_evaluation_questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_evaluation_questions
    ADD CONSTRAINT custom_evaluation_questions_pkey PRIMARY KEY (id);


--
-- Name: custom_evaluations custom_evaluations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_evaluations
    ADD CONSTRAINT custom_evaluations_pkey PRIMARY KEY (id);


--
-- Name: daily_tips daily_tips_couple_id_tip_date_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_tips
    ADD CONSTRAINT daily_tips_couple_id_tip_date_key UNIQUE (couple_id, tip_date);


--
-- Name: daily_tips daily_tips_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_tips
    ADD CONSTRAINT daily_tips_pkey PRIMARY KEY (id);


--
-- Name: dimension_keys dimension_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dimension_keys
    ADD CONSTRAINT dimension_keys_pkey PRIMARY KEY (id);


--
-- Name: dimension_keys dimension_keys_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dimension_keys
    ADD CONSTRAINT dimension_keys_slug_key UNIQUE (slug);


--
-- Name: dimension_scores dimension_scores_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dimension_scores
    ADD CONSTRAINT dimension_scores_pkey PRIMARY KEY (id);


--
-- Name: generated_assessment_items generated_assessment_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_assessment_items
    ADD CONSTRAINT generated_assessment_items_pkey PRIMARY KEY (id);


--
-- Name: generated_assessments generated_assessments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_assessments
    ADD CONSTRAINT generated_assessments_pkey PRIMARY KEY (id);


--
-- Name: guided_conversations guided_conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guided_conversations
    ADD CONSTRAINT guided_conversations_pkey PRIMARY KEY (id);


--
-- Name: guided_conversations guided_conversations_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.guided_conversations
    ADD CONSTRAINT guided_conversations_slug_key UNIQUE (slug);


--
-- Name: item_bank item_bank_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_bank
    ADD CONSTRAINT item_bank_pkey PRIMARY KEY (id);


--
-- Name: item_bank item_bank_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_bank
    ADD CONSTRAINT item_bank_slug_key UNIQUE (slug);


--
-- Name: item_dimensions item_dimensions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_dimensions
    ADD CONSTRAINT item_dimensions_pkey PRIMARY KEY (id);


--
-- Name: milestones milestones_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.milestones
    ADD CONSTRAINT milestones_pkey PRIMARY KEY (id);


--
-- Name: nosotros_narratives nosotros_narratives_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nosotros_narratives
    ADD CONSTRAINT nosotros_narratives_pkey PRIMARY KEY (id);


--
-- Name: onboarding_responses onboarding_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onboarding_responses
    ADD CONSTRAINT onboarding_responses_pkey PRIMARY KEY (id);


--
-- Name: onboarding_responses onboarding_responses_session_id_item_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onboarding_responses
    ADD CONSTRAINT onboarding_responses_session_id_item_id_key UNIQUE (session_id, item_id);


--
-- Name: onboarding_sessions onboarding_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onboarding_sessions
    ADD CONSTRAINT onboarding_sessions_pkey PRIMARY KEY (id);


--
-- Name: onboarding_sessions onboarding_sessions_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onboarding_sessions
    ADD CONSTRAINT onboarding_sessions_user_id_key UNIQUE (user_id);


--
-- Name: personal_reports personal_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_reports
    ADD CONSTRAINT personal_reports_pkey PRIMARY KEY (id);


--
-- Name: profile_vectors profile_vectors_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profile_vectors
    ADD CONSTRAINT profile_vectors_pkey PRIMARY KEY (id);


--
-- Name: profile_vectors profile_vectors_user_id_dimension_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profile_vectors
    ADD CONSTRAINT profile_vectors_user_id_dimension_slug_key UNIQUE (user_id, dimension_slug);


--
-- Name: profiles profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_pkey PRIMARY KEY (id);


--
-- Name: question_dimension_map question_dimension_map_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.question_dimension_map
    ADD CONSTRAINT question_dimension_map_pkey PRIMARY KEY (id);


--
-- Name: questionnaire_sections questionnaire_sections_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questionnaire_sections
    ADD CONSTRAINT questionnaire_sections_pkey PRIMARY KEY (id);


--
-- Name: questionnaires questionnaires_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questionnaires
    ADD CONSTRAINT questionnaires_pkey PRIMARY KEY (id);


--
-- Name: questionnaires questionnaires_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questionnaires
    ADD CONSTRAINT questionnaires_slug_key UNIQUE (slug);


--
-- Name: questions questions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_pkey PRIMARY KEY (id);


--
-- Name: response_sessions response_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.response_sessions
    ADD CONSTRAINT response_sessions_pkey PRIMARY KEY (id);


--
-- Name: responses responses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT responses_pkey PRIMARY KEY (id);


--
-- Name: responses responses_session_id_question_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT responses_session_id_question_id_key UNIQUE (session_id, question_id);


--
-- Name: weekly_challenges weekly_challenges_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weekly_challenges
    ADD CONSTRAINT weekly_challenges_pkey PRIMARY KEY (id);


--
-- Name: weekly_challenges weekly_challenges_slug_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weekly_challenges
    ADD CONSTRAINT weekly_challenges_slug_key UNIQUE (slug);


--
-- Name: weekly_plan_items weekly_plan_items_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weekly_plan_items
    ADD CONSTRAINT weekly_plan_items_pkey PRIMARY KEY (id);


--
-- Name: weekly_plans weekly_plans_couple_id_week_start_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weekly_plans
    ADD CONSTRAINT weekly_plans_couple_id_week_start_key UNIQUE (couple_id, week_start);


--
-- Name: weekly_plans weekly_plans_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weekly_plans
    ADD CONSTRAINT weekly_plans_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id, inserted_at);


--
-- Name: subscription pk_subscription; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.subscription
    ADD CONSTRAINT pk_subscription PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: realtime; Owner: -
--

ALTER TABLE ONLY realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: buckets_analytics buckets_analytics_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_analytics
    ADD CONSTRAINT buckets_analytics_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: buckets_vectors buckets_vectors_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.buckets_vectors
    ADD CONSTRAINT buckets_vectors_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_pkey PRIMARY KEY (id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_pkey PRIMARY KEY (id);


--
-- Name: vector_indexes vector_indexes_pkey; Type: CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_pkey PRIMARY KEY (id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: custom_oauth_providers_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_created_at_idx ON auth.custom_oauth_providers USING btree (created_at);


--
-- Name: custom_oauth_providers_enabled_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_enabled_idx ON auth.custom_oauth_providers USING btree (enabled);


--
-- Name: custom_oauth_providers_identifier_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_identifier_idx ON auth.custom_oauth_providers USING btree (identifier);


--
-- Name: custom_oauth_providers_provider_type_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX custom_oauth_providers_provider_type_idx ON auth.custom_oauth_providers USING btree (provider_type);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: flow_state_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX flow_state_created_at_idx ON auth.flow_state USING btree (created_at DESC);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: idx_auth_code; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_auth_code ON auth.flow_state USING btree (auth_code);


--
-- Name: idx_oauth_client_states_created_at; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_oauth_client_states_created_at ON auth.oauth_client_states USING btree (created_at);


--
-- Name: idx_user_id_auth_method; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX idx_user_id_auth_method ON auth.flow_state USING btree (user_id, authentication_method);


--
-- Name: mfa_challenge_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_challenge_created_at_idx ON auth.mfa_challenges USING btree (created_at DESC);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: mfa_factors_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX mfa_factors_user_id_idx ON auth.mfa_factors USING btree (user_id);


--
-- Name: oauth_auth_pending_exp_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_auth_pending_exp_idx ON auth.oauth_authorizations USING btree (expires_at) WHERE (status = 'pending'::auth.oauth_authorization_status);


--
-- Name: oauth_clients_deleted_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_clients_deleted_at_idx ON auth.oauth_clients USING btree (deleted_at);


--
-- Name: oauth_consents_active_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_client_idx ON auth.oauth_consents USING btree (client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_active_user_client_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_active_user_client_idx ON auth.oauth_consents USING btree (user_id, client_id) WHERE (revoked_at IS NULL);


--
-- Name: oauth_consents_user_order_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX oauth_consents_user_order_idx ON auth.oauth_consents USING btree (user_id, granted_at DESC);


--
-- Name: one_time_tokens_relates_to_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_relates_to_hash_idx ON auth.one_time_tokens USING hash (relates_to);


--
-- Name: one_time_tokens_token_hash_hash_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX one_time_tokens_token_hash_hash_idx ON auth.one_time_tokens USING hash (token_hash);


--
-- Name: one_time_tokens_user_id_token_type_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX one_time_tokens_user_id_token_type_key ON auth.one_time_tokens USING btree (user_id, token_type);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_updated_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX refresh_tokens_updated_at_idx ON auth.refresh_tokens USING btree (updated_at DESC);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_created_at_idx ON auth.saml_relay_states USING btree (created_at DESC);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_not_after_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_not_after_idx ON auth.sessions USING btree (not_after DESC);


--
-- Name: sessions_oauth_client_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_oauth_client_id_idx ON auth.sessions USING btree (oauth_client_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: sso_providers_resource_id_pattern_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX sso_providers_resource_id_pattern_idx ON auth.sso_providers USING btree (resource_id text_pattern_ops);


--
-- Name: unique_phone_factor_per_user; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX unique_phone_factor_per_user ON auth.mfa_factors USING btree (user_id, phone);


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: -
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: users_is_anonymous_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX users_is_anonymous_idx ON auth.users USING btree (is_anonymous);


--
-- Name: webauthn_challenges_expires_at_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_challenges_expires_at_idx ON auth.webauthn_challenges USING btree (expires_at);


--
-- Name: webauthn_challenges_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_challenges_user_id_idx ON auth.webauthn_challenges USING btree (user_id);


--
-- Name: webauthn_credentials_credential_id_key; Type: INDEX; Schema: auth; Owner: -
--

CREATE UNIQUE INDEX webauthn_credentials_credential_id_key ON auth.webauthn_credentials USING btree (credential_id);


--
-- Name: webauthn_credentials_user_id_idx; Type: INDEX; Schema: auth; Owner: -
--

CREATE INDEX webauthn_credentials_user_id_idx ON auth.webauthn_credentials USING btree (user_id);


--
-- Name: idx_conocernos_answers_daily; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conocernos_answers_daily ON public.conocernos_answers USING btree (daily_id);


--
-- Name: idx_conocernos_daily_couple_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conocernos_daily_couple_date ON public.conocernos_daily USING btree (couple_id, question_date);


--
-- Name: idx_conocernos_reactions_daily; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_conocernos_reactions_daily ON public.conocernos_reactions USING btree (daily_id);


--
-- Name: idx_couple_insights_couple; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_couple_insights_couple ON public.couple_insights USING btree (couple_id);


--
-- Name: idx_couple_members_couple; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_couple_members_couple ON public.couple_members USING btree (couple_id);


--
-- Name: idx_couple_members_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_couple_members_user ON public.couple_members USING btree (user_id);


--
-- Name: idx_couple_vectors_couple; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_couple_vectors_couple ON public.couple_vectors USING btree (couple_id);


--
-- Name: idx_daily_tips_couple_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_daily_tips_couple_date ON public.daily_tips USING btree (couple_id, tip_date);


--
-- Name: idx_dimension_scores_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_dimension_scores_user ON public.dimension_scores USING btree (user_id);


--
-- Name: idx_item_bank_dimension; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_item_bank_dimension ON public.item_bank USING btree (dimension_slug);


--
-- Name: idx_item_bank_stage; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_item_bank_stage ON public.item_bank USING btree (stage);


--
-- Name: idx_onboarding_responses_session; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_onboarding_responses_session ON public.onboarding_responses USING btree (session_id);


--
-- Name: idx_onboarding_sessions_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_onboarding_sessions_user ON public.onboarding_sessions USING btree (user_id);


--
-- Name: idx_profile_vectors_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_profile_vectors_user ON public.profile_vectors USING btree (user_id);


--
-- Name: idx_questions_section; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_questions_section ON public.questions USING btree (section_id);


--
-- Name: idx_response_sessions_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_response_sessions_status ON public.response_sessions USING btree (user_id, status);


--
-- Name: idx_response_sessions_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_response_sessions_user ON public.response_sessions USING btree (user_id);


--
-- Name: idx_responses_session; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_responses_session ON public.responses USING btree (session_id);


--
-- Name: idx_weekly_plan_items_plan; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_weekly_plan_items_plan ON public.weekly_plan_items USING btree (plan_id);


--
-- Name: idx_weekly_plans_couple; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_weekly_plans_couple ON public.weekly_plans USING btree (couple_id);


--
-- Name: nosotros_narratives_unique_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX nosotros_narratives_unique_idx ON public.nosotros_narratives USING btree (couple_id, narrative_type, COALESCE(dimension_slug, '__null__'::text));


--
-- Name: ix_realtime_subscription_entity; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX ix_realtime_subscription_entity ON realtime.subscription USING btree (entity);


--
-- Name: messages_inserted_at_topic_index; Type: INDEX; Schema: realtime; Owner: -
--

CREATE INDEX messages_inserted_at_topic_index ON ONLY realtime.messages USING btree (inserted_at DESC, topic) WHERE ((extension = 'broadcast'::text) AND (private IS TRUE));


--
-- Name: subscription_subscription_id_entity_filters_action_filter_key; Type: INDEX; Schema: realtime; Owner: -
--

CREATE UNIQUE INDEX subscription_subscription_id_entity_filters_action_filter_key ON realtime.subscription USING btree (subscription_id, entity, filters, action_filter);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: buckets_analytics_unique_name_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX buckets_analytics_unique_name_idx ON storage.buckets_analytics USING btree (name) WHERE (deleted_at IS NULL);


--
-- Name: idx_multipart_uploads_list; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_multipart_uploads_list ON storage.s3_multipart_uploads USING btree (bucket_id, key, created_at);


--
-- Name: idx_objects_bucket_id_name; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name ON storage.objects USING btree (bucket_id, name COLLATE "C");


--
-- Name: idx_objects_bucket_id_name_lower; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX idx_objects_bucket_id_name_lower ON storage.objects USING btree (bucket_id, lower(name) COLLATE "C");


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: -
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: vector_indexes_name_bucket_id_idx; Type: INDEX; Schema: storage; Owner: -
--

CREATE UNIQUE INDEX vector_indexes_name_bucket_id_idx ON storage.vector_indexes USING btree (name, bucket_id);


--
-- Name: users on_auth_user_created; Type: TRIGGER; Schema: auth; Owner: -
--

CREATE TRIGGER on_auth_user_created AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();


--
-- Name: custom_evaluations update_custom_evaluations_modtime; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_custom_evaluations_modtime BEFORE UPDATE ON public.custom_evaluations FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: subscription tr_check_filters; Type: TRIGGER; Schema: realtime; Owner: -
--

CREATE TRIGGER tr_check_filters BEFORE INSERT OR UPDATE ON realtime.subscription FOR EACH ROW EXECUTE FUNCTION realtime.subscription_check_filters();


--
-- Name: buckets enforce_bucket_name_length_trigger; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER enforce_bucket_name_length_trigger BEFORE INSERT OR UPDATE OF name ON storage.buckets FOR EACH ROW EXECUTE FUNCTION storage.enforce_bucket_name_length();


--
-- Name: buckets protect_buckets_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_buckets_delete BEFORE DELETE ON storage.buckets FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects protect_objects_delete; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER protect_objects_delete BEFORE DELETE ON storage.objects FOR EACH STATEMENT EXECUTE FUNCTION storage.protect_delete();


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: -
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_authorizations oauth_authorizations_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_authorizations
    ADD CONSTRAINT oauth_authorizations_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_client_id_fkey FOREIGN KEY (client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: oauth_consents oauth_consents_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.oauth_consents
    ADD CONSTRAINT oauth_consents_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: one_time_tokens one_time_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.one_time_tokens
    ADD CONSTRAINT one_time_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_flow_state_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_flow_state_id_fkey FOREIGN KEY (flow_state_id) REFERENCES auth.flow_state(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_oauth_client_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_oauth_client_id_fkey FOREIGN KEY (oauth_client_id) REFERENCES auth.oauth_clients(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: webauthn_challenges webauthn_challenges_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_challenges
    ADD CONSTRAINT webauthn_challenges_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: webauthn_credentials webauthn_credentials_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: -
--

ALTER TABLE ONLY auth.webauthn_credentials
    ADD CONSTRAINT webauthn_credentials_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: ai_audit_log ai_audit_log_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_audit_log
    ADD CONSTRAINT ai_audit_log_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id);


--
-- Name: ai_insights ai_insights_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_insights
    ADD CONSTRAINT ai_insights_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id);


--
-- Name: ai_insights ai_insights_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ai_insights
    ADD CONSTRAINT ai_insights_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: answer_options answer_options_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.answer_options
    ADD CONSTRAINT answer_options_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: challenge_assignments challenge_assignments_challenge_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.challenge_assignments
    ADD CONSTRAINT challenge_assignments_challenge_id_fkey FOREIGN KEY (challenge_id) REFERENCES public.weekly_challenges(id);


--
-- Name: challenge_assignments challenge_assignments_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.challenge_assignments
    ADD CONSTRAINT challenge_assignments_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id) ON DELETE CASCADE;


--
-- Name: conocernos_answers conocernos_answers_daily_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conocernos_answers
    ADD CONSTRAINT conocernos_answers_daily_id_fkey FOREIGN KEY (daily_id) REFERENCES public.conocernos_daily(id) ON DELETE CASCADE;


--
-- Name: conocernos_answers conocernos_answers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conocernos_answers
    ADD CONSTRAINT conocernos_answers_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: conocernos_daily conocernos_daily_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conocernos_daily
    ADD CONSTRAINT conocernos_daily_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id) ON DELETE CASCADE;


--
-- Name: conocernos_daily conocernos_daily_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conocernos_daily
    ADD CONSTRAINT conocernos_daily_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.conocernos_questions(id);


--
-- Name: conocernos_reactions conocernos_reactions_daily_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conocernos_reactions
    ADD CONSTRAINT conocernos_reactions_daily_id_fkey FOREIGN KEY (daily_id) REFERENCES public.conocernos_daily(id) ON DELETE CASCADE;


--
-- Name: conocernos_reactions conocernos_reactions_target_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conocernos_reactions
    ADD CONSTRAINT conocernos_reactions_target_user_id_fkey FOREIGN KEY (target_user_id) REFERENCES auth.users(id);


--
-- Name: conocernos_reactions conocernos_reactions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conocernos_reactions
    ADD CONSTRAINT conocernos_reactions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: couple_insights couple_insights_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couple_insights
    ADD CONSTRAINT couple_insights_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id) ON DELETE CASCADE;


--
-- Name: couple_members couple_members_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couple_members
    ADD CONSTRAINT couple_members_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id) ON DELETE CASCADE;


--
-- Name: couple_members couple_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couple_members
    ADD CONSTRAINT couple_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: couple_reports couple_reports_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couple_reports
    ADD CONSTRAINT couple_reports_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id) ON DELETE CASCADE;


--
-- Name: couple_reports couple_reports_session_a_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couple_reports
    ADD CONSTRAINT couple_reports_session_a_id_fkey FOREIGN KEY (session_a_id) REFERENCES public.response_sessions(id);


--
-- Name: couple_reports couple_reports_session_b_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couple_reports
    ADD CONSTRAINT couple_reports_session_b_id_fkey FOREIGN KEY (session_b_id) REFERENCES public.response_sessions(id);


--
-- Name: couple_vectors couple_vectors_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couple_vectors
    ADD CONSTRAINT couple_vectors_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id) ON DELETE CASCADE;


--
-- Name: couples couples_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.couples
    ADD CONSTRAINT couples_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id);


--
-- Name: custom_evaluation_answers custom_evaluation_answers_evaluation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_evaluation_answers
    ADD CONSTRAINT custom_evaluation_answers_evaluation_id_fkey FOREIGN KEY (evaluation_id) REFERENCES public.custom_evaluations(id) ON DELETE CASCADE;


--
-- Name: custom_evaluation_answers custom_evaluation_answers_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_evaluation_answers
    ADD CONSTRAINT custom_evaluation_answers_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.custom_evaluation_questions(id) ON DELETE CASCADE;


--
-- Name: custom_evaluation_answers custom_evaluation_answers_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_evaluation_answers
    ADD CONSTRAINT custom_evaluation_answers_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: custom_evaluation_insights custom_evaluation_insights_evaluation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_evaluation_insights
    ADD CONSTRAINT custom_evaluation_insights_evaluation_id_fkey FOREIGN KEY (evaluation_id) REFERENCES public.custom_evaluations(id) ON DELETE CASCADE;


--
-- Name: custom_evaluation_questions custom_evaluation_questions_evaluation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_evaluation_questions
    ADD CONSTRAINT custom_evaluation_questions_evaluation_id_fkey FOREIGN KEY (evaluation_id) REFERENCES public.custom_evaluations(id) ON DELETE CASCADE;


--
-- Name: custom_evaluations custom_evaluations_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_evaluations
    ADD CONSTRAINT custom_evaluations_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id) ON DELETE CASCADE;


--
-- Name: custom_evaluations custom_evaluations_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.custom_evaluations
    ADD CONSTRAINT custom_evaluations_created_by_fkey FOREIGN KEY (created_by) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: daily_tips daily_tips_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.daily_tips
    ADD CONSTRAINT daily_tips_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id) ON DELETE CASCADE;


--
-- Name: dimension_scores dimension_scores_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dimension_scores
    ADD CONSTRAINT dimension_scores_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id);


--
-- Name: dimension_scores dimension_scores_dimension_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dimension_scores
    ADD CONSTRAINT dimension_scores_dimension_id_fkey FOREIGN KEY (dimension_id) REFERENCES public.dimension_keys(id);


--
-- Name: dimension_scores dimension_scores_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dimension_scores
    ADD CONSTRAINT dimension_scores_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: generated_assessment_items generated_assessment_items_assessment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_assessment_items
    ADD CONSTRAINT generated_assessment_items_assessment_id_fkey FOREIGN KEY (assessment_id) REFERENCES public.generated_assessments(id) ON DELETE CASCADE;


--
-- Name: generated_assessment_items generated_assessment_items_item_bank_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_assessment_items
    ADD CONSTRAINT generated_assessment_items_item_bank_id_fkey FOREIGN KEY (item_bank_id) REFERENCES public.item_bank(id);


--
-- Name: generated_assessments generated_assessments_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.generated_assessments
    ADD CONSTRAINT generated_assessments_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id) ON DELETE CASCADE;


--
-- Name: item_dimensions item_dimensions_item_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.item_dimensions
    ADD CONSTRAINT item_dimensions_item_id_fkey FOREIGN KEY (item_id) REFERENCES public.item_bank(id) ON DELETE CASCADE;


--
-- Name: milestones milestones_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.milestones
    ADD CONSTRAINT milestones_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id) ON DELETE CASCADE;


--
-- Name: nosotros_narratives nosotros_narratives_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.nosotros_narratives
    ADD CONSTRAINT nosotros_narratives_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id) ON DELETE CASCADE;


--
-- Name: onboarding_responses onboarding_responses_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onboarding_responses
    ADD CONSTRAINT onboarding_responses_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.onboarding_sessions(id) ON DELETE CASCADE;


--
-- Name: onboarding_sessions onboarding_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.onboarding_sessions
    ADD CONSTRAINT onboarding_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: personal_reports personal_reports_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_reports
    ADD CONSTRAINT personal_reports_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.response_sessions(id);


--
-- Name: personal_reports personal_reports_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.personal_reports
    ADD CONSTRAINT personal_reports_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id);


--
-- Name: profile_vectors profile_vectors_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profile_vectors
    ADD CONSTRAINT profile_vectors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: profiles profiles_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.profiles
    ADD CONSTRAINT profiles_id_fkey FOREIGN KEY (id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: question_dimension_map question_dimension_map_dimension_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.question_dimension_map
    ADD CONSTRAINT question_dimension_map_dimension_id_fkey FOREIGN KEY (dimension_id) REFERENCES public.dimension_keys(id) ON DELETE CASCADE;


--
-- Name: question_dimension_map question_dimension_map_question_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.question_dimension_map
    ADD CONSTRAINT question_dimension_map_question_id_fkey FOREIGN KEY (question_id) REFERENCES public.questions(id) ON DELETE CASCADE;


--
-- Name: questionnaire_sections questionnaire_sections_questionnaire_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questionnaire_sections
    ADD CONSTRAINT questionnaire_sections_questionnaire_id_fkey FOREIGN KEY (questionnaire_id) REFERENCES public.questionnaires(id) ON DELETE CASCADE;


--
-- Name: questions questions_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.questions
    ADD CONSTRAINT questions_section_id_fkey FOREIGN KEY (section_id) REFERENCES public.questionnaire_sections(id) ON DELETE CASCADE;


--
-- Name: response_sessions response_sessions_generated_assessment_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.response_sessions
    ADD CONSTRAINT response_sessions_generated_assessment_id_fkey FOREIGN KEY (generated_assessment_id) REFERENCES public.generated_assessments(id);


--
-- Name: response_sessions response_sessions_questionnaire_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.response_sessions
    ADD CONSTRAINT response_sessions_questionnaire_id_fkey FOREIGN KEY (questionnaire_id) REFERENCES public.questionnaires(id);


--
-- Name: response_sessions response_sessions_section_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.response_sessions
    ADD CONSTRAINT response_sessions_section_id_fkey FOREIGN KEY (section_id) REFERENCES public.questionnaire_sections(id);


--
-- Name: response_sessions response_sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.response_sessions
    ADD CONSTRAINT response_sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: responses responses_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.responses
    ADD CONSTRAINT responses_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.response_sessions(id) ON DELETE CASCADE;


--
-- Name: weekly_plan_items weekly_plan_items_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weekly_plan_items
    ADD CONSTRAINT weekly_plan_items_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id);


--
-- Name: weekly_plan_items weekly_plan_items_plan_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weekly_plan_items
    ADD CONSTRAINT weekly_plan_items_plan_id_fkey FOREIGN KEY (plan_id) REFERENCES public.weekly_plans(id) ON DELETE CASCADE;


--
-- Name: weekly_plans weekly_plans_couple_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.weekly_plans
    ADD CONSTRAINT weekly_plans_couple_id_fkey FOREIGN KEY (couple_id) REFERENCES public.couples(id) ON DELETE CASCADE;


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads s3_multipart_uploads_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads
    ADD CONSTRAINT s3_multipart_uploads_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: s3_multipart_uploads_parts s3_multipart_uploads_parts_upload_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.s3_multipart_uploads_parts
    ADD CONSTRAINT s3_multipart_uploads_parts_upload_id_fkey FOREIGN KEY (upload_id) REFERENCES storage.s3_multipart_uploads(id) ON DELETE CASCADE;


--
-- Name: vector_indexes vector_indexes_bucket_id_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: -
--

ALTER TABLE ONLY storage.vector_indexes
    ADD CONSTRAINT vector_indexes_bucket_id_fkey FOREIGN KEY (bucket_id) REFERENCES storage.buckets_vectors(id);


--
-- Name: audit_log_entries; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.audit_log_entries ENABLE ROW LEVEL SECURITY;

--
-- Name: flow_state; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.flow_state ENABLE ROW LEVEL SECURITY;

--
-- Name: identities; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.identities ENABLE ROW LEVEL SECURITY;

--
-- Name: instances; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.instances ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_amr_claims; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_amr_claims ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_challenges; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: mfa_factors; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.mfa_factors ENABLE ROW LEVEL SECURITY;

--
-- Name: one_time_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.one_time_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: refresh_tokens; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.refresh_tokens ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: saml_relay_states; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.saml_relay_states ENABLE ROW LEVEL SECURITY;

--
-- Name: schema_migrations; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.schema_migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: sessions; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_domains; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_domains ENABLE ROW LEVEL SECURITY;

--
-- Name: sso_providers; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.sso_providers ENABLE ROW LEVEL SECURITY;

--
-- Name: users; Type: ROW SECURITY; Schema: auth; Owner: -
--

ALTER TABLE auth.users ENABLE ROW LEVEL SECURITY;

--
-- Name: nosotros_narratives Couple members can view narratives; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Couple members can view narratives" ON public.nosotros_narratives FOR SELECT USING ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: nosotros_narratives Service role can delete narratives; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role can delete narratives" ON public.nosotros_narratives FOR DELETE USING (true);


--
-- Name: nosotros_narratives Service role can insert narratives; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role can insert narratives" ON public.nosotros_narratives FOR INSERT WITH CHECK (true);


--
-- Name: nosotros_narratives Service role can update narratives; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Service role can update narratives" ON public.nosotros_narratives FOR UPDATE USING (true);


--
-- Name: custom_evaluations Users can create custom evaluations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can create custom evaluations" ON public.custom_evaluations FOR INSERT WITH CHECK (((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))) AND (created_by = auth.uid())));


--
-- Name: custom_evaluation_insights Users can insert couple custom evaluation insights; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert couple custom evaluation insights" ON public.custom_evaluation_insights FOR INSERT WITH CHECK ((evaluation_id IN ( SELECT custom_evaluations.id
   FROM public.custom_evaluations
  WHERE (custom_evaluations.couple_id IN ( SELECT couple_members.couple_id
           FROM public.couple_members
          WHERE (couple_members.user_id = auth.uid()))))));


--
-- Name: custom_evaluation_questions Users can insert couple custom evaluation questions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert couple custom evaluation questions" ON public.custom_evaluation_questions FOR INSERT WITH CHECK ((evaluation_id IN ( SELECT custom_evaluations.id
   FROM public.custom_evaluations
  WHERE (custom_evaluations.couple_id IN ( SELECT couple_members.couple_id
           FROM public.couple_members
          WHERE (couple_members.user_id = auth.uid()))))));


--
-- Name: custom_evaluation_answers Users can insert own answers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can insert own answers" ON public.custom_evaluation_answers FOR INSERT WITH CHECK (((user_id = auth.uid()) AND (evaluation_id IN ( SELECT custom_evaluations.id
   FROM public.custom_evaluations
  WHERE (custom_evaluations.couple_id IN ( SELECT couple_members.couple_id
           FROM public.couple_members
          WHERE (couple_members.user_id = auth.uid())))))));


--
-- Name: custom_evaluation_answers Users can update own answers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update own answers" ON public.custom_evaluation_answers FOR UPDATE USING ((user_id = auth.uid()));


--
-- Name: custom_evaluations Users can update their custom evaluations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can update their custom evaluations" ON public.custom_evaluations FOR UPDATE USING ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: custom_evaluation_answers Users can view couple answers; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view couple answers" ON public.custom_evaluation_answers FOR SELECT USING ((evaluation_id IN ( SELECT custom_evaluations.id
   FROM public.custom_evaluations
  WHERE (custom_evaluations.couple_id IN ( SELECT couple_members.couple_id
           FROM public.couple_members
          WHERE (couple_members.user_id = auth.uid()))))));


--
-- Name: custom_evaluation_insights Users can view couple custom evaluation insights; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view couple custom evaluation insights" ON public.custom_evaluation_insights FOR SELECT USING ((evaluation_id IN ( SELECT custom_evaluations.id
   FROM public.custom_evaluations
  WHERE (custom_evaluations.couple_id IN ( SELECT couple_members.couple_id
           FROM public.couple_members
          WHERE (couple_members.user_id = auth.uid()))))));


--
-- Name: custom_evaluation_questions Users can view couple custom evaluation questions; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view couple custom evaluation questions" ON public.custom_evaluation_questions FOR SELECT USING ((evaluation_id IN ( SELECT custom_evaluations.id
   FROM public.custom_evaluations
  WHERE (custom_evaluations.couple_id IN ( SELECT couple_members.couple_id
           FROM public.couple_members
          WHERE (couple_members.user_id = auth.uid()))))));


--
-- Name: custom_evaluations Users can view couple custom evaluations; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY "Users can view couple custom evaluations" ON public.custom_evaluations FOR SELECT USING ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: ai_audit_log; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ai_audit_log ENABLE ROW LEVEL SECURITY;

--
-- Name: ai_audit_log ai_audit_log_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_audit_log_select ON public.ai_audit_log FOR SELECT TO authenticated USING (true);


--
-- Name: ai_insights; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.ai_insights ENABLE ROW LEVEL SECURITY;

--
-- Name: ai_insights ai_insights_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY ai_insights_select ON public.ai_insights FOR SELECT TO authenticated USING ((user_id = auth.uid()));


--
-- Name: answer_options; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.answer_options ENABLE ROW LEVEL SECURITY;

--
-- Name: answer_options answer_options_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY answer_options_select ON public.answer_options FOR SELECT TO authenticated USING (true);


--
-- Name: challenge_assignments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.challenge_assignments ENABLE ROW LEVEL SECURITY;

--
-- Name: challenge_assignments challenge_assignments_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY challenge_assignments_insert ON public.challenge_assignments FOR INSERT TO authenticated WITH CHECK ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: challenge_assignments challenge_assignments_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY challenge_assignments_select ON public.challenge_assignments FOR SELECT TO authenticated USING ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: challenge_assignments challenge_assignments_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY challenge_assignments_update ON public.challenge_assignments FOR UPDATE TO authenticated USING ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: conocernos_answers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.conocernos_answers ENABLE ROW LEVEL SECURITY;

--
-- Name: conocernos_answers conocernos_answers_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY conocernos_answers_insert ON public.conocernos_answers FOR INSERT TO authenticated WITH CHECK ((user_id = auth.uid()));


--
-- Name: conocernos_answers conocernos_answers_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY conocernos_answers_read ON public.conocernos_answers FOR SELECT TO authenticated USING ((user_id = auth.uid()));


--
-- Name: conocernos_daily; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.conocernos_daily ENABLE ROW LEVEL SECURITY;

--
-- Name: conocernos_daily conocernos_daily_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY conocernos_daily_insert ON public.conocernos_daily FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: conocernos_daily conocernos_daily_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY conocernos_daily_read ON public.conocernos_daily FOR SELECT TO authenticated USING ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: conocernos_questions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.conocernos_questions ENABLE ROW LEVEL SECURITY;

--
-- Name: conocernos_questions conocernos_questions_read; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY conocernos_questions_read ON public.conocernos_questions FOR SELECT TO authenticated USING (true);


--
-- Name: conocernos_reactions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.conocernos_reactions ENABLE ROW LEVEL SECURITY;

--
-- Name: conocernos_reactions conocernos_reactions_all; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY conocernos_reactions_all ON public.conocernos_reactions TO authenticated USING ((user_id = auth.uid()));


--
-- Name: couple_insights; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.couple_insights ENABLE ROW LEVEL SECURITY;

--
-- Name: couple_insights couple_insights_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY couple_insights_select ON public.couple_insights FOR SELECT TO authenticated USING ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: couple_members; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.couple_members ENABLE ROW LEVEL SECURITY;

--
-- Name: couple_members couple_members_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY couple_members_insert ON public.couple_members FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: couple_members couple_members_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY couple_members_select ON public.couple_members FOR SELECT TO authenticated USING ((user_id = auth.uid()));


--
-- Name: couple_reports; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.couple_reports ENABLE ROW LEVEL SECURITY;

--
-- Name: couple_reports couple_reports_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY couple_reports_select ON public.couple_reports FOR SELECT TO authenticated USING ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: couple_vectors; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.couple_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: couple_vectors couple_vectors_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY couple_vectors_select ON public.couple_vectors FOR SELECT TO authenticated USING ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: couples; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.couples ENABLE ROW LEVEL SECURITY;

--
-- Name: couples couples_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY couples_insert ON public.couples FOR INSERT TO authenticated WITH CHECK ((auth.uid() = created_by));


--
-- Name: couples couples_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY couples_select ON public.couples FOR SELECT TO authenticated USING ((id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: couples couples_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY couples_update ON public.couples FOR UPDATE TO authenticated USING ((id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: custom_evaluation_answers; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.custom_evaluation_answers ENABLE ROW LEVEL SECURITY;

--
-- Name: custom_evaluation_insights; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.custom_evaluation_insights ENABLE ROW LEVEL SECURITY;

--
-- Name: custom_evaluation_questions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.custom_evaluation_questions ENABLE ROW LEVEL SECURITY;

--
-- Name: custom_evaluations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.custom_evaluations ENABLE ROW LEVEL SECURITY;

--
-- Name: daily_tips; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.daily_tips ENABLE ROW LEVEL SECURITY;

--
-- Name: daily_tips daily_tips_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY daily_tips_insert ON public.daily_tips FOR INSERT TO authenticated WITH CHECK (true);


--
-- Name: daily_tips daily_tips_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY daily_tips_select ON public.daily_tips FOR SELECT TO authenticated USING ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: daily_tips daily_tips_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY daily_tips_update ON public.daily_tips FOR UPDATE TO authenticated USING (true);


--
-- Name: dimension_keys; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.dimension_keys ENABLE ROW LEVEL SECURITY;

--
-- Name: dimension_keys dimension_keys_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY dimension_keys_select ON public.dimension_keys FOR SELECT TO authenticated USING (true);


--
-- Name: dimension_scores; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.dimension_scores ENABLE ROW LEVEL SECURITY;

--
-- Name: dimension_scores dimension_scores_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY dimension_scores_select ON public.dimension_scores FOR SELECT TO authenticated USING ((user_id = auth.uid()));


--
-- Name: generated_assessment_items; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.generated_assessment_items ENABLE ROW LEVEL SECURITY;

--
-- Name: generated_assessment_items generated_assessment_items_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY generated_assessment_items_select ON public.generated_assessment_items FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.generated_assessments
  WHERE ((generated_assessments.id = generated_assessment_items.assessment_id) AND (generated_assessments.couple_id IN ( SELECT couple_members.couple_id
           FROM public.couple_members
          WHERE (couple_members.user_id = auth.uid())))))));


--
-- Name: generated_assessments; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.generated_assessments ENABLE ROW LEVEL SECURITY;

--
-- Name: generated_assessments generated_assessments_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY generated_assessments_select ON public.generated_assessments FOR SELECT TO authenticated USING ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: guided_conversations; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.guided_conversations ENABLE ROW LEVEL SECURITY;

--
-- Name: guided_conversations guided_conversations_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY guided_conversations_select ON public.guided_conversations FOR SELECT TO authenticated USING (true);


--
-- Name: item_bank; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.item_bank ENABLE ROW LEVEL SECURITY;

--
-- Name: item_bank item_bank_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY item_bank_select ON public.item_bank FOR SELECT TO authenticated USING (true);


--
-- Name: item_dimensions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.item_dimensions ENABLE ROW LEVEL SECURITY;

--
-- Name: item_dimensions item_dimensions_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY item_dimensions_select ON public.item_dimensions FOR SELECT TO authenticated USING (true);


--
-- Name: milestones; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.milestones ENABLE ROW LEVEL SECURITY;

--
-- Name: milestones milestones_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY milestones_insert ON public.milestones FOR INSERT TO authenticated WITH CHECK ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: milestones milestones_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY milestones_select ON public.milestones FOR SELECT TO authenticated USING ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: nosotros_narratives; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.nosotros_narratives ENABLE ROW LEVEL SECURITY;

--
-- Name: onboarding_responses; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.onboarding_responses ENABLE ROW LEVEL SECURITY;

--
-- Name: onboarding_responses onboarding_responses_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY onboarding_responses_insert ON public.onboarding_responses FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.onboarding_sessions
  WHERE ((onboarding_sessions.id = onboarding_responses.session_id) AND (onboarding_sessions.user_id = auth.uid())))));


--
-- Name: onboarding_responses onboarding_responses_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY onboarding_responses_select ON public.onboarding_responses FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.onboarding_sessions
  WHERE ((onboarding_sessions.id = onboarding_responses.session_id) AND (onboarding_sessions.user_id = auth.uid())))));


--
-- Name: onboarding_responses onboarding_responses_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY onboarding_responses_update ON public.onboarding_responses FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.onboarding_sessions
  WHERE ((onboarding_sessions.id = onboarding_responses.session_id) AND (onboarding_sessions.user_id = auth.uid())))));


--
-- Name: onboarding_sessions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.onboarding_sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: onboarding_sessions onboarding_sessions_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY onboarding_sessions_insert ON public.onboarding_sessions FOR INSERT TO authenticated WITH CHECK ((user_id = auth.uid()));


--
-- Name: onboarding_sessions onboarding_sessions_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY onboarding_sessions_select ON public.onboarding_sessions FOR SELECT TO authenticated USING ((user_id = auth.uid()));


--
-- Name: onboarding_sessions onboarding_sessions_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY onboarding_sessions_update ON public.onboarding_sessions FOR UPDATE TO authenticated USING ((user_id = auth.uid()));


--
-- Name: personal_reports; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.personal_reports ENABLE ROW LEVEL SECURITY;

--
-- Name: personal_reports personal_reports_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY personal_reports_select ON public.personal_reports FOR SELECT TO authenticated USING ((user_id = auth.uid()));


--
-- Name: profile_vectors; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.profile_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: profile_vectors profile_vectors_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profile_vectors_insert ON public.profile_vectors FOR INSERT TO authenticated WITH CHECK ((user_id = auth.uid()));


--
-- Name: profile_vectors profile_vectors_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profile_vectors_select ON public.profile_vectors FOR SELECT TO authenticated USING ((user_id = auth.uid()));


--
-- Name: profile_vectors profile_vectors_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profile_vectors_update ON public.profile_vectors FOR UPDATE TO authenticated USING ((user_id = auth.uid()));


--
-- Name: profiles; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;

--
-- Name: profiles profiles_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_insert ON public.profiles FOR INSERT TO authenticated WITH CHECK ((auth.uid() = id));


--
-- Name: profiles profiles_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_select ON public.profiles FOR SELECT TO authenticated USING ((auth.uid() = id));


--
-- Name: profiles profiles_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY profiles_update ON public.profiles FOR UPDATE TO authenticated USING ((auth.uid() = id));


--
-- Name: question_dimension_map; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.question_dimension_map ENABLE ROW LEVEL SECURITY;

--
-- Name: question_dimension_map question_dimension_map_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY question_dimension_map_select ON public.question_dimension_map FOR SELECT TO authenticated USING (true);


--
-- Name: questionnaire_sections; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.questionnaire_sections ENABLE ROW LEVEL SECURITY;

--
-- Name: questionnaire_sections questionnaire_sections_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY questionnaire_sections_select ON public.questionnaire_sections FOR SELECT TO authenticated USING (true);


--
-- Name: questionnaires; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.questionnaires ENABLE ROW LEVEL SECURITY;

--
-- Name: questionnaires questionnaires_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY questionnaires_select ON public.questionnaires FOR SELECT TO authenticated USING (true);


--
-- Name: questions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.questions ENABLE ROW LEVEL SECURITY;

--
-- Name: questions questions_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY questions_select ON public.questions FOR SELECT TO authenticated USING (true);


--
-- Name: response_sessions; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.response_sessions ENABLE ROW LEVEL SECURITY;

--
-- Name: response_sessions response_sessions_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY response_sessions_insert ON public.response_sessions FOR INSERT TO authenticated WITH CHECK ((user_id = auth.uid()));


--
-- Name: response_sessions response_sessions_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY response_sessions_select ON public.response_sessions FOR SELECT TO authenticated USING ((user_id = auth.uid()));


--
-- Name: response_sessions response_sessions_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY response_sessions_update ON public.response_sessions FOR UPDATE TO authenticated USING ((user_id = auth.uid()));


--
-- Name: responses; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.responses ENABLE ROW LEVEL SECURITY;

--
-- Name: responses responses_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY responses_insert ON public.responses FOR INSERT TO authenticated WITH CHECK ((EXISTS ( SELECT 1
   FROM public.response_sessions
  WHERE ((response_sessions.id = responses.session_id) AND (response_sessions.user_id = auth.uid())))));


--
-- Name: responses responses_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY responses_select ON public.responses FOR SELECT TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.response_sessions
  WHERE ((response_sessions.id = responses.session_id) AND (response_sessions.user_id = auth.uid())))));


--
-- Name: responses responses_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY responses_update ON public.responses FOR UPDATE TO authenticated USING ((EXISTS ( SELECT 1
   FROM public.response_sessions
  WHERE ((response_sessions.id = responses.session_id) AND (response_sessions.user_id = auth.uid())))));


--
-- Name: weekly_challenges; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.weekly_challenges ENABLE ROW LEVEL SECURITY;

--
-- Name: weekly_challenges weekly_challenges_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY weekly_challenges_select ON public.weekly_challenges FOR SELECT TO authenticated USING (true);


--
-- Name: weekly_plan_items; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.weekly_plan_items ENABLE ROW LEVEL SECURITY;

--
-- Name: weekly_plan_items weekly_plan_items_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY weekly_plan_items_insert ON public.weekly_plan_items FOR INSERT TO authenticated WITH CHECK ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: weekly_plan_items weekly_plan_items_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY weekly_plan_items_select ON public.weekly_plan_items FOR SELECT TO authenticated USING ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: weekly_plan_items weekly_plan_items_update; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY weekly_plan_items_update ON public.weekly_plan_items FOR UPDATE TO authenticated USING ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: weekly_plans; Type: ROW SECURITY; Schema: public; Owner: -
--

ALTER TABLE public.weekly_plans ENABLE ROW LEVEL SECURITY;

--
-- Name: weekly_plans weekly_plans_insert; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY weekly_plans_insert ON public.weekly_plans FOR INSERT TO authenticated WITH CHECK ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: weekly_plans weekly_plans_select; Type: POLICY; Schema: public; Owner: -
--

CREATE POLICY weekly_plans_select ON public.weekly_plans FOR SELECT TO authenticated USING ((couple_id IN ( SELECT couple_members.couple_id
   FROM public.couple_members
  WHERE (couple_members.user_id = auth.uid()))));


--
-- Name: messages; Type: ROW SECURITY; Schema: realtime; Owner: -
--

ALTER TABLE realtime.messages ENABLE ROW LEVEL SECURITY;

--
-- Name: objects Anyone can view avatars; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Anyone can view avatars" ON storage.objects FOR SELECT USING ((bucket_id = 'avatars'::text));


--
-- Name: objects Users can delete their own avatar; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Users can delete their own avatar" ON storage.objects FOR DELETE TO authenticated USING (((bucket_id = 'avatars'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- Name: objects Users can update their own avatar; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Users can update their own avatar" ON storage.objects FOR UPDATE TO authenticated USING (((bucket_id = 'avatars'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- Name: objects Users can upload their own avatar; Type: POLICY; Schema: storage; Owner: -
--

CREATE POLICY "Users can upload their own avatar" ON storage.objects FOR INSERT TO authenticated WITH CHECK (((bucket_id = 'avatars'::text) AND ((storage.foldername(name))[1] = (auth.uid())::text)));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_analytics; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_analytics ENABLE ROW LEVEL SECURITY;

--
-- Name: buckets_vectors; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.buckets_vectors ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads ENABLE ROW LEVEL SECURITY;

--
-- Name: s3_multipart_uploads_parts; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.s3_multipart_uploads_parts ENABLE ROW LEVEL SECURITY;

--
-- Name: vector_indexes; Type: ROW SECURITY; Schema: storage; Owner: -
--

ALTER TABLE storage.vector_indexes ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: -
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: -
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT USAGE ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: -
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: -
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: -
--

GRANT USAGE ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO anon;
GRANT USAGE ON SCHEMA realtime TO authenticated;
GRANT USAGE ON SCHEMA realtime TO service_role;
GRANT ALL ON SCHEMA realtime TO supabase_realtime_admin;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: -
--

GRANT USAGE ON SCHEMA storage TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA vault; Type: ACL; Schema: -; Owner: -
--

GRANT USAGE ON SCHEMA vault TO postgres WITH GRANT OPTION;
GRANT USAGE ON SCHEMA vault TO service_role;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.armor(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.armor(bytea, text[], text[]) FROM postgres;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.crypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.dearmor(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.digest(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.digest(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.gen_random_bytes(integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.gen_random_uuid() FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.gen_salt(text, integer) FROM postgres;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.grant_pg_cron_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_graphql_access(); Type: ACL; Schema: extensions; Owner: -
--

GRANT ALL ON FUNCTION extensions.grant_pg_graphql_access() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.grant_pg_net_access() FROM supabase_admin;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO supabase_admin WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.hmac(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.hmac(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT shared_blk_read_time double precision, OUT shared_blk_write_time double precision, OUT local_blk_read_time double precision, OUT local_blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision, OUT jit_deform_count bigint, OUT jit_deform_time double precision, OUT stats_since timestamp with time zone, OUT minmax_stats_since timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) FROM postgres;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint, minmax_only boolean) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_key_id(bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) FROM postgres;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgrst_ddl_watch(); Type: ACL; Schema: extensions; Owner: -
--

GRANT ALL ON FUNCTION extensions.pgrst_ddl_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION pgrst_drop_watch(); Type: ACL; Schema: extensions; Owner: -
--

GRANT ALL ON FUNCTION extensions.pgrst_drop_watch() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION set_graphql_placeholder(); Type: ACL; Schema: extensions; Owner: -
--

GRANT ALL ON FUNCTION extensions.set_graphql_placeholder() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v1mc() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v4() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.uuid_nil() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_dns() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_oid() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_url() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON FUNCTION extensions.uuid_ns_x500() FROM postgres;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: -
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION pg_reload_conf(); Type: ACL; Schema: pg_catalog; Owner: -
--

GRANT ALL ON FUNCTION pg_catalog.pg_reload_conf() TO postgres WITH GRANT OPTION;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: -
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION generate_invite_code(); Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON FUNCTION public.generate_invite_code() TO anon;
GRANT ALL ON FUNCTION public.generate_invite_code() TO authenticated;
GRANT ALL ON FUNCTION public.generate_invite_code() TO service_role;


--
-- Name: FUNCTION get_couple_id_for_user(user_uuid uuid); Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON FUNCTION public.get_couple_id_for_user(user_uuid uuid) TO anon;
GRANT ALL ON FUNCTION public.get_couple_id_for_user(user_uuid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.get_couple_id_for_user(user_uuid uuid) TO service_role;


--
-- Name: FUNCTION get_my_couple_ids(); Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON FUNCTION public.get_my_couple_ids() TO anon;
GRANT ALL ON FUNCTION public.get_my_couple_ids() TO authenticated;
GRANT ALL ON FUNCTION public.get_my_couple_ids() TO service_role;


--
-- Name: FUNCTION get_my_couple_partner_ids(); Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON FUNCTION public.get_my_couple_partner_ids() TO anon;
GRANT ALL ON FUNCTION public.get_my_couple_partner_ids() TO authenticated;
GRANT ALL ON FUNCTION public.get_my_couple_partner_ids() TO service_role;


--
-- Name: FUNCTION handle_new_user(); Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON FUNCTION public.handle_new_user() TO anon;
GRANT ALL ON FUNCTION public.handle_new_user() TO authenticated;
GRANT ALL ON FUNCTION public.handle_new_user() TO service_role;


--
-- Name: FUNCTION has_couple(user_uuid uuid); Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON FUNCTION public.has_couple(user_uuid uuid) TO anon;
GRANT ALL ON FUNCTION public.has_couple(user_uuid uuid) TO authenticated;
GRANT ALL ON FUNCTION public.has_couple(user_uuid uuid) TO service_role;


--
-- Name: FUNCTION is_member_of_couple(target_couple_id uuid); Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON FUNCTION public.is_member_of_couple(target_couple_id uuid) TO anon;
GRANT ALL ON FUNCTION public.is_member_of_couple(target_couple_id uuid) TO authenticated;
GRANT ALL ON FUNCTION public.is_member_of_couple(target_couple_id uuid) TO service_role;


--
-- Name: FUNCTION refresh_couple_status_view(); Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON FUNCTION public.refresh_couple_status_view() TO anon;
GRANT ALL ON FUNCTION public.refresh_couple_status_view() TO authenticated;
GRANT ALL ON FUNCTION public.refresh_couple_status_view() TO service_role;


--
-- Name: FUNCTION update_updated_at_column(); Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON FUNCTION public.update_updated_at_column() TO anon;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO authenticated;
GRANT ALL ON FUNCTION public.update_updated_at_column() TO service_role;


--
-- Name: FUNCTION apply_rls(wal jsonb, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.apply_rls(wal jsonb, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text); Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO postgres;
GRANT ALL ON FUNCTION realtime.broadcast_changes(topic_name text, event_name text, operation text, table_name text, table_schema text, new record, old record, level text) TO dashboard_user;


--
-- Name: FUNCTION build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]); Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO postgres;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO anon;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO service_role;
GRANT ALL ON FUNCTION realtime.build_prepared_statement_sql(prepared_statement_name text, entity regclass, columns realtime.wal_column[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION "cast"(val text, type_ regtype); Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO postgres;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO dashboard_user;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO anon;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO authenticated;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO service_role;
GRANT ALL ON FUNCTION realtime."cast"(val text, type_ regtype) TO supabase_realtime_admin;


--
-- Name: FUNCTION check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text); Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO postgres;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO anon;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO authenticated;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO service_role;
GRANT ALL ON FUNCTION realtime.check_equality_op(op realtime.equality_op, type_ regtype, val_1 text, val_2 text) TO supabase_realtime_admin;


--
-- Name: FUNCTION is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]); Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO postgres;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO anon;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO authenticated;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO service_role;
GRANT ALL ON FUNCTION realtime.is_visible_through_filters(columns realtime.wal_column[], filters realtime.user_defined_filter[]) TO supabase_realtime_admin;


--
-- Name: FUNCTION list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer); Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO postgres;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO anon;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO authenticated;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO service_role;
GRANT ALL ON FUNCTION realtime.list_changes(publication name, slot_name name, max_changes integer, max_record_bytes integer) TO supabase_realtime_admin;


--
-- Name: FUNCTION quote_wal2json(entity regclass); Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO postgres;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO anon;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO authenticated;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO service_role;
GRANT ALL ON FUNCTION realtime.quote_wal2json(entity regclass) TO supabase_realtime_admin;


--
-- Name: FUNCTION send(payload jsonb, event text, topic text, private boolean); Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO postgres;
GRANT ALL ON FUNCTION realtime.send(payload jsonb, event text, topic text, private boolean) TO dashboard_user;


--
-- Name: FUNCTION subscription_check_filters(); Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO postgres;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO dashboard_user;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO anon;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO authenticated;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO service_role;
GRANT ALL ON FUNCTION realtime.subscription_check_filters() TO supabase_realtime_admin;


--
-- Name: FUNCTION to_regrole(role_name text); Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO postgres;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO dashboard_user;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO anon;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO authenticated;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO service_role;
GRANT ALL ON FUNCTION realtime.to_regrole(role_name text) TO supabase_realtime_admin;


--
-- Name: FUNCTION topic(); Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON FUNCTION realtime.topic() TO postgres;
GRANT ALL ON FUNCTION realtime.topic() TO dashboard_user;


--
-- Name: FUNCTION _crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea); Type: ACL; Schema: vault; Owner: -
--

GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault._crypto_aead_det_decrypt(message bytea, additional bytea, key_id bigint, context bytea, nonce bytea) TO service_role;


--
-- Name: FUNCTION create_secret(new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: -
--

GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.create_secret(new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: FUNCTION update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid); Type: ACL; Schema: vault; Owner: -
--

GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO postgres WITH GRANT OPTION;
GRANT ALL ON FUNCTION vault.update_secret(secret_id uuid, new_secret text, new_name text, new_description text, new_key_id uuid) TO service_role;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.audit_log_entries TO postgres;
GRANT SELECT ON TABLE auth.audit_log_entries TO postgres WITH GRANT OPTION;


--
-- Name: TABLE custom_oauth_providers; Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON TABLE auth.custom_oauth_providers TO postgres;
GRANT ALL ON TABLE auth.custom_oauth_providers TO dashboard_user;


--
-- Name: TABLE flow_state; Type: ACL; Schema: auth; Owner: -
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.flow_state TO postgres;
GRANT SELECT ON TABLE auth.flow_state TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.flow_state TO dashboard_user;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: -
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.identities TO postgres;
GRANT SELECT ON TABLE auth.identities TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.instances TO postgres;
GRANT SELECT ON TABLE auth.instances TO postgres WITH GRANT OPTION;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: -
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_amr_claims TO postgres;
GRANT SELECT ON TABLE auth.mfa_amr_claims TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: -
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_challenges TO postgres;
GRANT SELECT ON TABLE auth.mfa_challenges TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: -
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.mfa_factors TO postgres;
GRANT SELECT ON TABLE auth.mfa_factors TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE oauth_authorizations; Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON TABLE auth.oauth_authorizations TO postgres;
GRANT ALL ON TABLE auth.oauth_authorizations TO dashboard_user;


--
-- Name: TABLE oauth_client_states; Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON TABLE auth.oauth_client_states TO postgres;
GRANT ALL ON TABLE auth.oauth_client_states TO dashboard_user;


--
-- Name: TABLE oauth_clients; Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON TABLE auth.oauth_clients TO postgres;
GRANT ALL ON TABLE auth.oauth_clients TO dashboard_user;


--
-- Name: TABLE oauth_consents; Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON TABLE auth.oauth_consents TO postgres;
GRANT ALL ON TABLE auth.oauth_consents TO dashboard_user;


--
-- Name: TABLE one_time_tokens; Type: ACL; Schema: auth; Owner: -
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.one_time_tokens TO postgres;
GRANT SELECT ON TABLE auth.one_time_tokens TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.one_time_tokens TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.refresh_tokens TO postgres;
GRANT SELECT ON TABLE auth.refresh_tokens TO postgres WITH GRANT OPTION;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: -
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_providers TO postgres;
GRANT SELECT ON TABLE auth.saml_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: -
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.saml_relay_states TO postgres;
GRANT SELECT ON TABLE auth.saml_relay_states TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: -
--

GRANT SELECT ON TABLE auth.schema_migrations TO postgres WITH GRANT OPTION;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: -
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sessions TO postgres;
GRANT SELECT ON TABLE auth.sessions TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: -
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_domains TO postgres;
GRANT SELECT ON TABLE auth.sso_domains TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: -
--

GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.sso_providers TO postgres;
GRANT SELECT ON TABLE auth.sso_providers TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,MAINTAIN,UPDATE ON TABLE auth.users TO postgres;
GRANT SELECT ON TABLE auth.users TO postgres WITH GRANT OPTION;


--
-- Name: TABLE webauthn_challenges; Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON TABLE auth.webauthn_challenges TO postgres;
GRANT ALL ON TABLE auth.webauthn_challenges TO dashboard_user;


--
-- Name: TABLE webauthn_credentials; Type: ACL; Schema: auth; Owner: -
--

GRANT ALL ON TABLE auth.webauthn_credentials TO postgres;
GRANT ALL ON TABLE auth.webauthn_credentials TO dashboard_user;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON TABLE extensions.pg_stat_statements FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: -
--

REVOKE ALL ON TABLE extensions.pg_stat_statements_info FROM postgres;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO postgres WITH GRANT OPTION;
GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: TABLE ai_audit_log; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.ai_audit_log TO anon;
GRANT ALL ON TABLE public.ai_audit_log TO authenticated;
GRANT ALL ON TABLE public.ai_audit_log TO service_role;


--
-- Name: TABLE ai_insights; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.ai_insights TO anon;
GRANT ALL ON TABLE public.ai_insights TO authenticated;
GRANT ALL ON TABLE public.ai_insights TO service_role;


--
-- Name: TABLE answer_options; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.answer_options TO anon;
GRANT ALL ON TABLE public.answer_options TO authenticated;
GRANT ALL ON TABLE public.answer_options TO service_role;


--
-- Name: TABLE challenge_assignments; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.challenge_assignments TO anon;
GRANT ALL ON TABLE public.challenge_assignments TO authenticated;
GRANT ALL ON TABLE public.challenge_assignments TO service_role;


--
-- Name: TABLE conocernos_answers; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.conocernos_answers TO anon;
GRANT ALL ON TABLE public.conocernos_answers TO authenticated;
GRANT ALL ON TABLE public.conocernos_answers TO service_role;


--
-- Name: TABLE conocernos_daily; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.conocernos_daily TO anon;
GRANT ALL ON TABLE public.conocernos_daily TO authenticated;
GRANT ALL ON TABLE public.conocernos_daily TO service_role;


--
-- Name: TABLE conocernos_questions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.conocernos_questions TO anon;
GRANT ALL ON TABLE public.conocernos_questions TO authenticated;
GRANT ALL ON TABLE public.conocernos_questions TO service_role;


--
-- Name: TABLE conocernos_reactions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.conocernos_reactions TO anon;
GRANT ALL ON TABLE public.conocernos_reactions TO authenticated;
GRANT ALL ON TABLE public.conocernos_reactions TO service_role;


--
-- Name: TABLE couple_insights; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.couple_insights TO anon;
GRANT ALL ON TABLE public.couple_insights TO authenticated;
GRANT ALL ON TABLE public.couple_insights TO service_role;


--
-- Name: TABLE couple_members; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.couple_members TO anon;
GRANT ALL ON TABLE public.couple_members TO authenticated;
GRANT ALL ON TABLE public.couple_members TO service_role;


--
-- Name: TABLE couple_reports; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.couple_reports TO anon;
GRANT ALL ON TABLE public.couple_reports TO authenticated;
GRANT ALL ON TABLE public.couple_reports TO service_role;


--
-- Name: TABLE couple_vectors; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.couple_vectors TO anon;
GRANT ALL ON TABLE public.couple_vectors TO authenticated;
GRANT ALL ON TABLE public.couple_vectors TO service_role;


--
-- Name: TABLE couples; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.couples TO anon;
GRANT ALL ON TABLE public.couples TO authenticated;
GRANT ALL ON TABLE public.couples TO service_role;


--
-- Name: TABLE custom_evaluation_answers; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.custom_evaluation_answers TO anon;
GRANT ALL ON TABLE public.custom_evaluation_answers TO authenticated;
GRANT ALL ON TABLE public.custom_evaluation_answers TO service_role;


--
-- Name: TABLE custom_evaluation_insights; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.custom_evaluation_insights TO anon;
GRANT ALL ON TABLE public.custom_evaluation_insights TO authenticated;
GRANT ALL ON TABLE public.custom_evaluation_insights TO service_role;


--
-- Name: TABLE custom_evaluation_questions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.custom_evaluation_questions TO anon;
GRANT ALL ON TABLE public.custom_evaluation_questions TO authenticated;
GRANT ALL ON TABLE public.custom_evaluation_questions TO service_role;


--
-- Name: TABLE custom_evaluations; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.custom_evaluations TO anon;
GRANT ALL ON TABLE public.custom_evaluations TO authenticated;
GRANT ALL ON TABLE public.custom_evaluations TO service_role;


--
-- Name: TABLE daily_tips; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.daily_tips TO anon;
GRANT ALL ON TABLE public.daily_tips TO authenticated;
GRANT ALL ON TABLE public.daily_tips TO service_role;


--
-- Name: TABLE dimension_keys; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.dimension_keys TO anon;
GRANT ALL ON TABLE public.dimension_keys TO authenticated;
GRANT ALL ON TABLE public.dimension_keys TO service_role;


--
-- Name: TABLE dimension_scores; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.dimension_scores TO anon;
GRANT ALL ON TABLE public.dimension_scores TO authenticated;
GRANT ALL ON TABLE public.dimension_scores TO service_role;


--
-- Name: TABLE generated_assessment_items; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.generated_assessment_items TO anon;
GRANT ALL ON TABLE public.generated_assessment_items TO authenticated;
GRANT ALL ON TABLE public.generated_assessment_items TO service_role;


--
-- Name: TABLE generated_assessments; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.generated_assessments TO anon;
GRANT ALL ON TABLE public.generated_assessments TO authenticated;
GRANT ALL ON TABLE public.generated_assessments TO service_role;


--
-- Name: TABLE guided_conversations; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.guided_conversations TO anon;
GRANT ALL ON TABLE public.guided_conversations TO authenticated;
GRANT ALL ON TABLE public.guided_conversations TO service_role;


--
-- Name: TABLE item_bank; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.item_bank TO anon;
GRANT ALL ON TABLE public.item_bank TO authenticated;
GRANT ALL ON TABLE public.item_bank TO service_role;


--
-- Name: TABLE item_dimensions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.item_dimensions TO anon;
GRANT ALL ON TABLE public.item_dimensions TO authenticated;
GRANT ALL ON TABLE public.item_dimensions TO service_role;


--
-- Name: TABLE milestones; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.milestones TO anon;
GRANT ALL ON TABLE public.milestones TO authenticated;
GRANT ALL ON TABLE public.milestones TO service_role;


--
-- Name: TABLE nosotros_narratives; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.nosotros_narratives TO anon;
GRANT ALL ON TABLE public.nosotros_narratives TO authenticated;
GRANT ALL ON TABLE public.nosotros_narratives TO service_role;


--
-- Name: TABLE onboarding_responses; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.onboarding_responses TO anon;
GRANT ALL ON TABLE public.onboarding_responses TO authenticated;
GRANT ALL ON TABLE public.onboarding_responses TO service_role;


--
-- Name: TABLE onboarding_sessions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.onboarding_sessions TO anon;
GRANT ALL ON TABLE public.onboarding_sessions TO authenticated;
GRANT ALL ON TABLE public.onboarding_sessions TO service_role;


--
-- Name: TABLE personal_reports; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.personal_reports TO anon;
GRANT ALL ON TABLE public.personal_reports TO authenticated;
GRANT ALL ON TABLE public.personal_reports TO service_role;


--
-- Name: TABLE profile_vectors; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.profile_vectors TO anon;
GRANT ALL ON TABLE public.profile_vectors TO authenticated;
GRANT ALL ON TABLE public.profile_vectors TO service_role;


--
-- Name: TABLE profiles; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.profiles TO anon;
GRANT ALL ON TABLE public.profiles TO authenticated;
GRANT ALL ON TABLE public.profiles TO service_role;


--
-- Name: TABLE question_dimension_map; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.question_dimension_map TO anon;
GRANT ALL ON TABLE public.question_dimension_map TO authenticated;
GRANT ALL ON TABLE public.question_dimension_map TO service_role;


--
-- Name: TABLE questionnaire_sections; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.questionnaire_sections TO anon;
GRANT ALL ON TABLE public.questionnaire_sections TO authenticated;
GRANT ALL ON TABLE public.questionnaire_sections TO service_role;


--
-- Name: TABLE questionnaires; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.questionnaires TO anon;
GRANT ALL ON TABLE public.questionnaires TO authenticated;
GRANT ALL ON TABLE public.questionnaires TO service_role;


--
-- Name: TABLE questions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.questions TO anon;
GRANT ALL ON TABLE public.questions TO authenticated;
GRANT ALL ON TABLE public.questions TO service_role;


--
-- Name: TABLE response_sessions; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.response_sessions TO anon;
GRANT ALL ON TABLE public.response_sessions TO authenticated;
GRANT ALL ON TABLE public.response_sessions TO service_role;


--
-- Name: TABLE responses; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.responses TO anon;
GRANT ALL ON TABLE public.responses TO authenticated;
GRANT ALL ON TABLE public.responses TO service_role;


--
-- Name: TABLE weekly_challenges; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.weekly_challenges TO anon;
GRANT ALL ON TABLE public.weekly_challenges TO authenticated;
GRANT ALL ON TABLE public.weekly_challenges TO service_role;


--
-- Name: TABLE weekly_plan_items; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.weekly_plan_items TO anon;
GRANT ALL ON TABLE public.weekly_plan_items TO authenticated;
GRANT ALL ON TABLE public.weekly_plan_items TO service_role;


--
-- Name: TABLE weekly_plans; Type: ACL; Schema: public; Owner: -
--

GRANT ALL ON TABLE public.weekly_plans TO anon;
GRANT ALL ON TABLE public.weekly_plans TO authenticated;
GRANT ALL ON TABLE public.weekly_plans TO service_role;


--
-- Name: TABLE messages; Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON TABLE realtime.messages TO postgres;
GRANT ALL ON TABLE realtime.messages TO dashboard_user;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO anon;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO authenticated;
GRANT SELECT,INSERT,UPDATE ON TABLE realtime.messages TO service_role;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON TABLE realtime.schema_migrations TO postgres;
GRANT ALL ON TABLE realtime.schema_migrations TO dashboard_user;
GRANT SELECT ON TABLE realtime.schema_migrations TO anon;
GRANT SELECT ON TABLE realtime.schema_migrations TO authenticated;
GRANT SELECT ON TABLE realtime.schema_migrations TO service_role;
GRANT ALL ON TABLE realtime.schema_migrations TO supabase_realtime_admin;


--
-- Name: TABLE subscription; Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON TABLE realtime.subscription TO postgres;
GRANT ALL ON TABLE realtime.subscription TO dashboard_user;
GRANT SELECT ON TABLE realtime.subscription TO anon;
GRANT SELECT ON TABLE realtime.subscription TO authenticated;
GRANT SELECT ON TABLE realtime.subscription TO service_role;
GRANT ALL ON TABLE realtime.subscription TO supabase_realtime_admin;


--
-- Name: SEQUENCE subscription_id_seq; Type: ACL; Schema: realtime; Owner: -
--

GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO postgres;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO dashboard_user;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO anon;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO authenticated;
GRANT USAGE ON SEQUENCE realtime.subscription_id_seq TO service_role;
GRANT ALL ON SEQUENCE realtime.subscription_id_seq TO supabase_realtime_admin;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: -
--

REVOKE ALL ON TABLE storage.buckets FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.buckets TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO postgres WITH GRANT OPTION;


--
-- Name: TABLE buckets_analytics; Type: ACL; Schema: storage; Owner: -
--

GRANT ALL ON TABLE storage.buckets_analytics TO service_role;
GRANT ALL ON TABLE storage.buckets_analytics TO authenticated;
GRANT ALL ON TABLE storage.buckets_analytics TO anon;


--
-- Name: TABLE buckets_vectors; Type: ACL; Schema: storage; Owner: -
--

GRANT SELECT ON TABLE storage.buckets_vectors TO service_role;
GRANT SELECT ON TABLE storage.buckets_vectors TO authenticated;
GRANT SELECT ON TABLE storage.buckets_vectors TO anon;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: -
--

REVOKE ALL ON TABLE storage.objects FROM supabase_storage_admin;
GRANT ALL ON TABLE storage.objects TO supabase_storage_admin WITH GRANT OPTION;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO postgres WITH GRANT OPTION;


--
-- Name: TABLE s3_multipart_uploads; Type: ACL; Schema: storage; Owner: -
--

GRANT ALL ON TABLE storage.s3_multipart_uploads TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads TO anon;


--
-- Name: TABLE s3_multipart_uploads_parts; Type: ACL; Schema: storage; Owner: -
--

GRANT ALL ON TABLE storage.s3_multipart_uploads_parts TO service_role;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO authenticated;
GRANT SELECT ON TABLE storage.s3_multipart_uploads_parts TO anon;


--
-- Name: TABLE vector_indexes; Type: ACL; Schema: storage; Owner: -
--

GRANT SELECT ON TABLE storage.vector_indexes TO service_role;
GRANT SELECT ON TABLE storage.vector_indexes TO authenticated;
GRANT SELECT ON TABLE storage.vector_indexes TO anon;


--
-- Name: TABLE secrets; Type: ACL; Schema: vault; Owner: -
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.secrets TO service_role;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: vault; Owner: -
--

GRANT SELECT,REFERENCES,DELETE,TRUNCATE ON TABLE vault.decrypted_secrets TO postgres WITH GRANT OPTION;
GRANT SELECT,DELETE ON TABLE vault.decrypted_secrets TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: extensions; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON SEQUENCES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: extensions; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON FUNCTIONS TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: extensions; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA extensions GRANT ALL ON TABLES TO postgres WITH GRANT OPTION;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: -
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES TO service_role;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: -
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


--
-- PostgreSQL database dump complete
--

\unrestrict 9T95aNWufIGBaTkk4s2wKc4lYzRwOCzMx7a5MDThEWaBJaNGAVOhA7DFt7rmQme

