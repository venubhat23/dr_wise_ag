# Case-insensitive "contains" search for the admin list pages.
#
# pg_search's tsearch only matches from the start of a word, so "Loke" found
# "Lokesh Shivanna" but "esh" / "anna" did not. This scope matches anywhere
# inside the text instead. The query is split into words and every word has to
# appear in at least one of the columns, so "Lokesh Shivanna" and "esh anna"
# both work even though first and last name are separate columns.
#
#   substring_search_scope :search_leads,
#     against: [:name, :email],
#     associated_against: { customer: [:first_name, :last_name] }
module SubstringSearchable
  extend ActiveSupport::Concern

  class_methods do
    def substring_search_scope(name, against:, associated_against: {})
      scope name, ->(query) {
        words = query.to_s.split
        next all if words.empty?

        words.inject(all) do |relation, word|
          pattern = "%#{sanitize_sql_like(word)}%"
          condition = against.map { |col| arel_table[col].matches(pattern) }.inject(:or)

          associated_against.each do |assoc, cols|
            reflection = reflect_on_association(assoc)
            target = reflection.klass
            matching = target.where(cols.map { |col| target.arel_table[col].matches(pattern) }.inject(:or))
            condition = condition.or(arel_table[reflection.foreign_key].in(matching.select(:id).arel))
          end

          relation.where(condition)
        end
      }
    end
  end
end
