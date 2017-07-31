$(function() {
  setupSearchSelect(document);

  $(document).on('has_many_add:after', function(event, container) {
    setupSearchSelect(container);
  });

  function setupSearchSelect(container) {
    $('.search-select', container).each(function(i, el) {
      var url = $(el).data('url');
      var fields = $(el).data('fields');
      var displayName = $(el).data('display_name');
      var width = $(el).data('width') || '80%';
      var responseRoot = $(el).data('response_root');
      var collection = $(el).data('collection');
      var minimumInputLength = $(el).data('minimum_input_length');
      var order = $(el).data('order') || (fields[0] + '_desc');

      var selectOptions = {
        width: width,
        minimumInputLength: minimumInputLength,
        data: collection,
        placeholder: '',
        allowClear: true,
        ajax: {
          url: url,
          dataType: 'json',
          delay: 250,
          cache: true,
          data: function(params) {
            var textQuery = { m: 'or' };
            fields.forEach(function(field) {
              if (field == 'id') {
                textQuery[field + '_eq'] = params.term;
              } else {
                textQuery[field + '_contains'] = params.term;
              }
            });

            var query = {
              order: order,
              q: {
                groupings: [textQuery],
                combinator: 'and',
              },
            };

            return query;
          },
          processResults: function(data) {
            if (data.constructor == Object) {
              data = data[responseRoot];
            }

            return {
              results: jQuery.map(data, function(resource) {
                if (!resource[displayName]) {
                  resource[displayName] = 'No display name for id #' + resource.id.toString();
                }
                return {
                  id: resource.id,
                  text: resource[displayName].toString(),
                };
              }),
            };
          },
        },
      };

      $(el).select2(selectOptions);
    });
  }
});
