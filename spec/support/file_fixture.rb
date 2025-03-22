# frozen_string_literal: true

def file_fixture(filename)
  file_path = File.join("spec", "fixtures", "files", filename)
  File.read(file_path)
  JSON.parse(File.read(file_path), symbolize_names: true)
end
