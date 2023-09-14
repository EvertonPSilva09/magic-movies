class Cart
    attr_accessor :items
  
    def initialize
      @items = []
    end
  
    def add_movie(movie)
      @items << movie
    end
  
    def remove_movie(movie)
      @items.delete(movie)
    end
  
    def clear
      @items = []
    end
  end
  