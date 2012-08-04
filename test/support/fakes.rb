module Fakes
  def self.book_params(attributes={})
    {
      'title' => 'Some Book',
      'description' => 'A description of the book.',
      'price'       => '9.99'
    }.merge(attributes)
  end

  def self.catalog
    [
      { :title       => 'The Well-Grounded Rubyist',
        :description => 'This is an awesome book!',
        :price       => 44.99,
        :status      => 'active'
      },
      { :title       => 'Eloquent Ruby',
        :description => 'Another awesome book about Ruby!',
        :price       => 30.67,
        :status      => 'inactive'
      }
    ]
  end
end