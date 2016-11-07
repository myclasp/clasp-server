var MomentMap = (function () {
  return {

    reverseGeocode: function (popup, latlng) {
      var url = 'http://nominatim.openstreetmap.org/reverse.php?format=json&lat='+latlng[0]+'&lon='+latlng[1]+'&zoom=18&extratags=1';
      jQuery.getJSON(url, function(result) { 
        
        console.log(result);

        var str = '<p class="question">Does this location match the datamark?</p><p class="result">';

        var keys = Object.keys(result.address);
        var nkeys = keys.filter(function(el) {
          return !["road", "neighbourhood", "suburb", "city", "county", "state_district", "state", "postcode", "country", "country_code"].includes(el);
        });

        var type = "road";  var title = "";

        if (nkeys.length > 0) { 
          type = nkeys[0]; 
          title = '<b>' + result.address[type] + " ("+ type + ')</b>, ' + result.address.road + ", ";
        } else {
          title = '<b>' + result.address.road + '</b>, ' 
        }

        str = str + title + result.address.city + '</p>';

        $(popup).find('.possible-feature textarea').text(JSON.stringify(result));
        $(popup).find('.possible-feature').removeClass('hidden');
        $(popup).find('.possible-feature .answer').before(str);
      });
    },

    geoSearch: function (latlng, query) {
      var boxDiff = [0.002200000000001978/2.0, 0.003589999999999982/2.0]
      var box = [latlng[1]-boxDiff[1], latlng[0]+boxDiff[0], latlng[1]+boxDiff[1], latlng[0]-boxDiff[0]]
      var url = 'http://nominatim.openstreetmap.org/search?q='+query+'&limit=10&viewbox='+box.toString()+'&bounded=1&format=json';
      jQuery.getJSON(url, function(result) { console.log(result); });
    },

    handlePopup: function (e) {   
      
      jQuery.get(e.popup.options.feature_url, function(result){});

      /*
        TODO disable submit buttons on click and add spinner
      */
    }

  };
})();