# How To activate OMP logging
Logging of SQL statements executed for debugging, can be activated in the file config.inc.php.
Set "debug = True" in the [database] section.
But this leads to all SQL statements being printed interleaved with the HTML output,
and is not readable for longer sessions.

Another way to inspect the executed database queries is to enable general logging on the MYSQL server.
See the official [MySQL documentation](https://dev.mysql.com/doc/refman/5.5/en/query-log.html) for more information.

The query log for MySQL can be activated while the server is running with the following statement.
```sql
SET GLOBAL general_log = 'ON';
```

Even more detailed inspection of the OMP workflow can be done with debugging.
One way is using Xdebug in combination with Jetbrains PhpStorm, see the
[instructions from the JetBrains](https://confluence.jetbrains.com/display/PhpStorm/Zero-configuration+Web+Application+Debugging+with+Xdebug+and+PhpStorm) website for debugging with PhpStorm and Xdebug.

The Xdebug PHP module needs to be installed on the webserver running the code.
For Ubuntu and PHP 7 bundled packages are available http://packages.ubuntu.com/de/xenial/php-xdebug,
 which can be installed with apt-get.
```sh
sudo apt-get install php-xdebug
```

See the [Xdebug installation instructions](https://xdebug.org/docs/install) for other versions and platforms.
And the instructions on the JetBrains website.

## Recommendations


# Database Entry steps
OMP branch: omp-stable-1_2_0, commit: e7edf095c3c037abeef3bb92db6d24adb23f77cb
On localhost, with user nweiher, userid: 33, usergroupid: 87.

The following entries have been extracted from logfile: ...
## Submission wizard
The submission was initiated by pressing "New Submission" from the "Submissions" page.

### Step 2: Upload Submission file
In popup uploading file.
submissionId: 217
#### Table "submission_files"
```sql
INSERT INTO submission_files
    (revision, submission_id, source_file_id, source_revision, file_type,
    file_size, original_file_name, file_stage, date_uploaded, date_modified,
    viewable, uploader_user_id, user_group_id, assoc_type, assoc_id, genre_id, direct_sales_price, sales_type)
VALUES
    (1, 217, NULL, NULL, 'application/vnd.oasis.opendocument.text',
    15161, 'Jahresbericht 2016.odt', 2, '2017-02-22 12:46:47', '2017-02-22 12:46:47',
    1, 33, 87, NULL, NULL, 6
8, NULL, NULL)
```

#### Table "event_log" and "event_log_settings"
submissionFileId: 76844

```sql
INSERT INTO event_log
    (user_id, date_logged, ip_address, event_type, assoc_type, assoc_id, message, is_translated)
VALUES
    (33, '2017-02-22 12:46:47', '127.0.0.1', 1342177281, 515, 76844, 'submission.event.fileUploaded', 0)

INSERT INTO event_log_settings (log_id, setting_name, setting_value, setting_type) VALUES (13566, 'fileStage', 2, 'int')
INSERT INTO event_log_settings (log_id, setting_name, setting_value, setting_type) VALUES (13566, 'revisedFileId', NULL, 'string')
INSERT INTO event_log_settings (log_id, setting_name, setting_value, setting_type) VALUES (13566, 'fileId', 76844, 'int')
INSERT INTO event_log_settings (log_id, setting_name, setting_value, setting_type) VALUES (13566, 'fileRevision', 1, 'int')
INSERT INTO event_log_settings (log_id, setting_name, setting_value, setting_type) VALUES (13566, 'originalFileName', 'Jahresbericht 2016.odt', 'string')
INSERT INTO event_log_settings (log_id, setting_name, setting_value, setting_type) VALUES (13566, 'submissionId', 217, 'int')
INSERT INTO event_log_settings (log_id, setting_name, setting_value, setting_type) VALUES (13566, 'username', 'nweiher', 'string')
```
"event_type" are numerical identifiers defined in lib/pkp/classes/log/PKPSubmissionEventLogEntry.inc.php.

#### Table "submission_settings"
Completing tab "2. Metadata" from Upload Submission File popup.
Connection 177 from logfile. Many redundant SQL statements have been executed.
```sql
UPDATE submission_file_settings
SET setting_type='string',setting_value='Test name'
WHERE file_id='76844' and locale='en_US' and setting_name='name'

INSERT INTO submission_file_settings (file_id,locale,setting_name,set
ting_type,setting_value) VALUES ('76844','en_US','name','string','Test name')

UPDATE submission_file_settings
SET setting_type='string',setting_value=''
WHERE file_id='76844' and locale='de_DE' and setting_name='name'

INSERT INTO submission_file_settings
    (file_id,locale,setting_name,setting_type,setting_value)
VALUES
    ('76844','de_DE','name','string','')
```

Completing Step 2.

#### Table "controlled_vocabularies"
Connection 191 in logfile. Double inserts have been omitted.
```
INSERT INTO controlled_vocabs
    (symbolic, assoc_type, assoc_id)
VALUES
    ('submissionSubject', 1048585, 217)

INSERT INTO controlled_vocabs
    (symbolic, assoc_type, assoc_id)
VALUES
    ('submissionKeyword', 1048585, 217)

INSERT INTO controlled_vocabs
    (symbolic, assoc_type, assoc_id)
VALUES
    ('submissionDiscipline', 1048585, 217)

INSERT INTO controlled_vocabs
    (symbolic, assoc_type, assoc_id)
VALUES
    ('submissionAgency', 1048585, 217)

INSERT INTO controlled_vocabs
    (symbolic, assoc_type, assoc_id)
VALUES
    ('submissionLanguage', 1048585, 217)
```
The values for "assoc_type" fields are numerical identifiers defined in the file: lib/pkp/classes/core/PKPApplication.inc.php.

### Step 3: Catalog
#### Adding Chapter
Connection 204.
##### Table "submission_chapters" and "submission_chapter_settings"
```sql
INSERT INTO submission_chapters (submission_id, chapter_seq)
VALUES (217, 0)

INSERT INTO submission_chapter_settings
(chapter_id,locale,setting_name,setting_type,setting_value)
VALUES ('1977','en_US','title','string','Chapter title en')

INSERT INTO submission_chapter_settings
(chapter_id,locale,setting_name,setting_type,setting_value)
VALUES ('1977','de_DE','title','string','Chapter title de')

INSERT INTO submission_chapter_settings
(chapter_id,locale,setting_name,setting_type,setting_value)
VALUES ('1977','en_US','subtitle','string','subtitle en')

INSERT INTO submission_chapter_settings
(chapter_id,locale,setting_name,setting_type,setting_value)
VALUES ('1977','de_DE','subtitle','string','subtitle de')
```
#### Saving
Connection 212.
##### Table "submissions" and "submission_settings"
```
UPDATE  submissions
SET     series_id = 0,
        series_position = NULL,
        language = '',
        comments_to_ed = '',
        date_submitted = null,
        date_status_modified = '2017-02-22 13:10:11',
        last_modified = '2017-02-22 12:36:39',
        status = 1,
        context_id = 6,
        submission_progress = 3,
        stage_id = 1,
        edited_volume = 2,
        hide_author = 0,
        citations = NULL
WHERE   submission_id = 217

INSERT INTO submission_settings (submission_id,locale,setting_name,setting_type,setting_value) VALUES ('217','en_US','title','string','Title en')
INSERT INTO submission_settings (submission_id,locale,setting_name,setting_type,setting_value) VALUES ('217','de_DE','title','string','Title de')
INSERT INTO submission_settings (submission_id,locale,setting_name,setting_type,setting_value) VALUES ('217','en_US','cleanTitle','string','Title en')
INSERT INTO submission_settings (submission_id,locale,setting_name,setting_type,setting_value) VALUES ('217','de_DE','cleanTitle','string','Title de')
INSERT INTO submission_settings (submission_id,locale,setting_name,setting_type,setting_value) VALUES ('217','en_US','abstract','string','<p>Abstract en</p>')
INSERT INTO submission_settings (submission_id,locale,setting_name,setting_type,setting_value) VALUES ('217','de_DE','abstract','string','<p>Abstract de</p>')
INSERT INTO submission_settings (submission_id,locale,setting_name,setting_type,setting_value) VALUES ('217','en_US','prefix','string','')
INSERT INTO submission_settings (submission_id,locale,setting_name,setting_type,setting_value) VALUES ('217','de_DE','prefix','string','')
INSERT INTO submission_settings (submission_id,locale,setting_name,setting_type,setting_value) VALUES ('217','en_US','subtitle','string','')
INSERT INTO submission_settings (submission_id,locale,setting_name,setting_type,setting_value) VALUES ('217','de_DE','subtitle','string','')
```
