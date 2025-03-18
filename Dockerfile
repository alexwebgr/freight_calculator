# Use official Ruby image with minimal dependencies
FROM ruby:3.4.2-slim

# Set working directory
WORKDIR /

# Copy dependencies first for layer caching
COPY Gemfile* ./
RUN bundle install

# Copy application code
COPY . .

# Run command when container starts
CMD ["ruby", "app/main.rb"]
