var MomentMap = (function () {
  return {


    reverseGeocode: function (latlng) {
      var url = 'http://nominatim.openstreetmap.org/reverse.php?format=json&lat='+latlng[0]+'&lon='+latlng[1]+'&zoom=18&extratags=1';
      jQuery.getJSON(url, function(result) { console.log(result);  });
    },

    geoSearch: function (latlng, query) {
      var boxDiff = [0.002200000000001978/2.0, 0.003589999999999982/2.0]
      var box = [latlng[1]-boxDiff[1], latlng[0]+boxDiff[0], latlng[1]+boxDiff[1], latlng[0]-boxDiff[0]]
      var url = 'http://nominatim.openstreetmap.org/search?q='+query+'&limit=10&viewbox='+box.toString()+'&bounded=1&format=json';
      console.log(url);
      jQuery.getJSON(url, function(result) { console.log(result); });
    },

    watchMapPopups: function () {
      console.log("watchMapPopups");
      $('div.marker-popup .edit').off().click((e) => {
        console.log($(e.currentTarget).attr('data-moment'));
      });
    }

    
  };
})();
