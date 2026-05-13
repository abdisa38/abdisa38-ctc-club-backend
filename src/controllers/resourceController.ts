import { Response } from 'express';
import asyncHandler from 'express-async-handler';
import { AuthRequest } from '../middleware/authMiddleware';
import Lesson from '../models/lessonModel';
import { sendSuccess } from '../utils/apiResponse';

// @desc    Delete a resource/attachment from a lesson
// @route   DELETE /api/resources/:resourceId
// @access  Private/Admin
export const deleteResource = asyncHandler(async (req: AuthRequest, res: Response): Promise<void> => {
  const { resourceId } = req.params;

  // Resource ID format: attachment-{lessonId}-{index}
  const match = resourceId.match(/^attachment-([a-fA-F0-9]{24})-(\d+)$/);
  
  if (!match) {
    res.status(400);
    throw new Error('Invalid resource ID format');
  }

  const [, lessonId, indexStr] = match;
  const attachmentIndex = parseInt(indexStr, 10);

  // Find the lesson
  const lesson = await Lesson.findById(lessonId);

  if (!lesson) {
    res.status(404);
    throw new Error('Lesson not found');
  }

  // Check if attachment index is valid
  if (!lesson.attachments || attachmentIndex >= lesson.attachments.length || attachmentIndex < 0) {
    res.status(404);
    throw new Error('Resource not found');
  }

  // Remove the attachment at the specified index
  lesson.attachments.splice(attachmentIndex, 1);

  // Save the lesson
  await lesson.save();

  sendSuccess(res, { message: 'Resource deleted successfully' });
});
