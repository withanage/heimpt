$('form').jsonForm({
    "schema": {
        "projects": {
            "type": "array",
            "items": {
                "type": "object",
                "title": "project",
                "properties": {
                    "name": {
                        "type": "string",
                        "title": "Name"
                    },
                    "path": {
                        "type": "string",
                        "title": "Path"
                    },
                   
                    "files": {
                        "type": "array",
                        "items": {
                            "type": "string",
                            "title": "File",
                            "default": ".docx"
                        }
                    }

                }
            }
        }

    },
    "form": [
        {
            "key": "projects",
            "inlinetitle": "Check this box if you are over 18",


        },


        {
            "type": "submit",
            "title": "Submit"
        }
    ]
,
    onSubmit: function (errors, values) {
        if (errors) {
            $('#res').html('<p>I beg your pardon?</p>');
        }
        else {
            $('#res').html('<p>Hello ' + values.projects.name + '.' +
                (values.age ? '<br/>You are ' + values.age + '.' : '') +
                '</p>');
        }
        console.log(values);
    }
});
