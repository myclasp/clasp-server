var MomentMap = (function () {
  return {

    reverseGeocode: function (popup) {
      var latlng = popup.options.latlng;
      var url = 'http://nominatim.openstreetmap.org/reverse.php?format=json&lat='+latlng[0]+'&lon='+latlng[1]+'&zoom=18&extratags=1';
      jQuery.getJSON(url, function(result) { 
        
        console.log(result);

        var str = '<p class="question">Does this location match the datamark?</p>';
        str = str + '<p class="result">' + result.display_name + '</p>';

        $(popup._contentNode).find('.possible-feature textarea').text(JSON.stringify(result));
        $(popup._contentNode).find('.possible-feature').removeClass('hidden');
        $(popup._contentNode).find('.possible-feature .answer').before(str);
      });
    },

    geoSearch: function (latlng, query) {
      var boxDiff = [0.002200000000001978/2.0, 0.003589999999999982/2.0]
      var box = [latlng[1]-boxDiff[1], latlng[0]+boxDiff[0], latlng[1]+boxDiff[1], latlng[0]-boxDiff[0]]
      var url = 'http://nominatim.openstreetmap.org/search?q='+query+'&limit=10&viewbox='+box.toString()+'&bounded=1&format=json';
      jQuery.getJSON(url, function(result) { console.log(result); });
    },

    watchMapPopup: function (e) {   
      $('div.marker-popup .edit').off();

      if ((e.popup.options.is_mine) && (e.popup.options.needs_feature)){
        MomentMap.reverseGeocode(e.popup);
      }

      $(e.popup._contentNode).find('.edit').click(function(e){
        console.log($(e.currentTarget).attr('data-moment'));
      });
    }

  };
})();