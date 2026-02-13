class FeatureFlagEngine
  @cache = {}

  class << self
    def enabled?(feature_name, user = nil, region: nil)
      cache_key = "#{feature_name}_#{user&.id || 'global'}_#{region || 'all'}"
      return @cache[cache_key] if @cache.key?(cache_key)

      feature = Feature.find_by(name: feature_name.to_s)
      raise "Feature not found" unless feature

      # User override
      if user
        user_override = feature.feature_overrides.find_by(user_id: user.id)
        return cache(cache_key, user_override.enabled) if user_override

        if user.group
          group_override = feature.feature_overrides.find_by(group_id: user.group.id)
          return cache(cache_key, group_override.enabled) if group_override
        end
      end

      # Region override
      if region
        region_override = feature.feature_overrides.find_by(region: region)
        return cache(cache_key, region_override.enabled) if region_override
      end

      cache(cache_key, feature.enabled)
    end

    def clear_cache!
      @cache.clear
    end

    private

    def cache(key, value)
      @cache[key] = value
    end
  end
end
