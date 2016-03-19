// Modified from /vendor/packages/x-editable/address.js

(function ($) {
  "use strict";

  var ProfileName = function (options) {
    this.init('profile_name', options, ProfileName.defaults);
  };

  $.fn.editableutils.inherit(ProfileName, $.fn.editabletypes.abstractinput);

  $.extend(ProfileName.prototype, {

    render: function() {
      this.$input = this.$tpl.find('input');
    },

    // HTML set in explicit success callback instead
    value2html: function(value, element) {},

    // Internal use only
    value2str: function(value) {
      var str = '';
      if(value) {
        for(var k in value) {
          str = str + k + ':' + value[k] + ';';
        }
      }
      return str;
    },

    // Sets value of input.
    value2input: function(value) {
      if(!value) {
        return;
      }
      this.$input.filter('[name="title"]').val(value.title);
      this.$input.filter('[name="first_name"]').val(value.first_name);
      this.$input.filter('[name="last_name"]').val(value.last_name);
      this.$input.filter('[name="suffix"]').val(value.suffix);
    },

    // Get value of input
    input2value: function() {
      return {
        title: this.$input.filter('[name="title"]').val(),
        first_name: this.$input.filter('[name="first_name"]').val(),
        last_name: this.$input.filter('[name="last_name"]').val(),
        suffix: this.$input.filter('[name="suffix"]').val()
      };
    },

    activate: function() {
      this.$input.filter('[name="first_name"]').focus();
    },

    // Attaches handler to submit form in case of 'showbuttons=false' mode
    autosubmit: function() {
      this.$input.keydown(function (e) {
        if (e.which === 13) {
          $(this).closest('form').submit();
        }
      });
    }
  });

  ProfileName.defaults = $.extend({}, $.fn.editabletypes.abstractinput.defaults, {
    tpl: '<div><input type="text" name="title" class="form-control input-sm" placeholder="Title"></div>'+
         '<div><input type="text" name="first_name" class="form-control input-sm" placeholder="First name"></div>'+
         '<div><input type="text" name="last_name" class="form-control input-sm" placeholder="Last name"></div>' +
         '<div><input type="text" name="suffix" class="form-control input-sm" placeholder="Suffix"></div>',

    inputclass: ''
  });

  $.fn.editabletypes.profile_name = ProfileName;

}(window.jQuery));