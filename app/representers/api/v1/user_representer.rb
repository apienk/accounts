module Api::V1
  class UserRepresenter < Roar::Decorator
    include Roar::JSON

    property :id,
             type: Integer,
             readable: true,
             writeable: false,
             schema_info: {
               required: true
             }

    property :username,
             type: String,
             readable: true,
             writeable: true

    property :first_name,
             type: String,
             readable: true,
             writeable: true

    property :last_name,
             type: String,
             readable: true,
             writeable: true

    property :full_name,
             type: String,
             readable: true,
             writeable: false

    property :title,
             type: String,
             readable: true,
             writeable: true

    property :uuid,
             type: String,
             readable: true,
             writeable: false

    property :faculty_status,
             type: String,
             readable: true,
             writeable: false

    collection :contact_infos,
               if: ->(user_options:, **) { user_options.try(:fetch, :render_contact_infos, false) },
               decorator: ContactInfoRepresenter

  end
end
