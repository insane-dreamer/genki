// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
Ajax.Responders.register({   
  onCreate: function(){   
    $('spinner').show();   
  },   
  onComplete: function() {   
    if(Ajax.activeRequestCount == 0)   
      $('spinner').hide();   
  }   
}); 
