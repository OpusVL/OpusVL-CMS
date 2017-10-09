$(function() {
    var is_asset = $('.asset').length > 0;

    var add_text = function(context, text) {
        if(context.invoke('codeview.isActivated')) {
            var cv = context.layoutInfo.codable.data('cmEditor');
            cv.replaceSelection(text, 'end');
        } else {
            context.invoke('editor.insertText', text);
        }

    };
    var fudge_tt = function(escape_func, text) {
      var tag_regex = /\[%(.*?)%\]/g;
      var r;
      var to_replace = {};
      while((r = tag_regex.exec(text)) != null) {
          var block = r[1];
          to_replace[block] = escape_func(block);
      }
      for(var p in to_replace) {
          if(to_replace[p] === p) {
          } else {
              text = text.split(p).join(to_replace[p]);
          }
      }
      return text;
    };
    var _escape = function(str) {
        return str.replace(/&amp;/g, '&amp;amp;');
            //.replace(/</g, '&lt;')
            //.replace(/>/g, '&gt;')
            //.replace(/"/g, '&quot;')
            //.replace(/'/g, '&#039;'); 
    };
    var _unescape = function(str) {
        return str.replace(/&lt;/g, '<')
          .replace(/&gt;/g, '>')
          .replace(/&quot;/g, '"')
          .replace(/&#039;/g, "'")
          .replace(/&amp;/g, '&');
    };
    window.markupType = $('select[name=markup_type]').val();
    var code_mode = window.markupType === 'Markdown' || $('#wysiwyg.code').length > 0;
    if ($('#wysiwyg').length > 0) {
        var construct_button = function (title, tooltip, type, icon, module) {
            var ElementDialog = function(context) {
                var self = this;
                var ui = $.summernote.ui;

                var $editor = context.layoutInfo.editor;
                var options = context.options;
                var lang = options.langInfo;

                this.initialize = function () {
                    var $container = options.dialogsInBody ? $(document.body) : $editor;

                    var $tbl = $('table.insert-element.'+ type);
                    var html = '<table class="dialog table table-striped datatable ' + type + '">' + $tbl.html() + '</table>';
                    var body = html;

                    this.$dialog = ui.dialog({
                        className: 'test-dialog',
                        title: title,
                        fade: options.dialogsFade,
                        body: body,
                        footer: ''//footer
                    }).render().appendTo($container);
                    var $newTbl = $('table.dialog.datatable.' + type);
                    $newTbl.DataTable();
                    var $dialog = this.$dialog;
                    $newTbl.on('click', 'a.insert-element', function () {
                        var $link = $(this);
                        var slug = $link.attr('rel');
                        var attributes = $link.closest('tr').find('input.element-attribute');
                        var data = '{';
                        $(attributes).each(function(i, v) {
                            var $inpt = $(v);
                            var value = $inpt.val();
                            var key = $inpt.attr('rel');
                            if(value) {
                                data += ' "' + key.replace(/"/g, '\\"') + '"="' + value.replace(/"/g, '\\"') + '"';
                                data[key] = value;
                            }
                        });
                        data += '}';

                        var insert = $link.closest('tbody').data('insertText');
                        var processed = insert.replace('$slug', slug);
                        processed = processed.replace('$data', data);
                        add_text(context, '[% ' + processed + ' %]');
                        $dialog.modal('hide');
                        // FIXME: this only works in html mode,
                        // not code mode.
                        // this restores focus
                        context.invoke('editor.saveRange');
                        return false;
                    }).on('click', '.collapse-element-attributes', function() {
                        var _attr = $(this).attr('rel');
                        $(_attr).slideToggle('fast');
                        return false;
                    });
                };

                this.destroy = function () {
                    ui.hideDialog(this.$dialog);
                    this.$dialog.remove();
                };

                this.bindEnterKey = function ($input, $btn) {
                    $input.on('keypress', function (event) {
                        if (event.keyCode === key.code.ENTER) {
                            $btn.trigger('click');
                        }
                    });
                };

                this.showSelectionDialog = function () {
                    return $.Deferred(function (deferred) {
                        ui.showDialog(self.$dialog);
                    }).promise();
                };

                this.show = function () {
                    context.invoke('editor.saveRange');
                    this.showSelectionDialog();
                };
            };
            var ElementButton = function(context) {
                var ui = $.summernote.ui;
                var button = ui.button({
                    contents: '<i class="fa ' + icon + '"/> ' + title,
                    className: 'btn-codeview codeview-active',
                    tooltip: tooltip,
                    click: function () {
                        context.invoke(module + '.show');
                    }
                });
                return button.render();
            };
            return { button: ElementButton, module: ElementDialog };
        };
        var modules = $.summernote.options.modules;
        var elements = construct_button('Elements', 'Pick an element', 'elements', 'fa-tint', 'elementsDialog');
        modules['elementsDialog'] = elements.module;
        var assets = construct_button('Assets', 'Pick an asset', 'assets', 'fa-file', 'assetsDialog');
        modules['assetsDialog'] = assets.module;
        var attachments = construct_button('Attachments', 'Pick an attachment', 'attachments', 'fa-paperclip', 'attachmentsDialog');
        modules['attachmentsDialog'] = attachments.module;
        var pages = construct_button('Pages', 'Pick page', 'pages', 'fa-file-text', 'pagesDialog');
        modules['pagesDialog'] = pages.module;
        var attributes = construct_button('Attributes', 'Pick an attribute', 'attributes', 'fa-th-list', 'attributesDialog');
        modules['attributesDialog'] = attributes.module;
        if(code_mode) {
            // clobber the wysiwyg editor because it's dangerous when trying to deal with embedded javascript.
            delete modules['editor'];
            var FakeEditor = function(context) {
                var self = this;
                var ui = $.summernote.ui;
                var options = context.options;
                var $editable = context.layoutInfo.editable;
                this.shouldInitialize = function () {
                    return true;
                };

                this.initialize = function () {
                    if (!options.airMode) {
                        if (options.width) {
                            $editor.outerWidth(options.width);
                        }
                        if (options.height) {
                            $editable.outerHeight(options.height);
                        }
                        if (options.maxHeight) {
                            $editable.css('max-height', options.maxHeight);
                        }
                        if (options.minHeight) {
                            $editable.css('min-height', options.minHeight);
                        }
                    }
                    if (options.maxHeight) {
                        $editable.css('max-height', options.maxHeight);
                    }
                    if (options.minHeight) {
                        $editable.css('min-height', options.minHeight);
                    }
                };
                this.destroy = function () {
                };
                this.currentStyle = function () {
                    return {};
                };
            };
            modules['editor'] = FakeEditor;
            // FIXME: need to clobber the code view button so
            // that it's either not there, or disabled.
        }
        // updated to work in code view.
        var EDITABLE_PADDING = 24;
        var Statusbar = function (context) {
            var $document = $(document);
            var $statusbar = context.layoutInfo.statusbar;
            var $editable = context.layoutInfo.editable;
            var options = context.options;

            this.initialize = function () {
                if (options.airMode || options.disableResizeEditor) {
                    return;
                }

                $statusbar.on('mousedown', function (event) {
                    event.preventDefault();
                    event.stopPropagation();

                    var codeMode = $('div.note-editor').hasClass('codeview');
                    var editableTop = $editable.offset().top - $document.scrollTop();
                    if(codeMode) {
                        editableTop = $('div.note-editor').offset().top - $document.scrollTop();
                    }

                    $document.on('mousemove', function (event) {
                        var height = event.clientY - (editableTop + EDITABLE_PADDING);

                        height = (options.minheight > 0) ? Math.max(height, options.minheight) : height;
                        height = (options.maxHeight > 0) ? Math.min(height, options.maxHeight) : height;

                        if(codeMode) {
                            $('.note-codable').data('cmEditor').setSize(null, height - EDITABLE_PADDING);
                        } else {
                            $editable.height(height);
                        }
                    }).one('mouseup', function () {
                        $document.off('mousemove');
                    });
                });
            };

            this.destroy = function () {
                $statusbar.off();
            };
        };
        modules['statusbar'] = Statusbar;
        // FIXME: allow resizing in code mode.
        // can we fudge the editor.
        $('#wysiwyg').val(fudge_tt(_escape, $('#wysiwyg').val()));
        $('#wysiwyg').summernote({
            height: 300,
            toolbar: [
                ['style', ['style']],
                ['font', ['bold', 'underline', 'italic', 'clear']],
                ['fontname', ['fontname']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['table', ['table']],
                ['insert', ['link', 'picture', 'video']],
                ['view', ['fullscreen', 'codeview', 'help']],
                ['cms', ['elements', 'assets', 'attachments', 'pages', 'attributes']]
            ],
            codemirror: {
                lineWrapping: true,
                indentUnit: 4,
                tabSize: 4,
                indentWithTabs: false,
                lineNumbers: true,
            },
            buttons: {
                elements: elements.button,
                assets: assets.button,
                attachments: attachments.button,
                pages: pages.button,
                attributes: attributes.button,
            },
            modules: modules
        });
    }

    if(code_mode) {
        // code view.
        $('#wysiwyg').summernote('codeview.toggle');
        // disable the codeview toggle.
        $.summernote.ui.toggleBtn($($('#wysiwyg').data('summernote').layoutInfo.toolbar.find('button.btn-codeview')[0]), false);
    }
    $('select[name=markup_type]').change(function() {
        window.markupType = $('select[name=markup_type]').val();
        if(window.markupType === 'Markdown') {
            if(!$('#wysiwyg').summernote('codeview.isActivated')) {
                $('#wysiwyg').summernote('codeview.toggle');
            }
        } else {
            if($('#wysiwyg').summernote('codeview.isActivated')) {
                $('#wysiwyg').summernote('codeview.toggle');
            }
        }
    });

    // FIXME: should I hook into the change event for the markup type?

    // kludge to sync the editor.
    $('#wysiwyg').closest('form').parsley().on('form:validate', function(f) {
        if($('div.note-editor').hasClass('codeview')) {
            var val = $('.note-codable').data('cmEditor').getValue();
            $('#wysiwyg').val(val);
        } else {
          // FIX up TT tags in html view.
          // NOTE: there is a corresponding copy of this code within summernote
          // for when it flips to code view.  This is ugly and should probably be
          // cleaned up.
          var str = $('#wysiwyg').val();
          $('#wysiwyg').val(fudge_tt(_unescape, str));
        }
    });


});

