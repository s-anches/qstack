class Search
  SCOPES = %w(all question answer comment user)
  class << self
    def find(query, scope, page = 1)
      return unless SCOPES.include? scope
      query_escaped = Riddle::Query.escape(query)
      scope_klass = scope == "all" ? nil : scope.classify.constantize
      ThinkingSphinx.search query_escaped, classes: [scope_klass], page: page
    end
  end
end 