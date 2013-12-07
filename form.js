
var taxon_a = 'cat';
var taxon_b = 'dog';

var phantom=require('node-phantom');
phantom.create(function(err,ph) {
  return ph.createPage(function(err,page) {
    return page.open("http://timetree.org/index.php?taxon_a=" + taxon_a +"&taxon_b=" + taxon_b + "&submit=Search", function(err,status) {
      console.log("opened site? ", status);
      page.includeJs('http://ajax.googleapis.com/ajax/libs/jquery/1.7.2/jquery.min.js', function(err) {
        //jQuery Loaded.
        //Wait for a bit for AJAX content to load on the page. Here, we are waiting 5 seconds.
        setTimeout(function() {
          return page.evaluate(function() {
            //Get what you want from the page using jQuery. A good way is to populate an object with all the jQuery commands that you need and then return the object.
            var time = [];
            $('.time').each(function() {
              time.push($(this).html());
            });

            return {
              times: time
            };
          }, function(err,result) {
            console.log(result['times'][0]);
            ph.exit();
          });
        }, 5000);
      });
    });
  });
});