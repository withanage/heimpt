# -*- coding: utf-8 -*-
'''
Copyright (c) 2015 Heidelberg University Library
Distributed under the GNU GPL v3. For full terms see the file
LICENSE.md
'''


from pydal import Field


def define_tables(db):

    db.define_table("announcements",
                    Field("announcement_id", "integer"),
                    Field("assoc_type", "integer"),
                    Field("assoc_id", "integer"),
                    Field("type_id", "integer"),
                    Field("date_expire", "datetime"),
                    Field("date_posted", "datetime"),
                    primarykey=['announcement_id'],
                    migrate=False
                    )

    db.define_table("announcement_settings",
                    Field("announcement_id", "integer"),
                    Field("locale", "string"),
                    Field("setting_name", "string"),
                    Field("setting_value", "string"),
                    Field("setting_type", "string"),
                    primarykey=['announcement_id', 'locale', 'setting_name'],
                    migrate=False
                    )


    db.define_table("announcement_types",
                    Field("type_id", "integer"),
                    Field("assoc_type", "integer"),
                    Field("assoc_id", "integer"),
                    primarykey=["type_id"],
                    migrate=False
                    )


    db.define_table("announcement_type_settings",
                    Field("type_id", "integer"),
                    Field("locale", "string"),
                    Field("setting_name", "string"),
                    Field("setting_value", "string"),
                    Field("setting_type", "string"),
                    primarykey=['type_id', 'locale', 'setting_name'],
                    migrate=False
                    )

    db.define_table("authors",
                    Field("author_id", "integer"),
                    Field("submission_id", "integer"),
                    Field("primary_contact", "integer"),
                    Field("seq", "integer"),
                    #Field("first_name", "string"),
                    #Field("middle_name", "string"),
                    #Field("last_name", "string"),
                    #Field("suffix", "string"),
                    Field("country", "string"),
                    Field("email", "string"),
                    Field("url", "string"),
                    Field("user_group_id", "integer"),
                    Field("include_in_browse", "integer"),
                    primarykey=['author_id'],
                    migrate=False
                    )

    db.define_table("author_settings",
                    Field("author_id", "integer"),
                    Field("locale", "string"),
                    Field("setting_name", "string"),
                    Field("setting_value", "string"),
                    Field("setting_type", "string"),
                    primarykey=['author_id', 'locale', 'setting_name'],
                    migrate=False
                    )

    db.define_table("categories",
                    Field("category_id", "integer"),
                    Field("context_id", "integer"),
                    Field("parent_id", "integer"),
                    Field("path","string"),
                    Field("image","text"),
                    Field("seq", "integer"),
                    primarykey=['category_id'],
                    migrate=False
                    )

    db.define_table("category_settings",
                    Field("category_id", "integer"),
                    Field("locale", "string"),
                    Field("setting_name", "string"),
                    Field("setting_value", "string"),
                    Field("setting_type", "string"),
                    primarykey=['category_id', 'locale', 'setting_name'],
                    migrate=False
                    )


    db.define_table("event_log",
                    Field("log_id", "integer"),
                    Field("assoc_type", "integer"),
                    Field("assoc_id", "integer"),
                    Field("user_id", "integer"),
                    Field("date_logged", "datetime"),
                    Field("ip_address", "string"),
                    Field("event_type", "integer"),
                    Field("message", "string"),
                    Field("is_translated", "integer"),
                    primarykey=['log_id'],
                    migrate=False
                    )


    db.define_table("event_log_settings",
                    Field("log_id", "integer"),
                    Field("setting_name", "string"),
                    Field("setting_value", "string"),
                    Field("setting_type", "string"),
                    primarykey=['log_id', 'setting_name'],
                    migrate=False
                    )


    db.define_table("submission_chapters",
                    Field("chapter_id", "integer"),
                    Field("submission_id", 'integer'),
                    Field("seq", 'integer'),
                    primarykey=['chapter_id'],
                    migrate=False
                    )

    db.define_table("submission_chapter_authors",
                    Field("author_id", "integer"),
                    Field("chapter_id", "integer"),
                    Field("submission_id", 'integer'),
                    Field("primary_contact", 'integer'),
                    Field("seq", 'integer'),
                    primarykey=['author_id', 'chapter_id'],
                    migrate=False
                    )

    db.define_table("submission_chapter_settings",
                    Field("chapter_id", "integer"),
                    Field("locale", "string"),
                    Field("setting_name", "string"),
                    Field("setting_value", "string"),
                    Field("setting_type", "string"),
                    primarykey=['chapter_id', 'locale', 'setting_name'],
                    migrate=False
                    )

    db.define_table("markets",
                    Field("market_id", "integer"),
                    Field("publication_format_id", "integer"),
                    Field("countries_included", "string"),
                    Field("countries_excluded", "string"),
                    Field("regions_included", "string"),
                    Field("regions_excluded", "string"),
                    Field("market_date_role", "string"),
                    Field("market_date_format", "string"),
                    Field("market_date", "string"),
                    Field("price", "string"),
                    Field("discount", "string"),
                    Field("price_type_code", "string"),
                    Field("currency_code", "string"),
                    Field("tax_rate_code", "string"),
                    Field("tax_type_code", "string"),
                    Field("agent_id", "integer"),
                    Field("supplier_id", "integer"),
                    migrate=False
                    )

    db.define_table("press_settings",
                    Field("press_id", "integer"),
                    Field("locale", "string"),
                    Field("setting_name", "string"),
                    Field("setting_value", "string"),
                    Field("setting_type", "string"),
                    primarykey=['press_id', 'locale', 'setting_name'],
                    migrate=False
                    )

    db.define_table("presses",
                    Field("press_id", "integer"),
                    Field("path", "string"),
                    Field("seq", "integer"),
                    Field("primary_locale", "string"),
                    Field("enabled", "integer"),
                    primarykey=['press_id'],
                    migrate=False
                    )

    db.define_table("publication_dates",
                    Field("publication_date_id", "integer"),
                    Field("publication_format_id", "integer"),
                    Field("role", "string"),
                    Field("date", "string"),
                    Field("date_format", "string"),
                    primarykey=['publication_date_id'],
                    migrate=False
                    )

    db.define_table("published_submissions",
                    Field("pub_id", "integer"),
                    Field("submission_id", "integer"),
                    Field(
                        "date_published",
                        "datetime",
                       ),
                    Field("audience", "string"),
                    Field("audience_range_qualifier", "string"),
                    Field("audience_range_from", "string"),
                    Field("audience_range_to", "string"),
                    Field("audience_range_exact", "string"),
                    Field("cover_image", "string"),
                    primarykey=['pub_id'],
                    migrate=False
                    )

    db.define_table("publication_formats",
                    Field("publication_format_id", "integer"),
                    Field("submission_id", "integer"),
                    Field("physical_format", "integer"),
                    Field("entry_key", "string"),
                    Field("seq", "double"),
                    Field("file_size", "string"),
                    Field("front_matter", "string"),
                    Field("back_matter", "string"),
                    Field("height", "string"),
                    Field("height_unit_code", "string"),
                    Field("width", "string"),
                    Field("width_unit_code", "string"),
                    Field("thickness", "string"),
                    Field("thickness_unit_code", "string"),
                    Field("weight", "string"),
                    Field("weight_unit_code", "string"),
                    Field("product_composition_code", "string"),
                    Field("product_form_detail_code", "string"),
                    Field("country_manufacture_code", "string"),
                    Field("imprint", "string"),
                    Field("product_availability_code", "string"),
                    Field("technical_protection_code", "string"),
                    Field("returnable_indicator_code", "string"),
                    Field("remote_url", "string"),
                    Field("is_approved", "integer"),
                    Field("is_available", "integer"),
                    primarykey=['publication_format_id'],
                    migrate=False
                    )

    db.define_table("publication_format_settings",
                    Field("publication_format_id", "integer"),
                    Field("locale", "string"),
                    Field("setting_name", "string"),
                    Field("setting_value", "string"),
                    Field("setting_type", "string"),
                    primarykey=['publication_format_id', 'locale', 'setting_name'],
                    migrate=False
                    )

    db.define_table("series",
                    Field("series_id", "integer"),
                    Field("press_id", "integer"),
                    Field("seq", "integer"),
                    Field("featured", "integer"),
                    Field("editor_restricted", "integer"),
                    Field("path","string"),
                    Field("image","text"),
                    primarykey=['series_id'],
                    migrate=False
                    )


    db.define_table("series_categories",
                    Field("series_id", "integer"),
                    Field("category_id", "integer"),
                    primarykey=['series_id'],
                    migrate=False
                    )
    db.define_table("series_editors",
                    Field("press_id", "integer"),
                    Field("series_id", "integer"),
                    Field("user_id", "integer"),
                    Field("can_edit", "boolean"),
                    Field("can_review", "boolean"),
                    primarykey=['series_id', 'press_id', 'user_id'],
                    migrate=False
                    )

    db.define_table("series_settings",
                    Field("series_id", "integer"),
                    Field("locale", "string"),
                    Field("setting_name", "string"),
                    Field("setting_value", "string"),
                    Field("setting_type", "string"),
                    primarykey=['series_id', 'locale', 'setting_name'],
                    migrate=False
                    )

    db.define_table("representatives",
                    Field("representative_id", "integer"),
                    Field("submission_id", "integer"),
                    Field("role","string"),
                    Field("representative_id_type", "integer"),
                    Field("representative_id_value", "string"),
                    Field("name", "string"),
                    Field("phone", "string"),
                    Field("email", "string"),
                    Field("url", "string"),
                    Field("is_supplier", "integer"),
                    primarykey=['representative_id'],
                    migrate=False
                    )

    db.define_table("submissions",
                    Field("submission_id", "integer"),
                    Field("locale", "string"),
                    Field("context_id", "integer"),
                    Field("series_id", "integer"),
                    Field("series_position", "string"),
                    Field("edited_volume", "integer"),
                    Field("language", "string"),
                    #Field("comments_to_ed", "string"),
                    Field("date_submitted", "string"),
                    Field("last_modified","datetime",),
                    Field("date_status_modified","datetime",),
                    Field("status", "integer"),
                    Field("submission_progress", "integer"),
                    Field("pages", "string"),
                    Field("fast_tracked", "integer"),
                    Field("hide_author", "integer"),
                    Field("stage_id", "integer"),
                    primarykey=['submission_id'],
                    migrate=False
                    )

    db.define_table("submission_settings",
                    Field("submission_id", "integer"),
                    Field("locale", "string"),
                    Field("setting_name", "string"),
                    Field("setting_value", "string"),
                    Field("setting_type", "string"),
                    primarykey=['submission_id'],
                    migrate=False
                    )

    db.define_table("submission_categories",
                    Field("submission_id", "integer"),
                    Field("category_id", "integer"),
                    primarykey=['submission_id'],
                    migrate=False
                    )

    db.define_table("submission_file_settings",
                    Field("file_id", "integer"),
                    Field("locale", "string"),
                    Field("setting_name", "string"),
                    Field("setting_value", "string"),
                    Field("setting_type", "string"),
                    primarykey=['file_id', 'locale', 'setting_name'],
                    migrate=False,
                    )

    db.define_table('submission_files',
                    Field('file_id', 'integer'),
                    Field('revision', 'integer'),
                    Field('source_file_id', 'integer'),
                    Field('source_revision', 'integer'),
                    Field('submission_id', 'integer'),
                    Field('file_type'),
                    Field('genre_id', 'integer'),
                    Field('file_size', 'integer'),
                    Field('original_file_name'),
                    Field('file_stage', 'integer'),
                    Field('direct_sales_price'),
                    Field('sales_type'),
                    Field('viewable', 'integer'),
                    Field('date_uploaded', 'datetime'),
                    Field('date_modified', 'datetime'),
                    #Field('user_group_id', 'integer'),
                    Field('uploader_user_id', 'integer'),
                    Field('assoc_type', 'integer'),
                    Field('assoc_id', 'integer'),
                    primarykey=['file_id', 'revision'],
                    migrate=False
                    )

    db.define_table("identification_codes",
                    Field("identification_code_id", "integer"),
                    Field("publication_format_id", "integer"),
                    Field("code", "integer"),
                    Field("value", "string"),
                    primarykey=['identification_code_id'],
                    migrate=False
                    )

    db.define_table("user_group_settings",
                    Field("user_group_id", "integer"),
                    Field("locale", "string"),
                    Field("setting_name", "string"),
                    Field("setting_value", "string"),
                    Field("setting_type", "string"),
                    migrate=False
                    )

    db.define_table("users",
                    Field("user_id", "integer"),
                    Field("username", "string"),
                    Field("password", "string"),
                # All the following fields moved to user_settings for translated names since OMP 3.1.2-1
                #Field("salutation", "string"),
                #Field("first_name", "string"),
                #Field("middle_name", "string"),
                #Field("last_name", "string"),
                #Field("suffix", "string"),
                    #Field("gender", "string"),
                #Field("initials", "string"),
                    Field("email", "string"),
                    Field("url", "string"),
                    Field("phone", "string"),
                    Field("mailing_address", "string"),
                    Field("billing_address", "string"),
                    Field("country", "string"),
                    Field("locales", "string"),
                    Field("date_last_email","datetime",),
                    Field("date_registered","datetime",),
                    Field("date_validated","datetime",),
                    Field("date_last_login","datetime",),
                    Field("must_change_password", "integer"),
                    Field("auth_id", "integer"),
                    Field("auth_str", "string"),
                    Field("disabled", "integer"),
                    Field("disabled_reason", "text"),
                    Field("inline_help", "integer"),
                    primarykey=["user_id"],
                    migrate=False
                    )

    db.define_table("user_settings",
                    Field("user_id", "integer"),
                    Field("locale", "string"),
                    Field("setting_name", "string"),
                    Field("assoc_type", "integer"),
                    Field("assoc_id", "integer"),
                    Field("setting_value", "string"),
                    Field("setting_type", "string"),
                    primarykey=["user_id", "locale", "setting_name"],
                    migrate=False
                    )



    db.define_table('t_license_settings',
                    Field( "license_id", "integer"),
                    Field("locale", "string", length=6),
                    Field("setting_name", "string",length=48),
                    Field("setting_value", "string"),
                    migrate = False,
                    primarykey=["license_id" ,"locale", "setting_name"],
                    )


    #
    # request_client = ''
    # if request.client:
    #     rcs = request.client.split('.')
    #     if len(rcs) == 4:
    #         request_client = rcs[0] + '.' + rcs[1] + '.' + rcs[2] + '.xxx'
    #
    # db.define_table('t_usage_statistics',
    #                 Field('time_stamp', 'datetime', default=request.now),
    #                 Field('client_ip', 'string', default=request_client),
    #                 Field(
    #                     'request_controller',
    #                     'string',
    #                     default=request.controller),
    #                 Field('request_function', 'string', default=request.function),
    #                 Field(
    #                     'request_extension',
    #                     'string',
    #                     default=request.extension),
    #                 Field('request_ajax', 'string', default=request.ajax),
    #                 Field('request_args', 'string', default=request.args),
    #                 Field('request_vars', 'string', default=request.vars),
    #                 Field('request_view', 'string', default=request.view),
    #                 Field('request_http_user_agent', 'string',
    #                       default=request.env.http_user_agent),
    #                 Field(
    #                     'request_language',
    #                     'string',
    #                     default=request.env.http_accept_language),
    #                 Field('description', 'text'),
    #                 migrate=False,
    #                 )
    #
