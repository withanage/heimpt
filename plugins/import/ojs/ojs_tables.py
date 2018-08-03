db.define_table("access_keys",
     Field("access_key_id","string"),
     Field("context","string"),
     Field("key_hash","string"),
     Field("user_id","string"),
     Field("assoc_id","string"),
     Field("expiry_date","string"),
)


db.define_table("announcement_settings",
     Field("announcement_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("announcement_type_settings",
     Field("type_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("announcement_types",
     Field("type_id","string"),
     Field("assoc_type","string"),
     Field("assoc_id","string"),
)


db.define_table("announcements",
     Field("announcement_id","integer"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
     Field("type_id","integer"),
     Field("date_expire","string"),
     Field("date_posted","datetime"),
)


db.define_table("auth_sources",
     Field("auth_id","string"),
     Field("title","string"),
     Field("plugin","string"),
     Field("auth_default","string"),
     Field("settings","string"),
)


db.define_table("author_settings",
     Field("author_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("authors",
     Field("author_id","integer"),
     Field("submission_id","integer"),
     Field("primary_contact","integer"),
     Field("seq","string"),
     Field("first_name","string"),
     Field("middle_name","string"),
     Field("last_name","string"),
     Field("suffix","string"),
     Field("country","string"),
     Field("email","string"),
     Field("url","string"),
     Field("user_group_id","integer"),
     Field("include_in_browse","integer"),
)


db.define_table("books_for_review",
     Field("book_id","string"),
     Field("journal_id","string"),
     Field("status","string"),
     Field("author_type","string"),
     Field("publisher","string"),
     Field("year","string"),
     Field("language","string"),
     Field("copy","string"),
     Field("url","string"),
     Field("edition","string"),
     Field("pages","string"),
     Field("isbn","string"),
     Field("date_created","string"),
     Field("date_requested","string"),
     Field("date_assigned","string"),
     Field("date_mailed","string"),
     Field("date_due","string"),
     Field("date_submitted","string"),
     Field("user_id","string"),
     Field("editor_id","string"),
     Field("submission_id","string"),
     Field("notes","string"),
)


db.define_table("books_for_review_authors",
     Field("author_id","string"),
     Field("book_id","string"),
     Field("seq","string"),
     Field("first_name","string"),
     Field("middle_name","string"),
     Field("last_name","string"),
)


db.define_table("books_for_review_settings",
     Field("book_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("captchas",
     Field("captcha_id","integer"),
     Field("session_id","integer"),
     Field("value","string"),
     Field("date_created","datetime"),
)


db.define_table("citation_settings",
     Field("citation_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("citations",
     Field("citation_id","integer"),
     Field("submission_id","integer"),
     Field("raw_citation","string"),
     Field("seq","string"),
)


db.define_table("comments",
     Field("comment_id","integer"),
     Field("submission_id","integer"),
     Field("parent_comment_id","string"),
     Field("num_children","integer"),
     Field("user_id","string"),
     Field("poster_ip","string"),
     Field("poster_name","string"),
     Field("poster_email","string"),
     Field("title","string"),
     Field("body","string"),
     Field("date_posted","datetime"),
     Field("date_modified","datetime"),
)


db.define_table("completed_payments",
     Field("completed_payment_id","string"),
     Field("timestamp","string"),
     Field("payment_type","string"),
     Field("context_id","string"),
     Field("user_id","string"),
     Field("assoc_id","string"),
     Field("amount","string"),
     Field("currency_code_alpha","string"),
     Field("payment_method_plugin_name","string"),
)


db.define_table("controlled_vocab_entries",
     Field("controlled_vocab_entry_id","integer"),
     Field("controlled_vocab_id","integer"),
     Field("seq","string"),
)


db.define_table("controlled_vocab_entry_settings",
     Field("controlled_vocab_entry_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("controlled_vocabs",
     Field("controlled_vocab_id","integer"),
     Field("symbolic","string"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
)


db.define_table("custom_issue_orders",
     Field("issue_id","integer"),
     Field("journal_id","integer"),
     Field("seq","double"),
)


db.define_table("custom_section_orders",
     Field("issue_id","integer"),
     Field("section_id","integer"),
     Field("seq","string"),
)


db.define_table("data_object_tombstone_oai_set_objects",
     Field("object_id","integer"),
     Field("tombstone_id","integer"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
)


db.define_table("data_object_tombstone_settings",
     Field("tombstone_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("data_object_tombstones",
     Field("tombstone_id","integer"),
     Field("data_object_id","integer"),
     Field("date_deleted","datetime"),
     Field("set_spec","string"),
     Field("set_name","string"),
     Field("oai_identifier","string"),
)


db.define_table("dataverse_files",
     Field("dvfile_id","string"),
     Field("supp_id","string"),
     Field("submission_id","string"),
     Field("study_id","string"),
     Field("content_source_uri","string"),
)


db.define_table("dataverse_studies",
     Field("study_id","string"),
     Field("submission_id","string"),
     Field("edit_uri","string"),
     Field("edit_media_uri","string"),
     Field("statement_uri","string"),
     Field("persistent_uri","string"),
     Field("data_citation","string"),
)


db.define_table("edit_assignments",
     Field("edit_id","integer"),
     Field("article_id","integer"),
     Field("editor_id","integer"),
     Field("can_edit","integer"),
     Field("can_review","integer"),
     Field("date_assigned","string"),
     Field("date_notified","string"),
     Field("date_underway","string"),
)


db.define_table("edit_decisions",
     Field("edit_decision_id","integer"),
     Field("submission_id","integer"),
     Field("round","integer"),
     Field("editor_id","integer"),
     Field("decision","integer"),
     Field("date_decided","datetime"),
     Field("review_round_id","string"),
     Field("stage_id","integer"),
)


db.define_table("email_log",
     Field("log_id","string"),
     Field("assoc_type","string"),
     Field("assoc_id","string"),
     Field("sender_id","string"),
     Field("date_sent","string"),
     Field("ip_address","string"),
     Field("event_type","string"),
     Field("from_address","string"),
     Field("recipients","string"),
     Field("cc_recipients","string"),
     Field("bcc_recipients","string"),
     Field("subject","string"),
     Field("body","string"),
)


db.define_table("email_log_users",
     Field("email_log_id","integer"),
     Field("user_id","integer"),
)


db.define_table("email_templates",
     Field("email_id","integer"),
     Field("email_key","string"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
     Field("enabled","integer"),
)


db.define_table("email_templates_data",
     Field("email_key","string"),
     Field("locale","string"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
     Field("subject","string"),
     Field("body","string"),
)


db.define_table("email_templates_default",
     Field("email_id","integer"),
     Field("email_key","string"),
     Field("can_disable","integer"),
     Field("can_edit","integer"),
     Field("from_role_id","string"),
     Field("to_role_id","string"),
)


db.define_table("email_templates_default_data",
     Field("email_key","string"),
     Field("locale","string"),
     Field("subject","string"),
     Field("body","string"),
     Field("description","string"),
)


db.define_table("event_log",
     Field("log_id","integer"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
     Field("user_id","integer"),
     Field("date_logged","datetime"),
     Field("ip_address","string"),
     Field("event_type","integer"),
     Field("message","string"),
     Field("is_translated","integer"),
)


db.define_table("event_log_settings",
     Field("log_id","integer"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("external_feed_settings",
     Field("feed_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("external_feeds",
     Field("feed_id","string"),
     Field("journal_id","string"),
     Field("url","string"),
     Field("seq","string"),
     Field("display_homepage","string"),
     Field("display_block","string"),
     Field("limit_items","string"),
     Field("recent_items","string"),
)


db.define_table("filter_groups",
     Field("filter_group_id","integer"),
     Field("symbolic","string"),
     Field("display_name","string"),
     Field("description","string"),
     Field("input_type","string"),
     Field("output_type","string"),
)


db.define_table("filter_settings",
     Field("filter_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("filters",
     Field("filter_id","integer"),
     Field("filter_group_id","integer"),
     Field("context_id","integer"),
     Field("display_name","string"),
     Field("class_name","string"),
     Field("is_template","integer"),
     Field("parent_filter_id","integer"),
     Field("seq","integer"),
)


db.define_table("genre_settings",
     Field("genre_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("genres",
     Field("genre_id","integer"),
     Field("context_id","integer"),
     Field("seq","integer"),
     Field("enabled","integer"),
     Field("category","integer"),
     Field("dependent","integer"),
     Field("supplementary","integer"),
     Field("entry_key","string"),
)


db.define_table("group_memberships",
     Field("user_id","integer"),
     Field("group_id","integer"),
     Field("about_displayed","integer"),
     Field("seq","string"),
)


db.define_table("group_settings",
     Field("group_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("groups",
     Field("group_id","integer"),
     Field("assoc_type","integer"),
     Field("publish_email","integer"),
     Field("assoc_id","integer"),
     Field("context","integer"),
     Field("about_displayed","integer"),
     Field("seq","double"),
)


db.define_table("institutional_subscription_ip",
     Field("institutional_subscription_ip_id","string"),
     Field("subscription_id","string"),
     Field("ip_string","string"),
     Field("ip_start","string"),
     Field("ip_end","string"),
)


db.define_table("institutional_subscriptions",
     Field("institutional_subscription_id","string"),
     Field("subscription_id","string"),
     Field("institution_name","string"),
     Field("mailing_address","string"),
     Field("domain","string"),
)


db.define_table("issue_files",
     Field("file_id","integer"),
     Field("issue_id","integer"),
     Field("file_name","string"),
     Field("file_type","string"),
     Field("file_size","integer"),
     Field("content_type","integer"),
     Field("original_file_name","string"),
     Field("date_uploaded","datetime"),
     Field("date_modified","datetime"),
)


db.define_table("issue_galley_settings",
     Field("galley_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("issue_galleys",
     Field("galley_id","integer"),
     Field("locale","string"),
     Field("issue_id","integer"),
     Field("file_id","integer"),
     Field("label","string"),
     Field("seq","string"),
)


db.define_table("issue_settings",
     Field("issue_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("issues",
     Field("issue_id","integer"),
     Field("journal_id","integer"),
     Field("volume","integer"),
     Field("number","string"),
     Field("year","integer"),
     Field("published","integer"),
     Field("current","integer"),
     Field("date_published","string"),
     Field("date_notified","string"),
     Field("last_modified","string"),
     Field("access_status","integer"),
     Field("open_access_date","string"),
     Field("show_volume","integer"),
     Field("show_number","integer"),
     Field("show_year","integer"),
     Field("show_title","integer"),
     Field("style_file_name","string"),
     Field("original_style_file_name","string"),
)


db.define_table("item_views",
     Field("assoc_type","string"),
     Field("assoc_id","string"),
     Field("user_id","string"),
     Field("date_last_viewed","string"),
)


db.define_table("journal_settings",
     Field("journal_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("journals",
     Field("journal_id","integer"),
     Field("path","string"),
     Field("seq","double"),
     Field("primary_locale","string"),
     Field("enabled","integer"),
)


db.define_table("library_file_settings",
     Field("file_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("library_files",
     Field("file_id","string"),
     Field("context_id","string"),
     Field("file_name","string"),
     Field("original_file_name","string"),
     Field("file_type","string"),
     Field("file_size","string"),
     Field("type","string"),
     Field("date_uploaded","string"),
     Field("date_modified","string"),
     Field("submission_id","string"),
     Field("public_access","string"),
)


db.define_table("metadata_description_settings",
     Field("metadata_description_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("metadata_descriptions",
     Field("metadata_description_id","string"),
     Field("assoc_type","string"),
     Field("assoc_id","string"),
     Field("schema_namespace","string"),
     Field("schema_name","string"),
     Field("display_name","string"),
     Field("seq","string"),
)


db.define_table("metrics",
     Field("load_id","string"),
     Field("assoc_type","integer"),
     Field("context_id","integer"),
     Field("submission_id","string"),
     Field("assoc_id","integer"),
     Field("day","integer"),
     Field("month","integer"),
     Field("file_type","string"),
     Field("country_id","string"),
     Field("region","string"),
     Field("city","string"),
     Field("metric_type","string"),
     Field("metric","integer"),
     Field("pkp_section_id","string"),
     Field("assoc_object_type","string"),
     Field("assoc_object_id","string"),
     Field("representation_id","string"),
)


db.define_table("mutex",
     Field("i","integer"),
)


db.define_table("navigation_menu_item_assignment_settings",
     Field("navigation_menu_item_assignment_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("navigation_menu_item_assignments",
     Field("navigation_menu_item_assignment_id","integer"),
     Field("navigation_menu_id","integer"),
     Field("navigation_menu_item_id","integer"),
     Field("parent_id","integer"),
     Field("seq","integer"),
)


db.define_table("navigation_menu_item_settings",
     Field("navigation_menu_item_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("navigation_menu_items",
     Field("navigation_menu_item_id","integer"),
     Field("context_id","integer"),
     Field("url","string"),
     Field("path","string"),
     Field("type","string"),
)


db.define_table("navigation_menus",
     Field("navigation_menu_id","integer"),
     Field("context_id","integer"),
     Field("area_name","string"),
     Field("title","string"),
)


db.define_table("notes",
     Field("note_id","string"),
     Field("assoc_type","string"),
     Field("assoc_id","string"),
     Field("user_id","string"),
     Field("date_created","string"),
     Field("date_modified","string"),
     Field("title","string"),
     Field("contents","string"),
)


db.define_table("notification_mail_list",
     Field("notification_mail_list_id","integer"),
     Field("email","string"),
     Field("confirmed","integer"),
     Field("token","string"),
     Field("context","integer"),
)


db.define_table("notification_settings",
     Field("notification_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("notification_subscription_settings",
     Field("setting_id","integer"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("user_id","integer"),
     Field("context","integer"),
     Field("setting_type","string"),
)


db.define_table("notifications",
     Field("notification_id","integer"),
     Field("context_id","integer"),
     Field("user_id","integer"),
     Field("level","integer"),
     Field("type","integer"),
     Field("date_created","datetime"),
     Field("date_read","string"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
)


db.define_table("oai_resumption_tokens",
     Field("token","string"),
     Field("expire","integer"),
     Field("record_offset","integer"),
     Field("params","string"),
)


db.define_table("object_for_review_assignments",
     Field("assignment_id","string"),
     Field("object_id","string"),
     Field("user_id","string"),
     Field("submission_id","string"),
     Field("status","string"),
     Field("date_requested","string"),
     Field("date_assigned","string"),
     Field("date_mailed","string"),
     Field("date_due","string"),
     Field("date_reminded_before","string"),
     Field("date_reminded_after","string"),
     Field("notes","string"),
)


db.define_table("object_for_review_persons",
     Field("person_id","string"),
     Field("object_id","string"),
     Field("seq","string"),
     Field("role","string"),
     Field("first_name","string"),
     Field("middle_name","string"),
     Field("last_name","string"),
)


db.define_table("object_for_review_settings",
     Field("object_id","string"),
     Field("review_object_metadata_id","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("objects_for_review",
     Field("object_id","string"),
     Field("review_object_type_id","string"),
     Field("context_id","string"),
     Field("available","string"),
     Field("date_created","string"),
     Field("editor_id","string"),
     Field("notes","string"),
)


db.define_table("paypal_transactions",
     Field("txn_id","string"),
     Field("txn_type","string"),
     Field("payer_email","string"),
     Field("receiver_email","string"),
     Field("item_number","string"),
     Field("payment_date","string"),
     Field("payer_id","string"),
     Field("receiver_id","string"),
)


db.define_table("pixel_tags",
     Field("pixel_tag_id","string"),
     Field("journal_id","string"),
     Field("article_id","string"),
     Field("private_code","string"),
     Field("public_code","string"),
     Field("domain","string"),
     Field("date_ordered","string"),
     Field("date_assigned","string"),
     Field("date_registered","string"),
     Field("date_removed","string"),
     Field("status","string"),
     Field("text_type","string"),
)


db.define_table("pln_deposit_objects",
     Field("deposit_object_id","string"),
     Field("journal_id","string"),
     Field("object_id","string"),
     Field("object_type","string"),
     Field("deposit_id","string"),
     Field("date_created","string"),
     Field("date_modified","string"),
)


db.define_table("pln_deposits",
     Field("deposit_id","string"),
     Field("journal_id","string"),
     Field("uuid","string"),
     Field("status","string"),
     Field("date_status","string"),
     Field("date_created","string"),
     Field("date_modified","string"),
)


db.define_table("plugin_settings",
     Field("plugin_name","string"),
     Field("context_id","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("processes",
     Field("process_id","string"),
     Field("process_type","string"),
     Field("time_started","string"),
     Field("obliterated","string"),
)


db.define_table("published_submissions",
     Field("published_submission_id","integer"),
     Field("submission_id","integer"),
     Field("issue_id","integer"),
     Field("date_published","string"),
     Field("seq","double"),
     Field("access_status","integer"),
)


db.define_table("queries",
     Field("query_id","integer"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
     Field("stage_id","integer"),
     Field("seq","double"),
     Field("date_posted","string"),
     Field("date_modified","string"),
     Field("closed","integer"),
)


db.define_table("query_participants",
     Field("query_id","integer"),
     Field("user_id","integer"),
)


db.define_table("queued_payments",
     Field("queued_payment_id","string"),
     Field("date_created","string"),
     Field("date_modified","string"),
     Field("expiry_date","string"),
     Field("payment_data","string"),
)


db.define_table("referral_settings",
     Field("referral_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("referrals",
     Field("referral_id","integer"),
     Field("submission_id","integer"),
     Field("status","integer"),
     Field("url","string"),
     Field("date_added","string"),
     Field("link_count","string"),
)


db.define_table("review_assignments",
     Field("review_id","integer"),
     Field("submission_id","integer"),
     Field("reviewer_id","integer"),
     Field("competing_interests","string"),
     Field("recommendation","string"),
     Field("date_assigned","datetime"),
     Field("date_notified","datetime"),
     Field("date_confirmed","string"),
     Field("date_completed","string"),
     Field("date_acknowledged","string"),
     Field("date_due","datetime"),
     Field("date_response_due","datetime"),
     Field("last_modified","datetime"),
     Field("reminder_was_automatic","integer"),
     Field("declined","integer"),
     Field("replaced","integer"),
     Field("reviewer_file_id","string"),
     Field("date_rated","string"),
     Field("date_reminded","string"),
     Field("quality","string"),
     Field("review_round_id","integer"),
     Field("stage_id","integer"),
     Field("review_method","integer"),
     Field("round","integer"),
     Field("step","integer"),
     Field("review_form_id","string"),
     Field("unconsidered","integer"),
)


db.define_table("review_files",
     Field("review_id","integer"),
     Field("file_id","integer"),
)


db.define_table("review_form_element_settings",
     Field("review_form_element_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("review_form_elements",
     Field("review_form_element_id","string"),
     Field("review_form_id","string"),
     Field("seq","string"),
     Field("element_type","string"),
     Field("required","string"),
     Field("included","string"),
)


db.define_table("review_form_responses",
     Field("review_form_element_id","string"),
     Field("review_id","string"),
     Field("response_type","string"),
     Field("response_value","string"),
)


db.define_table("review_form_settings",
     Field("review_form_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("review_forms",
     Field("review_form_id","string"),
     Field("assoc_type","string"),
     Field("assoc_id","string"),
     Field("seq","string"),
     Field("is_active","string"),
)


db.define_table("review_object_metadata",
     Field("metadata_id","string"),
     Field("review_object_type_id","string"),
     Field("seq","string"),
     Field("metadata_type","string"),
     Field("required","string"),
     Field("display","string"),
     Field("metadata_key","string"),
)


db.define_table("review_object_metadata_settings",
     Field("metadata_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("review_object_type_settings",
     Field("type_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("review_object_types",
     Field("type_id","string"),
     Field("context_id","string"),
     Field("is_active","string"),
     Field("type_key","string"),
)


db.define_table("review_round_files",
     Field("submission_id","integer"),
     Field("review_round_id","integer"),
     Field("stage_id","integer"),
     Field("file_id","integer"),
     Field("revision","integer"),
)


db.define_table("review_rounds",
     Field("review_round_id","integer"),
     Field("submission_id","integer"),
     Field("stage_id","integer"),
     Field("round","integer"),
     Field("review_revision","integer"),
     Field("status","string"),
)


db.define_table("roles",
     Field("journal_id","integer"),
     Field("user_id","integer"),
     Field("role_id","integer"),
)


db.define_table("rt_contexts",
     Field("context_id","integer"),
     Field("version_id","integer"),
     Field("title","string"),
     Field("abbrev","string"),
     Field("description","string"),
     Field("cited_by","string"),
     Field("author_terms","string"),
     Field("define_terms","integer"),
     Field("geo_terms","integer"),
     Field("seq","string"),
)


db.define_table("rt_searches",
     Field("search_id","string"),
     Field("context_id","string"),
     Field("title","string"),
     Field("description","string"),
     Field("url","string"),
     Field("search_url","string"),
     Field("search_post","string"),
     Field("seq","string"),
)


db.define_table("rt_versions",
     Field("version_id","integer"),
     Field("journal_id","integer"),
     Field("version_key","string"),
     Field("locale","string"),
     Field("title","string"),
     Field("description","string"),
)


db.define_table("scheduled_tasks",
     Field("class_name","string"),
     Field("last_run","datetime"),
)


db.define_table("section_editors",
     Field("context_id","string"),
     Field("section_id","string"),
     Field("user_id","string"),
)


db.define_table("section_settings",
     Field("section_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("sections",
     Field("section_id","integer"),
     Field("journal_id","integer"),
     Field("review_form_id","integer"),
     Field("seq","string"),
     Field("editor_restricted","integer"),
     Field("meta_indexed","integer"),
     Field("meta_reviewed","integer"),
     Field("abstracts_not_required","integer"),
     Field("hide_title","integer"),
     Field("hide_author","integer"),
     Field("abstract_word_count","string"),
)


db.define_table("sessions",
     Field("session_id","string"),
     Field("user_id","string"),
     Field("ip_address","string"),
     Field("user_agent","string"),
     Field("created","string"),
     Field("last_used","string"),
     Field("remember","integer"),
     Field("data","string"),
     Field("domain","string"),
)


db.define_table("site",
     Field("redirect","integer"),
     Field("primary_locale","string"),
     Field("min_password_length","integer"),
     Field("installed_locales","string"),
     Field("supported_locales","string"),
     Field("original_style_file_name","string"),
)


db.define_table("site_settings",
     Field("setting_name","string"),
     Field("locale","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("stage_assignments",
     Field("stage_assignment_id","integer"),
     Field("submission_id","integer"),
     Field("user_group_id","integer"),
     Field("user_id","integer"),
     Field("date_assigned","datetime"),
     Field("recommend_only","integer"),
)


db.define_table("static_page_settings",
     Field("static_page_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("static_pages",
     Field("static_page_id","string"),
     Field("path","string"),
     Field("context_id","string"),
)


db.define_table("submission_artwork_files",
     Field("file_id","integer"),
     Field("revision","integer"),
     Field("caption","string"),
     Field("credit","string"),
     Field("copyright_owner","string"),
     Field("copyright_owner_contact","string"),
     Field("permission_terms","string"),
     Field("permission_file_id","string"),
     Field("chapter_id","string"),
     Field("contact_author","string"),
)


db.define_table("submission_comments",
     Field("comment_id","integer"),
     Field("comment_type","integer"),
     Field("role_id","integer"),
     Field("submission_id","integer"),
     Field("assoc_id","integer"),
     Field("author_id","integer"),
     Field("comment_title","string"),
     Field("comments","string"),
     Field("date_posted","string"),
     Field("date_modified","string"),
     Field("viewable","string"),
)


db.define_table("submission_file_settings",
     Field("file_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("submission_files",
     Field("file_id","integer"),
     Field("revision","integer"),
     Field("source_file_id","string"),
     Field("source_revision","string"),
     Field("submission_id","integer"),
     Field("file_type","string"),
     Field("file_size","integer"),
     Field("original_file_name","string"),
     Field("file_stage","string"),
     Field("viewable","string"),
     Field("date_uploaded","string"),
     Field("date_modified","string"),
     Field("assoc_id","string"),
     Field("genre_id","string"),
     Field("direct_sales_price","string"),
     Field("sales_type","string"),
     Field("uploader_user_id","string"),
     Field("assoc_type","string"),
)


db.define_table("submission_galley_settings",
     Field("galley_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("submission_galleys",
     Field("galley_id","integer"),
     Field("locale","string"),
     Field("submission_id","integer"),
     Field("file_id","integer"),
     Field("label","string"),
     Field("seq","string"),
     Field("remote_url","string"),
     Field("is_approved","integer"),
)


db.define_table("submission_search_keyword_list",
     Field("keyword_id","integer"),
     Field("keyword_text","string"),
)


db.define_table("access_keys",
     Field("access_key_id","string"),
     Field("context","string"),
     Field("key_hash","string"),
     Field("user_id","string"),
     Field("assoc_id","string"),
     Field("expiry_date","string"),
)


db.define_table("announcement_settings",
     Field("announcement_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("announcement_type_settings",
     Field("type_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("announcement_types",
     Field("type_id","string"),
     Field("assoc_type","string"),
     Field("assoc_id","string"),
)


db.define_table("announcements",
     Field("announcement_id","integer"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
     Field("type_id","integer"),
     Field("date_expire","string"),
     Field("date_posted","datetime"),
)


db.define_table("auth_sources",
     Field("auth_id","string"),
     Field("title","string"),
     Field("plugin","string"),
     Field("auth_default","string"),
     Field("settings","string"),
)


db.define_table("author_settings",
     Field("author_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("authors",
     Field("author_id","integer"),
     Field("submission_id","integer"),
     Field("primary_contact","integer"),
     Field("seq","double"),
     Field("first_name","string"),
     Field("middle_name","string"),
     Field("last_name","string"),
     Field("suffix","string"),
     Field("country","string"),
     Field("email","string"),
     Field("url","string"),
     Field("user_group_id","integer"),
     Field("include_in_browse","integer"),
)


db.define_table("books_for_review",
     Field("book_id","string"),
     Field("journal_id","string"),
     Field("status","string"),
     Field("author_type","string"),
     Field("publisher","string"),
     Field("year","string"),
     Field("language","string"),
     Field("copy","string"),
     Field("url","string"),
     Field("edition","string"),
     Field("pages","string"),
     Field("isbn","string"),
     Field("date_created","string"),
     Field("date_requested","string"),
     Field("date_assigned","string"),
     Field("date_mailed","string"),
     Field("date_due","string"),
     Field("date_submitted","string"),
     Field("user_id","string"),
     Field("editor_id","string"),
     Field("submission_id","string"),
     Field("notes","string"),
)


db.define_table("books_for_review_authors",
     Field("author_id","string"),
     Field("book_id","string"),
     Field("seq","string"),
     Field("first_name","string"),
     Field("middle_name","string"),
     Field("last_name","string"),
)


db.define_table("books_for_review_settings",
     Field("book_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("captchas",
     Field("captcha_id","integer"),
     Field("session_id","integer"),
     Field("value","string"),
     Field("date_created","datetime"),
)


db.define_table("citation_settings",
     Field("citation_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("citations",
     Field("citation_id","integer"),
     Field("submission_id","integer"),
     Field("raw_citation","string"),
     Field("seq","string"),
)


db.define_table("comments",
     Field("comment_id","integer"),
     Field("submission_id","integer"),
     Field("parent_comment_id","string"),
     Field("num_children","integer"),
     Field("user_id","string"),
     Field("poster_ip","string"),
     Field("poster_name","string"),
     Field("poster_email","string"),
     Field("title","string"),
     Field("body","string"),
     Field("date_posted","datetime"),
     Field("date_modified","datetime"),
)


db.define_table("completed_payments",
     Field("completed_payment_id","string"),
     Field("timestamp","string"),
     Field("payment_type","string"),
     Field("context_id","string"),
     Field("user_id","string"),
     Field("assoc_id","string"),
     Field("amount","string"),
     Field("currency_code_alpha","string"),
     Field("payment_method_plugin_name","string"),
)


db.define_table("controlled_vocab_entries",
     Field("controlled_vocab_entry_id","integer"),
     Field("controlled_vocab_id","integer"),
     Field("seq","string"),
)


db.define_table("controlled_vocab_entry_settings",
     Field("controlled_vocab_entry_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("controlled_vocabs",
     Field("controlled_vocab_id","integer"),
     Field("symbolic","string"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
)


db.define_table("custom_issue_orders",
     Field("issue_id","integer"),
     Field("journal_id","integer"),
     Field("seq","double"),
)


db.define_table("custom_section_orders",
     Field("issue_id","integer"),
     Field("section_id","integer"),
     Field("seq","string"),
)


db.define_table("data_object_tombstone_oai_set_objects",
     Field("object_id","integer"),
     Field("tombstone_id","integer"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
)


db.define_table("data_object_tombstone_settings",
     Field("tombstone_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("data_object_tombstones",
     Field("tombstone_id","integer"),
     Field("data_object_id","integer"),
     Field("date_deleted","datetime"),
     Field("set_spec","string"),
     Field("set_name","string"),
     Field("oai_identifier","string"),
)


db.define_table("dataverse_files",
     Field("dvfile_id","string"),
     Field("supp_id","string"),
     Field("submission_id","string"),
     Field("study_id","string"),
     Field("content_source_uri","string"),
)


db.define_table("dataverse_studies",
     Field("study_id","string"),
     Field("submission_id","string"),
     Field("edit_uri","string"),
     Field("edit_media_uri","string"),
     Field("statement_uri","string"),
     Field("persistent_uri","string"),
     Field("data_citation","string"),
)


db.define_table("edit_assignments",
     Field("edit_id","integer"),
     Field("article_id","integer"),
     Field("editor_id","integer"),
     Field("can_edit","integer"),
     Field("can_review","integer"),
     Field("date_assigned","string"),
     Field("date_notified","datetime"),
     Field("date_underway","datetime"),
)


db.define_table("edit_decisions",
     Field("edit_decision_id","integer"),
     Field("submission_id","integer"),
     Field("round","integer"),
     Field("editor_id","integer"),
     Field("decision","integer"),
     Field("date_decided","datetime"),
     Field("review_round_id","string"),
     Field("stage_id","integer"),
)


db.define_table("email_log",
     Field("log_id","string"),
     Field("assoc_type","string"),
     Field("assoc_id","string"),
     Field("sender_id","string"),
     Field("date_sent","string"),
     Field("ip_address","string"),
     Field("event_type","string"),
     Field("from_address","string"),
     Field("recipients","string"),
     Field("cc_recipients","string"),
     Field("bcc_recipients","string"),
     Field("subject","string"),
     Field("body","string"),
)


db.define_table("email_log_users",
     Field("email_log_id","integer"),
     Field("user_id","integer"),
)


db.define_table("email_templates",
     Field("email_id","integer"),
     Field("email_key","string"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
     Field("enabled","integer"),
)


db.define_table("email_templates_data",
     Field("email_key","string"),
     Field("locale","string"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
     Field("subject","string"),
     Field("body","string"),
)


db.define_table("email_templates_default",
     Field("email_id","integer"),
     Field("email_key","string"),
     Field("can_disable","integer"),
     Field("can_edit","integer"),
     Field("from_role_id","string"),
     Field("to_role_id","string"),
)


db.define_table("email_templates_default_data",
     Field("email_key","string"),
     Field("locale","string"),
     Field("subject","string"),
     Field("body","string"),
     Field("description","string"),
)


db.define_table("event_log",
     Field("log_id","integer"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
     Field("user_id","integer"),
     Field("date_logged","datetime"),
     Field("ip_address","string"),
     Field("event_type","integer"),
     Field("message","string"),
     Field("is_translated","integer"),
)


db.define_table("event_log_settings",
     Field("log_id","integer"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("external_feed_settings",
     Field("feed_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("external_feeds",
     Field("feed_id","string"),
     Field("journal_id","string"),
     Field("url","string"),
     Field("seq","string"),
     Field("display_homepage","string"),
     Field("display_block","string"),
     Field("limit_items","string"),
     Field("recent_items","string"),
)


db.define_table("filter_groups",
     Field("filter_group_id","integer"),
     Field("symbolic","string"),
     Field("display_name","string"),
     Field("description","string"),
     Field("input_type","string"),
     Field("output_type","string"),
)


db.define_table("filter_settings",
     Field("filter_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("filters",
     Field("filter_id","integer"),
     Field("filter_group_id","integer"),
     Field("context_id","integer"),
     Field("display_name","string"),
     Field("class_name","string"),
     Field("is_template","integer"),
     Field("parent_filter_id","integer"),
     Field("seq","integer"),
)


db.define_table("genre_settings",
     Field("genre_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("genres",
     Field("genre_id","integer"),
     Field("context_id","integer"),
     Field("seq","integer"),
     Field("enabled","integer"),
     Field("category","integer"),
     Field("dependent","integer"),
     Field("supplementary","integer"),
     Field("entry_key","string"),
)


db.define_table("group_memberships",
     Field("user_id","integer"),
     Field("group_id","integer"),
     Field("about_displayed","integer"),
     Field("seq","string"),
)


db.define_table("group_settings",
     Field("group_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("groups",
     Field("group_id","integer"),
     Field("assoc_type","integer"),
     Field("publish_email","integer"),
     Field("assoc_id","integer"),
     Field("context","integer"),
     Field("about_displayed","integer"),
     Field("seq","double"),
)


db.define_table("institutional_subscription_ip",
     Field("institutional_subscription_ip_id","string"),
     Field("subscription_id","string"),
     Field("ip_string","string"),
     Field("ip_start","string"),
     Field("ip_end","string"),
)


db.define_table("institutional_subscriptions",
     Field("institutional_subscription_id","string"),
     Field("subscription_id","string"),
     Field("institution_name","string"),
     Field("mailing_address","string"),
     Field("domain","string"),
)


db.define_table("issue_files",
     Field("file_id","integer"),
     Field("issue_id","integer"),
     Field("file_name","string"),
     Field("file_type","string"),
     Field("file_size","integer"),
     Field("content_type","integer"),
     Field("original_file_name","string"),
     Field("date_uploaded","datetime"),
     Field("date_modified","datetime"),
)


db.define_table("issue_galley_settings",
     Field("galley_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("issue_galleys",
     Field("galley_id","integer"),
     Field("locale","string"),
     Field("issue_id","integer"),
     Field("file_id","integer"),
     Field("label","string"),
     Field("seq","string"),
)


db.define_table("issue_settings",
     Field("issue_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("issues",
     Field("issue_id","integer"),
     Field("journal_id","integer"),
     Field("volume","integer"),
     Field("number","string"),
     Field("year","integer"),
     Field("published","integer"),
     Field("current","integer"),
     Field("date_published","string"),
     Field("date_notified","string"),
     Field("last_modified","string"),
     Field("access_status","integer"),
     Field("open_access_date","string"),
     Field("show_volume","integer"),
     Field("show_number","integer"),
     Field("show_year","integer"),
     Field("show_title","integer"),
     Field("style_file_name","string"),
     Field("original_style_file_name","string"),
)


db.define_table("item_views",
     Field("assoc_type","string"),
     Field("assoc_id","string"),
     Field("user_id","string"),
     Field("date_last_viewed","string"),
)


db.define_table("journal_settings",
     Field("journal_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("journals",
     Field("journal_id","integer"),
     Field("path","string"),
     Field("seq","double"),
     Field("primary_locale","string"),
     Field("enabled","integer"),
)


db.define_table("library_file_settings",
     Field("file_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("library_files",
     Field("file_id","string"),
     Field("context_id","string"),
     Field("file_name","string"),
     Field("original_file_name","string"),
     Field("file_type","string"),
     Field("file_size","string"),
     Field("type","string"),
     Field("date_uploaded","string"),
     Field("date_modified","string"),
     Field("submission_id","string"),
     Field("public_access","string"),
)


db.define_table("metadata_description_settings",
     Field("metadata_description_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("metadata_descriptions",
     Field("metadata_description_id","string"),
     Field("assoc_type","string"),
     Field("assoc_id","string"),
     Field("schema_namespace","string"),
     Field("schema_name","string"),
     Field("display_name","string"),
     Field("seq","string"),
)


db.define_table("metrics",
     Field("load_id","string"),
     Field("assoc_type","integer"),
     Field("context_id","integer"),
     Field("submission_id","string"),
     Field("assoc_id","integer"),
     Field("day","integer"),
     Field("month","integer"),
     Field("file_type","string"),
     Field("country_id","string"),
     Field("region","string"),
     Field("city","string"),
     Field("metric_type","string"),
     Field("metric","integer"),
     Field("pkp_section_id","string"),
     Field("assoc_object_type","string"),
     Field("assoc_object_id","string"),
     Field("representation_id","string"),
)


db.define_table("mutex",
     Field("i","integer"),
)


db.define_table("navigation_menu_item_assignment_settings",
     Field("navigation_menu_item_assignment_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("navigation_menu_item_assignments",
     Field("navigation_menu_item_assignment_id","integer"),
     Field("navigation_menu_id","integer"),
     Field("navigation_menu_item_id","integer"),
     Field("parent_id","integer"),
     Field("seq","integer"),
)


db.define_table("navigation_menu_item_settings",
     Field("navigation_menu_item_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("navigation_menu_items",
     Field("navigation_menu_item_id","integer"),
     Field("context_id","integer"),
     Field("url","string"),
     Field("path","string"),
     Field("type","string"),
)


db.define_table("navigation_menus",
     Field("navigation_menu_id","integer"),
     Field("context_id","integer"),
     Field("area_name","string"),
     Field("title","string"),
)


db.define_table("notes",
     Field("note_id","string"),
     Field("assoc_type","string"),
     Field("assoc_id","string"),
     Field("user_id","string"),
     Field("date_created","string"),
     Field("date_modified","string"),
     Field("title","string"),
     Field("contents","string"),
)


db.define_table("notification_mail_list",
     Field("notification_mail_list_id","integer"),
     Field("email","string"),
     Field("confirmed","integer"),
     Field("token","string"),
     Field("context","integer"),
)


db.define_table("notification_settings",
     Field("notification_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("notification_subscription_settings",
     Field("setting_id","integer"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("user_id","integer"),
     Field("context","integer"),
     Field("setting_type","string"),
)


db.define_table("notifications",
     Field("notification_id","integer"),
     Field("context_id","integer"),
     Field("user_id","integer"),
     Field("level","integer"),
     Field("type","integer"),
     Field("date_created","datetime"),
     Field("date_read","string"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
)


db.define_table("oai_resumption_tokens",
     Field("token","string"),
     Field("expire","integer"),
     Field("record_offset","integer"),
     Field("params","string"),
)


db.define_table("object_for_review_assignments",
     Field("assignment_id","string"),
     Field("object_id","string"),
     Field("user_id","string"),
     Field("submission_id","string"),
     Field("status","string"),
     Field("date_requested","string"),
     Field("date_assigned","string"),
     Field("date_mailed","string"),
     Field("date_due","string"),
     Field("date_reminded_before","string"),
     Field("date_reminded_after","string"),
     Field("notes","string"),
)


db.define_table("object_for_review_persons",
     Field("person_id","string"),
     Field("object_id","string"),
     Field("seq","string"),
     Field("role","string"),
     Field("first_name","string"),
     Field("middle_name","string"),
     Field("last_name","string"),
)


db.define_table("object_for_review_settings",
     Field("object_id","string"),
     Field("review_object_metadata_id","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("objects_for_review",
     Field("object_id","string"),
     Field("review_object_type_id","string"),
     Field("context_id","string"),
     Field("available","string"),
     Field("date_created","string"),
     Field("editor_id","string"),
     Field("notes","string"),
)


db.define_table("paypal_transactions",
     Field("txn_id","string"),
     Field("txn_type","string"),
     Field("payer_email","string"),
     Field("receiver_email","string"),
     Field("item_number","string"),
     Field("payment_date","string"),
     Field("payer_id","string"),
     Field("receiver_id","string"),
)


db.define_table("pixel_tags",
     Field("pixel_tag_id","string"),
     Field("journal_id","string"),
     Field("article_id","string"),
     Field("private_code","string"),
     Field("public_code","string"),
     Field("domain","string"),
     Field("date_ordered","string"),
     Field("date_assigned","string"),
     Field("date_registered","string"),
     Field("date_removed","string"),
     Field("status","string"),
     Field("text_type","string"),
)


db.define_table("pln_deposit_objects",
     Field("deposit_object_id","string"),
     Field("journal_id","string"),
     Field("object_id","string"),
     Field("object_type","string"),
     Field("deposit_id","string"),
     Field("date_created","string"),
     Field("date_modified","string"),
)


db.define_table("pln_deposits",
     Field("deposit_id","string"),
     Field("journal_id","string"),
     Field("uuid","string"),
     Field("status","string"),
     Field("date_status","string"),
     Field("date_created","string"),
     Field("date_modified","string"),
)


db.define_table("plugin_settings",
     Field("plugin_name","string"),
     Field("context_id","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("processes",
     Field("process_id","string"),
     Field("process_type","string"),
     Field("time_started","string"),
     Field("obliterated","string"),
)


db.define_table("published_submissions",
     Field("published_submission_id","integer"),
     Field("submission_id","integer"),
     Field("issue_id","integer"),
     Field("date_published","string"),
     Field("seq","double"),
     Field("access_status","integer"),
)


db.define_table("queries",
     Field("query_id","integer"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
     Field("stage_id","integer"),
     Field("seq","double"),
     Field("date_posted","string"),
     Field("date_modified","string"),
     Field("closed","integer"),
)


db.define_table("query_participants",
     Field("query_id","integer"),
     Field("user_id","integer"),
)


db.define_table("queued_payments",
     Field("queued_payment_id","string"),
     Field("date_created","string"),
     Field("date_modified","string"),
     Field("expiry_date","string"),
     Field("payment_data","string"),
)


db.define_table("referral_settings",
     Field("referral_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("referrals",
     Field("referral_id","integer"),
     Field("submission_id","integer"),
     Field("status","integer"),
     Field("url","string"),
     Field("date_added","string"),
     Field("link_count","string"),
)


db.define_table("review_assignments",
     Field("review_id","integer"),
     Field("submission_id","integer"),
     Field("reviewer_id","integer"),
     Field("competing_interests","string"),
     Field("recommendation","string"),
     Field("date_assigned","datetime"),
     Field("date_notified","datetime"),
     Field("date_confirmed","string"),
     Field("date_completed","string"),
     Field("date_acknowledged","string"),
     Field("date_due","datetime"),
     Field("date_response_due","datetime"),
     Field("last_modified","datetime"),
     Field("reminder_was_automatic","integer"),
     Field("declined","integer"),
     Field("replaced","integer"),
     Field("reviewer_file_id","string"),
     Field("date_rated","string"),
     Field("date_reminded","string"),
     Field("quality","string"),
     Field("review_round_id","integer"),
     Field("stage_id","integer"),
     Field("review_method","integer"),
     Field("round","integer"),
     Field("step","integer"),
     Field("review_form_id","string"),
     Field("unconsidered","integer"),
)


db.define_table("review_files",
     Field("review_id","integer"),
     Field("file_id","integer"),
)


db.define_table("review_form_element_settings",
     Field("review_form_element_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("review_form_elements",
     Field("review_form_element_id","string"),
     Field("review_form_id","string"),
     Field("seq","string"),
     Field("element_type","string"),
     Field("required","string"),
     Field("included","string"),
)


db.define_table("review_form_responses",
     Field("review_form_element_id","string"),
     Field("review_id","string"),
     Field("response_type","string"),
     Field("response_value","string"),
)


db.define_table("review_form_settings",
     Field("review_form_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("review_forms",
     Field("review_form_id","string"),
     Field("assoc_type","string"),
     Field("assoc_id","string"),
     Field("seq","string"),
     Field("is_active","string"),
)


db.define_table("review_object_metadata",
     Field("metadata_id","string"),
     Field("review_object_type_id","string"),
     Field("seq","string"),
     Field("metadata_type","string"),
     Field("required","string"),
     Field("display","string"),
     Field("metadata_key","string"),
)


db.define_table("review_object_metadata_settings",
     Field("metadata_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("review_object_type_settings",
     Field("type_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("review_object_types",
     Field("type_id","string"),
     Field("context_id","string"),
     Field("is_active","string"),
     Field("type_key","string"),
)


db.define_table("review_round_files",
     Field("submission_id","integer"),
     Field("review_round_id","integer"),
     Field("stage_id","integer"),
     Field("file_id","integer"),
     Field("revision","integer"),
)


db.define_table("review_rounds",
     Field("review_round_id","integer"),
     Field("submission_id","integer"),
     Field("stage_id","integer"),
     Field("round","integer"),
     Field("review_revision","integer"),
     Field("status","string"),
)


db.define_table("roles",
     Field("journal_id","integer"),
     Field("user_id","integer"),
     Field("role_id","integer"),
)


db.define_table("rt_contexts",
     Field("context_id","integer"),
     Field("version_id","integer"),
     Field("title","string"),
     Field("abbrev","string"),
     Field("description","string"),
     Field("cited_by","string"),
     Field("author_terms","string"),
     Field("define_terms","integer"),
     Field("geo_terms","integer"),
     Field("seq","string"),
)


db.define_table("rt_searches",
     Field("search_id","string"),
     Field("context_id","string"),
     Field("title","string"),
     Field("description","string"),
     Field("url","string"),
     Field("search_url","string"),
     Field("search_post","string"),
     Field("seq","string"),
)


db.define_table("rt_versions",
     Field("version_id","integer"),
     Field("journal_id","integer"),
     Field("version_key","string"),
     Field("locale","string"),
     Field("title","string"),
     Field("description","string"),
)


db.define_table("scheduled_tasks",
     Field("class_name","string"),
     Field("last_run","datetime"),
)


db.define_table("section_editors",
     Field("context_id","string"),
     Field("section_id","string"),
     Field("user_id","string"),
)


db.define_table("section_settings",
     Field("section_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("sections",
     Field("section_id","integer"),
     Field("journal_id","integer"),
     Field("review_form_id","integer"),
     Field("seq","string"),
     Field("editor_restricted","integer"),
     Field("meta_indexed","integer"),
     Field("meta_reviewed","integer"),
     Field("abstracts_not_required","integer"),
     Field("hide_title","integer"),
     Field("hide_author","integer"),
     Field("abstract_word_count","string"),
)


db.define_table("sessions",
     Field("session_id","string"),
     Field("user_id","string"),
     Field("ip_address","string"),
     Field("user_agent","string"),
     Field("created","string"),
     Field("last_used","integer"),
     Field("remember","integer"),
     Field("data","string"),
     Field("domain","string"),
)


db.define_table("site",
     Field("redirect","integer"),
     Field("primary_locale","string"),
     Field("min_password_length","integer"),
     Field("installed_locales","string"),
     Field("supported_locales","string"),
     Field("original_style_file_name","string"),
)


db.define_table("site_settings",
     Field("setting_name","string"),
     Field("locale","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("stage_assignments",
     Field("stage_assignment_id","integer"),
     Field("submission_id","integer"),
     Field("user_group_id","integer"),
     Field("user_id","integer"),
     Field("date_assigned","datetime"),
     Field("recommend_only","integer"),
)


db.define_table("static_page_settings",
     Field("static_page_id","string"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("static_pages",
     Field("static_page_id","string"),
     Field("path","string"),
     Field("context_id","string"),
)


db.define_table("submission_artwork_files",
     Field("file_id","integer"),
     Field("revision","integer"),
     Field("caption","string"),
     Field("credit","string"),
     Field("copyright_owner","string"),
     Field("copyright_owner_contact","string"),
     Field("permission_terms","string"),
     Field("permission_file_id","string"),
     Field("chapter_id","string"),
     Field("contact_author","string"),
)


db.define_table("submission_comments",
     Field("comment_id","integer"),
     Field("comment_type","integer"),
     Field("role_id","integer"),
     Field("submission_id","integer"),
     Field("assoc_id","integer"),
     Field("author_id","integer"),
     Field("comment_title","string"),
     Field("comments","string"),
     Field("date_posted","string"),
     Field("date_modified","string"),
     Field("viewable","string"),
)


db.define_table("submission_file_settings",
     Field("file_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("submission_files",
     Field("file_id","integer"),
     Field("revision","integer"),
     Field("source_file_id","string"),
     Field("source_revision","string"),
     Field("submission_id","integer"),
     Field("file_type","string"),
     Field("file_size","integer"),
     Field("original_file_name","string"),
     Field("file_stage","integer"),
     Field("viewable","integer"),
     Field("date_uploaded","datetime"),
     Field("date_modified","datetime"),
     Field("assoc_id","string"),
     Field("genre_id","integer"),
     Field("direct_sales_price","string"),
     Field("sales_type","string"),
     Field("uploader_user_id","integer"),
     Field("assoc_type","string"),
)


db.define_table("submission_galley_settings",
     Field("galley_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("submission_galleys",
     Field("galley_id","integer"),
     Field("locale","string"),
     Field("submission_id","integer"),
     Field("file_id","integer"),
     Field("label","string"),
     Field("seq","string"),
     Field("remote_url","string"),
     Field("is_approved","integer"),
)


db.define_table("submission_search_keyword_list",
     Field("keyword_id","integer"),
     Field("keyword_text","string"),
)


db.define_table("submission_search_object_keywords",
     Field("object_id","integer"),
     Field("keyword_id","integer"),
     Field("pos","integer"),
)


db.define_table("submission_search_objects",
     Field("object_id","integer"),
     Field("submission_id","integer"),
     Field("type","integer"),
     Field("assoc_id","integer"),
)


db.define_table("submission_settings",
     Field("submission_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("submission_supplementary_files",
     Field("file_id","integer"),
     Field("revision","integer"),
)


db.define_table("submission_tombstones",
     Field("tombstone_id","string"),
     Field("submission_id","string"),
     Field("date_deleted","string"),
     Field("journal_id","string"),
     Field("section_id","string"),
     Field("set_spec","string"),
     Field("set_name","string"),
     Field("oai_identifier","string"),
)


db.define_table("submission_xml_galleys",
     Field("xml_galley_id","string"),
     Field("galley_id","string"),
     Field("submission_id","string"),
     Field("label","string"),
     Field("galley_type","string"),
     Field("views","string"),
)


db.define_table("submissions",
     Field("submission_id","integer"),
     Field("locale","string"),
     Field("context_id","integer"),
     Field("section_id","integer"),
     Field("language","string"),
     Field("citations","string"),
     Field("date_submitted","datetime"),
     Field("last_modified","datetime"),
     Field("date_status_modified","datetime"),
     Field("status","integer"),
     Field("submission_progress","integer"),
     Field("pages","string"),
     Field("hide_author","integer"),
     Field("stage_id","integer"),
)


db.define_table("subscription_type_settings",
     Field("type_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("subscription_types",
     Field("type_id","integer"),
     Field("journal_id","integer"),
     Field("cost","double"),
     Field("currency_code_alpha","string"),
     Field("non_expiring","integer"),
     Field("duration","integer"),
     Field("format","integer"),
     Field("institutional","integer"),
     Field("membership","integer"),
     Field("disable_public_display","integer"),
     Field("seq","double"),
)


db.define_table("subscriptions",
     Field("subscription_id","integer"),
     Field("journal_id","integer"),
     Field("user_id","integer"),
     Field("type_id","integer"),
     Field("date_start","date",requires=IS_DATE(format="%Y-%m-%d")),
     Field("date_end","datetime"),
     Field("status","integer"),
     Field("membership","string"),
     Field("reference_number","string"),
     Field("notes","string"),
)


db.define_table("temporary_files",
     Field("file_id","integer"),
     Field("user_id","integer"),
     Field("file_name","string"),
     Field("file_type","string"),
     Field("file_size","integer"),
     Field("original_file_name","string"),
     Field("date_uploaded","string"),
)


db.define_table("theses",
     Field("thesis_id","string"),
     Field("journal_id","string"),
     Field("status","string"),
     Field("degree","string"),
     Field("degree_name","string"),
     Field("department","string"),
     Field("university","string"),
     Field("date_approved","string"),
     Field("title","string"),
     Field("url","string"),
     Field("abstract","string"),
     Field("comment","string"),
     Field("student_first_name","string"),
     Field("student_middle_name","string"),
     Field("student_last_name","string"),
     Field("student_email","string"),
     Field("student_email_publish","string"),
     Field("student_bio","string"),
     Field("supervisor_first_name","string"),
     Field("supervisor_middle_name","string"),
     Field("supervisor_last_name","string"),
     Field("supervisor_email","string"),
     Field("discipline","string"),
     Field("subject_class","string"),
     Field("subject","string"),
     Field("coverage_geo","string"),
     Field("coverage_chron","string"),
     Field("coverage_sample","string"),
     Field("method","string"),
     Field("language","string"),
     Field("date_submitted","string"),
)


db.define_table("usage_stats_temporary_records",
     Field("assoc_id","integer"),
     Field("assoc_type","integer"),
     Field("day","integer"),
     Field("metric","integer"),
     Field("country_id","string"),
     Field("region","string"),
     Field("city","string"),
     Field("load_id","string"),
     Field("file_type","integer"),
     Field("entry_time","integer"),
)


db.define_table("user_group_settings",
     Field("user_group_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("user_group_stage",
     Field("context_id","integer"),
     Field("user_group_id","integer"),
     Field("stage_id","integer"),
)


db.define_table("user_groups",
     Field("user_group_id","integer"),
     Field("context_id","integer"),
     Field("role_id","integer"),
     Field("is_default","integer"),
     Field("show_title","integer"),
     Field("permit_self_registration","integer"),
)


db.define_table("user_interests",
     Field("user_id","integer"),
     Field("controlled_vocab_entry_id","integer"),
)


db.define_table("user_settings",
     Field("user_id","integer"),
     Field("locale","string"),
     Field("setting_name","string"),
     Field("assoc_type","integer"),
     Field("assoc_id","integer"),
     Field("setting_value","string"),
     Field("setting_type","string"),
)


db.define_table("user_user_groups",
     Field("user_group_id","integer"),
     Field("user_id","integer"),
)


db.define_table("users",
     Field("user_id","string"),
     Field("username","string"),
     Field("password","string"),
     Field("salutation","string"),
     Field("first_name","string"),
     Field("middle_name","string"),
     Field("last_name","string"),
     Field("suffix","string"),
     Field("initials","string"),
     Field("email","string"),
     Field("url","string"),
     Field("phone","string"),
     Field("mailing_address","string"),
     Field("billing_address","string"),
     Field("country","string"),
     Field("locales","string"),
     Field("date_last_email","string"),
     Field("date_registered","string"),
     Field("date_validated","string"),
     Field("date_last_login","string"),
     Field("must_change_password","string"),
     Field("auth_id","string"),
     Field("auth_str","string"),
     Field("disabled","string"),
     Field("disabled_reason","string"),
     Field("inline_help","string"),
     Field("gossip","string"),
)


db.define_table("versions",
     Field("major","integer"),
     Field("minor","integer"),
     Field("revision","integer"),
     Field("build","integer"),
     Field("date_installed","datetime"),
     Field("current","integer"),
     Field("product_type","string"),
     Field("product","string"),
     Field("product_class_name","string"),
     Field("lazy_load","integer"),
     Field("sitewide","integer"),
)


