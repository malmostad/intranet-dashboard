Paperclip.interpolates :username do |attachment, style_name|
  attachment.instance.username
end

Paperclip::Attachment.default_options.update({
  default_style: :medium_quadrat,
  path: "#{APP_CONFIG['avatar_base_path']}:username/:style.:extension",
  url: "http://#{APP_CONFIG['avatar_base_url']}:username/:style.:extension",
  default_url: "http://#{APP_CONFIG["avatar_default_url"]}",
  styles: {
    xlarge: {
      geometry: '600x',
      format: 'jpg',
      quality: 70
    },
    large: {
      geometry: '300x',
      format: 'jpg',
      quality: 70
    },
    large_quadrat: {
      geometry: '300x300#',
      format: 'jpg',
      quality: 70
    },
    medium: {
      geometry: '180x',
      format: 'jpg',
      quality: 70
    },
    medium_quadrat: {
      geometry: '180x180#',
      format: 'jpg',
      quality: 70
    },
    small: {
      geometry: '120x',
      format: 'jpg',
      quality: 70
    },
    small_quadrat: {
      geometry: '120x120#',
      format: 'jpg',
      quality: 70
    },
    thumb_quadrat: {
      geometry: '60x60#',
      format: 'jpg',
      quality: 50
    },
    tiny_quadrat: {
      geometry: '46x46#',
      format: 'jpg',
      quality: 50
    },
    mini_quadrat: {
      geometry: '32x32#',
      format: 'jpg',
      quality: 50
    }
  },
  convert_options: {
    all: "-strip -auto-orient "
  }
})
