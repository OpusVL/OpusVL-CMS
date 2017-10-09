$(function() {
    $('#wysiwyg').keydown(function (e) {
        if (e.keyCode == 9) {
            var myValue = "    ";
            var startPos = this.selectionStart;
            var endPos = this.selectionEnd;
            var scrollTop = this.scrollTop;
            this.value = this.value.substring(0, startPos) + myValue + this.value.substring(endPos,this.value.length);
            this.focus();
            this.selectionStart = startPos + myValue.length;
            this.selectionEnd = startPos + myValue.length;
            this.scrollTop = scrollTop;

            e.preventDefault();
        }
    });

    // form error message begone!
    $('.form_error_message').click(function() { $(this).fadeOut(300); });

    // Pages list hierarchy controls
    (function() {
        function find_children (level, deeply=false) {
            return function(i,o) {
                return deeply
                ? $(this).data('level') > level
                : $(this).data('level') == level + 1
                ;
            };
        }

        function show_children_of ($row) {
            var level = parseInt($row.data('level'));

            $row.nextUntil('.level-' + level).filter(find_children(level)).each(function() {
                var $child = $(this);
                if ($child.data('level') == level + 1) {
                    $child.show();
                };

                if ($child.find('.js-show-children').hasClass('active')) {
                    show_children_of($child);
                }
            });
        }

        function hide_children_of ($row) {
            var level = parseInt($row.data('level'));

            $row.nextUntil('.level-' + level).filter(find_children(level,true)).hide();
        }

        $('table.records-pages .record-page .js-show-children').on('click', function(e) {
            var $this = $(this),
                $row = $this.closest('tr');
            
            if ($this.hasClass('active')) {
                hide_children_of($row);
                $this.removeClass('active');
            }
            else {
                show_children_of($row);
                $this.addClass('active');
            }
            e.preventDefault();
        });
    })();
});
