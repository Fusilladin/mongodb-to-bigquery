CREATE OR REPLACE PROCEDURE `<project_id>.<dataset_id>.procDropRecreateStagingTables`()
BEGIN

DROP TABLE IF EXISTS `<project_id>.<dataset_id>.brand`;
DROP TABLE IF EXISTS `<project_id>.<dataset_id>.checkout`;
DROP TABLE IF EXISTS `<project_id>.<dataset_id>.company`;
DROP TABLE IF EXISTS `<project_id>.<dataset_id>.order`;
DROP TABLE IF EXISTS `<project_id>.<dataset_id>.product`;
DROP TABLE IF EXISTS `<project_id>.<dataset_id>.product_category`;
DROP TABLE IF EXISTS `<project_id>.<dataset_id>.store`;
DROP TABLE IF EXISTS `<project_id>.<dataset_id>.user`;

CREATE OR REPLACE TABLE `<project_id>.<dataset_id>.company` (
        `__v` STRING,
        `_algolia` STRING,
        `_id` STRING,
        `api_key` STRING,
        `app_url_scheme` STRING,
        `bundle_id` STRING,
        `createdAt` STRING,
        `handle` STRING,
        `is_medical_only` STRING,
        `name` STRING,
        `updatedAt` STRING
);

CREATE OR REPLACE TABLE `<project_id>.<dataset_id>.store` (
        `__v` STRING,
        `_id` STRING,
        `address` STRING,
        `algolia_index` STRING,
        `company_id` STRING,
        `createdAt` STRING,
        `delivery_only` STRING,
        `description` STRING,
        `email` STRING,
        `external_id` STRING,
        `has_medical_menu` STRING,
        `homepage_id` STRING,
        `hours` STRING,
        `menupage_id` STRING,
        `name` STRING,
        `phone` STRING,
        `photos` STRING,
        `preview_photo` STRING,
        `sync` STRING,
        `updatedAt` STRING,
        `website_url` STRING
);

CREATE OR REPLACE TABLE `<project_id>.<dataset_id>.user` (
        `__v` STRING,
        `_config` STRING,
        `_id` STRING,
        `analytic_profile_id` STRING,
        `company_id` STRING,
        `createdAt` STRING,
        `dob` STRING,
        `email` STRING,
        `external_id` STRING,
        `first_name` STRING,
        `has_medical` STRING,
        `ids` STRING,
        `last_name` STRING,
        `optins` STRING,
        `phone` STRING,
        `updatedAt` STRING
);

CREATE OR REPLACE TABLE `<project_id>.<dataset_id>.product` (
        `__v` STRING,
        `_id` STRING,
        `available_menus` STRING,
        `brand` STRING,
        `category` STRING,
        `collection_index` STRING,
        `created_at` STRING,
        `description` STRING,
        `effects` STRING,
        `external_id` STRING,
        `hidden` STRING,
        `images` STRING,
        `is_active` STRING,
        `name` STRING,
        `options` STRING,
        `potency` STRING,
        `sku` STRING,
        `star_rating` STRING,
        `status` STRING,
        `store_id` STRING,
        `strain` STRING,
        `thumbnail` STRING,
        `updated_at` STRING,
        `vendor` STRING,
        `website_url` STRING
);

CREATE OR REPLACE TABLE `<project_id>.<dataset_id>.product_category` (
        `__v` STRING,
        `_id` STRING,
        `created_at` STRING,
        `external_id` STRING,
        `hidden` STRING,
        `image` STRING,
        `name` STRING,
        `store_id` STRING,
        `subcategories` STRING,
        `updated_at` STRING
);

CREATE OR REPLACE TABLE `<project_id>.<dataset_id>.brand` (
        `__v` STRING,
        `_id` STRING,
        `created_at` STRING,
        `external_id` STRING,
        `logo_url` STRING,
        `name` STRING,
        `store_id` STRING,
        `updated_at` STRING
);

CREATE OR REPLACE TABLE `<project_id>.<dataset_id>.order` (
        `__v` STRING,
        `_id` STRING,
        `canceled_at` STRING,
        `completed_at` STRING,
        `created_at` STRING,
        `external_id` STRING,
        `items` STRING,
        `mode` STRING,
        `order_number` STRING,
        `price` STRING,
        `status` STRING,
        `store_id` STRING,
        `updated_at` STRING,
        `user_id` STRING
);

CREATE OR REPLACE TABLE `<project_id>.<dataset_id>.checkout` (
        `__v` STRING,
        `_id` STRING,
        `checkout_url` STRING,
        `created_at` STRING,
        `debug` STRING,
        `external_id` STRING,
        `items` STRING,
        `order_id` STRING,
        `pickup_windows` STRING,
        `price` STRING,
        `status` STRING,
        `store_id` STRING,
        `updated_at` STRING,
        `user_id` STRING
);


END;