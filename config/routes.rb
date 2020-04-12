# == Route Map
#
#                                Prefix Verb   URI Pattern                                                                              Controller#Action
#                               secrets GET    /secrets(.:format)                                                                       secrets#index
#                                       POST   /secrets(.:format)                                                                       secrets#create
#                            new_secret GET    /secrets/new(.:format)                                                                   secrets#new
#                           edit_secret GET    /secrets/:id/edit(.:format)                                                              secrets#edit
#                                secret GET    /secrets/:id(.:format)                                                                   secrets#show
#                                       PATCH  /secrets/:id(.:format)                                                                   secrets#update
#                                       PUT    /secrets/:id(.:format)                                                                   secrets#update
#                                       DELETE /secrets/:id(.:format)                                                                   secrets#destroy
#                       check_pipelines GET    /pipelines/check(.:format)                                                               pipelines#check
#                             pipelines GET    /pipelines(.:format)                                                                     pipelines#index
#                                       POST   /pipelines(.:format)                                                                     pipelines#create
#                          new_pipeline GET    /pipelines/new(.:format)                                                                 pipelines#new
#                         edit_pipeline GET    /pipelines/:id/edit(.:format)                                                            pipelines#edit
#                              pipeline GET    /pipelines/:id(.:format)                                                                 pipelines#show
#                                       PATCH  /pipelines/:id(.:format)                                                                 pipelines#update
#                                       PUT    /pipelines/:id(.:format)                                                                 pipelines#update
#                                       DELETE /pipelines/:id(.:format)                                                                 pipelines#destroy
#                          run_pipeline GET    /pipelines/:id/run(.:format)                                                             pipelines#run
#                              show_run GET    /pipelines/:id/runs/:run_id(.:format)                                                    runs#show
#         rails_mandrill_inbound_emails POST   /rails/action_mailbox/mandrill/inbound_emails(.:format)                                  action_mailbox/ingresses/mandrill/inbound_emails#create
#         rails_postmark_inbound_emails POST   /rails/action_mailbox/postmark/inbound_emails(.:format)                                  action_mailbox/ingresses/postmark/inbound_emails#create
#            rails_relay_inbound_emails POST   /rails/action_mailbox/relay/inbound_emails(.:format)                                     action_mailbox/ingresses/relay/inbound_emails#create
#         rails_sendgrid_inbound_emails POST   /rails/action_mailbox/sendgrid/inbound_emails(.:format)                                  action_mailbox/ingresses/sendgrid/inbound_emails#create
#          rails_mailgun_inbound_emails POST   /rails/action_mailbox/mailgun/inbound_emails/mime(.:format)                              action_mailbox/ingresses/mailgun/inbound_emails#create
#        rails_conductor_inbound_emails GET    /rails/conductor/action_mailbox/inbound_emails(.:format)                                 rails/conductor/action_mailbox/inbound_emails#index
#                                       POST   /rails/conductor/action_mailbox/inbound_emails(.:format)                                 rails/conductor/action_mailbox/inbound_emails#create
#     new_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/new(.:format)                             rails/conductor/action_mailbox/inbound_emails#new
#    edit_rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id/edit(.:format)                        rails/conductor/action_mailbox/inbound_emails#edit
#         rails_conductor_inbound_email GET    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#show
#                                       PATCH  /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#update
#                                       PUT    /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#update
#                                       DELETE /rails/conductor/action_mailbox/inbound_emails/:id(.:format)                             rails/conductor/action_mailbox/inbound_emails#destroy
# rails_conductor_inbound_email_reroute POST   /rails/conductor/action_mailbox/:inbound_email_id/reroute(.:format)                      rails/conductor/action_mailbox/reroutes#create
#                    rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#             rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#                    rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#             update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#                  rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create

Rails.application.routes.draw do
  resources :secrets
  get '/pipelines/check', to: 'pipelines#check', as: 'check_pipelines'
  resources :pipelines
  get '/pipelines/:id/run', to: 'pipelines#run', as: 'run_pipeline'
  get '/pipelines/:id/runs/:run_id', to: 'runs#show', as: 'show_run'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
