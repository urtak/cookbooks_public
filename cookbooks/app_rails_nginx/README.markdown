# Rails Backend Server with nginx+passenger

Unlike the rails_app cookbook, this cookbook assumes that you have a completely separate front end instance. This cookbook *just* sets up nginx+passenger to listen on port 8000 so that you can connect it to a front end running HAProxy.
