require 'active_support/concern'
# TODO: 优化重构 xiaobo
# include ElasticsearchSearchable
module ElasticsearchSearchable
  extend ActiveSupport::Concern

  included do

    require 'elasticsearch/model'
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    include Elasticsearch::Model::Indexing

    after_touch() { __elasticsearch__.index_document }

    def as_indexed_json(options={})
      _include = self.class.reflect_on_all_associations.each_with_object({}) {|a,hsh|
        hsh[a.name] = {}
        hsh[a.name][:only] = a.klass.attribute_names
      }
      self.as_json(include: _include)
    end

  end

  module ClassMethods

    def search_params(params={})
      return [nil,nil] if params.blank? || params[:search].blank?
      p = params[:search].dup
      q = p.delete(:q)
      [q, p]
    end

    def search(query=nil, options={page: 1, per_page: 30})
      options ||= {}
      @search_definition = {
        query: {},
        filter: {},
        facets: {},
        size: options[:per_page],
        from: options[:page] * options[:per_page]
      }

      __set_filters = lambda do |key, f|
        @search_definition[:filter][:and] ||= []
        @search_definition[:filter][:and]  |= [f]
        @search_definition[:facets][key.to_sym][:facet_filter][:and] ||= []
        @search_definition[:facets][key.to_sym][:facet_filter][:and]  |= [f]
      end

      @search_definition[:facets] = search_facet_fields.each_with_object({}) do |a,hsh|
        hsh[a.to_sym] = {
          terms: {
            field: a
          },
          facet_filter: {}
        }
      end

      unless query.blank?
        @search_definition[:query] = {
          bool: {
            should: [
              { multi_match: {
                  query: query,
                  fields: search_text_fields,
                  operator: 'and'
                }
              }
            ]
          }
        }
      else
        @search_definition[:query] = { match_all: {} }
      end

      options.each do |key,value|
        next unless search_facet_fields.include?(key)
        f = { term: { key.to_sym => value } }
        __set_filters.(key, f)
        __set_filters.(key, f)
      end
      __elasticsearch__.search(@search_definition)
    end

    private

    def search_text_fields
      self.content_columns.select {|c| [:string,:text].include?(c.type) }.map {|c| c.name }
    end

    def search_facet_fields
      self.content_columns.select {|c| [:boolean,:decimal,:float,:integer,:string,:text].include?(c.type) }.map {|c| c.name }
    end

  end

end
