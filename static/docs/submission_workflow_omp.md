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

The following entries have been extracted from logfile: [/logs/mysql-log-submission-steps-1-3.log]
## Submission wizard
The submission was initiated by pressing "New Submission" from the "Submissions" page.

### Step 1
After submitting the first form. Connection 45 from log.
### Table "submissions"
```sql
INSERT INTO submissions
    (locale, context_id, series_id, series_position, language, comments_to_ed,
     date_submitted, date_status_modified, last_modified, status,
     submission_progress, stage_id, pages, hide_author, edited_volume, citations)
VALUES
    ('en_US', 6, 0, NULL, '', '',
     null, '2017-02-24 08:56:06', '2017-02-24 08:56:06', 1,
     2, 1, NULL, 0, 2, NULL)
```
The column "submission_progress" refers to the progress within the submission wizard.

### Table "authors" and "author_settings"
```sql
INSERT INTO authors
    (submission_id, first_name, middle_name, last_name, suffix, country,
    email, url, user_group_id, primary_contact, seq, include_in_browse)
VALUES
    (219, 'Nils', '', 'Weiher', '', 'DE',
    'weiher@ub.uni-heidelberg.de', '', 87, 1, 1, 1)

INSERT INTO author_settings (author_id,locale,setting_name,setting_type,setting_value) VALUES ('2386','de_DE','biography','string','')
INSERT INTO author_settings (author_id,locale,setting_name,setting_type,setting_value) VALUES ('2386','en_US','biography','string','')
INSERT INTO author_settings (author_id,locale,setting_name,setting_type,setting_value) VALUES ('2386','de_DE','affiliation','string','')
INSERT INTO author_settings (author_id,locale,setting_name,setting_type,setting_value) VALUES ('2386','en_US','affiliation','string','')
DELETE FROM author_settings WHERE author_id = 2386 AND setting_name IN ( 'competingInterests' ,'orcid' )
```
Redundant UPDATE statements for author_settings have been omitted.

### Table "stage_assignments"
```sql
INSERT INTO stage_assignments
    (submission_id, user_group_id, user_id, date_assigned)
VALUES
    (219, 87, 33, '2017-02-24 08:56:06')
```

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
Connection 177 from logfile.
```sql
INSERT INTO submission_file_settings
    (file_id,locale,setting_name,setting_type,setting_value)
VALUES
    ('76844','en_US','name','string','Test name')
INSERT INTO submission_file_settings
    (file_id,locale,setting_name,setting_type,setting_value)
VALUES
    ('76844','de_DE','name','string','')
```
Many redundant SQL statements for setting updates have been omitted.
Completing Step 2.

#### Table "controlled_vocabularies"
Connection 191 in logfile. Double inserts have been omitted.
```sql
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

#### Submission file path ####
The submission file has been copied to a path constructed by the function [getFilePath in the class SumbissionFile](https://github.com/pkp/pkp-lib/blob/c3b503dc9dccf7460d0c21f0f5e8e451f2cd5ced/classes/submission/SubmissionFile.inc.php#L447).
It consists of the following parts:
`basePath + fileStagePath + serverFileName`
The path for the submission file above the components would look like.

##### basePath #####
The following pseudo code describes the basePath component:

`"files/presses/" + pressId + "/monographs/" + submissionId + "/"`

The basePath for the uploaded file above would be `files/presses/6/monographs/217/`.

##### fileStagePath #####
The [method _fileStageToPath](https://github.com/pkp/pkp-lib/blob/c3b503dc9dccf7460d0c21f0f5e8e451f2cd5ced/classes/submission/SubmissionFile.inc.php#L601) maps a numerical stage id to a path.
File stages are defined in [lib/pkp/classes/submission/SubmissionFile.inc.php](https://github.com/pkp/pkp-lib/blob/c3b503dc9dccf7460d0c21f0f5e8e451f2cd5ced/classes/submission/SubmissionFile.inc.php).

For example, stage 2 (`SUBMISSION_FILE_SUBMISSION`), will be mapped to `"submission"`.

##### serverFileName #####
The following pattern describes the file name of a submission file on the server.
```
submissionId-genreId-fileId-revision-fileStage-timestamp
```
The placeholders above are field names from the SubmissionFile class.

`timestamp` is a date stamp of the format `"Ymd"`, e.g., `20170222`.

### Step 3: Catalog
Adding meta data for catalog entry.

#### Adding a chapter
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
```sql
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
