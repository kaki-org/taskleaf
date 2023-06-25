// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `rails generate channel` command.
//
//= require ../../vendor/bundle/ruby/3.2.0/gems/actioncable-7.0.4.3/app/assets/javascripts/action_cable
//= require_self
//= require_tree channels

(function() {
  this.App || (this.App = {});

  App.cable = ActionCable.createConsumer();

}).call(this);
