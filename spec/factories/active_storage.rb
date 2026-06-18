# Define FactoryBot factories for creating Active Storage attachments and blobs
FactoryBot.define do
  # Factory for creating ActiveStorage::Attachment objects
  factory :attached_file, class: 'ActiveStorage::Attachment' do
    # Set default name attribute to "file"
    name { 'file' }
    # Set default record_type attribute to "User"
    record_type { 'User' }
    # Create an association between the attachment and a User object
    record { association :user }

    # After building the attachment, assign a blob to it
    after(:build) do |attachment, evaluator|
      attachment.blob = build(:active_storage_blob)
    end
  end

  # Factory for creating ActiveStorage::Blob objects
  factory :active_storage_blob, class: 'ActiveStorage::Blob' do
    # Set default filename attribute to "example_file.pdf"
    filename { 'example_file.pdf' }
    # Generate a random key for the blob
    key { SecureRandom.hex(28) }
    # Set default content_type attribute to "application/pdf"
    content_type { 'application/pdf' }
    # Set default byte_size attribute to 1000
    byte_size { 1000 }
    # Calculate a checksum for the blob content
    checksum { Digest::MD5.base64digest('example') }
    # Set default service_name attribute to "local"
    service_name { 'local' }
    
    # After building the blob, upload test data to it
    after(:build) do |blob|
      blob.upload(io: StringIO.new('test'), filename: blob.filename, content_type: blob.content_type)
    end
  end
end
