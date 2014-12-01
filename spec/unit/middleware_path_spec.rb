require 'spec_helper'

describe LightResizer::Middleware::Path do

  subject(:path) { described_class.new(path_string) }

  context 'valid path methods' do

    let(:path_string) { '/some_dir/light_resize/150x150_image.png' }

    it { expect(path.image_path?).to be_truthy }

    it { expect(path.image_path).to eq('/some_dir/image') }

    it { expect(path.image_extension).to eq('.png') }

    it { expect(path.dimensions).to eq('150x150') }

    it { expect(path.prefix).to eq('150x150') }

    it { expect(path.original_image_exists?).to be_falsey   }

  end

  context 'resize with crop' do
    let(:path_string) { '/some_dir/light_resize/150x150_crop_convert_image.png' }

    it { expect(path.crop_path?).to be_truthy }

    it { expect(path.convert_path?).to be_truthy }

    it { expect(path.image_path).to eq('/some_dir/image') }

    it { expect(path.image_extension).to eq('.png') }

    it { expect(path.dimensions).to eq('150x150') }

    it { expect(path.prefix).to eq('150x150_crop_convert') }

    it { expect(path.original_image_exists?).to be_falsey   }
  end

  context 'wrong path methods' do

    let(:path_string) { '/asdada/123acad/some_dir/imdage.png' }

    it { expect(path.image_path?).to be_falsey }

  end

  context 'valid path' do
    let(:path_string) { File.join(ROOT, 'fixtures', 'light_resize', '50x50_sample') }

    it { expect(path.original_image_exists?).to be_truthy }
  end

end