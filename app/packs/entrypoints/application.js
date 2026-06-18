// Import necessary modules and libraries
import $ from 'jquery'; // Import jQuery library
import Rails from "@rails/ujs"; // Import Rails UJS library for making AJAX requests
import "bootstrap"; // Import Bootstrap library for UI components
import '../scripts/flash_message'; // Import custom script for handling flash messages
import initMediaPreview from "../scripts/media_preview"; // Import custom script for initializing media preview functionality

// Start Rails UJS to enable AJAX functionality in the application
Rails.start();

// Initialize media preview functionality
initMediaPreview();
