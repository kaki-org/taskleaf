// Entry point for the build script in your package.json
import { Turbo } from "@hotwired/turbo"
import "@hotwired/turbo-rails"
import "controllers"

// Make Turbo available globally for debugging
window.Turbo = Turbo

// Bootstrap JS is loaded via importmap
// TODO: Add bootstrap to importmap if JS features (modals, dropdowns) are needed
