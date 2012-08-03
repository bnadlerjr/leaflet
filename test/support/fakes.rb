module Fakes
  def self.book_params(attributes={})
    {
      'title' => 'Some Book',
      'description' => 'A description of the book.',
      'price'       => '9.99'
    }.merge(attributes)
  end
end