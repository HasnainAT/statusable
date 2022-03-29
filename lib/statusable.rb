module Statusable
  module ClassMethods
    def acts_as_statusable(**options)
        raise "Invalid status class" if options[:klass].present? && options[:klass].safe_constantize.blank?
        class_attribute :_default_status_slug
        class_attribute :_status_klass
        self._default_status_slug = options[:slug]
        self._status_klass = if options[:klass].present?
                               options[:klass].to_s
                             else
                               get_status_class_name
                             end
        belongs_to :status, class_name: _status_klass
        default_value_for :status_id do self.default_status_id end
        if options[:disposition].present? && options[:disposition][:enable].present?
          include Dispositionable
          acts_as_dispositionable(**options[:disposition])
        end
    end
    def all_statuses
      _status_klass.constantize.where(statusable_type: self.name).order(position: :asc)
    end

    def default_status_id
      if self._default_status_slug.present?
        all_statuses.where(slug: self._default_status_slug).first&.id
      else
        all_statuses.first&.id
      end
    end
    def status_id_for(slug)
      all_statuses.where(slug: slug).first&.id
    end
    private
    def get_status_class_name
      ns = self.module_parent if self.module_parent != Object
      ns.present? ? ns.to_s + "::Status" : "Status"
    end
  end
  module InstanceMethods
    def status_is?(staslugtus_slug)
      status.slug == status_slug
    end
  end
  module Dispositionable
    def self.included(base)
      base.extend(ClassMethods)
    end
    module ClassMethods
      def acts_as_dispositionable(**options)
        raise "Invalid Disposition class" if options[:klass].present? && options[:klass].safe_constantize.blank?
        class_attribute :_default_disposition_slug
        class_attribute :_disposition_klass

        self._default_disposition_slug = options[:slug]
        self._disposition_klass = if options[:klass].present?
                                    options[:klass].to_s
                                  else
                                    get_disposition_class_name
                                  end
        belongs_to :disposition, class_name: _disposition_klass
        default_value_for :disposition_id do
          self.default_disposition_id
        end
      end
      def default_disposition_id
        if self._default_disposition_slug.present?
          _disposition_klass.constantize.where(status_id: self.default_status_id, slug: self._default_disposition_slug).order(position: :asc).first&.id
        else
          _disposition_klass.constantize.where(status_id: self.default_status_id).order(position: :asc).first&.id
        end
      end
      private
      def get_disposition_class_name
        ns = self.module_parent if self.module_parent != Object
        ns.present? ? ns.to_s + "::Disposition" : "Disposition"
      end
    end
  end
  def self.included(base)
    base.extend(ClassMethods)
    base.include(InstanceMethods)
  end
end
