module OStatus
  # This element conveys information about a category associated with an entry
  # or feed. There is no defined meaning to the content according to the Atom
  # specification.
  class Category
    # Holds the base URI for relative URIs contained in scheme.
    attr_reader :base

    # Holds the language of term and label, when it exists. The language
    # should be specified as RFC 3066 as either 2 or 3 letter codes.
    # For example: 'en' for English or more specifically 'en-us'
    attr_reader :lang

    # Holds the optional scheme used for categorization.
    attr_reader :scheme

    # Holds the string identifying the category to which the entry or
    # feed belongs.
    attr_reader :term

    # Holds the string that provides a human-readable label for display in
    # end-user applications. The content of this field is language sensitive.
    attr_reader :label

    # Create a Category to apply to a feed or entry.
    def initialize(options = {})
      @base = options[:base]
      @lang = options[:lang]
      @scheme = options[:scheme]
      @term = options[:term]
      @label = options[:label]
    end

    # Yields a Hash that represents this category.
    def to_hash
      {
        :base => @base,
        :lang => @lang,
        :scheme => @scheme,
        :term => @term,
        :label => @label
      }
    end
  end
end
