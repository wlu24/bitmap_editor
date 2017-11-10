require 'bitmap_editor.rb'


RSpec.describe 'BitmapEditor' do
  
  describe 'constructor' do
    
    editor = BitmapEditor.new
    
    it 'sets image to nil' do
      expect(editor.image).to be_nil
    end
    
    it 'sets current_max_row to 0' do
      expect(editor.current_max_row).to eq(0)
    end
    
    it 'sets current_max_col to 0' do
      expect(editor.current_max_col).to eq(0)
    end
    
  end
  
end